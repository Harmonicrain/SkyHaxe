#!/usr/bin/env python3
"""M2a — the deterministic AS3 -> Haxe sync pipeline.

The product goal is not one successful build. It is that `habbo-client-clean` stays authoritative
and an upstream change costs a sync run plus bounded review. That only holds if generated code is
disposable and hand-maintained code is small, named, and fails closed when its source moves.

So this command:

  * reads the client tree **read-only** and writes only to a workspace and a generated directory;
  * applies pre-conversion rewrites that are **count-guarded** -- a rule that does not match its
    declared number of sites aborts rather than silently doing nothing;
  * runs the pinned ax3 build;
  * records source, tool, rule and output hashes in a manifest, so two runs over the same input
    can be compared byte for byte;
  * checks the exception manifest: every hand-maintained Haxe file names an AS3 counterpart, and
    if that counterpart's hash has moved the sync stops and asks for review.

Anything it cannot do honestly, it reports. It does not "best-effort" a conversion.

Usage:
    python scripts/sync.py --package com/sulake/core
    python scripts/sync.py --package com/sulake/core --check-determinism
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

REPO = Path(__file__).resolve().parent.parent
CLIENT = Path(r"C:\habbo\client\habbo-client-clean")
WORKSPACE = REPO / ".toolchain/m2/workspace"
GENERATED = REPO / "generated"
AX3 = REPO / ".toolchain/ax3"
# Patched for E4X call typing by evidence/m2_patch_ax3.py; see that script for why
# the converter is patched rather than the source rewritten.
CONVERTER = AX3 / "converter-m2.jar"
EXCEPTIONS = REPO / "evidence/m2_exceptions.json"
ASSET_INPUTS = REPO / "evidence/m2_asset_inputs.json"

# ax3 needs the Flash/AIR type libraries plus the client's own SWC to resolve types. These are the
# same libraries G1c used; the client SWC is the compiled HabboAir build.
SWC_LIBRARIES = [
    "C:/flex/frameworks/libs/player/32.0/playerglobal.swc",
    "C:/flex/frameworks/libs/air/airglobal.swc",
    "C:/flex/frameworks/libs/framework.swc",
    "C:/flex/frameworks/libs/mx/mx.swc",
    "C:/flex/frameworks/libs/air/airframework.swc",
    str((REPO / ".toolchain/g1c/habbo-client.swc")).replace("\\", "/"),
]

# The client's own SWC holds AS3 this pipeline also converts, so a rest argument read out of
# it becomes a trailing `Array<ASAny>` parameter rather than staying variadic. ax3 has to know
# that, or a call that crosses a closure boundary -- resolved through the SWC instead of
# through source -- keeps its arguments unwrapped and compiles against the wrong signature.
AS3_SWC_LIBRARIES = [
    str((REPO / ".toolchain/g1c/habbo-client.swc")).replace("\\", "/"),
]
MANIFEST = REPO / "evidence/m2_sync_manifest.json"

from m2_rules import RULES, SCOPE_EXPECTATIONS


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def sha256_tree(root: Path, suffixes: tuple[str, ...]) -> tuple[str, int]:
    """Hash of a tree's contents, independent of walk order and of absolute location."""
    digest = hashlib.sha256()
    count = 0
    for path in sorted(root.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in suffixes:
            continue
        digest.update(str(path.relative_to(root)).replace("\\", "/").encode())
        digest.update(sha256_file(path).encode())
        count += 1
    return digest.hexdigest(), count


def sha256_paths(root: Path, relatives: list[str]) -> tuple[str, int]:
    """Hash an explicit output list. A closure spans packages, so there is no single subtree."""
    digest = hashlib.sha256()
    count = 0
    for relative in sorted(relatives):
        path = root / relative
        if not path.is_file():
            continue
        digest.update(relative.encode())
        digest.update(sha256_file(path).encode())
        count += 1
    return digest.hexdigest(), count


# Kept in step with PrinterBase.RESERVED_PACKAGE_SEGMENTS in the patched ax3. AS3 allows a package
# segment named `enum` -- com.sulake.habbo.avatar.enum holds eight of the avatar constants -- and
# Haxe does not, so the converter escapes such segments with a leading underscore and writes the
# file under the escaped directory. This side has to agree, or the pre-clean leaves stale output
# behind and the produced-file count silently misses whatever the escape moved.
RESERVED_PACKAGE_SEGMENTS = {
    "abstract", "break", "case", "cast", "catch", "class", "continue", "default", "do", "dynamic",
    "else", "enum", "extends", "extern", "false", "final", "for", "function", "if", "implements",
    "import", "in", "inline", "interface", "macro", "new", "null", "operator", "overload",
    "override", "package", "private", "public", "return", "static", "super", "switch", "this",
    "throw", "true", "try", "typedef", "untyped", "using", "var", "while",
}


def generated_relative(source_relative: str) -> str:
    """Where the converter writes the Haxe for an AS3 source path."""
    parts = source_relative[: -len(".as")].split("/")
    return "/".join(
        ("_" + part if part in RESERVED_PACKAGE_SEGMENTS else part) for part in parts
    ) + ".hx"


def inside_string_literal(text: str, index: int) -> bool:
    """Is `index` inside a quoted AS3 string, judged from the start of its line?

    XML literals never appear inside a string, so a match that does is not one. This matters
    because part of the corpus has already been normalized: AssetLibraryCollection's manifest was
    rewritten to `new XML("<manifest><library></library></manifest>")` under P2, and its inner
    `<library></library>` still looks exactly like a literal. Wrapping it again produces nested
    `new XML("new XML(...)")` -- which converts, compiles, and is silently wrong at runtime.

    Counting quotes from the line start is enough here: the corpus has no multi-line strings, and
    an escaped quote inside one is not a delimiter.
    """
    line_start = text.rfind("\n", 0, index) + 1
    quotes = 0
    position = line_start
    while position < index:
        char = text[position]
        if char == "\\":
            position += 2
            continue
        if char in "\"'":
            quotes += 1
        position += 1
    return quotes % 2 == 1


def subn_xml_literal(pattern: str, text: str) -> tuple[str, int]:
    """Replace E4X literals with `new XML("...")`, skipping any that are already inside a string."""
    hits = 0

    def replace(match: re.Match) -> str:
        nonlocal hits
        if inside_string_literal(text, match.start()):
            return match.group(0)
        hits += 1
        return "new XML(" + json.dumps(match.group(0)) + ")"

    return re.sub(pattern, replace, text), hits


def stage_files(client: Path, relatives: list[str],
                context: list[str] | None = None) -> tuple[Path, int]:
    """Stage an explicit file list -- a dependency closure rather than a whole package.

    A package is the wrong unit for an ordered batch: the floor-furniture path needs 20 files
    spread over 9 packages, and converting those packages whole would drag in several hundred
    unrelated classes. The client tree is never written.
    """
    target = WORKSPACE / "as3"
    if target.exists():
        shutil.rmtree(target)
    # Context files are staged so ax3 types against source rather than against the SWC. They are
    # converted too -- ax3 writes whatever it is given -- but only the closure's own outputs are
    # kept, so a context file never overwrites the batch that owns it.
    for relative in (context or []):
        source = client / "src" / relative
        if source.is_file():
            destination = target / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, destination)
    for relative in relatives:
        source = client / "src" / relative
        if not source.is_file():
            raise SystemExit("no such file in the client: {}".format(source))
        destination = target / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
    return target, len(relatives)


def stage_sources(client: Path, package: str,
                  subpackages: list[str] | None = None) -> tuple[Path, int]:
    """Copy the selected sources into the workspace. The client tree is never written.

    `subpackages` narrows the batch. M2b converts in dependency order rather than all at once, so
    the unit of work has to be smaller than a package; staging is where that is expressed.
    """
    source = client / "src" / package
    if not source.is_dir():
        raise SystemExit("no such package in the client: {}".format(source))
    target = WORKSPACE / "as3"
    if target.exists():
        shutil.rmtree(target)
    staged = target / package
    if subpackages:
        for name in subpackages:
            part = source / name
            if not part.is_dir():
                raise SystemExit("no such subpackage: {}/{}".format(package, name))
            shutil.copytree(part, staged / name)
        # Package-root files are shared by every subpackage, so they always travel with a batch.
        staged.mkdir(parents=True, exist_ok=True)
        for path in source.glob("*.as"):
            shutil.copy2(path, staged / path.name)
    else:
        shutil.copytree(source, staged)
    return target, sum(1 for _ in staged.rglob("*.as"))


def apply_rules(root: Path, scope: str) -> tuple[list[dict], list[dict]]:
    """Apply the guarded pre-conversion rewrites, failing loudly on a rule that misfires."""
    import re

    applied = []
    unpinned = []
    for rule in RULES:
        sites = 0
        files = 0
        for path in sorted(root.rglob("*.as")):
            relative = path.relative_to(root).as_posix()
            if rule.get("paths") and relative not in rule["paths"]:
                continue
            text = path.read_text(encoding="utf-8-sig", errors="replace")
            if rule["kind"] == "regex":
                updated, hits = re.subn(rule["pattern"], rule["replacement"], text)
            elif rule["kind"] == "xml-cdata":
                updated, hits = subn_xml_literal(rule["pattern"], text)
            else:
                lines = text.splitlines(keepends=True)
                kept = [line for line in lines if rule["match"] not in line]
                hits = len(lines) - len(kept)
                updated = "".join(kept)
            if hits:
                path.write_text(updated, encoding="utf-8", newline="\n")
                sites += hits
                files += 1
        # `expect` is per package: a measured count guards the rule, and an unmeasured package
        # is reported rather than silently accepted.
        expected = rule["expect"]
        if isinstance(expected, dict):
            expected = expected.get(
                scope,
                SCOPE_EXPECTATIONS.get(scope, {}).get(rule["id"], "unpinned"),
            )
        if expected == "unpinned":
            unpinned.append({"rule": rule["id"], "scope": scope, "observed": sites})
        elif isinstance(expected, int) and sites != expected:
            raise SystemExit(
                "rule {} matched {} sites in {}, expected {}. Refusing to continue: a rewrite "
                "that no longer matches its source is a silent behaviour change.".format(
                    rule["id"], sites, scope, expected))
        applied.append({"id": rule["id"], "reason": rule["reason"],
                        "sites": sites, "files": files})
    return applied, unpinned


def check_exceptions(client: Path) -> dict:
    """Fail closed on drift, omission, stale entries, or undocumented compatibility code."""
    if not EXCEPTIONS.is_file():
        return {"declared": 0, "drifted": [], "missing_source": [], "missing_haxe": [],
                "unlisted_haxe": [], "stale_entries": [], "unannotated": [],
                "missing_contract": [], "missing_api_check": [],
                "note": "no exception manifest yet"}
    manifest = json.loads(EXCEPTIONS.read_text(encoding="utf-8"))
    drifted, missing_source, missing_haxe = [], [], []
    missing_contract, missing_api_check, unannotated = [], [], []
    declared_haxe = set()
    for entry in manifest.get("exceptions", []):
        haxe_rel = entry.get("haxe")
        if haxe_rel:
            declared_haxe.add(haxe_rel)
            haxe_path = REPO / haxe_rel
            if not haxe_path.is_file():
                missing_haxe.append(haxe_rel)
            elif entry.get("haxe_sha256") != sha256_file(haxe_path):
                drifted.append({"haxe": haxe_rel, "pinned": entry.get("haxe_sha256"),
                                "current": sha256_file(haxe_path)})
        if not entry.get("reason"):
            unannotated.append(haxe_rel)
        tests = entry.get("contract_tests")
        if not tests or any(not (REPO / test).is_file() for test in tests):
            missing_contract.append({"haxe": haxe_rel, "contract_tests": tests})
        if not entry.get("api_surface_check"):
            missing_api_check.append(haxe_rel)
        as3 = entry.get("as3_source")
        if not as3:
            continue                                  # platform adapter with no counterpart
        path = client / as3
        if not path.is_file():
            missing_source.append(as3)
            continue
        current = sha256_file(path)
        if entry.get("as3_sha256") != current:
            drifted.append({"as3": as3, "pinned": entry["as3_sha256"], "current": current})
    current_haxe = {
        path.relative_to(REPO).as_posix()
        for path in (REPO / "src/com/sulake/core").rglob("*.hx")
    }
    current_haxe.add("src/ASError.hx")
    return {
        "declared": len(manifest.get("exceptions", [])),
        "drifted": drifted,
        "missing_source": missing_source,
        "missing_haxe": missing_haxe,
        "unlisted_haxe": sorted(current_haxe - declared_haxe),
        "stale_entries": sorted(declared_haxe - current_haxe),
        "unannotated": unannotated,
        "missing_contract": missing_contract,
        "missing_api_check": missing_api_check,
    }


def exception_errors(result: dict) -> bool:
    return any(result.get(key) for key in (
        "drifted", "missing_source", "missing_haxe", "unlisted_haxe", "stale_entries",
        "unannotated", "missing_contract", "missing_api_check"))


def check_asset_inputs() -> dict:
    if not ASSET_INPUTS.is_file():
        return {"missing_manifest": True, "missing": [], "drifted": []}
    manifest = json.loads(ASSET_INPUTS.read_text(encoding="utf-8"))
    missing, drifted = [], []
    for group in ("clean_client_inputs", "tool_inputs"):
        for entry in manifest.get(group, []):
            path = Path(entry["path"])
            if not path.is_absolute():
                path = REPO / path
            if not path.is_file():
                missing.append(entry["path"])
                continue
            current = sha256_file(path)
            if current != entry["sha256"]:
                drifted.append({"path": entry["path"], "pinned": entry["sha256"],
                                "current": current})
    return {"missing_manifest": False, "missing": missing, "drifted": drifted,
            "declared": len(manifest.get("clean_client_inputs", []))}


def run_converter(workspace: Path, out: Path) -> dict:
    config = {
        "src": str(workspace / "as3").replace("\\", "/"),
        "hxout": str(out).replace("\\", "/"),
        "swc": SWC_LIBRARIES,
        "as3Swc": AS3_SWC_LIBRARIES,
        "haxeTypes": {
            "flash.display.DisplayObject.filters$get": "return:Array<flash.filters.BitmapFilter>",
            "flash.display.DisplayObject.filters$set": "p1:Array<flash.filters.BitmapFilter>",
        },
        "settings": {"checkNullIteratee": False, "flashProperties": "none"},
    }
    config_path = workspace / "ax3-config.json"
    config_path.write_text(json.dumps(config, indent=2), encoding="utf-8")
    started = time.time()
    result = subprocess.run(
        ["java", "-jar", str(CONVERTER), str(config_path)],
        capture_output=True, text=True, cwd=str(REPO))
    return {
        "exit_code": result.returncode,
        "seconds": round(time.time() - started, 2),
        "stdout_tail": result.stdout.strip().splitlines()[-15:],
        "stderr_tail": result.stderr.strip().splitlines()[-15:],
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--client-root", type=Path, default=CLIENT,
                    help="read-only clean-client root; override only for copied-source drills")
    ap.add_argument("--generated-root", type=Path, default=GENERATED,
                    help="generated output directory")
    ap.add_argument("--manifest", type=Path, default=MANIFEST,
                    help="machine-readable run manifest")
    ap.add_argument("--package", default="com/sulake/core")
    ap.add_argument("--closure", type=Path, default=None,
                    help="convert exactly the files listed under `closure` in a JSON file, "
                         "instead of a package. This is the unit an ordered batch needs: a "
                         "dependency closure usually spans packages.")
    ap.add_argument("--subpackage", action="append", default=None,
                    help="convert only these subpackages of --package, in the order given. "
                         "M2b needs dependency-ordered batches rather than one whole-package "
                         "run; repeat the flag to build a batch.")
    ap.add_argument("--check-determinism", action="store_true",
                    help="convert twice and require an identical generated-tree hash")
    args = ap.parse_args()
    client = args.client_root.resolve()
    generated = args.generated_root.resolve()
    manifest_path = args.manifest.resolve()

    # Site counts belong to the batch, not the package: converting `utils + runtime` legitimately
    # matches fewer sites than the whole package, and pinning by package alone would abort every
    # batch. An unmeasured batch is reported as unpinned rather than treated as a regression.
    closure_files = None
    context_files = []
    if args.closure:
        payload = json.loads(args.closure.read_text(encoding="utf-8"))
        closure_files = sorted(payload["closure"])
        context_files = sorted(set(payload.get("context", [])) - set(closure_files))
    scope = ("closure:" + args.closure.stem) if args.closure else         args.package if not args.subpackage else "{}[{}]".format(
        args.package, "+".join(sorted(args.subpackage)))
    WORKSPACE.mkdir(parents=True, exist_ok=True)
    client_hash, client_files = sha256_tree(client / "src" / args.package, (".as",))
    print("client package  :", args.package)
    print("source files    :", client_files)
    print("source tree hash:", client_hash[:16])

    exceptions = check_exceptions(client)
    if exception_errors(exceptions):
        print("\nEXCEPTION CONTRACT INVALID — compatibility code is stale or undocumented:")
        for key in ("drifted", "missing_source", "missing_haxe", "unlisted_haxe",
                    "stale_entries", "unannotated", "missing_contract", "missing_api_check"):
            if exceptions.get(key):
                print("   {}: {}".format(key, exceptions[key]))
        print("Regenerate and review evidence/m2_exceptions.json before syncing.")
        return 2

    asset_inputs = check_asset_inputs()
    if asset_inputs["missing_manifest"] or asset_inputs["missing"] or asset_inputs["drifted"]:
        print("\nASSET INPUT CONTRACT INVALID — clean-client UI data moved:")
        print("  ", asset_inputs)
        print("Regenerate and review evidence/m2_asset_inputs.json before syncing.")
        return 2

    runs = []
    passes = 2 if args.check_determinism else 1
    for index in range(passes):
        out = generated if index == 0 else WORKSPACE / "hx-verify"
        if index == 0:
            # Clear only this batch's prior output, not the whole tree. In closure mode the files
            # span packages, so deleting args.package alone leaves stale .hx files in place and
            # can make a no-op conversion look deterministic. Remove every declared closure
            # target explicitly so the produced-file count and hash describe this converter run.
            if closure_files is not None:
                for source_file in closure_files:
                    target_file = out / generated_relative(source_file)
                    if target_file.is_file():
                        target_file.unlink()
            else:
                package_out = out / args.package
                if package_out.exists():
                    shutil.rmtree(package_out)
        elif out.exists():
            shutil.rmtree(out)
        out.mkdir(parents=True, exist_ok=True)
        if closure_files is not None:
            workspace, staged = stage_files(client, closure_files, context_files)
        else:
            workspace, staged = stage_sources(client, args.package, args.subpackage)
        applied, unpinned = apply_rules(workspace, scope)
        if context_files:
            # Convert everything into a scratch tree, then take only what this batch owns.
            scratch = WORKSPACE / "hx-context"
            if scratch.exists():
                shutil.rmtree(scratch)
            scratch.mkdir(parents=True)
            conversion = run_converter(WORKSPACE, scratch)
            for source_file in closure_files:
                produced_file = scratch / generated_relative(source_file)
                if produced_file.is_file():
                    target_file = out / generated_relative(source_file)
                    target_file.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(produced_file, target_file)
            # ax3 also emits Globals.hx, its module-level-function shim. It belongs to no AS3
            # source, so the closure list does not name it and it would silently stop being
            # regenerated -- which is exactly what happened when contexts were introduced.
            globals_module = scratch / "Globals.hx"
            if globals_module.is_file():
                shutil.copy2(globals_module, out / "Globals.hx")
        else:
            conversion = run_converter(WORKSPACE, out)
        # Hash what this batch produced, not the whole output directory: now that batches
        # accumulate, a whole-tree hash would fold unrelated packages into this batch's
        # determinism check and never match the verification pass.
        if closure_files is not None:
            tree_hash, produced = sha256_paths(
                out, [generated_relative(f) for f in closure_files])
        else:
            tree_hash, produced = sha256_tree(out / args.package, (".hx",))
        # ax3 can report a parse failure for one file, skip it, and still exit 0. A run that
        # staged 55 sources and produced 54 outputs looked green, and the missing class only
        # surfaced later as an unresolved type. Every staged source must produce an output.
        runs.append({"generated_files": produced, "staged_files": staged,
                     "unconverted_files": staged - produced,
                     "generated_tree_sha256": tree_hash,
                     "rules": applied, "unpinned_rules": unpinned, "conversion": conversion})
        print("\nrun {}: staged {} .as -> produced {} .hx in {}s (exit {})".format(
            index + 1, staged, produced, conversion["seconds"], conversion["exit_code"]))
        for rule in applied:
            print("   rule {:<28} {:>5} sites / {} files".format(
                rule["id"], rule["sites"], rule["files"]))
        if staged != produced:
            print("   {} staged source(s) produced no .hx -- ax3 skipped them:".format(
                staged - produced))
            for line in conversion["stdout_tail"]:
                if ".as:" in line:
                    print("   |", line)
        if conversion["exit_code"] != 0:
            for line in conversion["stderr_tail"] or conversion["stdout_tail"]:
                print("   |", line)

    deterministic = None
    if passes == 2:
        deterministic = runs[0]["generated_tree_sha256"] == runs[1]["generated_tree_sha256"]
        print("\ndeterministic across two runs:", deterministic)

    client_hash_after, client_files_after = sha256_tree(
        client / "src" / args.package, (".as",))
    client_modified = client_hash_after != client_hash or client_files_after != client_files

    ok = (
        all(run["conversion"]["exit_code"] == 0 and run["generated_files"] > 0 for run in runs)
        and all(not run["unpinned_rules"] for run in runs)
        and all(run["unconverted_files"] == 0 for run in runs)
        and deterministic is True
        and not client_modified
    )

    manifest = {
        "gate": "M2a-sync-pipeline",
        "ok": ok,
        "package": args.package,
        "subpackages": args.subpackage,
        "scope": scope,
        "client": {
            "root": str(client),
            "commit": subprocess.run(["git", "-C", str(client), "rev-parse", "HEAD"],
                                     capture_output=True, text=True).stdout.strip() or None,
            "package_tree_sha256_before": client_hash,
            "package_tree_sha256_after": client_hash_after,
            "source_files": client_files,
            "source_files_after": client_files_after,
            "modified_by_sync": client_modified,
        },
        "tooling": {
            "converter": str(CONVERTER.relative_to(REPO)).replace("\\", "/"),
            "converter_sha256": sha256_file(CONVERTER) if CONVERTER.is_file() else None,
            # Everything that can change the generated bytes is pinned. A manifest that records
            # only the jar cannot tell you why two runs differed.
            "swc": [{"path": s, "sha256": sha256_file(Path(s)) if Path(s).is_file() else None}
                    for s in SWC_LIBRARIES],
            "rules_script_sha256": sha256_file(REPO / "scripts/m2_rules.py"),
            "sync_script_sha256": sha256_file(Path(__file__)),
            "converter_build_script_sha256": sha256_file(
                REPO / "scripts/build-m2-converter.ps1"),
            "patch_script_sha256": sha256_file(REPO / "evidence/m2_patch_ax3.py")
                if (REPO / "evidence/m2_patch_ax3.py").is_file() else None,
            "exception_manifest_sha256": sha256_file(EXCEPTIONS),
            "exception_generator_sha256": sha256_file(REPO / "evidence/m2_build_exceptions.py"),
            "asset_inputs_manifest_sha256": sha256_file(ASSET_INPUTS),
            "asset_inputs_generator_sha256": sha256_file(REPO / "evidence/m2_asset_inputs.py"),
            "python": sys.version.split()[0],
            "java": subprocess.run(["java", "-version"], capture_output=True, text=True)
                    .stderr.splitlines()[0] if shutil.which("java") else None,
        },
        "rules": RULES,
        "runs": runs,
        "deterministic": deterministic,
        "generated_tree_sha256": runs[-1]["generated_tree_sha256"] if runs else None,
        "exceptions": exceptions,
        "asset_inputs": asset_inputs,
    }
    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print("\nmanifest:", manifest_path)

    print(
        "M2a scoped sync ({}):".format(scope),
        "OK" if ok else "INCOMPLETE - see manifest",
    )
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
