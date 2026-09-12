#!/usr/bin/env python3
"""Report guarded rewrite counts for an already-staged AS3 tree without changing it."""
from __future__ import annotations

import argparse
import re
import tempfile
import shutil
from pathlib import Path

from m2_rules import RULES
from sync import subn_xml_literal


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path)
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="skyhaxe-rules-") as temporary:
        root = Path(temporary) / "as3"
        shutil.copytree(args.root, root)
        for rule in RULES:
            sites = 0
            for path in sorted(root.rglob("*.as")):
                relative = path.relative_to(root).as_posix()
                if rule.get("paths") and relative not in rule["paths"]:
                    continue
                text = path.read_text(encoding="utf-8-sig", errors="replace")
                if rule["kind"] == "regex":
                    updated, hits = re.subn(rule["pattern"], rule["replacement"], text)
                elif rule["kind"] == "xml-cdata":
                    updated, hits = subn_xml_literal(rule["pattern"], text)
                else:
                    lines = text.splitlines(keepends=True)
                    kept = [line for line in lines if rule["match"] not in line]
                    hits = len(lines) - len(kept)
                    updated = "".join(kept)
                if hits:
                    path.write_text(updated, encoding="utf-8", newline="\n")
                    sites += hits
            print(f'        "{rule["id"]}": {sites},')
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
