#!/usr/bin/env python3
"""Compare AIR's native E4X metrics with the independent G3 XML contract."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("capture", type=Path)
    parser.add_argument("--contract", type=Path, default=Path("evidence/g3_xml_blob_contract.json"))
    parser.add_argument("--output", type=Path, default=Path("evidence/g3_flash_reference.json"))
    args = parser.parse_args()
    capture = json.loads(args.capture.read_text(encoding="utf-8"))
    contract = json.loads(args.contract.read_text(encoding="utf-8"))
    expected = {(item["file"], item["symbol"]): item for item in contract["records"]}
    keys = ("root", "elements", "attributes", "text_nodes", "max_depth", "tag_counts", "canonical_md5")
    for actual in capture["records"]:
        reference = expected[(actual["file"], actual["symbol"])]
        for key in keys:
            if actual[key] != reference[key]:
                raise SystemExit(f"{actual['symbol']} {key}: AIR {actual[key]!r} != reference {reference[key]!r}")
    if capture["compared"] != 25 or len(capture["records"]) != 25:
        raise SystemExit("AIR must compare exactly 25 records")
    result = {
        "gate": "G3-air-native-e4x-reference",
        "status": "pass",
        "runtime": "Harman AIR 51.2.2 native E4X XML",
        "records_compared": 25,
        "fields_compared": list(keys),
        "records": capture["records"],
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print("G3_FLASH_XML_REFERENCE_PASS records=25")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
