#!/usr/bin/env python3
"""Validate and optionally copy the bounded G1c ActionScript canary corpus."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
from pathlib import Path


PATTERNS = {
    "vector": re.compile(r"\bVector\s*\.\s*<"),
    "dictionary": re.compile(r"\bDictionary\b"),
    "bytearray": re.compile(r"\bByteArray\b"),
    "reflection": re.compile(
        r"\b(?:describeType|getDefinitionByName|getQualifiedClassName|getQualifiedSuperclassName)\b"
    ),
    "xml": re.compile(r"\bXMLList\b|:\s*XML\b|\bnew\s+XML\s*\("),
    "namespace": re.compile(
        r"\buse\s+namespace\b|\bnamespace\s+[A-Za-z_$]|\b[A-Za-z_$][\w$]*::[A-Za-z_$]"
    ),
}

LEXICAL_NOISE = re.compile(
    r'//[^\n]*|/\*.*?\*/|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',
    re.DOTALL,
)


def parse_manifest(path: Path) -> list[tuple[str, set[str]]]:
    entries: list[tuple[str, set[str]]] = []
    for line_number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        try:
            relative, categories = line.split("\t", 1)
        except ValueError as error:
            raise ValueError(f"{path}:{line_number}: expected path<TAB>categories") from error
        entries.append((relative, set(categories.split(","))))
    return entries


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("--manifest", type=Path, default=Path(__file__).with_name("g1c_canary_files.txt"))
    parser.add_argument("--copy-to", type=Path)
    parser.add_argument("--json", type=Path)
    args = parser.parse_args()

    source = args.source.resolve()
    entries = parse_manifest(args.manifest)
    if not 20 <= len(entries) <= 30:
        raise ValueError(f"canary must contain 20-30 files, found {len(entries)}")

    seen: set[str] = set()
    results = []
    coverage = {name: 0 for name in PATTERNS}
    for relative, expected in entries:
        normalized = Path(relative).as_posix()
        if normalized in seen:
            raise ValueError(f"duplicate canary path: {normalized}")
        seen.add(normalized)
        path = (source / relative).resolve()
        if source not in path.parents or not path.is_file():
            raise FileNotFoundError(f"missing or out-of-scope canary file: {path}")

        content = path.read_text(encoding="utf-8-sig", errors="strict")
        code = LEXICAL_NOISE.sub(" ", content)
        actual = {name for name, pattern in PATTERNS.items() if pattern.search(code)}
        missing = expected - actual
        if missing:
            raise ValueError(f"{normalized}: expected constructs not found: {sorted(missing)}")
        for name in actual:
            coverage[name] += 1

        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        results.append(
            {
                "path": normalized,
                "expected_constructs": sorted(expected),
                "detected_constructs": sorted(actual),
                "lines": content.count("\n") + 1,
                "sha256": digest,
            }
        )

        if args.copy_to:
            destination = args.copy_to.resolve() / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, destination)

    absent = [name for name, count in coverage.items() if count == 0]
    if absent:
        raise ValueError(f"canary has no coverage for: {absent}")

    report = {
        "source": source.as_posix(),
        "file_count": len(results),
        "coverage_file_counts": coverage,
        "files": results,
    }
    rendered = json.dumps(report, indent=2) + "\n"
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(rendered, encoding="utf-8", newline="\n")
    else:
        print(rendered, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
