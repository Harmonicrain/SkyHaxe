#!/usr/bin/env python3
"""Measure the clean-client ByteArray surface and record the G1d adapter contract."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


METHODS = (
    "readByte",
    "readUnsignedByte",
    "readShort",
    "readUnsignedShort",
    "readInt",
    "readUnsignedInt",
    "readFloat",
    "readDouble",
    "readBoolean",
    "readUTF",
    "readUTFBytes",
    "readBytes",
    "readObject",
    "writeByte",
    "writeShort",
    "writeInt",
    "writeUnsignedInt",
    "writeFloat",
    "writeDouble",
    "writeBoolean",
    "writeUTF",
    "writeUTFBytes",
    "writeBytes",
    "writeObject",
    "compress",
    "uncompress",
    "deflate",
    "inflate",
    "clear",
)
PROPERTIES = ("position", "length", "bytesAvailable", "endian", "objectEncoding")


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
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_bytearray_contract.json"),
    )
    args = parser.parse_args()

    token_files: list[tuple[Path, str]] = []
    for path in sorted(args.client_src.rglob("*.as")):
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        if re.search(r"\bByteArray\b", text):
            token_files.append((path, text))
    corpus = "\n".join(text for _, text in token_files)

    object_serialization_sites = []
    for path, text in token_files:
        for line_number, line in enumerate(text.splitlines(), 1):
            if re.search(r"\.(?:readObject|writeObject)\s*\(", line):
                object_serialization_sites.append(
                    {
                        "file": path.relative_to(args.client_src).as_posix(),
                        "line": line_number,
                    }
                )

    openfl_source = args.skyhaxe / ".haxelib/openfl/9,5,2/src/openfl/utils/ByteArray.hx"
    implementation = [
        args.skyhaxe / "src/com/sulake/core/utils/ByteArray.hx",
        args.skyhaxe / "test/G1dByteArrayTest.hx",
        args.skyhaxe / "test/G1dByteArrayBrowserMain.hx",
        args.skyhaxe / "project.g1d-bytearray.xml",
    ]

    result = {
        "gate": "G1d-bytearray",
        "strategy": "thin Flash-default adapter over OpenFL ByteArray",
        "source_contract": {
            "bytearray_files": len(token_files),
            "constructor_calls": len(re.findall(r"\bnew\s+ByteArray\s*\(", corpus)),
            "method_syntax_counts_in_bytearray_files": {
                method: len(re.findall(rf"\.{method}\s*\(", corpus)) for method in METHODS
            },
            "property_syntax_counts_in_bytearray_files": {
                prop: len(re.findall(rf"\.{prop}\b", corpus)) for prop in PROPERTIES
            },
            "explicit_endian_assignments": len(re.findall(r"\.endian\s*=", corpus)),
            "object_serialization_sites": object_serialization_sites,
            "object_serialization_scope": "vendored org/openvideoads only",
        },
        "semantic_decision": {
            "problem": "OpenFL non-Flash ByteArray defaults to platform endian; Flash/AIR defaults big-endian",
            "fix": "custom constructor and OpenFL adaptation normalize to Endian.BIG_ENDIAN",
            "preserved": "call sites can still explicitly select Endian.LITTLE_ENDIAN",
            "openfl_source_sha256": sha256(openfl_source),
        },
        "rewrite_rules": [
            "import flash.utils.ByteArray -> import com.sulake.core.utils.ByteArray",
            "import flash.utils.Endian -> import openfl.utils.Endian",
            "new ByteArray() remains new ByteArray(); adapter supplies Flash default endian",
            "OpenFL-provided buffers assigned to the adapter are normalized at the boundary",
            "do not port vendored readObject/writeObject unless org/openvideoads is explicitly retained",
        ],
        "haxe_sha256": {
            str(path.relative_to(args.skyhaxe)).replace("\\", "/"): sha256(path)
            for path in implementation
        },
        "verification": {
            "test_script": "scripts/test-g1d-bytearray.ps1",
            "browser_project": "project.g1d-bytearray.xml",
            "expected_dom_marker": "data-skyhaxe-g1d-bytearray=pass",
        },
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
