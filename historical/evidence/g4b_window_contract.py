#!/usr/bin/env python3
"""Derive the G4b login/UI contract from the read-only clean client and NGH texts."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from pathlib import Path
import xml.etree.ElementTree as ET


CLIENT = Path(r"C:\habbo\client\habbo-client-clean")
TEXTS = Path(r"C:\habbo\ngh\gamedata\external_dev_texts.txt")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def element_counts(root: ET.Element) -> dict[str, int]:
    return dict(sorted(Counter(node.tag for node in root.iter()).items()))


def localization(path: Path, key: str) -> str:
    prefix = key + "="
    for line in path.read_text(encoding="utf-8-sig").splitlines():
        if line.startswith(prefix):
            return line[len(prefix) :]
    raise RuntimeError(f"missing localization {key} in {path}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--client", type=Path, default=CLIENT)
    parser.add_argument("--texts", type=Path, default=TEXTS)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).with_name("g4b_window_contract.json"),
    )
    args = parser.parse_args()

    binary = args.client / "src" / "binaryData"
    images = args.client / "src" / "images"
    login_path = binary / "HabboCommunicationDemoCom_login_window.bin"
    feature_path = binary / "HabboCatalogCom_layout_frontpage_featured.bin"
    frame_layout_path = binary / "HabboWindowManagerCom_habbo_window_layout_frame_3_xml.bin"
    login = ET.fromstring(login_path.read_text(encoding="utf-8-sig"))
    feature = ET.fromstring(feature_path.read_text(encoding="utf-8-sig"))
    frame_layout = ET.fromstring(frame_layout_path.read_text(encoding="utf-8-sig"))

    assert login.attrib["name"] == "habbo_login_dialog"
    assert (login.attrib["width"], login.attrib["height"]) == ("360", "242")
    assert login.find("./window/frame[@style='3']") is not None
    assert login.find(".//border[@name='name_border'][@style='4']") is not None
    assert login.find(".//input[@name='name_field']") is not None
    assert login.find(".//button_thick[@name='login_btn'][@style='3']") is not None
    assert login.find(".//DropShadowFilter") is not None
    login_frame = login.find("./window/frame")
    assert login_frame is not None
    frame_variables = {
        item.attrib["key"]: int(item.attrib["value"])
        for item in login_frame.findall("./variables/var")
        if item.attrib["key"].startswith("margin_")
    }
    assert frame_variables == {
        "margin_left": 6,
        "margin_top": 25,
        "margin_right": 6,
        "margin_bottom": 7,
    }
    content_placeholder = frame_layout.find(".//*[@name='content_area']")
    assert content_placeholder is not None
    assert "_CONTENT" in content_placeholder.attrib["tags"]
    placeholder_offset = [
        int(content_placeholder.attrib["x"]),
        int(content_placeholder.attrib["y"]),
    ]
    runtime_offset = [frame_variables["margin_left"], frame_variables["margin_top"]]
    runtime_size = [
        int(login.attrib["width"]) - frame_variables["margin_left"] - frame_variables["margin_right"],
        int(login.attrib["height"]) - frame_variables["margin_top"] - frame_variables["margin_bottom"],
    ]

    assert feature.find(".//html") is not None
    assert feature.find(".//scrollable_itemlist_vertical[@name='itemlist_featured']") is not None
    assert feature.find(".//input[@name='voucher_code']") is not None
    link_text = localization(args.texts, "camera.competition.info")
    assert '<a href="http://www.habbo.com/habbo15">' in link_text

    sources = [
        login_path,
        feature_path,
        frame_layout_path,
        binary / "HabboWindowManagerCom_habbo_skin_frame_3_xml.bin",
        binary / "HabboWindowManagerCom_habbo_skin_border_4_xml.bin",
        binary / "HabboWindowManagerCom_habbo_skin_button_shiny_thick_xml.bin",
        binary / "HabboWindowManagerCom_habbo_skin_border_colorless_xml.bin",
        binary / "HabboWindowManagerCom_habbo_skin_button_shiny_default_xml.bin",
        images / "HabboWindowManagerCom_habbo_blue_skin_png.png",
        images / "HabboWindowManagerCom_habbo_skin_ubuntu_png.png",
        args.texts,
    ]
    result = {
        "gate": "G4b-source-contract",
        "client_root": str(args.client),
        "primary": {
            "file": str(login_path),
            "layout": "habbo_login_dialog",
            "size": [360, 242],
            "role": "complete first-visible AIR client window",
            "elements": element_counts(login),
            "skins": {
                "frame:3": "frame_3",
                "border:4": "border_4",
                "button_thick:3": "button_shiny_thick",
            },
            "theme_content_placeholder_offset": placeholder_offset,
            "runtime_content_offset": runtime_offset,
            "runtime_content_size": runtime_size,
            "runtime_rule": "the app layout's margin_* variables override the theme placeholder",
        },
        "secondary": {
            "file": str(feature_path),
            "layout": "layout_frontpage_featured",
            "role": "real HTML/input/scroll-list/mask coverage absent from login XML",
            "elements": element_counts(feature),
            "link_localization": "camera.competition.info",
            "link_text_sha256": hashlib.sha256(link_text.encode()).hexdigest(),
        },
        "sources": {str(path): sha256(path) for path in sources},
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print("G4B_WINDOW_CONTRACT_PASS sources=11 primary=login secondary=frontpage")


if __name__ == "__main__":
    main()
