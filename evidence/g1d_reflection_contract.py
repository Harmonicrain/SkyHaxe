#!/usr/bin/env python3
"""Measure the Flash reflection boundary and record its Haxe rewrite contract."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


APIS = (
    "describeType",
    "getDefinitionByName",
    "getQualifiedClassName",
    "getQualifiedSuperclassName",
    "getClassByAlias",
    "registerClassAlias",
)
THIRD_PARTY = (
    "org/openvideoads/",
    "com/hurlant/",
    "com/adobe/",
    "adobe/",
    "deng/",
    "com/probertson/",
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def is_third_party(relative: str) -> bool:
    return any(relative.startswith(prefix) for prefix in THIRD_PARTY)


def main() -> int:
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
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_reflection_contract.json"),
    )
    args = parser.parse_args()

    counts = {
        "first_party": {api: 0 for api in APIS},
        "third_party": {api: 0 for api in APIS},
    }
    sites: list[dict[str, object]] = []
    files = sorted(args.client_src.rglob("*.as"))
    for path in files:
        relative = path.relative_to(args.client_src).as_posix()
        bucket = "third_party" if is_third_party(relative) else "first_party"
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        for line_number, line in enumerate(text.splitlines(), 1):
            for api in APIS:
                occurrences = len(re.findall(rf"\b{api}\s*\(", line))
                if occurrences:
                    counts[bucket][api] += occurrences
                    sites.append(
                        {
                            "scope": bucket,
                            "api": api,
                            "file": relative,
                            "line": line_number,
                            "occurrences": occurrences,
                        }
                    )

    implementation = [
        args.skyhaxe / "src/com/sulake/core/utils/ClassUtils.hx",
        args.skyhaxe / "src/com/sulake/core/utils/DefinitionRegistry.hx",
        args.skyhaxe / "test/G1dReflectionTest.hx",
    ]
    result = {
        "gate": "G1d-reflection",
        "files_scanned": len(files),
        "api_counts": counts,
        "sites": sites,
        "semantic_decisions": [
            "getQualifiedClassName becomes ClassUtils.getQualifiedClassName and preserves AS3 package::Class spelling",
            "describeType interface tests become Type.createEmptyInstance plus Std.isOfType without constructor execution",
            "getDefinitionByName becomes DefinitionRegistry.resolve",
            "manifest-only classes require explicit generated registration to survive dead-code elimination",
            "vendored describeType feature probes and OpenVideoAds reflection remain outside the first-party boundary",
        ],
        "rewrite_rules": [
            "getQualifiedClassName(value) -> ClassUtils.getQualifiedClassName(value)",
            "getDefinitionByName(name) -> DefinitionRegistry.resolve(name)",
            "ClassUtils AS3 API keeps its existing call shape",
            "component bootstrap generation registers every manifest-only class",
        ],
        "haxe_sha256": {
            str(path.relative_to(args.skyhaxe)).replace("\\", "/"): sha256(path)
            for path in implementation
        },
        "verification": {"test_script": "scripts/test-g1d-reflection.ps1"},
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
