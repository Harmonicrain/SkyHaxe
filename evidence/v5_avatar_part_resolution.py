#!/usr/bin/env python3
"""Classify V5's live scale-32 avatar part warnings against the published assets.

This is a read-only corpus check. It distinguishes an exact small (`sh_`) asset/alias from the
current renderer's broader same-type library loading, so a plausible fallback cannot be mistaken
for the requested clothing set.
"""
from __future__ import annotations

import importlib.util
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path

HERE = Path(__file__).resolve().parent
NGH = Path(r"C:\habbo\ngh")
GAMEDATA = NGH / "gamedata"
GORDON = NGH / "gordon/PRODUCTION-201611291003-338511768"
FIGURES = {
    "Ray": "hr-829-34.lg-281-72.ch-803-62.hd-180-19.sh-295-68",
    "Tongbits": "hr-987462893-42.hd-3091-23.lg-275-1207.he-987462901-62."
                "ch-3208-82-106.wa-3263-1207-1315",
    "John": "sh-730-110.cc-3075-1189.ha-3710-0.he-6377-0.hr-811-40.hd-3091-1."
            "lg-720-1408.ch-230-83.wa-2009-62.mc-5810-3072",
}
ASSET = re.compile(r"<asset name=['\"]([^'\"]+)['\"]")
ALIAS = re.compile(r"<alias name=['\"]([^'\"]+)['\"]")


def load_scanner():
    spec = importlib.util.spec_from_file_location("g0", HERE / "g0_scan_swf_exports.py")
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def binary_blobs(body: bytes) -> list[bytes]:
    import struct
    position = (5 + (body[0] >> 3) * 4 + 7) // 8 + 4
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
        if tag == 87:
            blobs.append(data[6:])
        if tag == 0:
            break
    return blobs


def manifest_names(scanner, library: str) -> set[str]:
    path = GORDON / f"{library}.swf"
    if not path.exists():
        return set()
    _, body, error = scanner.decompress(path.read_bytes())
    if body is None:
        raise ValueError(f"{path}: {error}")
    blobs = binary_blobs(body)
    if not blobs:
        return set()
    manifest = max(blobs, key=len).decode("utf-8", "replace")
    return set(ASSET.findall(manifest)) | set(ALIAS.findall(manifest))


def required_parts(figuredata: ET.Element, figure: str) -> set[str]:
    result = set()
    for segment in figure.split("."):
        pieces = segment.split("-")
        if len(pieces) < 2:
            continue
        set_type, set_id = pieces[:2]
        node = figuredata.find(f"./sets/settype[@type='{set_type}']/set[@id='{set_id}']")
        if node is None:
            continue
        for part in node.findall("part"):
            result.add(f"{part.attrib['type']}:{part.attrib['id']}")
    return result


def main() -> int:
    scanner = load_scanner()
    figuredata = ET.parse(GAMEDATA / "figuredata.xml").getroot()
    figuremap = ET.parse(GAMEDATA / "figuremap.xml").getroot()
    people = {name: sorted(required_parts(figuredata, figure))
              for name, figure in FIGURES.items()}
    all_parts = set().union(*(set(parts) for parts in people.values())) | {"sd:1"}
    types = {part.partition(":")[0] for part in all_parts}

    mapped_libraries = set()
    for library in figuremap.findall("lib"):
        library_id = library.attrib.get("id", "")
        for part in library.findall("part"):
            key = f"{part.attrib.get('type')}:{part.attrib.get('id')}"
            if key in all_parts or (library_id.startswith("hh_human_50_")
                                    and part.attrib.get("type") in types):
                mapped_libraries.add(library_id)
                break

    library_names = {library: manifest_names(scanner, library)
                     for library in sorted(mapped_libraries)}
    resolution = {}
    for key in sorted(all_parts):
        part_type, part_id = key.split(":")
        needle = re.compile(rf"^sh_[^_]+_{re.escape(part_type)}_{re.escape(part_id)}_")
        exact = sorted(library for library, names in library_names.items()
                       if any(needle.match(name) for name in names))
        same_type = sorted(library for library, names in library_names.items()
                           if any(f"_{part_type}_" in name for name in names))
        resolution[key] = {"exact_sh_libraries": exact, "same_type_libraries": same_type}

    unresolved = [key for key, value in resolution.items() if not value["exact_sh_libraries"]]
    report = {
        "gate": "V5-live-avatar-part-resolution",
        "figures": FIGURES,
        "required_parts_by_user": people,
        "mapped_libraries": sorted(mapped_libraries),
        "resolution": resolution,
        "unresolved_exact_sh_parts": unresolved,
        "unresolved_count": len(unresolved),
        "result": "pass" if not unresolved else "partial",
    }
    output = HERE / "v5_avatar_part_resolution.json"
    output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"required={len(all_parts)} libraries={len(mapped_libraries)} unresolved={len(unresolved)}")
    print(" ".join(unresolved))
    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
