#!/usr/bin/env python3
"""Discover the AS3 dependency closure for an isolated SkyHaxe update candidate."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from collections import deque
from pathlib import Path

PACKAGE = re.compile(r"(?m)^\s*package(?:\s+([\w.]+))?")
IMPORT = re.compile(r"(?m)^\s*import\s+([\w.]+)\s*;")
WILDCARD = re.compile(r"(?m)^\s*import\s+([\w.]+)\.\*\s*;")
QUALIFIED = re.compile(r"\b((?:[a-z_]\w*\.){2,}[A-Z_]\w*)\b")
IDENT = re.compile(r"\b([A-Z_][A-Za-z0-9_]*)\b")
REFLECTED = re.compile(r"[\"']((?:[a-z_]\w*\.){2,}[A-Z_]\w*)[\"']")
EMBED = re.compile(r"\[Embed\s*\([^\]]*?source\s*=\s*[\"']([^\"']+)[\"']", re.S)
STRINGS_COMMENTS = re.compile(
    r'"(?:[^"\\]|\\.)*"|\'(?:[^\'\\]|\\.)*\'|//[^\n]*|/\*.*?\*/', re.S)
SKIP_PREFIXES = ("flash/", "__AS3__/", "mx/", "fl/")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def index_sources(source: Path) -> tuple[dict[str, str], dict[tuple[str, str], str]]:
    qualified: dict[str, str] = {}
    siblings: dict[tuple[str, str], str] = {}
    for path in sorted(source.rglob("*.as")):
        relative = path.relative_to(source).as_posix()
        # The clean client's package layout mirrors its declared AS3 package. Avoid opening all
        # 8k+ sources merely to construct the index; reached sources are still parsed below.
        package = ".".join(Path(relative).parent.parts)
        if package == ".": package = ""
        name = path.stem
        identity = f"{package}.{name}" if package else name
        qualified[identity] = relative
        siblings[(package, name)] = relative
    return qualified, siblings


def discover(source: Path, roots: list[str], seams: set[str]) -> tuple[list[str], list[dict], list[str]]:
    by_qualified, siblings = index_sources(source)
    by_relative = {value: key for key, value in by_qualified.items()}
    seam_keys = {item.replace("\\", "/").lower() for item in seams}
    queue = deque(roots)
    queued = set(roots)
    seen: set[str] = set()
    assets: dict[str, dict] = {}
    unresolved: set[str] = set()

    while queue:
        relative = queue.popleft().replace("\\", "/")
        if relative.lower() in seam_keys or relative in seen:
            continue
        path = source / relative
        if not path.is_file():
            unresolved.add(relative)
            continue
        seen.add(relative)
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        package_match = PACKAGE.search(text)
        package = (package_match.group(1) or "") if package_match else ""
        imports = {name.rsplit(".", 1)[-1]: name for name in IMPORT.findall(text)}
        wildcards = WILDCARD.findall(text)
        code = STRINGS_COMMENTS.sub(" ", text)

        identities = set(QUALIFIED.findall(code)) | set(REFLECTED.findall(text))
        for name in IDENT.findall(code):
            if name in imports:
                identities.add(imports[name])
            elif (package, name) in siblings:
                target = siblings[(package, name)]
                if target not in seen and target not in queued:
                    queue.append(target); queued.add(target)
            else:
                for wildcard in wildcards:
                    identity = f"{wildcard}.{name}"
                    if identity in by_qualified:
                        identities.add(identity)
        for identity in identities:
            relative_target = by_qualified.get(identity)
            if (relative_target and not relative_target.startswith(SKIP_PREFIXES)
                    and relative_target not in seen and relative_target not in queued):
                queue.append(relative_target); queued.add(relative_target)

        for asset in EMBED.findall(text):
            normalized = (path.parent / asset).resolve()
            exists = normalized.is_file()
            key = str(normalized)
            assets[key] = {
                "declared_by": relative,
                "source": asset,
                "resolved": key,
                "exists": exists,
                "sha256": sha256(normalized) if exists else None,
            }
    return sorted(seen, key=str.lower), sorted(assets.values(), key=lambda x: x["resolved"].lower()), sorted(unresolved)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-root", type=Path, required=True)
    parser.add_argument("--base-closure", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    source = args.source_root.resolve() / "src"
    base = json.loads(args.base_closure.read_text(encoding="utf-8"))
    roots = list(base["roots"])
    closure, assets, unresolved = discover(source, roots, set(base.get("seams", {})))
    previous = set(base.get("closure", []))
    current = set(closure)
    payload = {
        "gate": base.get("gate", "SkyHaxe-update-candidate"),
        "roots": roots,
        "closure": closure,
        "context": [],
        "seams": base.get("seams", {}),
        "closure_files": len(closure),
        "embedded_assets": assets,
        "closure_changes": {
            "added": sorted(current - previous, key=str.lower),
            "removed": sorted(previous - current, key=str.lower),
        },
        "unresolved_roots": unresolved,
        "discovery": "transitive imports, same-package types, qualified/reflected names",
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(json.dumps({"closure_files": len(closure), "assets": len(assets),
                      "added": len(current - previous), "removed": len(previous - current),
                      "missing_assets": sum(not item["exists"] for item in assets),
                      "unresolved": unresolved}, indent=2))
    return 1 if unresolved else 0


if __name__ == "__main__":
    raise SystemExit(main())
