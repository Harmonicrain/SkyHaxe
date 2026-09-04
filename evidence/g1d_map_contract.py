#!/usr/bin/env python3
"""Measure the AS3 Map boundary and emit the reproducible G1d contract."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from collections import Counter
from pathlib import Path


MAP_IMPORT = "import com.sulake.core.utils.Map;"
API_METHODS = (
    "add",
    "unshift",
    "remove",
    "getWithIndex",
    "getKey",
    "getKeys",
    "hasKey",
    "getValue",
    "setValue",
    "getValues",
    "hasValue",
    "indexOf",
    "concatenate",
    "clone",
    "reset",
    "dispose",
)
API_CALL = re.compile(r"\.(" + "|".join(API_METHODS) + r")\s*\(")
NULL_WRITE = re.compile(r"\.(?:add|unshift)\([^\r\n]*,\s*null\s*\)")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def parse_args() -> argparse.Namespace:
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
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_map_contract.json"),
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    as3_files = sorted(args.client_src.rglob("*.as"))
    imported_files: list[Path] = []
    api_counts: Counter[str] = Counter()
    null_writes: list[str] = []

    for path in as3_files:
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        if NULL_WRITE.search(text):
            null_writes.append(path.relative_to(args.client_src).as_posix())
        if MAP_IMPORT not in text:
            continue
        imported_files.append(path)
        api_counts.update(API_CALL.findall(text))

    map_as = args.client_src / "com/sulake/core/utils/Map.as"
    single_as = args.client_src / "com/sulake/core/utils/SingleWriteMap.as"
    disposable_as = args.client_src / "com/sulake/core/runtime/IDisposable.as"
    messages_as = args.client_src / "com/sulake/habbo/communication/HabboMessages.as"
    messages = messages_as.read_text(encoding="utf-8-sig", errors="replace")

    haxe_sources = [
        args.skyhaxe / "src/com/sulake/core/runtime/IDisposable.hx",
        args.skyhaxe / "src/com/sulake/core/utils/Map.hx",
        args.skyhaxe / "src/com/sulake/core/utils/SingleWriteMap.hx",
        args.skyhaxe / "test/G1dMapTest.hx",
    ]

    result = {
        "gate": "G1d-map",
        "strategy": "hand-port Flash-semantic boundary; ax3 remains for leaves and DTOs",
        "source": {
            "client_src": str(args.client_src),
            "as3_file_count": len(as3_files),
            "custom_map_import_file_count": len(imported_files),
            # This is deliberately labelled syntax, not exact receiver typing:
            # AS3 does not expose enough information for a grep to prove the receiver.
            "api_call_syntax_in_importing_files": {
                method: api_counts[method] for method in API_METHODS
            },
            "api_call_syntax_total": sum(api_counts.values()),
            "literal_null_add_or_unshift_files": null_writes,
            "single_write_packet_assignments": {
                "incoming": len(re.findall(r"INCOMING_PACKETS\s*\[", messages)),
                "outgoing": len(re.findall(r"OUTGOING_PACKETS\s*\[", messages)),
            },
            "sha256": {
                str(path.relative_to(args.client_src)).replace("\\", "/"): sha256(path)
                for path in (map_as, single_as, disposable_as)
            },
        },
        "haxe": {
            "sha256": {
                str(path.relative_to(args.skyhaxe)).replace("\\", "/"): sha256(path)
                for path in haxe_sources
            },
            "test_entry_point": "test/G1dMapTest.hx",
            "test_script": "scripts/test-g1d-map.ps1",
        },
        "proxy_rewrite_rules": [
            "map[key] -> map.getValue(key)",
            "map[key] = value -> map.setValue(key, value)",
            "for (key in map) may remain: Haxe iterator yields ordered keys",
            "for each (value in map) -> for (value in map.getValues())",
            "QName bracket keys -> pass qname.localName to getValue/setValue",
        ],
        "parity_decisions": [
            "preserve insertion order and defensive getKeys/getValues copies",
            "preserve dynamic primitive distinction and object identity on JavaScript",
            "preserve duplicate-null-key behavior from Dictionary value-based add/unshift checks",
            "preserve shared-value removal behavior from Array.indexOf(value)",
            "SingleWriteMap setValue throws on overwrite, matching Proxy assignment",
        ],
    }
    packet_counts = result["source"]["single_write_packet_assignments"]
    packet_counts["total"] = packet_counts["incoming"] + packet_counts["outgoing"]

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
