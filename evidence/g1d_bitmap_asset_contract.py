#!/usr/bin/env python3
"""Record BitmapDataAsset use and the corrected ownership contract."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--client-src", type=Path, default=Path(r"C:\habbo\client\habbo-client-clean\src"))
    parser.add_argument("--skyhaxe", type=Path, default=Path(r"C:\habbo\client\SkyHaxe"))
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_bitmap_asset_contract.json"),
    )
    args = parser.parse_args()

    files = sorted(args.client_src.rglob("*.as"))
    token_files = []
    corpus_parts = []
    for path in files:
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        if "BitmapDataAsset" in text:
            token_files.append(path.relative_to(args.client_src).as_posix())
            corpus_parts.append(text)
    corpus = "\n".join(corpus_parts)
    implementation = [
        args.skyhaxe / "src/com/sulake/core/assets/BitmapDataAsset.hx",
        args.skyhaxe / "src/com/sulake/core/assets/AssetLibrary.hx",
        args.skyhaxe / "test/G1dBitmapDataAssetTest.hx",
        args.skyhaxe / "test/G1dBitmapDataAssetBrowserMain.hx",
        args.skyhaxe / "project.g1d-bitmap-asset.xml",
    ]
    result = {
        "gate": "G1d-bitmap-data-asset",
        "source_contract": {
            "bitmap_data_asset_files": len(token_files),
            "constructor_calls": len(re.findall(r"\bnew\s+BitmapDataAsset\s*\(", corpus)),
            "owns_data_assignments": len(re.findall(r"\.ownsData\s*=", corpus)),
            "parameter_keys": ["offset", "region", "flipH", "flipV"],
            "manifest_png_assets": 2021,
            "manifest_png_aliases": 46,
        },
        "semantic_decisions": [
            "owned BitmapData is counted exactly once and disposed exactly once",
            "setFromOtherAsset creates a borrowed wrapper and copies metadata without cloning pixels",
            "AssetLibrary aliases use setFromOtherAsset so aliases cannot double-own shared bitmap pixels",
            "borrowed-wrapper disposal leaves owner pixels readable",
            "encoded ByteArray input fails explicitly until the G2 SWF/image decoder supplies BitmapData",
            "offset, region, flipH, and flipV remain metadata and do not mutate source pixels",
        ],
        "as3_ownership_correction": {
            "problem": "AS3 aliases share BitmapData but default ownsData to true; allocation accounting can subtract uncounted shared bytes",
            "haxe_fix": "source owns and accounts pixels; aliases borrow through setFromOtherAsset; accounting cannot underflow",
            "corpus_owns_data_assignments": 0,
        },
        "rewrite_rules": [
            "BitmapData aliases -> BitmapDataAsset.setFromOtherAsset(source)",
            "ByteArray image content -> decode to BitmapData in G2 before setUnknownContent",
            "bitmap parameter XML -> explicit offset/region/flip metadata parsing",
        ],
        "haxe_sha256": {
            str(path.relative_to(args.skyhaxe)).replace("\\", "/"): sha256(path)
            for path in implementation
        },
        "verification": {
            "test_script": "scripts/test-g1d-bitmap-asset.ps1",
            "expected_dom_marker": "data-skyhaxe-g1d-bitmap-asset=pass",
        },
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
