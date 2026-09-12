#!/usr/bin/env python3
"""G2 — what is actually inside the SWF "JPEG" tags?

SWF 8 allows PNG and GIF89a payloads inside `DefineBitsJPEG2` and `DefineBitsJPEG3`. PLAN.md and
CHECKLIST.md describe G2's scope as four bitmap tags and "two decoder families (lossless + JPEG)".
The canary set contradicted that immediately: every `DefineBitsJPEG2` character in
`hh_game_bb_room.swf` begins `89 50 4E 47`.

This surveys the whole measured corpus so the reader's decoder scope is derived rather than
assumed. It reads only files the G0/P1c CSVs already say contain a JPEG-family tag, so it opens
hundreds of files instead of 21,000.

Usage:
    python g2_embedded_format_survey.py [--json out.json]

Read-only with respect to `c:/habbo/ngh`.
"""
from __future__ import annotations

import argparse
import collections
import csv
import gzip
import io
import json
import struct
from pathlib import Path

import g0_scan_swf_exports as scanner

EVIDENCE = Path(__file__).resolve().parent
NGH = Path(r"C:\habbo\ngh")
JPEG_TAGS = {21: "DefineBitsJPEG2", 35: "DefineBitsJPEG3"}


def magic(data: bytes) -> str:
    if data[:4] == b"\x89PNG":
        return "png"
    if data[:3] == b"GIF":
        return "gif"
    if data[:4] == b"\xff\xd9\xff\xd8":
        return "jpeg (erroneous EOI/SOI prefix)"
    if data[:2] == b"\xff\xd8":
        return "jpeg"
    return "unknown " + data[:4].hex()


def files_with_jpeg_tags(csv_gz: Path, root: Path, column: str) -> set:
    """Pull the file list from an existing scan rather than re-walking the corpus."""
    wanted = set()
    with io.TextIOWrapper(gzip.open(csv_gz), encoding="utf-8") as handle:
        for row in csv.DictReader(handle):
            if row["tag"] in JPEG_TAGS.values():
                if column == "gordon" and row.get("set") != "production_reachable":
                    continue
                wanted.add((root / row["file"].replace("\\", "/")).resolve())
    return wanted


def survey(paths: set) -> tuple[collections.Counter, collections.Counter, list]:
    per_tag: collections.Counter = collections.Counter()
    per_file_mixed = []
    sizes: collections.Counter = collections.Counter()
    for path in sorted(paths):
        signature, body, error = scanner.decompress(path.read_bytes())
        if body is None:
            continue
        seen = set()
        offset = ((5 + (body[0] >> 3) * 4) + 7) // 8 + 4
        while offset < len(body) - 1:
            record = struct.unpack_from("<H", body, offset)[0]
            offset += 2
            code, length = record >> 6, record & 0x3F
            if length == 0x3F:
                length = struct.unpack_from("<I", body, offset)[0]
                offset += 4
            if code in JPEG_TAGS:
                payload = body[offset:offset + length]
                if code == 35:
                    alpha_offset = struct.unpack_from("<I", payload, 2)[0]
                    data = payload[6:6 + alpha_offset]
                else:
                    data = payload[2:]
                kind = magic(data)
                per_tag[(JPEG_TAGS[code], kind)] += 1
                seen.add(kind.split(" ")[0])
                sizes[kind.split(" ")[0]] += len(data)
            offset += length
            if code == 0:
                break
        if len(seen) > 1:
            per_file_mixed.append({"file": str(path), "encodings": sorted(seen)})
    return per_tag, sizes, per_file_mixed


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", type=Path, default=EVIDENCE / "g2_embedded_format_survey.json")
    args = ap.parse_args()

    corpora = {
        # g0_dcr.csv.gz stores paths relative to the SkyHaxe repo root, not to evidence/.
        "dcr": files_with_jpeg_tags(EVIDENCE / "g0_dcr.csv.gz", EVIDENCE.parent, "dcr"),
        "gordon_reachable": files_with_jpeg_tags(
            EVIDENCE / "g0_gordon_contract.csv.gz", NGH / "gordon", "gordon"),
    }

    result = {
        "gate": "G2-swf-reader",
        "question": "which image codecs do the SWF JPEG-family tags actually carry?",
        "corpora": {},
    }
    for name, paths in corpora.items():
        per_tag, sizes, mixed = survey(paths)
        rows = {"{} -> {}".format(tag, kind): count
                for (tag, kind), count in per_tag.most_common()}
        result["corpora"][name] = {
            "files_examined": len(paths),
            "characters_by_tag_and_encoding": rows,
            "payload_bytes_by_encoding": dict(sizes.most_common()),
            "files_mixing_encodings": mixed,
        }
        print("{}: {} files".format(name, len(paths)))
        for key, count in rows.items():
            print("   {:<52} {:>7}".format(key, count))
        if mixed:
            print("   files mixing encodings: {}".format(len(mixed)))

    decoders = set()
    for corpus in result["corpora"].values():
        for key in corpus["characters_by_tag_and_encoding"]:
            decoders.add(key.split("-> ")[1].split(" ")[0])
    result["decoder_families_required"] = sorted(decoders | {"zlib"})
    result["finding"] = (
        "the JPEG-family tags are containers, not a codec: scope the reader by payload magic "
        "(PNG / GIF / JPEG) rather than by tag id"
    )
    args.json.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print("\ndecoder families required:", ", ".join(result["decoder_families_required"]))
    print("written to", args.json)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
