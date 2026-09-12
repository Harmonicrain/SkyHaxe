#!/usr/bin/env python3
"""Create, finalize, inspect, promote, or roll back an isolated SkyHaxe update candidate."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
SUPPORT = Path(__file__).resolve().parent
ACTIVE = {"generated": REPO / ".skyhaxe/generated", "platform": REPO / ".skyhaxe/platform",
          "compat": REPO / ".skyhaxe/compat", "assets": REPO / "build-support/assets"}


def now() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def tree_manifest(root: Path) -> dict:
    files, total, aggregate = [], 0, hashlib.sha256()
    if not root.is_dir():
        return {"file_count": 0, "total_bytes": 0, "aggregate_sha256": None, "files": []}
    for path in sorted((p for p in root.rglob("*") if p.is_file()),
                       key=lambda p: p.relative_to(root).as_posix().lower()):
        rel, size, digest = path.relative_to(root).as_posix(), path.stat().st_size, sha256_file(path)
        files.append({"path": rel, "size": size, "sha256": digest})
        total += size
        aggregate.update(rel.encode()); aggregate.update(b"\0"); aggregate.update(bytes.fromhex(digest))
    return {"file_count": len(files), "total_bytes": total,
            "aggregate_sha256": aggregate.hexdigest(), "files": files}


def compact(tree: dict) -> dict:
    return {key: tree[key] for key in ("file_count", "total_bytes", "aggregate_sha256")}


def compare(left: dict, right: dict) -> dict:
    a, b = ({x["path"]: x for x in tree["files"]} for tree in (left, right))
    return {
        "added": sorted(set(b) - set(a), key=str.lower),
        "removed": sorted(set(a) - set(b), key=str.lower),
        "changed": sorted((p for p in set(a) & set(b) if a[p]["sha256"] != b[p]["sha256"]),
                          key=str.lower),
    }


def run(command: list[str], cwd: Path = REPO, capture: bool = False) -> subprocess.CompletedProcess:
    print("+", subprocess.list2cmdline(command), flush=True)
    result = subprocess.run(command, cwd=cwd, text=True, capture_output=capture)
    if result.returncode:
        detail = (result.stderr or result.stdout or "").strip()
        raise RuntimeError(f"command failed ({result.returncode}): {detail[-4000:]}")
    return result


def apply_guarded_patch(root: Path, patch: Path) -> str:
    base = ["git", "-c", "core.autocrlf=false", "apply", "--whitespace=nowarn"]
    check = subprocess.run(base + ["--check", str(patch)], cwd=root, capture_output=True, text=True)
    if check.returncode == 0:
        run(base + [str(patch)], cwd=root)
        return "applied"
    reverse = subprocess.run(base + ["--reverse", "--check", str(patch)], cwd=root,
                             capture_output=True, text=True)
    if reverse.returncode == 0:
        return "already-applied"
    raise RuntimeError("guarded patch conflict: " + str(patch) + "\n" +
                       (check.stderr or check.stdout)[-4000:])


def git_info(source: Path, include_dirty: bool) -> dict:
    commit = run(["git", "-C", str(source), "rev-parse", "HEAD"], capture=True).stdout.strip()
    status = run(["git", "-C", str(source), "status", "--porcelain=v1", "--untracked-files=all"],
                 capture=True).stdout.splitlines()
    if status and not include_dirty:
        raise RuntimeError("upstream checkout is dirty; pass -IncludeDirty to snapshot its exact content")
    return {"commit": commit, "dirty": bool(status), "status": status}


def require_outside_repo(path: Path) -> None:
    try:
        path.resolve().relative_to(REPO.resolve())
    except ValueError:
        return
    raise RuntimeError("candidate root must be outside the SkyHaxe repository")


def load_candidate(path: Path) -> dict:
    manifest = path / "UPDATE-MANIFEST.json"
    if not manifest.is_file():
        raise RuntimeError(f"not a SkyHaxe update candidate: {path}")
    return json.loads(manifest.read_text(encoding="utf-8"))


def save(path: Path, payload: dict) -> None:
    (path / "UPDATE-MANIFEST.json").write_text(
        json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")


def discover(source: Path, base: str, output: Path) -> dict:
    run([sys.executable, str(SUPPORT / "discover-update.py"), "--source-root", str(source),
         "--base-closure", str(SUPPORT / base), "--output", str(output)])
    return json.loads(output.read_text(encoding="utf-8"))


def combined_base(output: Path) -> None:
    inputs = [json.loads((SUPPORT / name).read_text(encoding="utf-8")) for name in
              ("v32_component_graph_boot_closure.json", "v33_loading_screen_closure.json")]
    payload = {
        "gate": "SkyHaxe-full-client-update",
        "roots": sorted({item for source in inputs for item in source["roots"]}, key=str.lower),
        "closure": sorted({item for source in inputs for item in source["closure"]}, key=str.lower),
        "seams": {key: value for source in inputs for key, value in source.get("seams", {}).items()},
    }
    output.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")


def prepare(args: argparse.Namespace) -> int:
    source, parent = args.source_root.resolve(), args.candidates_root.resolve()
    require_outside_repo(parent)
    info = git_info(source, args.include_dirty)
    identifier = args.candidate_id or f"{now()}-{info['commit'][:10]}"
    root = parent / identifier
    if root.exists():
        raise RuntimeError(f"candidate already exists: {root}")
    root.mkdir(parents=True)
    try:
        shutil.copytree(source / "src", root / "upstream/src")
        shutil.copytree(ACTIVE["compat"], root / "compat")
        shutil.copytree(ACTIVE["assets"], root / "build-support/assets")
        active_trees = {name: tree_manifest(path) for name, path in ACTIVE.items()}
        source_tree = tree_manifest(root / "upstream/src")
        closure_dir = root / "closures"; closure_dir.mkdir()
        base = closure_dir / "supported-roots.json"; combined_base(base)
        full = discover(root / "upstream", str(base),
                        closure_dir / "v32_component_graph_boot_closure.json")
        run([sys.executable, str(SUPPORT / "prepare-candidate-assets.py"), "--candidate", str(root)])
        manifest = {
            "schema": 1, "candidate_id": identifier, "created_utc": datetime.now(timezone.utc).isoformat(),
            "state": "prepared", "finalized": False, "source": {**info, "root": str(source),
            "snapshot": compact(source_tree)}, "active_at_creation": {k: compact(v) for k, v in active_trees.items()},
            "closure": {"files": full["closure_files"], "assets": len(full["embedded_assets"])},
            "source_changes": full["closure_changes"],
            "missing_embedded_assets": [item for item in full["embedded_assets"] if not item["exists"]],
            "class_resolution_boundary": {
                "converted_transitive_source": True,
                "declared_seams": full.get("seams", {}),
                "platform_prefixes": ["flash/", "__AS3__/", "mx/", "fl/"],
                "client_swc_policy": "typing fallback only; every reachable indexed AS3 class is in the closure",
            },
            "checks": [], "differences": {},
        }
        save(root, manifest)
        return convert_and_build(root, manifest, finalize=args.finalize)
    except Exception as error:
        manifest_path = root / "UPDATE-MANIFEST.json"
        if manifest_path.is_file():
            failed = json.loads(manifest_path.read_text(encoding="utf-8"))
            failed.update({"state": "failed", "error": str(error),
                           "failed_utc": datetime.now(timezone.utc).isoformat()})
            save(root, failed)
        (root / "FAILED").write_text("Candidate preparation failed; active client was untouched.\n",
                                     encoding="utf-8")
        raise


def convert_and_build(root: Path, manifest: dict, finalize: bool) -> int:
    generated = root / "generated"; generated.mkdir(exist_ok=True)
    passes = []
    for name in ("v32_component_graph_boot_closure.json",):
        sync_manifest = root / "reports" / name.replace("_closure.json", "-sync.json")
        sync_manifest.parent.mkdir(exist_ok=True)
        reusable = (finalize and sync_manifest.is_file() and generated.is_dir())
        sync = json.loads(sync_manifest.read_text(encoding="utf-8")) if reusable else None
        reusable = bool(reusable and sync.get("published") and sync.get("deterministic") is True)
        if not reusable:
            command = [sys.executable, str(SUPPORT / "sync.py"), "--client-root", str(root / "upstream"),
                       "--closure", str(root / "closures" / name), "--generated-root", str(generated),
                       "--workspace-root", str(root / "work" / name.removesuffix(".json")),
                       "--manifest", str(sync_manifest), "--expectation-mode", "report",
                       "--contract-mode", "report"]
            if finalize:
                command.append("--check-determinism")
            run(command)
            sync = json.loads(sync_manifest.read_text(encoding="utf-8"))
        if not sync.get("published"):
            raise RuntimeError(f"conversion did not publish {name}; see {sync_manifest}")
        if finalize and sync.get("deterministic") is not True:
            raise RuntimeError(f"final conversion was not deterministic: {name}")
        passes.append({"closure": name, "manifest": str(sync_manifest.relative_to(root)),
                       "rewrite_drift": sync["runs"][-1]["unpinned_rules"],
                       "exceptions": sync["exceptions"], "asset_inputs": sync["asset_inputs"]})

    from reproduce import build_platform
    config = json.loads((SUPPORT / "composition.json").read_text(encoding="utf-8"))
    generated_patch = apply_guarded_patch(generated, REPO / config["post_generation_patch"]["path"])
    platform = root / "platform"
    if platform.exists(): shutil.rmtree(platform)
    platform.mkdir()
    build_platform(config, generated, platform)
    shutil.copyfile(root / "EmbeddedFontCatalog.hx",
                    platform / "skyhaxe/assets/EmbeddedFontCatalog.hx")
    build = run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                 str(REPO / "scripts/build.ps1"), "-CandidateRoot", str(root), "-SkipBootstrap"])

    candidate_trees = {name: tree_manifest(root / name) for name in ("generated", "platform", "compat")}
    candidate_trees["assets"] = tree_manifest(root / "build-support/assets")
    baseline = {name: tree_manifest(path) for name, path in ACTIVE.items()}
    manifest.update({
        "state": "compiled", "finalized": finalize,
        "conversion": passes,
        "generated_patch": generated_patch,
        "candidate_trees": {k: compact(v) for k, v in candidate_trees.items()},
        "differences": {k: compare(baseline[k], candidate_trees[k]) for k in candidate_trees},
        "build": {"ok": build.returncode == 0,
                  "index": "build/client/html5/bin/index.html"},
        "checks": manifest.get("checks", []) + ["isolated-source-snapshot", "guarded-patches",
                                                   "isolated-html5-build"],
    })
    save(root, manifest)
    print(json.dumps({"candidate": str(root), "state": manifest["state"],
                      "finalized": finalize, "differences": manifest["differences"]}, indent=2))
    return 0


def finalize(args: argparse.Namespace) -> int:
    root = args.candidate.resolve(); manifest = load_candidate(root)
    if manifest["state"] not in ("prepared", "compiled", "failed"):
        raise RuntimeError(f"cannot finalize candidate in state {manifest['state']}")
    run([sys.executable, str(SUPPORT / "prepare-candidate-assets.py"), "--candidate", str(root)])
    manifest.pop("error", None); manifest.pop("failed_utc", None)
    result = convert_and_build(root, manifest, finalize=True)
    (root / "FAILED").unlink(missing_ok=True)
    return result


def promote(args: argparse.Namespace) -> int:
    root = args.candidate.resolve(); manifest = load_candidate(root)
    if manifest.get("state") != "compiled" or not manifest.get("finalized") or not manifest["build"]["ok"]:
        raise RuntimeError("candidate must be compiled and finalized before promotion")
    current = {name: tree_manifest(path) for name, path in ACTIVE.items()}
    for name, tree in current.items():
        if compact(tree) != manifest["active_at_creation"][name]:
            raise RuntimeError(f"active {name} changed since candidate creation; refusing promotion")
    rollback = args.rollback_root.resolve() / f"rollback-{now()}-{manifest['candidate_id']}"
    require_outside_repo(rollback)
    rollback.mkdir(parents=True)
    for name, path in ACTIVE.items():
        shutil.copytree(path, rollback / name)
    (rollback / "ROLLBACK-MANIFEST.json").write_text(json.dumps({
        "schema": 1, "candidate": str(root), "trees": {k: compact(v) for k, v in current.items()}
    }, indent=2) + "\n", encoding="utf-8")
    sources = {"generated": root / "generated", "platform": root / "platform",
               "compat": root / "compat", "assets": root / "build-support/assets"}
    staged = {}
    for name, destination in ACTIVE.items():
        temp = destination.with_name(destination.name + ".promote-new")
        if temp.exists(): shutil.rmtree(temp)
        shutil.copytree(sources[name], temp); staged[name] = temp
    for name, destination in ACTIVE.items():
        old = destination.with_name(destination.name + ".promote-old")
        if old.exists(): shutil.rmtree(old)
        destination.rename(old); staged[name].rename(destination); shutil.rmtree(old)
    manifest.update({"state": "promoted", "promoted_utc": datetime.now(timezone.utc).isoformat(),
                     "rollback": str(rollback)})
    save(root, manifest)
    print(json.dumps({"promoted": manifest["candidate_id"], "rollback": str(rollback)}, indent=2))
    return 0


def rollback(args: argparse.Namespace) -> int:
    source = args.rollback.resolve()
    record = source / "ROLLBACK-MANIFEST.json"
    if not record.is_file(): raise RuntimeError(f"invalid rollback snapshot: {source}")
    for name, destination in ACTIVE.items():
        expected = json.loads(record.read_text(encoding="utf-8"))["trees"][name]
        if compact(tree_manifest(source / name)) != expected:
            raise RuntimeError(f"rollback snapshot failed integrity check: {name}")
        temp = destination.with_name(destination.name + ".rollback-new")
        if temp.exists(): shutil.rmtree(temp)
        shutil.copytree(source / name, temp)
        old = destination.with_name(destination.name + ".rollback-old")
        if old.exists(): shutil.rmtree(old)
        destination.rename(old); temp.rename(destination); shutil.rmtree(old)
    print(f"Restored {source}")
    return 0


def parser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="command", required=True)
    p = sub.add_parser("prepare"); p.add_argument("--source-root", type=Path, required=True)
    p.add_argument("--candidates-root", type=Path, required=True); p.add_argument("--candidate-id")
    p.add_argument("--include-dirty", action="store_true"); p.add_argument("--finalize", action="store_true")
    p.set_defaults(func=prepare)
    p = sub.add_parser("finalize"); p.add_argument("--candidate", type=Path, required=True); p.set_defaults(func=finalize)
    p = sub.add_parser("promote"); p.add_argument("--candidate", type=Path, required=True)
    p.add_argument("--rollback-root", type=Path, required=True); p.set_defaults(func=promote)
    p = sub.add_parser("rollback"); p.add_argument("--rollback", type=Path, required=True); p.set_defaults(func=rollback)
    return ap


if __name__ == "__main__":
    try:
        arguments = parser().parse_args()
        raise SystemExit(arguments.func(arguments))
    except (OSError, RuntimeError, subprocess.CalledProcessError) as error:
        print(f"ERROR: {error}", file=sys.stderr); raise SystemExit(1)
