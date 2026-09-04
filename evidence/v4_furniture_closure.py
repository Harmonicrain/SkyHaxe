#!/usr/bin/env python3
"""Measure the AS3 dependency closure of the floor-furniture message path.

The furniture parsers convert cleanly, but they do not compile in isolation: `ObjectDataParser`
reaches `IStuffData`, which reaches `IRoomObjectModel`, and so on into the room engine. Converting
package by package and hoping the edges meet is how a port stalls, so this walks the imports and
says up front how many files and which packages the path actually needs.

Seeded from the message classes V4 must dispatch to place objects and users in a room.

Usage:
    python evidence/v4_furniture_closure.py [--json out.json]
"""
from __future__ import annotations

import argparse
import collections
import json
import re
from pathlib import Path

CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")

SEEDS = [
    "com/sulake/habbo/communication/messages/parser/room/engine/ObjectsMessageParser.as",
    "com/sulake/habbo/communication/messages/parser/room/engine/ObjectDataParser.as",
    "com/sulake/habbo/communication/messages/parser/room/engine/ObjectAddMessageParser.as",
    "com/sulake/habbo/communication/messages/parser/room/engine/ItemsMessageParser.as",
    "com/sulake/habbo/communication/messages/parser/room/engine/ItemAddMessageParser.as",
    "com/sulake/habbo/communication/messages/parser/room/engine/UsersMessageParser.as",
    "com/sulake/habbo/communication/messages/parser/room/engine/PublicRoomObjectsMessageParser.as",
]

IMPORT = re.compile(r"(?m)^\s*import\s+([\w.]+)\s*;")
# Imports alone under-report the closure: a subclass in the same package needs no import, so
# `StuffDataBase` was invisible even though every StuffData class extends it. Following the
# inheritance clause and resolving bare names against the file's own package closes that hole.
INHERITS = re.compile(r"\bclass\s+\w+\s+(?:extends\s+([\w.]+))?\s*(?:implements\s+([\w.,\s]+))?")
PACKAGE = re.compile(r"(?m)^\s*package\s+([\w.]+)")
# AS3 does not require imports for classes in the current package. Imports + inheritance therefore
# still miss helpers such as ItemsMessageParser -> ItemDataParser and JSONDecoder -> JSONTokenizer.
# A capitalized identifier is only followed when a matching .as file exists beside the source, so
# this deliberately favours a safe closure superset without inventing dependencies.
LOCAL_TYPE = re.compile(r"\b[A-Z][A-Za-z0-9_]*\b")


def to_path(qualified: str) -> Path:
    return CLIENT / (qualified.replace(".", "/") + ".as")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", type=Path,
                    default=Path(__file__).resolve().parent / "v4_furniture_closure.json")
    args = ap.parse_args()

    # Files with a hand-maintained override must not be converted on top of it. Sol's cutover
    # finding: generated code normally wins, but a genuine semantic boundary -- the Proxy-backed
    # `Map` is the example -- keeps its hand-written implementation. Converting it anyway puts a
    # generated copy earlier on the class path and shadows the exception silently.
    manifest = json.loads(
        (Path(__file__).resolve().parent / "m2_exceptions.json").read_text(encoding="utf-8"))
    overridden = {
        entry["as3_source"] for entry in manifest["exceptions"] if entry.get("as3_source")
    }
    overridden = {source[len("src/"):] if source.startswith("src/") else source
                  for source in overridden}

    seen: set[str] = set()
    hand_written: set[str] = set()
    missing: set[str] = set()
    queue = list(SEEDS)

    while queue:
        relative = queue.pop()
        if relative in seen:
            continue
        path = CLIENT / relative
        if not path.is_file():
            missing.add(relative)
            continue
        if relative in overridden:
            hand_written.add(relative)
            continue
        seen.add(relative)
        text = path.read_text(encoding="utf-8-sig", errors="replace")

        # Base classes and interfaces, which may be bare names resolved against this file's package.
        own_package = PACKAGE.search(text)
        inherits = INHERITS.search(text)
        if inherits:
            names = [inherits.group(1)] if inherits.group(1) else []
            if inherits.group(2):
                names += [n.strip() for n in inherits.group(2).split(",")]
            for name in filter(None, names):
                if "." not in name and own_package:
                    name = own_package.group(1) + "." + name
                candidate = to_path(name)
                if candidate.is_file():
                    queue.append(candidate.relative_to(CLIENT).as_posix())

        if own_package:
            package_path = CLIENT / own_package.group(1).replace(".", "/")
            for type_name in LOCAL_TYPE.findall(text):
                candidate = package_path / (type_name + ".as")
                if candidate.is_file() and candidate != path:
                    queue.append(candidate.relative_to(CLIENT).as_posix())

        for qualified in IMPORT.findall(text):
            # flash.* and __AS3__ are runtime types the target supplies, not client source.
            if qualified.startswith(("flash.", "__AS3__", "mx.", "fl.")):
                continue
            candidate = to_path(qualified)
            if candidate.is_file():
                queue.append(candidate.relative_to(CLIENT).as_posix())
            else:
                missing.add(qualified)

    packages = collections.Counter(
        "/".join(relative.split("/")[:-1]) for relative in seen)
    lines = sum(
        len((CLIENT / relative).read_text(encoding="utf-8-sig", errors="replace").splitlines())
        for relative in seen)

    result = {
        "gate": "V4-furniture-dependency-closure",
        "seeds": SEEDS,
        "closure_files": len(seen),
        "closure": sorted(seen),
        "closure_source_lines": lines,
        "packages": dict(packages.most_common()),
        "unresolved_imports": sorted(missing),
        "hand_written_overrides_skipped": sorted(hand_written),
        "note": "This is what must be converted and compiling before the furniture path can run. "
                "Package-at-a-time conversion cannot be ordered without it.",
    }
    args.json.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")

    print("closure: {} files, {} source lines, {} packages".format(
        len(seen), lines, len(packages)))
    for package, count in packages.most_common(12):
        print("   {:<58} {:>4}".format(package, count))
    if missing:
        print("\nunresolved imports:", len(missing))
    print("\nwritten to", args.json)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
