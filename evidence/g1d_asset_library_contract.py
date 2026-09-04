#!/usr/bin/env python3
"""Measure manifests and record the synchronous AssetLibrary ownership contract."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from collections import Counter
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
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_asset_library_contract.json"),
    )
    args = parser.parse_args()

    manifests = sorted((args.client_src / "binaryData").glob("*_manifest.bin"))
    asset_mimes: Counter[str] = Counter()
    alias_mimes: Counter[str] = Counter()
    asset_count = 0
    alias_count = 0
    for path in manifests:
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        assets_blocks = re.findall(r"<assets\b[^>]*>(.*?)</assets\s*>", text, re.DOTALL | re.IGNORECASE)
        aliases_blocks = re.findall(r"<aliases\b[^>]*>(.*?)</aliases\s*>", text, re.DOTALL | re.IGNORECASE)
        for block in assets_blocks:
            mimes = re.findall(r"<asset\b[^>]*\bmimeType=[\"']([^\"']+)", block, re.IGNORECASE)
            asset_count += len(mimes)
            asset_mimes.update(mimes)
        for block in aliases_blocks:
            mimes = re.findall(r"<asset\b[^>]*\bmimeType=[\"']([^\"']+)", block, re.IGNORECASE)
            alias_count += len(mimes)
            alias_mimes.update(mimes)

    implementation = [
        args.skyhaxe / "src/com/sulake/core/assets/AssetLibrary.hx",
        args.skyhaxe / "test/G1dAssetLibraryTest.hx",
        args.skyhaxe / "test/G1dAssetLibraryBrowserMain.hx",
        args.skyhaxe / "project.g1d-asset-library.xml",
    ]
    result = {
        "gate": "G1d-asset-library",
        "manifest_contract": {
            "files": len(manifests),
            "asset_declarations": asset_count,
            "alias_declarations": alias_count,
            "asset_mime_counts": dict(sorted(asset_mimes.items())),
            "alias_mime_counts": dict(sorted(alias_mimes.items())),
            "real_browser_fixture": "binaryData/HabboCatalogCom_manifest.bin",
            "real_fixture_supported_assets_and_aliases": 153,
        },
        "semantic_decisions": [
            "setAsset overwrite does not dispose the replaced asset; ownership transfers to the caller",
            "removeAsset transfers an asset without disposal; unload disposes every asset still owned",
            "asset and alias order follows manifest insertion order",
            "aliases use new asset wrappers but preserve referenced content identity",
            "unknown MIME types are skipped during eager manifest loading, matching the AS3 path",
            "unload clears the name array to preserve the numAssets/nameArray invariant",
            "network loading and runtime SWF symbol resolution remain G2 responsibilities",
        ],
        "intentional_correction": {
            "as3_site": "AssetLibrary.getAssetTypeDeclarationByFileName",
            "problem": "decompiled helper coerces indexOf results to Boolean, rejecting index 0 and accepting -1",
            "evidence": "the active solveAssetTypeDeclarationFromUrl path already uses indexOf(extension) > -1",
            "haxe_rule": "strip the query string and require fileTypes.indexOf(extension) > -1",
        },
        "rewrite_rules": [
            "Dictionary<String,IAsset> -> haxe.ds.StringMap<IAsset> plus an ordered name array",
            "resource[name] -> explicit AssetContentResolver(name)",
            "manifest assets load before aliases",
            "unsupported asset types return to the relevant later boundary rather than receiving placeholders",
        ],
        "haxe_sha256": {
            str(path.relative_to(args.skyhaxe)).replace("\\", "/"): sha256(path)
            for path in implementation
        },
        "verification": {
            "test_script": "scripts/test-g1d-asset-library.ps1",
            "expected_dom_marker": "data-skyhaxe-g1d-asset-library=pass",
        },
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
