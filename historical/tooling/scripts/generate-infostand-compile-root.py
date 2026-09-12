#!/usr/bin/env python3
"""Compile both infostand and its concrete window runtime, not just UI interfaces."""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from sync import generated_relative

REPO = Path(__file__).resolve().parent.parent
GENERATED = REPO / "generated"
CLOSURES = [REPO / "evidence/v20_infostand_closure.json",
            REPO / "evidence/v21_window_runtime_closure.json"]
CANDIDATE = REPO / ".toolchain/v21/generated"
OUT = REPO / "test/V20InfoStandCompileMain.hx"


def main() -> int:
    profile = "--room-ui-profile" in sys.argv[1:]
    services = "--session-data" in sys.argv[1:]
    room_session = "--room-session" in sys.argv[1:]
    friend_list = "--friend-list" in sys.argv[1:]
    if friend_list: room_session = True
    if room_session: services = True
    if services: profile = True
    manager = "--window-manager" in sys.argv[1:] or profile
    closures = CLOSURES + ([REPO / "evidence/v22_window_manager_closure.json"] if manager else [])
    output = REPO / "test/V22WindowManagerCompileMain.hx" if manager else OUT
    main_class = "V22WindowManagerCompileMain" if manager else "V20InfoStandCompileMain"
    if profile:
        closures.append(REPO / "evidence/v24_infostand_profile_closure.json")
        output = REPO / "test/V24InfoStandCompileMain.hx"
        main_class = "V24InfoStandCompileMain"
    if services:
        closures.append(REPO / "evidence/v25_infostand_services_closure.json")
        output = REPO / "test/V25InfoStandServicesCompileMain.hx"
        main_class = "V25InfoStandServicesCompileMain"
    if room_session:
        closures.append(REPO / "evidence/v26_room_session_services_closure.json")
        output = REPO / "test/V26RoomSessionServicesCompileMain.hx"
        main_class = "V26RoomSessionServicesCompileMain"
    if friend_list:
        closures.append(REPO / "evidence/v27_friend_list_services_closure.json")
        output = REPO / "test/V27FriendListServicesCompileMain.hx"
        main_class = "V27FriendListServicesCompileMain"
    closure = sorted({entry for path in closures
                      for entry in json.loads(path.read_text(encoding="utf-8"))["closure"]})
    types, missing = [], []
    for relative in closure:
        generated = generated_relative(relative)
        qualified = generated[:-len(".hx")].replace("/", ".")
        if (CANDIDATE / generated).is_file() or (GENERATED / generated).is_file() or (profile and (REPO / ".toolchain/v24/generated" / generated).is_file()) or (services and (REPO / ".toolchain/v25/generated" / generated).is_file()) or (room_session and (REPO / ".toolchain/v26/generated" / generated).is_file()) or (friend_list and (REPO / ".toolchain/v27/generated" / generated).is_file()):
            types.append(qualified)
        else:
            missing.append(qualified)

    lines = [
        "/** Compile-only root for generated V20 infostand + V21 concrete windows. Regenerate with",
        " *  scripts/generate-infostand-compile-root.py -- do not edit by hand. */",
        f"class {main_class} {{",
    ]
    for index, qualified in enumerate(sorted(set(types))):
        lines.append(f"    static var infostand{index}:{qualified};")
    lines.extend([
        "",
        "    public static function main():Void {}",
        "}",
        "",
    ])
    output.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    print(f"wrote {output.relative_to(REPO)}: {len(set(types))} types")
    if missing:
        print(f"{len(missing)} closure entries have no generated file:")
        for qualified in sorted(set(missing)):
            print(f"   {qualified}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
