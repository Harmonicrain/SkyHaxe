#!/usr/bin/env python3
"""Pin the Flash room-renderer behaviors exercised by G4 to source evidence."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path

DEFAULT_ROOT = Path(r"C:\habbo\client\habbo-client-clean\src")
FILES = {
    "canvas": Path("com/sulake/room/renderer/RoomSpriteCanvas.as"),
    "extended_sprite": Path("com/sulake/room/renderer/utils/ExtendedSprite.as"),
    "room_object_sprite": Path("com/sulake/room/object/visualization/RoomObjectSprite.as"),
    "alpha_tolerance": Path("com/sulake/room/object/enum/AlphaTolerance.as"),
}
REQUIRED = {
    "display_list_sort": ("canvas", r'sortOn\("z", \(Array\.DESCENDING \| Array\.NUMERIC\)\)'),
    "display_add": ("canvas", r"_display\.addChild\(_local_3\)"),
    "display_insert": ("canvas", r"_display\.addChildAt\(_local_3, _arg_2\)"),
    "display_mask": ("canvas", r"this\._display\.mask = this\._spriteMask"),
    "pool_pop": ("canvas", r"this\._spritePool\.pop\(\)"),
    "pool_push": ("canvas", r"this\._spritePool\.push\(_local_4\)"),
    "blend_mode": ("canvas", r"_local_3\.blendMode = _local_4\.blendMode"),
    "filters": ("canvas", r"_local_3\.filters = _local_4\.filters"),
    "alpha_tolerance_copy": ("canvas", r"_local_3\.alphaTolerance = _local_4\.alphaTolerance"),
    "front_to_back_pick": ("canvas", r"this\._Str_21597 - 1"),
    "local_hit_test": ("canvas", r"hitTestPoint\(\(k - _local_10\.x\), \(_arg_2 - _local_10\.y\)\)"),
    "signed_alpha_shift": ("extended_sprite", r"_local_4 = \(_local_4 >> 24\)"),
    "strict_threshold_compare": ("extended_sprite", r"_local_4 > this\._threshold"),
    "match_all": ("alpha_tolerance", r"MATCH_ALL_PIXELS:int = -1"),
    "match_opaque": ("alpha_tolerance", r"MATCH_OPAQUE_PIXELS:int = 128"),
    "match_nothing": ("alpha_tolerance", r"MATCH_NOTHING:int = 0x0100"),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-root", type=Path, default=DEFAULT_ROOT)
    parser.add_argument("--output", type=Path,
                        default=Path(__file__).with_name("g4_renderer_contract.json"))
    args = parser.parse_args()
    root = args.source_root.resolve()
    texts: dict[str, str] = {}
    files: dict[str, object] = {}
    for key, relative in FILES.items():
        path = root / relative
        if not path.is_file():
            raise SystemExit(f"missing renderer source: {path}")
        text = path.read_text(encoding="utf-8-sig")
        texts[key] = text
        files[key] = {"relative": relative.as_posix(), "lines": text.count("\n") + 1,
                      "sha256": sha256(path)}

    assertions: dict[str, object] = {}
    missing: list[str] = []
    for name, (file_key, pattern) in REQUIRED.items():
        matches = list(re.finditer(pattern, texts[file_key]))
        if not matches:
            missing.append(name)
            continue
        assertions[name] = {
            "file": FILES[file_key].as_posix(),
            "count": len(matches),
            "lines": [texts[file_key].count("\n", 0, match.start()) + 1 for match in matches],
        }

    result = {
        "gate": "G4-renderer-contract",
        "generated_utc": datetime.now(timezone.utc).isoformat(),
        "source_root": str(root),
        "files": files,
        "assertions": assertions,
        "missing": missing,
        "note": ("AIR runtime capture is authoritative for the signed-shift boundary: alpha 127 "
                 "does not hit, while 128 and 129 do at tolerance 128."),
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"G4_RENDERER_CONTRACT_PASS assertions={len(assertions)} missing={len(missing)}")
    return 1 if missing else 0


if __name__ == "__main__":
    raise SystemExit(main())
