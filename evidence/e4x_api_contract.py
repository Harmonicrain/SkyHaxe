#!/usr/bin/env python3
"""Derive the E4X API surface the Haxe XML shim must implement.

PLAN.md originally proposed a three-method shim (att/child/length). That was a guess. This
enumerates what the source actually uses, so D2's scope comes from the corpus instead.

Two things make a naive grep wrong, and both are handled here:

  * `...args` and `...types` are REST PARAMETERS, not the descendant operator. An earlier count
    of "5 descendant sites" was inflated by exactly this.
  * `.descendants()` is the method form of `..` and must be counted with it.

Third-party trees are reported separately: `org/openvideoads` is a vendored VAST library and may
be dropped rather than ported, but that has to be an explicit decision, not an accident.

Usage:
    python e4x_api_contract.py <habbo-client-clean/src> [--json out.json]
"""
from __future__ import annotations

import argparse
import collections
import json
import os
import re

THIRD_PARTY = ("org/openvideoads", "com/hurlant", "com/adobe", "adobe/", "deng/", "com/probertson")

# E4X methods and properties the shim would have to provide.
API = [
    "children", "child", "childIndex", "attribute", "attributes", "elements",
    "text", "name", "localName", "namespace", "parent",
    "appendChild", "prependChild", "insertChildAfter", "insertChildBefore",
    "replace", "setChildren", "copy", "normalize",
    "toXMLString", "toString", "valueOf", "hasOwnProperty", "hasSimpleContent",
    "hasComplexContent", "nodeKind", "length",
]

# `..name` but not `...rest`. Only a *preceding dot* disqualifies a match: an earlier version
# also excluded word characters, which silently dropped the real `_local_2..alias` form.
DESCENDANT_OP = re.compile(r"(?<!\.)\.\.[A-Za-z_]")
REST_PARAM = re.compile(r"\.\.\.[A-Za-z_]")
DESCENDANTS_FN = re.compile(r"\.descendants\s*\(")
ATTR_READ = re.compile(r"\.@[A-Za-z_*]")
FILTER_PRED = re.compile(r"\.\([^)]*\)")                  # E4X predicate filter: .(@id == "x")


def is_third_party(rel: str) -> bool:
    n = rel.replace("\\", "/")
    return any(t in n for t in THIRD_PARTY)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("src")
    ap.add_argument("--json", default="e4x_contract.json")
    args = ap.parse_args()

    files = []
    for dirpath, _, names in os.walk(args.src):
        files.extend(os.path.join(dirpath, n) for n in names if n.lower().endswith(".as"))
    files.sort()

    # Only count API calls in files that actually touch XML, to avoid matching unrelated
    # methods that happen to share a name (`length`, `name`, `parent` are everywhere).
    xml_re = re.compile(r":XML\b|:XMLList\b|\bnew XML\(|XMLList\(")
    counts = {"all": collections.Counter(), "third_party": collections.Counter()}
    descendant_sites: list[tuple[str, int, str]] = []
    xml_files = []

    for path in files:
        rel = os.path.relpath(path, args.src).replace("\\", "/")
        text = open(path, encoding="utf-8", errors="replace").read()
        touches_xml = bool(xml_re.search(text))
        if touches_xml:
            xml_files.append(rel)
        bucket = counts["third_party"] if is_third_party(rel) else counts["all"]

        for lineno, line in enumerate(text.splitlines(), 1):
            rest_spans = [m.span() for m in REST_PARAM.finditer(line)]
            for m in DESCENDANT_OP.finditer(line):
                if any(a <= m.start() < b for a, b in rest_spans):
                    continue                                   # rest parameter, not E4X
                descendant_sites.append((rel, lineno, line.strip()[:90]))
            for m in DESCENDANTS_FN.finditer(line):
                descendant_sites.append((rel, lineno, line.strip()[:90]))

        if not touches_xml:
            continue
        for member in API:
            n = len(re.findall(r"\." + member + r"\s*\(", text))
            if member in ("length", "name", "text", "attributes", "parent"):
                n += len(re.findall(r"\." + member + r"\b(?!\s*\()", text))
            if n:
                bucket[member] += n
        if ATTR_READ.search(text):
            bucket["@attribute"] += len(ATTR_READ.findall(text))
        preds = [p for p in FILTER_PRED.findall(text) if "@" in p or "==" in p]
        if preds:
            bucket["(predicate filter)"] += len(preds)

    print("files scanned          :", len(files))
    print("files touching XML     :", len(xml_files))
    print("\nE4X API surface in first-party code (occurrences):")
    for member, n in counts["all"].most_common():
        print("   {:<22} {:>6}".format(member, n))
    print("\nsame, in vendored third-party trees:")
    for member, n in counts["third_party"].most_common():
        print("   {:<22} {:>6}".format(member, n))

    first = [d for d in descendant_sites if not is_third_party(d[0])]
    third = [d for d in descendant_sites if is_third_party(d[0])]
    print("\nDESCENDANT sites (`..name` and `.descendants()`), rest-params excluded:")
    print("  first-party: {}   third-party: {}".format(len(first), len(third)))
    for rel, lineno, src in first:
        print("   {}:{}  {}".format(rel, lineno, src))
    for rel, lineno, src in third:
        print("   [3rd] {}:{}  {}".format(rel, lineno, src))

    out = {
        "files_scanned": len(files),
        "files_touching_xml": len(xml_files),
        "api_first_party": dict(counts["all"]),
        "api_third_party": dict(counts["third_party"]),
        "descendant_sites_first_party": [
            {"file": r, "line": l, "source": s} for r, l, s in first],
        "descendant_sites_third_party": [
            {"file": r, "line": l, "source": s} for r, l, s in third],
    }
    with open(args.json, "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=1)
    print("\nwritten to", args.json)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
