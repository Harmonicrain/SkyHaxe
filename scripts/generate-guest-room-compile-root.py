#!/usr/bin/env python3
"""Emit a compile-only root that names every generated guest-room-closure type.

The client build proves nothing about these: Haxe types only what the entry point reaches, and the
guest-room renderer is not wired into the demo yet. 114 files that convert but do not compile would
look exactly like success. Naming each type in one root forces the compiler to resolve all of them.

The list comes from the measured closure rather than from a directory walk, because the closure
spans 25 packages and pulls only part of several of them.

Mirrors scripts/generate-parser-compile-root.py, which does the same job for the message parsers.

Usage:
    python scripts/generate-guest-room-compile-root.py
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from sync import generated_relative

REPO = Path(__file__).resolve().parent.parent
GENERATED = REPO / "generated"
CLOSURE = REPO / "evidence/v7_guest_room_closure.json"
OUT = REPO / "test/V7GuestRoomCompileMain.hx"


def main() -> int:
    closure = json.loads(CLOSURE.read_text(encoding="utf-8"))["closure"]
    types = []
    missing = []
    for relative in closure:
        # The converter escapes package segments Haxe reserves, so the generated path is not just
        # the source path with a new suffix: com/sulake/habbo/avatar/enum lands under _enum.
        generated = generated_relative(relative)
        qualified = generated[: -len(".hx")].replace("/", ".")
        if (GENERATED / generated).is_file():
            types.append(qualified)
        else:
            missing.append(qualified)

    lines = [
        "/** Compile-only root for the generated guest-room closure. Regenerate with",
        " *  scripts/generate-guest-room-compile-root.py -- do not edit by hand. */",
        "class V7GuestRoomCompileMain {",
    ]
    for index, qualified in enumerate(sorted(types)):
        lines.append(f"    static var guest{index}:{qualified};")
    lines.extend([
        "",
        "    public static function main():Void {",
        f"        // {len(types)} generated guest-room-closure types referenced above.",
        "    }",
        "}",
        "",
    ])
    OUT.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    print(f"named {len(types)} generated types in {OUT.relative_to(REPO)}")
    if missing:
        print(f"not generated ({len(missing)}): " + ", ".join(sorted(missing)[:10]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
