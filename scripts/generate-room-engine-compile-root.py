#!/usr/bin/env python3
"""Emit a compile-only root naming every generated type in the room-engine closures.

The room engine landed as four closures -- RoomManager (v11), the Component base it extends (v12),
the visualization factory and its 31 furniture visualizations (v13), and the logic component with
its 65 furniture logic classes and 40 room messages (v14). None of them is reachable from the demo
entry point yet, and Haxe only types what the entry point reaches, so 353 files that convert but do
not compile would look exactly like success.

Mirrors scripts/generate-guest-room-compile-root.py.

Usage:
    python scripts/generate-room-engine-compile-root.py
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from sync import generated_relative

REPO = Path(__file__).resolve().parent.parent
GENERATED = REPO / "generated"
# v18 (AvatarRenderManager) is converted and gated but deliberately absent: it reaches
# AvatarAssetDownloadManager, which needs IAssetLibrary.loadAssetFromFile -- the AS3
# LibraryLoader/FZip download stack this port replaces with SwfFile. Compiling it means
# deciding that seam first. See M3b in CHECKLIST.md.
CLOSURES = [
    "evidence/v11_room_manager_closure.json",
    "evidence/v12_component_closure.json",
    "evidence/v13_visualization_factory_closure.json",
    "evidence/v14_logic_component_closure.json",
    "evidence/v15_room_engine_completion_closure.json",
    "evidence/v16_room_message_handler_closure.json",
    "evidence/v17_room_renderer_closure.json",
    "evidence/v19_room_engine_closure.json",
]
OUT = REPO / "test/RoomEngineCompileMain.hx"


def main() -> int:
    types, missing = [], []
    for name in CLOSURES:
        path = REPO / name
        if not path.is_file():
            # v15 is grown from the compiler's own "Type not found" list, so it does not exist
            # until the first compile has run.
            continue
        for relative in json.loads(path.read_text(encoding="utf-8"))["closure"]:
            generated = generated_relative(relative)
            qualified = generated[: -len(".hx")].replace("/", ".")
            if (GENERATED / generated).is_file():
                types.append(qualified)
            else:
                missing.append(qualified)

    types = sorted(set(types))
    lines = [
        "/** Compile-only root for the generated room-engine closures. Regenerate with",
        " *  scripts/generate-room-engine-compile-root.py -- do not edit by hand. */",
        "class RoomEngineCompileMain {",
    ]
    for index, qualified in enumerate(types):
        lines.append(f"    static var engine{index}:{qualified};")
    lines.extend([
        "",
        "    public static function main():Void {",
        f"        // {len(types)} generated room-engine types referenced above.",
        "    }",
        "}",
        "",
    ])
    OUT.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    print(f"wrote {OUT.relative_to(REPO)}: {len(types)} types")
    if missing:
        print(f"{len(missing)} closure entries have no generated file:")
        for qualified in sorted(set(missing)):
            print(f"   {qualified}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
