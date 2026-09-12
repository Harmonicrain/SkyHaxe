#!/usr/bin/env python3
"""Derive the V4 public-room bitmap contract from the selected NGH config and SWF."""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from urllib.parse import urlparse

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import g0_scan_swf_exports as scanner  # noqa: E402

NGH = Path(r"C:\habbo\ngh")
VARIABLES = NGH / "gamedata/external_dev_vars.txt"
ROOM_TYPE = "netcafe"
BITMAP_TAGS = {20, 36, 21, 35}
BINARY_TAG = 87
SYMBOL_CLASS = 76


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def variable(path: Path, key: str) -> str:
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        name, separator, value = line.partition("=")
        if separator and name.strip() == key:
            return value.strip()
    raise ValueError(f"{key} is absent from {path}")


def characters(path: Path) -> tuple[str, dict[str, tuple[int, bytes]]]:
    raw = path.read_bytes()
    signature, body, error = scanner.decompress(raw)
    if body is None:
        raise ValueError(error)
    nbits = body[0] >> 3
    offset = ((5 + nbits * 4) + 7) // 8 + 4
    payloads: dict[int, tuple[int, bytes]] = {}
    symbols: list[tuple[int, str]] = []
    while offset < len(body) - 1:
        record = struct.unpack_from("<H", body, offset)[0]
        offset += 2
        code, length = record >> 6, record & 0x3F
        if length == 0x3F:
            length = struct.unpack_from("<I", body, offset)[0]
            offset += 4
        payload = body[offset:offset + length]
        if code in BITMAP_TAGS or code == BINARY_TAG:
            character_id = struct.unpack_from("<H", payload, 0)[0]
            content = payload[6:] if code == BINARY_TAG else payload
            payloads[character_id] = (code, content)
        elif code == SYMBOL_CLASS:
            count = struct.unpack_from("<H", payload, 0)[0]
            cursor = 2
            for _ in range(count):
                character_id = struct.unpack_from("<H", payload, cursor)[0]
                cursor += 2
                end = payload.index(b"\0", cursor)
                symbols.append((character_id, payload[cursor:end].decode("utf-8", "replace")))
                cursor = end + 1
        offset += length
        if code == 0:
            break
    return signature, {
        name: payloads[character_id]
        for character_id, name in symbols
        if character_id in payloads
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--room-type", default=ROOM_TYPE)
    parser.add_argument("--variables", type=Path, default=VARIABLES)
    parser.add_argument("--ngh", type=Path, default=NGH)
    parser.add_argument("--json", type=Path, default=HERE / "v4_public_room_contract.json")
    args = parser.parse_args()

    content_url = variable(args.variables, "flash.client.url")
    relative = urlparse(content_url).path.removeprefix("/ngh/")
    root_name = f"hh_room_{args.room_type}"
    swf = (args.ngh / relative / f"{root_name}.swf").resolve()
    if args.ngh.resolve() not in swf.parents:
        raise SystemExit("flash.client.url escapes the NGH root")
    signature, exported = characters(swf)

    assets_symbol = f"{root_name}_{root_name}_assets"
    visualization_symbol = f"{root_name}_{root_name}_visualization"
    assets_code, assets_bytes = exported[assets_symbol]
    visualization_code, visualization_bytes = exported[visualization_symbol]
    if assets_code != BINARY_TAG or visualization_code != BINARY_TAG:
        raise SystemExit("public-room XML symbols are not DefineBinaryData")
    assets_xml = ET.fromstring(assets_bytes)
    visualization_xml = ET.fromstring(visualization_bytes)
    assets = {
        node.attrib["name"]: node.attrib.get("source", node.attrib["name"])
        for node in assets_xml.findall("asset")
    }
    layouts = [node for node in visualization_xml.findall("layoutData")
               if node.attrib.get("name") == args.room_type]
    if len(layouts) != 1:
        raise SystemExit(f"expected one {args.room_type} layoutData, got {len(layouts)}")

    layers = layouts[0].findall("./elements/element/visualization/visualizationLayer")
    selected_assets: list[str] = []
    missing_asset_rows: list[str] = []
    missing_exports: list[str] = []
    for layer in layers:
        name = layer.attrib.get("asset", "")
        frames = [item.strip() for item in layer.attrib.get("frames", "").split(",") if item.strip()]
        if frames:
            name = frames[0]
        if name not in assets:
            missing_asset_rows.append(name)
            continue
        selected_assets.append(name)
        source = assets[name]
        candidates = (f"{root_name}_{source}", source)
        if not any(candidate in exported and exported[candidate][0] in BITMAP_TAGS
                   for candidate in candidates):
            missing_exports.append(source)

    report = {
        "gate": "V4-public-room-contract",
        "room_type": args.room_type,
        "variables": str(args.variables),
        "variables_sha256": sha256(args.variables),
        "flash_client_url": content_url,
        "swf": str(swf),
        "swf_sha256": sha256(swf),
        "swf_signature": signature,
        "layout_count": len(layouts),
        "layers": len(layers),
        "unique_selected_assets": len(set(selected_assets)),
        "additive_layers": sum(layer.attrib.get("ink") == "ADD" for layer in layers),
        "flipped_layers": sum(layer.attrib.get("flipH") in ("1", "true")
                              or layer.attrib.get("flipV") in ("1", "true") for layer in layers),
        "alpha_overridden_layers": sum("blend" in layer.attrib for layer in layers),
        "missing_asset_rows": sorted(set(missing_asset_rows)),
        "missing_bitmap_exports": sorted(set(missing_exports)),
        "result": "pass" if not missing_asset_rows and not missing_exports else "fail",
    }
    args.json.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))
    return 0 if report["result"] == "pass" else 1


if __name__ == "__main__":
    raise SystemExit(main())
