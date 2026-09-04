#!/usr/bin/env python3
"""Record the bounded real-layout canary and its source/implementation hashes."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET


SKYHAXE = Path(r"C:\habbo\client\SkyHaxe")
FIXTURE = Path(r"C:\habbo\client\habbo-client-clean\src\binaryData\HabboCatalogCom_redeemItemCodeWidget.bin")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    root = ET.fromstring(FIXTURE.read_text(encoding="utf-8-sig"))
    implementation = [
        SKYHAXE / "src/com/sulake/core/window/IWindow.hx",
        SKYHAXE / "src/com/sulake/core/window/WindowController.hx",
        SKYHAXE / "src/com/sulake/core/window/utils/WindowParser.hx",
        SKYHAXE / "test/G1dWindowLayoutTest.hx",
        SKYHAXE / "test/G1dWindowLayoutBrowserMain.hx",
        SKYHAXE / "project.g1d-window-layout.xml",
        SKYHAXE / "scripts/test-g1d-window-layout.ps1",
    ]
    entities = list(root.findall("./window/*")) + list(root.findall("./window/*/children/*"))
    result = {
        "gate": "G1d-real-window-layout-canary",
        "fixture": {
            "path": str(FIXTURE),
            "sha256": sha256(FIXTURE),
            "bytes": FIXTURE.stat().st_size,
            "layout_name": root.attrib["name"],
            "layout_size": [int(root.attrib["width"]), int(root.attrib["height"])],
            "entity_types": [node.tag for node in entities],
            "source_tree_policy": "read-only external asset packaged by the test project",
        },
        "scope": {
            "proved": [
                "layout/window/children hierarchy",
                "name, caption, style, params, id, position, size, visibility, and limit attributes",
                "URL-decoded captions",
                "typed Boolean, String, int, Number, and hex variables",
                "real OpenFL Sprite/TextField construction and non-transparent rendered pixels",
            ],
            "deferred_to_g4b": [
                "production bitmap skins",
                "HTML text and links",
                "input behavior",
                "scrolling item lists",
                "masks, filters, and reference-image parity",
            ],
        },
        "rewrite_rules": [
            "AS3 E4X property access -> explicit XML.child()/attribute()/children() calls",
            "AS3 unescape(caption/name) -> StringTools.urlDecode with malformed-input fallback",
            "AS3 XMLPropertyArrayParser variables -> typed StringMap values",
            "Flash window leaf display objects -> OpenFL Sprite/TextField equivalents",
        ],
        "haxe_sha256": {
            str(path.relative_to(SKYHAXE)).replace("\\", "/"): sha256(path)
            for path in implementation
        },
        "verification": {
            "test_script": "scripts/test-g1d-window-layout.ps1",
            "expected_dom_marker": "data-skyhaxe-g1d-window-layout=pass",
            "fixture_marker": "data-skyhaxe-g1d-window-layout-fixture=redeemItemCodeWidget",
        },
    }
    output = SKYHAXE / "evidence/g1d_window_layout_contract.json"
    output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
