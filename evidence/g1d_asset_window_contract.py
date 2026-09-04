#!/usr/bin/env python3
"""Measure the core asset/window boundary before its OpenFL hand-port."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


FLASH_FAMILIES = {
    "display": re.compile(r"\bflash\.display\."),
    "text": re.compile(r"\bflash\.text\."),
    "filters": re.compile(r"\bflash\.filters\."),
    "geometry": re.compile(r"\bflash\.geom\."),
    "events": re.compile(r"\bflash\.events\."),
    "network": re.compile(r"\bflash\.(?:net|system)\."),
    "sound": re.compile(r"\bflash\.media\."),
}

BEHAVIOURS = {
    "bitmap_data": re.compile(r"\bBitmapData\b"),
    "html_text": re.compile(r"\bhtmlText\b"),
    "text_field": re.compile(r"\bTextField\b"),
    "mask": re.compile(r"\.mask\b|\bmask\s*="),
    "filters": re.compile(r"\.filters\b"),
    "blend_mode": re.compile(r"\.blendMode\b"),
    "hit_test_point": re.compile(r"\bhitTestPoint\s*\("),
    "scroll": re.compile(r"\bscroll(?:V|H|Rect)?\b", re.IGNORECASE),
}


def scan(paths: list[Path]) -> tuple[dict[str, int], dict[str, int]]:
    flash = {name: 0 for name in FLASH_FAMILIES}
    behaviours = {name: 0 for name in BEHAVIOURS}
    for path in paths:
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        for name, pattern in FLASH_FAMILIES.items():
            flash[name] += len(pattern.findall(text))
        for name, pattern in BEHAVIOURS.items():
            behaviours[name] += len(pattern.findall(text))
    return flash, behaviours


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--client-src",
        type=Path,
        default=Path(r"C:\habbo\client\habbo-client-clean\src"),
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_asset_window_contract.json"),
    )
    args = parser.parse_args()

    asset_root = args.client_src / "com/sulake/core/assets"
    window_root = args.client_src / "com/sulake/core/window"
    asset_files = sorted(asset_root.rglob("*.as"))
    window_files = sorted(window_root.rglob("*.as"))
    asset_flash, asset_behaviours = scan(asset_files)
    window_flash, window_behaviours = scan(window_files)

    asset_implementations: list[str] = []
    lazy_asset_implementations: list[str] = []
    for path in asset_files:
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        relative = path.relative_to(args.client_src).as_posix()
        if re.search(r"\bimplements\s+IAsset\b", text):
            asset_implementations.append(relative)
        if re.search(r"\bimplements\s+ILazyAsset\b", text):
            lazy_asset_implementations.append(relative)

    result = {
        "gate": "G1d-asset-window-boundary",
        "status": "measured_not_implemented",
        "scope": {
            "asset_files": len(asset_files),
            "window_files": len(window_files),
            "asset_implementations": asset_implementations,
            "lazy_asset_implementations": lazy_asset_implementations,
        },
        "flash_family_occurrences": {
            "assets": asset_flash,
            "window": window_flash,
        },
        "behaviour_occurrences": {
            "assets": asset_behaviours,
            "window": window_behaviours,
        },
        "ordered_subgates": [
            "non-visual AssetTypeDeclaration/IAsset/TextAsset/XmlAsset/UnknownAsset contracts",
            "AssetLibrary name/type/alias ownership needed to consume G2 and G3 output",
            "BitmapDataAsset ownership and pixel-copy behaviour in a real OpenFL HTML5 browser",
            "minimal final Component shell over verified runtime and asset/event boundaries",
            "window interfaces and one real XML layout browser canary; full UI parity remains G4b",
        ],
        "semantic_decisions": [
            "Haxe interpreter results are not evidence for OpenFL BitmapData, display-list, text, mask, filter, or hit-testing behaviour",
            "do not bulk-port 245 window files into G1d; establish interfaces and a real layout canary, then enforce full parity at G4b",
            "asset ownership must distinguish borrowed versus owned BitmapData to prevent double disposal",
            "TextAsset and XmlAsset ByteArray reads inherit the verified Flash big-endian/position-compatible adapter",
            "no placeholder asset or event stubs may be introduced merely to make Component compile",
        ],
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
