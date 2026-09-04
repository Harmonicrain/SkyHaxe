#!/usr/bin/env python3
"""Build a representative real DefineBinaryData XML contract for G3."""

from __future__ import annotations

import collections
import hashlib
import json
from pathlib import Path
import sys
import xml.etree.ElementTree as ET

sys.path.insert(0, str(Path(__file__).resolve().parent))
import g2_reader_contract as swf  # independent Python container/tag implementation

NGH = Path(r"C:\habbo\ngh")
FILES = [
    "dcr/hof_furni/15pillow.swf",
    "dcr/hof_furni/01_dragonlamp_skream.swf",
    "dcr/hof_furni/BW_HeadmasterChair.swf",
    "dcr/hof_furni/godin.swf",
    "gordon/PRODUCTION-201611291003-338511768/elephants.swf",
]


def category(name: str) -> str | None:
    lowered = name.lower()
    for value in ("assets", "visualization", "logic", "index", "manifest"):
        if lowered.endswith("_" + value) or (value == "index" and "_index" in lowered):
            return value
    return None


def extract(path: Path) -> dict[str, bytes]:
    _, body = swf.decompress(path.read_bytes())
    blobs: dict[int, bytes] = {}
    names: list[tuple[int, str]] = []
    for code, payload in swf.tags(body):
        if code == swf.BINARY_TAG:
            blobs[int.from_bytes(payload[:2], "little")] = payload[6:]
        elif code == swf.SYMBOL_CLASS:
            count = int.from_bytes(payload[:2], "little")
            cursor = 2
            for _ in range(count):
                character_id = int.from_bytes(payload[cursor:cursor + 2], "little")
                cursor += 2
                end = payload.index(b"\0", cursor)
                names.append((character_id, payload[cursor:end].decode("utf-8", "replace")))
                cursor = end + 1
    return {name: blobs[character_id] for character_id, name in names if character_id in blobs}


def canonical(element: ET.Element) -> tuple[str, dict]:
    tokens: list[str] = []
    counts: collections.Counter[str] = collections.Counter()
    attributes = 0
    text_nodes = 0
    max_depth = 0

    def visit(node: ET.Element, depth: int) -> None:
        nonlocal attributes, text_nodes, max_depth
        max_depth = max(max_depth, depth)
        counts[node.tag] += 1
        tokens.append("E:" + node.tag)
        for name, value in sorted(node.attrib.items()):
            attributes += 1
            tokens.append("A:" + name + "=" + value)
        text = (node.text or "").strip()
        if text:
            text_nodes += 1
            tokens.append("T:" + text)
        for child in node:
            visit(child, depth + 1)
            tail = (child.tail or "").strip()
            if tail:
                text_nodes += 1
                tokens.append("T:" + tail)
        tokens.append("X:" + node.tag)

    visit(element, 0)
    stream = "\n".join(tokens)
    return stream, {
        "root": element.tag,
        "elements": sum(counts.values()),
        "attributes": attributes,
        "text_nodes": text_nodes,
        "max_depth": max_depth,
        "tag_counts": dict(sorted(counts.items())),
        "canonical_md5": hashlib.md5(stream.encode("utf-8")).hexdigest(),
    }


def main() -> int:
    records = []
    categories: collections.Counter[str] = collections.Counter()
    for relative in FILES:
        for name, blob in sorted(extract(NGH / relative).items()):
            kind = category(name)
            if kind is None:
                continue
            text = blob.decode("utf-8-sig").rstrip("\0")
            root = ET.fromstring(text)
            _, metrics = canonical(root)
            categories[kind] += 1
            records.append({
                "file": relative,
                "symbol": name,
                "category": kind,
                "bytes": len(blob),
                "raw_sha256": hashlib.sha256(blob).hexdigest(),
                **metrics,
            })
    required = {"assets", "visualization", "logic", "index", "manifest"}
    if len(records) < 20 or not required.issubset(categories):
        raise SystemExit(f"unrepresentative G3 selection: {len(records)} records, {dict(categories)}")
    result = {
        "gate": "G3-real-xml-blobs",
        "reference": "independent Python SWF parser + xml.etree.ElementTree",
        "canonicalization": "ordered E/A/T/X tokens; attributes sorted; whitespace-only text ignored",
        "files": FILES,
        "records": records,
        "record_count": len(records),
        "categories": dict(sorted(categories.items())),
    }
    output = Path(__file__).with_name("g3_xml_blob_contract.json")
    output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"records": len(records), "categories": dict(categories)}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
