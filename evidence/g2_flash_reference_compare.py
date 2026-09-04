#!/usr/bin/env python3
"""Compare the AIR/Flash runtime capture with the independently generated pixel contract."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("log", type=Path)
    parser.add_argument("--contract", type=Path, default=Path("evidence/g2_reader_contract.json"))
    parser.add_argument("--output", type=Path, default=Path("evidence/g2e_flash_reference.json"))
    args = parser.parse_args()

    if args.log.suffix.lower() == ".json":
        capture = json.loads(args.log.read_text(encoding="utf-8"))
    else:
        prefix = "G2_FLASH_REFERENCE_RESULT "
        lines = args.log.read_text(encoding="utf-8", errors="replace").splitlines()
        records = [json.loads(line[len(prefix):]) for line in lines if line.startswith(prefix)]
        if len(records) != 1:
            raise SystemExit(f"expected one Flash result record, got {len(records)}")
        capture = records[0]
    contract = json.loads(args.contract.read_text(encoding="utf-8"))
    compared = []
    for actual in capture["assets"]:
        symbols = contract["files"][actual["file"]]["symbols"]
        expected = next((item for item in symbols if item["name"] == actual["name"]), None)
        if expected is None:
            raise SystemExit("Flash returned an uncontracted symbol: " + actual["name"])
        for key in ("width", "height", "rgba_md5"):
            if actual[key] != expected[key]:
                raise SystemExit(
                    f"{actual['name']} {key}: Flash {actual[key]!r} != contract {expected[key]!r}"
                )
        compared.append(actual)
    if len(compared) != 20 or len({item["file"] for item in compared}) < 3:
        raise SystemExit("Flash comparison must cover exactly 20 assets across three furni")
    result = {
        "gate": "G2e-flash-runtime-reference",
        "status": "pass",
        "runtime": "Harman AIR 51.2.2 (Flash VM/display semantics)",
        "comparison": "exact straight-RGBA MD5 equality with the shared independent contract",
        "assets_compared": len(compared),
        "files_compared": sorted({item["file"] for item in compared}),
        "assets": compared,
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
