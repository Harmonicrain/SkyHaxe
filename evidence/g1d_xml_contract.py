#!/usr/bin/env python3
"""Record the implemented G1d XML boundary and mechanical AS3 rewrite contract."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


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
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_xml_foundation.json"),
    )
    args = parser.parse_args()

    lexical_path = args.skyhaxe / "evidence/e4x_contract.json"
    lexical = json.loads(lexical_path.read_text(encoding="utf-8-sig"))
    as3_files = sorted(args.client_src.rglob("*.as"))
    all_source = "\n".join(
        path.read_text(encoding="utf-8-sig", errors="replace") for path in as3_files
    )

    implementation = [
        args.skyhaxe / "src/com/sulake/core/utils/xml/XML.hx",
        args.skyhaxe / "src/com/sulake/core/utils/xml/XMLList.hx",
        args.skyhaxe / "test/G1dXmlTest.hx",
    ]
    result = {
        "gate": "G1d-xml",
        "scope": "semantic foundation; representative DefineBinaryData parity remains G3",
        "source_contract": {
            "files_scanned": lexical["files_scanned"],
            "files_touching_xml": lexical["files_touching_xml"],
            "measurement_kind": lexical["measurement_kind"],
            "api_upper_bound_first_party": lexical["api_upper_bound_first_party"],
            "api_upper_bound_third_party": lexical["api_upper_bound_third_party"],
            "first_party_descendant_sites_after_p2": len(
                lexical["descendant_sites_first_party"]
            ),
            "third_party_descendant_sites": len(
                lexical["descendant_sites_third_party"]
            ),
            "syntax_counts": {
                "direct_attribute_access": len(re.findall(r"\.@[A-Za-z_*]", all_source)),
                "direct_attribute_assignment": len(
                    re.findall(r"\.@[A-Za-z_*][A-Za-z0-9_]*\s*=", all_source)
                ),
                "xml_coercion": len(re.findall(r"(?<!new )\bXML\s*\(", all_source)),
                "xml_list_coercion": len(re.findall(r"\bXMLList\s*\(", all_source)),
                "xml_construction": len(re.findall(r"\bnew\s+XML\s*\(", all_source)),
            },
        },
        "implemented_surface": {
            "XML": [
                "coerce",
                "length",
                "at",
                "child",
                "children",
                "text",
                "attribute",
                "setAttribute",
                "name",
                "localName",
                "parent",
                "hasOwnProperty",
                "appendChild",
                "replace",
                "copy",
                "toString",
                "toXMLString",
            ],
            "XMLList": [
                "coerce",
                "length",
                "at",
                "child",
                "children",
                "text",
                "attribute",
                "setAttribute",
                "name",
                "localName",
                "parent",
                "hasOwnProperty",
                "appendChild",
                "replace",
                "copy",
                "iterator",
                "toString",
                "toXMLString",
            ],
        },
        "rewrite_rules": [
            "XML(value) -> XML.coerce(value); new XML(value) remains construction/copy",
            "XMLList(value) -> XMLList.coerce(value)",
            "xml.childName -> xml.child(\"childName\")",
            "xml.@name read/coercion -> xml.attribute(\"name\").toString()",
            "xml.@name = value -> xml.setAttribute(\"name\", value)",
            "xmlList[index] and xml[index] -> xmlList.at(index) / xml.at(index)",
            "for each (node in xmlList) -> for (node in xmlList)",
            "first-party descendant rewrites remain explicit depth-first children() walks",
        ],
        "haxe_sha256": {
            str(path.relative_to(args.skyhaxe)).replace("\\", "/"): sha256(path)
            for path in implementation
        },
        "known_limits": [
            "lexical API counts are upper bounds where member names overlap non-XML types",
            "namespace selection beyond qualified-name/localName handling is not implemented",
            "the one predicate filter and one remaining descendant site are vendored third-party code",
            "G3 must compare representative asset/visualization/logic/index blobs against AS3 values",
        ],
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
