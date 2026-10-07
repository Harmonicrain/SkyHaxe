#!/usr/bin/env python3
"""Pin clean-client UI inputs and the current HTML5 text payload.

Code generation alone cannot make the clean client authoritative: window layouts, skins, element
descriptions, and text styles are executable client data. This manifest makes changes to those
inputs fail the M2 sync until they are reviewed and regenerated.
"""
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import xml.etree.ElementTree as ET

REPO = Path(__file__).resolve().parents[2]
CLIENT = Path(os.environ["SKYHAXE_SOURCE_ROOT"])
PROJECT = REPO / "project.xml"
OUT = Path(__file__).resolve().with_name("asset-inputs.json")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tree_hash(root: Path) -> tuple[str, int, int]:
    digest = hashlib.sha256()
    files = 0
    size = 0
    for path in sorted(item for item in root.rglob("*") if item.is_file()):
        digest.update(path.relative_to(root).as_posix().encode())
        digest.update(sha256(path).encode())
        files += 1
        size += path.stat().st_size
    return digest.hexdigest(), files, size


def main() -> None:
    project = ET.parse(PROJECT).getroot()
    clean_inputs = {
        Path(node.attrib["path"])
        for node in project.findall("assets")
        if Path(node.attrib["path"]).is_absolute()
        and str(Path(node.attrib["path"])).lower().startswith(str(CLIENT).lower())
    }
    binary = CLIENT / "src/binaryData"
    clean_inputs.add(binary / "HabboWindowManagerCom_text_styles_css.bin")
    # Track the complete theme catalogue, not merely the eight layouts the G4b canary packages.
    clean_inputs.update(binary.glob("HabboWindowManagerCom_habbo_window_layout_*_xml.bin"))
    missing = [str(path) for path in sorted(clean_inputs) if not path.is_file()]
    if missing:
        raise SystemExit("missing clean-client asset inputs: " + repr(missing))

    text_root = REPO / "public/assets/habbo-text"
    text_hash, text_files, text_bytes = tree_hash(text_root)
    result = {
        "gate": "M2-asset-input-contract",
        "clean_client_inputs": [
            {"path": str(path), "sha256": sha256(path)} for path in sorted(clean_inputs)
        ],
        "counts": {
            "clean_client_inputs": len(clean_inputs),
            "internal_layouts": sum(
                1 for path in clean_inputs if "habbo_window_layout_" in path.name
            ),
        },
        "tool_inputs": [
            {"path": path.relative_to(REPO).as_posix(), "sha256": sha256(path)}
            for path in (REPO / "package.json", REPO / "package-lock.json",
                         REPO / "scripts/build-habbo-text.mjs", REPO / "scripts/extract-habbo-fonts.mjs",
                         REPO / "src/skyhaxe/text/habbo-text.mjs")
        ],
        "current_text_payload": {
            "path": "public/assets/habbo-text",
            "tree_sha256": text_hash,
            "files": text_files,
            "bytes": text_bytes,
        },
        "reference": "Pinned Habbo HTML5 AIR51 assets; regenerate with scripts/extract-habbo-fonts.mjs and the hash-checked reference ASAR.",
    }
    OUT.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print("M2_ASSET_INPUTS_PASS clean={} layouts={} text_files={}".format(
        result["counts"]["clean_client_inputs"], result["counts"]["internal_layouts"],
        text_files))


if __name__ == "__main__":
    main()
