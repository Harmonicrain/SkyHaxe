#!/usr/bin/env python3
"""Measure the incremental dependency closure needed to land RoomEngine (M3c/V19).

The complete transitive closure is deliberately larger than this batch: earlier room, renderer,
avatar and protocol slices already own most of it.  This records only types not present before M3c,
while retaining its previous result on reruns so generating the files does not make the measured
batch disappear.

Three AS3 edges are target seams rather than conversion candidates.  RoomContentLoader downloads
and executes library SWFs through LibraryLoader/FZip; SkyHaxe reads those SWFs through SwfFile.
IHabboCommunicationManager reaches the Flash handshake/crypto graph even though RoomEngine only
needs the already-open IConnection.  HabboWebTools is an ExternalInterface browser bridge.
"""
from __future__ import annotations

import importlib.util
import json
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")
OUT = Path(__file__).with_suffix(".json")
ROOT = "com/sulake/habbo/room/RoomEngine.as"

SEAMS = {
    "com/sulake/habbo/room/RoomContentLoader.as":
        "Flash LibraryLoader/FZip content downloader; the HTML5 adapter uses SwfFile",
    "com/sulake/habbo/communication/IHabboCommunicationManager.as":
        "RoomEngine needs only IConnection; the HTML5 connection adapter owns transport",
    "com/sulake/habbo/utils/HabboWebTools.as":
        "ExternalInterface/browser bridge with no direct HTML5 equivalent",
}


def load_walker():
    path = REPO / "scripts/generate-closure-context.py"
    spec = importlib.util.spec_from_file_location("closure_context", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def generated_source_paths() -> set[str]:
    result = set()
    for path in (REPO / "generated").rglob("*.hx"):
        relative = path.relative_to(REPO / "generated").as_posix()
        result.add(relative[:-3] + ".as")
    return result


def main() -> int:
    walker = load_walker()
    platform_seams = walker.seam_sources() | set(SEAMS)
    seen: set[str] = set()
    queue = [ROOT]
    while queue:
        relative = queue.pop()
        if relative in seen or relative in platform_seams:
            continue
        if not (CLIENT / relative).is_file():
            continue
        seen.add(relative)
        for reference in walker.references(relative):
            if reference.startswith(walker.SKIP_ROOTS):
                continue
            candidate = reference + ".as"
            if (CLIENT / candidate).is_file():
                queue.append(candidate)

    # Before the first run, existing generated files are prerequisites owned by earlier slices.
    # Afterwards retain this slice's recorded members, so a rerun is stable after they exist.
    previous: set[str] = set()
    if OUT.is_file():
        previous = set(json.loads(OUT.read_text(encoding="utf-8")).get("closure", []))
    closure = sorted((seen - generated_source_paths()) | previous | {ROOT})
    lines = sum(len((CLIENT / p).read_text(encoding="utf-8-sig", errors="replace").splitlines())
                for p in closure)
    packages = Counter("/".join(p.split("/")[:-1]) for p in closure)
    payload = {
        "gate": "V19-room-engine-closure",
        "root": ROOT,
        "closure_files": len(closure),
        "closure_source_lines": lines,
        "closure": closure,
        "packages": dict(packages.most_common()),
        "seams": SEAMS,
        "full_transitive_files_excluding_seams": len(seen),
        "note": "Incremental M3c batch over the generated tree that preceded it.",
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"RoomEngine incremental closure: {len(closure)} files / {lines} lines")
    for package, count in packages.most_common(15):
        print(f"  {count:3} {package}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
