#!/usr/bin/env python3
"""Record the generated identities exercised by the M2 OpenFL compile gate."""
from __future__ import annotations

import hashlib
import json
import re
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
from pathlib import Path


REPO = Path(__file__).resolve().parent.parent
TEST = REPO / "test/M2RuntimeCompileMain.hx"
PROJECT = REPO / "project.m2-runtime.xml"
PRECEDENCE_MACRO = REPO / "test/M2GeneratedPrecedence.hx"
GENERATED = REPO / "generated"
BUILD = REPO / "build/tests/m2-runtime/html5/bin/m2-runtime.js"
SYNC = REPO / "evidence/m2_sync_manifest.json"
OUT = REPO / "evidence/m2_compile_frontier.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tree_hash() -> str:
    digest = hashlib.sha256()
    for path in sorted(GENERATED.rglob("*.hx")):
        digest.update(path.relative_to(GENERATED).as_posix().encode())
        digest.update(sha256(path).encode())
    return digest.hexdigest()


def main() -> int:
    identities = re.findall(r"static var \w+:([\w.]+);", TEST.read_text(encoding="utf-8"))
    if len(identities) != len(set(identities)):
        raise AssertionError("compile frontier contains duplicate identities")
    missing = [
        identity for identity in identities
        if not (GENERATED / (identity.replace(".", "/") + ".hx")).is_file()
    ]
    if missing:
        raise AssertionError("frontier identities missing from generated output: {}".format(missing))
    collisions = [
        identity for identity in identities
        if (REPO / "src" / (identity.replace(".", "/") + ".hx")).is_file()
    ]
    if not collisions:
        raise AssertionError("precedence gate has no same-identity collision canary")
    if not BUILD.is_file():
        raise AssertionError("OpenFL compile artifact is missing: {}".format(BUILD))
    project_root = ET.parse(PROJECT).getroot()
    source_order = [node.attrib["path"] for node in project_root.findall("source")]
    if "src" not in source_order or "generated" not in source_order:
        raise AssertionError("M2 project must declare both src and generated classpaths")
    if source_order.index("generated") < source_order.index("src"):
        raise AssertionError(
            "generated must follow src: Haxe resolves duplicate classes from the last classpath")
    macros = [
        node.attrib.get("value") for node in project_root.findall("haxeflag")
        if node.attrib.get("name") == "--macro"
    ]
    required_macro = "M2GeneratedPrecedence.assertGenerated()"
    if required_macro not in macros:
        raise AssertionError("M2 project does not invoke the generated-precedence compiler guard")
    sync = json.loads(SYNC.read_text(encoding="utf-8"))
    actual_tree = tree_hash()
    if actual_tree != sync["generated_tree_sha256"]:
        raise AssertionError("generated tree no longer matches the deterministic sync manifest")

    data = {
        "gate": "M2b-generated-compile-frontier",
        "verified_utc": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "status": "pass",
        "target": "OpenFL 9.5.2 HTML5",
        "generated_precedence": {
            "compiler_enforced": True,
            "macro": required_macro,
            "checked_identities": len(identities),
            "same_identity_collision_count": len(collisions),
            "same_identity_collisions": collisions,
            "source_order": source_order,
            "resolution_rule": "Haxe resolves duplicate classes from the last classpath",
        },
        "identity_count": len(identities),
        "generated_file_count": len(list(GENERATED.rglob("*.hx"))),
        "generated_compile_coverage_percent": round(100 * len(identities) /
                                                       len(list(GENERATED.rglob("*.hx"))), 1),
        "identities": identities,
        "generated_tree_sha256": actual_tree,
        "build_sha256": sha256(BUILD),
        "test_sha256": sha256(TEST),
        "project_sha256": sha256(PROJECT),
        "precedence_macro_sha256": sha256(PRECEDENCE_MACRO),
    }
    OUT.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
    print("M2_COMPILE_FRONTIER_PASS identities={}".format(len(identities)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
