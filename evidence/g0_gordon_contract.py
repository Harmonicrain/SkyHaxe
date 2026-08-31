#!/usr/bin/env python3
"""P1c — derive and test the Gordon runtime contract from maps, config and client code.

The Gordon directory is mixed: runtime content, an owner-excluded newer content tree, and several
complete client/test SWFs. A path-wide tag histogram cannot distinguish those. This
script therefore derives the reachable production set from the current gamedata maps, runtime
variables, AS3 URL literals, a conservative public-room naming fallback, and NGHWin's six
local_include files. It scans every Gordon SWF, but only the derived runtime/content sets decide
the reader-contract result.

The asset corpus is read-only. Outputs are a gzipped per-symbol CSV and a JSON summary.
"""
from __future__ import annotations

import argparse
import collections
import csv
import gzip
import io
import json
import re
import struct
import xml.etree.ElementTree as ET
import zlib
from pathlib import Path

import g0_scan_swf_exports as scanner

LOCAL_INCLUDE = (
    "HabboRoomContent.swf",
    "PlaceHolderFurniture.swf",
    "PlaceHolderWallItem.swf",
    "PlaceHolderPet.swf",
    "TileCursor.swf",
    "SelectionArrow.swf",
)


def is_checksumless_complete_cws(path: Path) -> bool:
    raw = path.read_bytes()
    if raw[:3] != b"CWS":
        return False
    try:
        zlib.decompress(raw[8:])
        return False
    except zlib.error:
        stream = zlib.decompressobj()
        body = stream.decompress(raw[8:])
        expected = struct.unpack_from("<I", raw, 4)[0] - 8
        return not stream.eof and len(body) == expected


def add_reason(reasons: dict[str, set[str]], name: str, reason: str) -> None:
    key = name.lower()
    if not key.endswith(".swf"):
        key += ".swf"
    reasons[key].add(reason)


def derive_reasons(
    gamedata: Path, client: Path, variables: Path
) -> tuple[dict[str, set[str]], list[str]]:
    reasons: dict[str, set[str]] = collections.defaultdict(set)
    public_room_types: list[str] = []
    for lib in ET.parse(gamedata / "figuremap.xml").getroot().findall("lib"):
        add_reason(reasons, lib.attrib["id"], "gamedata/figuremap.xml")
    for effect in ET.parse(gamedata / "effectmap.xml").getroot().findall("effect"):
        add_reason(reasons, effect.attrib["lib"], "gamedata/effectmap.xml")

    for line in variables.read_text(encoding="utf-8", errors="replace").splitlines():
        line = line.strip()
        key, separator, value = line.partition("=")
        if not separator:
            continue
        key = key.strip()
        if key == "pet.configuration":
            for pet in (item.strip() for item in value.split(",")):
                if pet:
                    add_reason(reasons, pet, "pet.configuration")
        elif key == "public.room.preload.types":
            public_room_types = [
                room_type for room_type in (item.strip() for item in value.split(","))
                if room_type
            ]
            for room_type in public_room_types:
                add_reason(
                    reasons,
                    f"hh_room_{room_type}",
                    "public.room.preload.types",
                )

    for name in LOCAL_INCLUDE:
        add_reason(reasons, name, "NGHWin local_include")

    literal = re.compile(r"[A-Za-z0-9_.-]+\.swf", re.I)
    for source in (client / "src").rglob("*.as"):
        text = source.read_text(encoding="utf-8", errors="replace")
        for name in literal.findall(text):
            add_reason(reasons, name, "AS3 SWF literal")
    return reasons, public_room_types


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gordon", type=Path, default=Path(r"C:\habbo\ngh\gordon"))
    ap.add_argument("--gamedata", type=Path, default=Path(r"C:\habbo\ngh\gamedata"))
    ap.add_argument("--client", type=Path, default=Path(r"C:\habbo\client\habbo-client-clean"))
    ap.add_argument(
        "--variables",
        type=Path,
        default=Path(r"C:\habbo\ngh\gamedata\external_dev_vars.txt"),
    )
    ap.add_argument("--csv", type=Path, default=Path("g0_gordon_contract.csv.gz"))
    ap.add_argument("--json", type=Path, default=Path("g0_gordon_contract.json"))
    args = ap.parse_args()

    production_dirs = sorted(path for path in args.gordon.glob("PRODUCTION-*") if path.is_dir())
    ignored_dirs = sorted(
        path for path in args.gordon.glob("flash-assets-PRODUCTION-*") if path.is_dir()
    )
    if len(production_dirs) != 1:
        raise SystemExit("expected exactly one configured production directory")
    production = production_dirs[0]
    reasons, public_room_types = derive_reasons(args.gamedata, args.client, args.variables)
    # The broad literal matcher also sees variables such as `k + ".swf"`, event names, and an
    # external Vimeo player. Only hh_* literals are Gordon URL contracts; the six local files
    # already carry their stronger NGHWin reason.
    for key in list(reasons):
        if reasons[key] == {"AS3 SWF literal"} and not key.startswith("hh_"):
            del reasons[key]

    discovered_files = sorted(args.gordon.rglob("*.swf"), key=lambda p: str(p).lower())
    ignored_files = [
        path for path in discovered_files if any(root in path.parents for root in ignored_dirs)
    ]
    all_files = [path for path in discovered_files if path not in ignored_files]
    production_names = {p.name.lower(): p for p in production.glob("*.swf")}
    configured_public_rooms = {f"hh_room_{room_type}.swf" for room_type in public_room_types}
    naming_only_public_rooms = sorted(
        key for key in production_names
        if key.startswith("hh_room_") and key not in configured_public_rooms
    )
    for key in production_names:
        if key.startswith("hh_room_") and "public.room.preload.types" not in reasons[key]:
            reasons[key].add("public-room naming contract")
    missing_references = []
    for key in sorted(reasons):
        if key not in production_names:
            alternates = [str(p.relative_to(args.gordon)) for p in all_files if p.name.lower() == key]
            missing_references.append({
                "file": key,
                "reasons": sorted(reasons[key]),
                "alternates_elsewhere_in_gordon": alternates,
            })

    sets = collections.Counter()
    signatures = collections.Counter()
    kinds: dict[str, collections.Counter] = collections.defaultdict(collections.Counter)
    tags: dict[str, collections.Counter] = collections.defaultdict(collections.Counter)
    unreadable: dict[str, list[dict]] = collections.defaultdict(list)
    unsupported: dict[str, list[dict]] = collections.defaultdict(list)
    checksumless = []
    checksumless_by_set: dict[str, list[str]] = collections.defaultdict(list)

    args.csv.parent.mkdir(parents=True, exist_ok=True)
    compressed = gzip.GzipFile(filename=args.csv, mode="wb", mtime=0)
    with io.TextIOWrapper(compressed, encoding="utf-8", newline="") as out:
        writer = csv.writer(out)
        writer.writerow([
            "set", "file", "signature", "readable", "error", "reasons", "character_id",
            "exported_name", "kind", "tag", "supported",
        ])
        for path in all_files:
            rel = path.relative_to(args.gordon)
            key = path.name.lower()
            if path.parent == production:
                set_name = "production_reachable" if key in reasons else "production_unclassified"
            elif production in path.parents:
                set_name = "production_unclassified"
            elif path.parent == args.gordon and key in reasons:
                set_name = "root_content_duplicate"
            else:
                set_name = "root_unclassified"
            sets[set_name] += 1

            try:
                signature, rows, error = scanner.scan(str(path))
            except Exception as exc:
                signature, rows, error = "?", None, repr(exc)[:120]
            signatures[signature] += 1
            why = sorted(reasons.get(key, set()))
            reason_text = "; ".join(why)

            if rows is None:
                item = {"file": str(rel), "error": error or "?"}
                unreadable[set_name].append(item)
                writer.writerow([set_name, rel, signature, "no", error, reason_text, "", "", "", "", ""])
                continue
            if is_checksumless_complete_cws(path):
                checksumless.append(str(rel))
                checksumless_by_set[set_name].append(str(rel))
            for character_id, name, kind, tag in rows:
                supported = kind in scanner.SUPPORTED_KINDS
                kinds[set_name][kind] += 1
                if tag != "-":
                    tags[set_name][tag] += 1
                writer.writerow([
                    set_name, rel, signature, "yes", "", reason_text, character_id, name, kind,
                    tag, "yes" if supported else "no",
                ])
                if not supported:
                    unsupported[set_name].append({
                        "file": str(rel), "name": name, "kind": kind, "tag": tag,
                    })

    contract_sets = ("production_reachable",)
    reader_contract_pass = all(not unreadable[name] and not unsupported[name] for name in contract_sets)
    summary = {
        "reader_contract_pass": reader_contract_pass,
        "files_total": len(all_files),
        "ignored_files": len(ignored_files),
        "ignored_directories": [str(path.relative_to(args.gordon)) for path in ignored_dirs],
        "ignored_reason": "Owner decision 2026-08-31: not part of the SkyHaxe asset contract.",
        "file_sets": dict(sets),
        "containers": dict(signatures),
        "supported_kinds": sorted(scanner.SUPPORTED_KINDS),
        "kinds_by_set": {name: dict(counter) for name, counter in kinds.items()},
        "tags_by_set": {name: dict(counter) for name, counter in tags.items()},
        "unreadable_by_set": dict(unreadable),
        "unsupported_count_by_set": {name: len(rows) for name, rows in unsupported.items()},
        "unsupported_files_by_set": {
            name: dict(collections.Counter(row["file"] for row in rows))
            for name, rows in unsupported.items()
        },
        "checksumless_complete_cws": checksumless,
        "checksumless_complete_cws_by_set": dict(checksumless_by_set),
        "missing_references": missing_references,
        "local_include": list(LOCAL_INCLUDE),
        "variables_file": str(args.variables),
        "public_room_preload_types": public_room_types,
        "public_room_preload_files": sorted(configured_public_rooms),
        "public_room_naming_fallback_files": naming_only_public_rooms,
        "notes": [
            "Missing references are corpus/config completeness findings, not decoder failures.",
            "Unclassified files are retained in the report; they are not blanket-excluded.",
            "flash-assets-PRODUCTION-202605152352-294132426 is owner-excluded and not scanned.",
            "CWS files missing only the Adler-32 trailer are accepted after exact header-length verification.",
            "A checksumless CWS in production_reachable is a live reader requirement, not archived tolerance.",
        ],
    }
    args.json.parent.mkdir(parents=True, exist_ok=True)
    args.json.write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")

    print("files found       :", len(all_files))
    print("owner-ignored     :", len(ignored_files))
    print("sets              :", dict(sets))
    print("containers        :", dict(signatures))
    print("checksumless CWS  :", len(checksumless))
    print("missing references:", len(missing_references))
    print("unreadable        :", {k: len(v) for k, v in unreadable.items() if v})
    print("unsupported       :", {k: len(v) for k, v in unsupported.items() if v})
    print("CSV               :", args.csv)
    print("JSON              :", args.json)
    print("P1c reader contract:", "PASS" if reader_contract_pass else "FAIL")
    return 0 if reader_contract_pass else 1


if __name__ == "__main__":
    raise SystemExit(main())
