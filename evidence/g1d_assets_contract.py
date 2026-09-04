#!/usr/bin/env python3
"""Record the source-derived contract for the non-visual asset foundation."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


ASSET_CLASSES = (
    "AssetTypeDeclaration",
    "IAsset",
    "ILazyAsset",
    "UnknownAsset",
    "TextAsset",
    "XmlAsset",
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--client-src",
        type=Path,
        default=Path(r"C:\habbo\client\habbo-client-clean\src"),
    )
    parser.add_argument(
        "--skyhaxe",
        type=Path,
        default=Path(r"C:\habbo\client\SkyHaxe"),
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_assets_contract.json"),
    )
    args = parser.parse_args()

    source_root = args.client_src / "com/sulake/core/assets"
    source_text = {
        name: (source_root / f"{name}.as").read_text(encoding="utf-8-sig", errors="replace")
        for name in ASSET_CLASSES
    }
    all_client_files = sorted(args.client_src.rglob("*.as"))
    all_client_text = "\n".join(
        path.read_text(encoding="utf-8-sig", errors="replace") for path in all_client_files
    )
    implementation = [
        args.skyhaxe / f"src/com/sulake/core/assets/{name}.hx" for name in ASSET_CLASSES
    ] + [
        args.skyhaxe / "test/G1dAssetsTest.hx",
        args.skyhaxe / "test/G1dAssetsBrowserMain.hx",
        args.skyhaxe / "project.g1d-assets.xml",
    ]

    result = {
        "gate": "G1d-non-visual-assets",
        "source_contract": {
            "ported_classes": list(ASSET_CLASSES),
            "asset_type_declaration_constructions": len(
                re.findall(r"\bnew\s+AssetTypeDeclaration\s*\(", all_client_text)
            ),
            "text_asset_input_branches": ["String", "embedded Class", "ByteArray", "TextAsset", "toString fallback"],
            "xml_asset_input_branches": ["embedded Class", "ByteArray", "String", "XML", "XmlAsset"],
            "xml_asset_is_lazy": "implements ILazyAsset" in source_text["XmlAsset"],
            "copy_type_checks": {
                name: bool(re.search(r"setFromOtherAsset[\s\S]+?asset\s+is\s+" + name, source_text[name]))
                for name in ("TextAsset", "XmlAsset")
            },
        },
        "semantic_decisions": [
            "OpenFL ByteArray is an abstract; runtime input checks use its documented ByteArrayData representation",
            "TextAsset and XmlAsset consume bytes from the current position and advance it, matching readUTFBytes",
            "XmlAsset retains lazy parsing and direct XML identity",
            "UnknownAsset and cross-asset copies preserve content identity rather than cloning",
            "disposal is idempotent and clears content, declaration, and URL references",
        ],
        "rewrite_rules": [
            "flash XML/XMLList -> com.sulake.core.utils.xml.XML/XMLList",
            "flash.utils.ByteArray runtime type checks -> openfl.utils.ByteArray.ByteArrayData",
            "AS3 rest file types -> Haxe rest arguments with preserved order",
            "AS3 `is` asset checks -> Std.isOfType with explicit failure on wrong copy type",
            "embedded asset Class construction -> Type.createInstance followed by ByteArrayData validation",
        ],
        "haxe_sha256": {
            str(path.relative_to(args.skyhaxe)).replace("\\", "/"): sha256(path)
            for path in implementation
        },
        "verification": {
            "test_script": "scripts/test-g1d-assets.ps1",
            "browser_project": "project.g1d-assets.xml",
            "expected_dom_marker": "data-skyhaxe-g1d-assets=pass",
        },
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
