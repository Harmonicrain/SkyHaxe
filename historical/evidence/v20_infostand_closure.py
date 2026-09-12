#!/usr/bin/env python3
"""Measure the first incremental clean-client closure for the real room infostand path.

The first batch lands the original widget, views, handler, messages, and their shared contracts.
RoomDesktop and RoomUI remain required later owners, but adding RoomDesktop statically reaches
every room widget. Their measured frontiers are recorded here so that large jump is explicit
rather than hidden behind a custom overlay.
"""
from __future__ import annotations

import importlib.util
import json
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")
OUT = Path(__file__).with_suffix(".json")

FULL_ROOTS = [
    "com/sulake/habbo/ui/RoomUI.as",
    "com/sulake/habbo/ui/RoomDesktop.as",
    "com/sulake/habbo/ui/widget/RoomWidgetFactory.as",
    "com/sulake/habbo/ui/handler/InfoStandWidgetHandler.as",
    "com/sulake/habbo/ui/widget/infostand/InfoStandWidget.as",
]

ROOT_GROUPS = {
    "infostand": [
        "com/sulake/habbo/ui/handler/InfoStandWidgetHandler.as",
        "com/sulake/habbo/ui/widget/infostand/InfoStandWidget.as",
    ],
    "selection": [
        "com/sulake/habbo/ui/RoomDesktop.as",
        "com/sulake/habbo/ui/handler/InfoStandWidgetHandler.as",
        "com/sulake/habbo/ui/widget/infostand/InfoStandWidget.as",
    ],
    "desktop": [
        "com/sulake/habbo/ui/RoomUI.as",
        "com/sulake/habbo/ui/RoomDesktop.as",
        "com/sulake/habbo/ui/handler/InfoStandWidgetHandler.as",
        "com/sulake/habbo/ui/widget/infostand/InfoStandWidget.as",
    ],
    "full": FULL_ROOTS,
}

ACTIVE_GROUP = "infostand"

# Target-only replacements already owned by SkyHaxe. Following these AS3 implementations would
# reintroduce Flash loaders, ExternalInterface, or the connection stack behind a browser seam.
SEAMS = {
    "com/sulake/core/utils/Map.as":
        "Existing tested Flash Proxy map adapter; not part of the UI migration",
    "com/sulake/habbo/communication/IHabboCommunicationManager.as":
        "HTML5 uses the authenticated SkyConnection transport adapter",
    "com/sulake/habbo/utils/HabboWebTools.as":
        "ExternalInterface/browser bridge supplied by the HTML5 host",
    "com/sulake/habbo/avatar/AvatarRenderManager.as":
        "HTML5 avatar asset loading is supplied by the existing generated-compositor adapter",
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
        result.add((relative[:-3] + ".as").replace("/_enum/", "/enum/").lower())
    return result


def main() -> int:
    walker = load_walker()
    seams = {path.lower() for path in walker.seam_sources() | set(SEAMS)}

    def walk(roots: list[str]) -> set[str]:
        seen: set[str] = set()
        queue = list(roots)
        while queue:
            relative = queue.pop()
            if relative in seen or relative.lower() in seams:
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
        return seen

    generated = generated_source_paths()
    for name, roots in ROOT_GROUPS.items():
        group_seen = walk(roots)
        incremental = {path for path in group_seen if path.lower() not in generated}
        group_lines = sum(len((CLIENT / path).read_text(
            encoding="utf-8-sig", errors="replace").splitlines()) for path in incremental)
        print(f"{name:10} incremental={len(incremental):4} files/{group_lines:6} lines "
              f"transitive={len(group_seen):4}")

    roots = ROOT_GROUPS[ACTIVE_GROUP]
    seen = walk(roots)

    previous: set[str] = set()
    if OUT.is_file():
        prior = json.loads(OUT.read_text(encoding="utf-8"))
        if (prior.get("active_group") == ACTIVE_GROUP
                and len(prior.get("closure", [])) <= len(seen)):
            previous = set(prior.get("closure", []))
    closure = sorted(path for path in (
        {path for path in seen if path.lower() not in generated} | previous | set(roots))
        if path.lower() not in seams)
    lines = sum(len((CLIENT / path).read_text(
        encoding="utf-8-sig", errors="replace").splitlines()) for path in closure)
    packages = Counter("/".join(path.split("/")[:-1]) for path in closure)
    payload = {
        "gate": "V20-infostand-vertical-closure",
        "roots": roots,
        "active_group": ACTIVE_GROUP,
        "closure_files": len(closure),
        "closure_source_lines": lines,
        "closure": closure,
        "packages": dict(packages.most_common()),
        "seams": SEAMS,
        "full_transitive_files_excluding_seams": len(seen),
        "note": "Incremental closure over the generated production RoomEngine baseline.",
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"Infostand {ACTIVE_GROUP} closure: {len(closure)} files / {lines} lines")
    print(f"Full transitive closure excluding seams: {len(seen)} files")
    for package, count in packages.most_common(20):
        print(f"  {count:3} {package}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
