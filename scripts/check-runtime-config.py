#!/usr/bin/env python3
"""Read-only audit for stale browser deployment URLs in original gamedata/config files."""
from __future__ import annotations
import argparse
import re
from pathlib import Path

STALE = re.compile(r"(?:localhost|127\.0\.0\.1|nextgenhabbo\.com|(?<!s)http://)", re.I)
URLISH = re.compile(r"(?:url|path|host|endpoint|client|image|text|variable|gordon)", re.I)

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path, help="Operator-owned original SWF/gamedata root")
    args = parser.parse_args()
    root = args.root.resolve()
    if not root.is_dir():
        parser.error(f"not a directory: {root}")
    findings: list[str] = []
    for path in root.rglob("*"):
        if not path.is_file() or path.suffix.lower() not in {".txt", ".xml", ".json", ".ini", ".html"}:
            continue
        try:
            lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        except OSError:
            continue
        for number, line in enumerate(lines, 1):
            if URLISH.search(line) and STALE.search(line):
                # Do not print query strings, which could contain a ticket in an operator file.
                safe = line.split("?", 1)[0].strip()[:240]
                findings.append(f"{path.relative_to(root)}:{number}: {safe}")
    if findings:
        print("Potential stale or insecure public URL settings (no files changed):")
        print("\n".join(findings))
        return 2
    print("No stale localhost, NGH-domain, or plain-HTTP URL settings found in inspected text files.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
