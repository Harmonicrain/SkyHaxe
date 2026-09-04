#!/usr/bin/env python3
"""Measure how an avatar library SWF names the things the compositor asks for.

Written after a review caught SwfAssetLibrary guessing at both, and being wrong about both. The
adapter looked for a manifest export ending `_manifest_bin` and registered every bitmap under its
full SWF symbol name. Neither matches the real files, and neither would have failed loudly: the
manifest would simply be null and every part lookup would return null, so the avatar renders as
nothing at all with no error to follow.

Three facts this pins, so the adapter stops guessing:

  * the manifest export is `<library>_manifest`;
  * bitmap symbols carry the library name as a prefix, while the manifest -- and the compositor --
    use the short name (`hh_human_50_hair_sh_std_hr_1_0_0` against `sh_std_hr_1_0_0`);
  * every manifest asset carries an `offset` param, which is what lines the parts up.

Usage:
    python evidence/v5_avatar_library_contract.py [--json out.json]
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import re
import struct
from pathlib import Path

HERE = Path(__file__).resolve().parent
GORDON = Path(r"C:\habbo\ngh\gordon\PRODUCTION-201611291003-338511768")
# One 32px library and one 64px, so the naming is checked at both avatar scales.
LIBRARIES = ["hh_human_50_hair", "hh_human_50_body", "hh_human_hair"]

ASSET = re.compile(r"<asset name='([^']+)'")
OFFSET = re.compile(r"key='offset' value='(-?\d+),(-?\d+)'")


def load_scanner():
    spec = importlib.util.spec_from_file_location("g0", HERE / "g0_scan_swf_exports.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def binary_blobs(body: bytes) -> list[bytes]:
    """Every DefineBinaryData payload, in tag order."""
    nbits = body[0] >> 3
    position = (5 + nbits * 4 + 7) // 8 + 4  # rect, then frame rate and count
    blobs = []
    while position < len(body):
        code_length = struct.unpack_from("<H", body, position)[0]
        position += 2
        tag, length = code_length >> 6, code_length & 0x3F
        if length == 0x3F:
            length = struct.unpack_from("<I", body, position)[0]
            position += 4
        data = body[position:position + length]
        position += length
        if tag == 87:  # DefineBinaryData: two-byte id, four reserved, then the blob
            blobs.append(data[6:])
    return blobs


def measure(scanner, library: str) -> dict:
    path = GORDON / (library + ".swf")
    signature, rows, _ = scanner.scan(str(path))
    _, body, _ = scanner.decompress(path.read_bytes())

    exports = {name: kind for _, name, kind, _ in rows}
    manifest_exports = sorted(n for n, kind in exports.items() if kind == "binary")
    bitmaps = [n for n, kind in exports.items() if kind == "bitmap"]
    prefix = library + "_"
    prefixed = sum(1 for n in bitmaps if n.startswith(prefix))

    blobs = binary_blobs(body)
    manifest = max(blobs, key=len).decode("utf-8", "replace") if blobs else ""
    manifest_assets = ASSET.findall(manifest)
    short_names = {n[len(prefix):] for n in bitmaps if n.startswith(prefix)}

    return {
        "library": library,
        "signature": signature,
        "exports": len(rows),
        "binary_exports": manifest_exports,
        "manifest_export_matches_library_manifest":
            manifest_exports == [library + "_manifest"],
        "bitmap_exports": len(bitmaps),
        "bitmap_exports_carrying_library_prefix": prefixed,
        "manifest_assets": len(manifest_assets),
        "manifest_assets_resolved_by_short_name":
            sum(1 for name in manifest_assets if name in short_names),
        "manifest_assets_with_offset": len(OFFSET.findall(manifest)),
        "example_symbol": next((n for n in sorted(bitmaps) if n.startswith(prefix)), None),
        "example_manifest_asset": manifest_assets[0] if manifest_assets else None,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", type=Path, default=HERE / "v5_avatar_library_contract.json")
    args = ap.parse_args()

    scanner = load_scanner()
    measurements = [measure(scanner, library) for library in LIBRARIES]

    ok = all(
        m["manifest_export_matches_library_manifest"]
        and m["bitmap_exports_carrying_library_prefix"] == m["bitmap_exports"]
        and m["manifest_assets_resolved_by_short_name"] == m["manifest_assets"]
        for m in measurements
    )
    result = {
        "gate": "V5-avatar-library-naming-contract",
        "gordon": str(GORDON),
        "libraries": measurements,
        "result": "pass" if ok else "fail",
        "note": "SwfAssetLibrary strips the library prefix from each bitmap symbol and registers "
                "through AssetLibrary.loadFromManifest, so the manifest supplies the names, the "
                "aliases and the offsets.",
    }
    args.json.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")

    for m in measurements:
        print("{:<20} {:>5} exports  manifest={:<28} prefixed {}/{}  named {}/{}  offsets {}".format(
            m["library"], m["exports"], str(m["binary_exports"]),
            m["bitmap_exports_carrying_library_prefix"], m["bitmap_exports"],
            m["manifest_assets_resolved_by_short_name"], m["manifest_assets"],
            m["manifest_assets_with_offset"]))
    print("\n" + result["result"], "->", args.json)
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
