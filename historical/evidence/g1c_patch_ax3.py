#!/usr/bin/env python3
"""Apply the pinned G1c compatibility patch to a clean ax3 checkout."""

from __future__ import annotations

import argparse
import subprocess
from pathlib import Path


PINNED_COMMIT = "70f0ae5f9ce466b207c70952163aaa83a7aff357"


def replace_exact(path: Path, old: str, new: str, expected: int, rule: str) -> None:
    content = path.read_text(encoding="utf-8")
    actual = content.count(old)
    if actual != expected:
        raise ValueError(f"{path}: {rule}: expected {expected} matches, found {actual}")
    path.write_text(content.replace(old, new), encoding="utf-8", newline="\n")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("checkout", type=Path)
    args = parser.parse_args()

    checkout = args.checkout.resolve()
    commit = subprocess.run(
        ["git", "-C", str(checkout), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    if commit != PINNED_COMMIT:
        raise ValueError(f"expected ax3 {PINNED_COMMIT}, found {commit}")

    generator = (checkout / "src/ax3/GenHaxe.hx").read_text(encoding="utf-8")
    compatibility = (checkout / "compat/ASCompat.hx").read_text(encoding="utf-8")
    if (
        'case "unescape": "ASCompat.unescape";' in generator
        and "public static inline function unescape(s:String):String" in compatibility
    ):
        return 0

    replace_exact(
        checkout / "src/ax3/GenHaxe.hx",
        'case "escape": "escape";\n\t\t\tcase "arguments":',
        'case "escape": "ASCompat.escape";\n\t\t\tcase "unescape": "ASCompat.unescape";\n\t\t\tcase "arguments":',
        1,
        "route legacy escape globals through ASCompat",
    )
    replace_exact(
        checkout / "compat/ASCompat.hx",
        "\tpublic static inline function escape(s:String):String {\n"
        "\t\t#if flash\n"
        "\t\treturn untyped __global__[\"escape\"](s);\n"
        "\t\t#else\n"
        "\t\treturn js.Lib.global.escape(s);\n"
        "\t\t#end\n"
        "\t}\n",
        "\tpublic static inline function escape(s:String):String {\n"
        "\t\t#if flash\n"
        "\t\treturn untyped __global__[\"escape\"](s);\n"
        "\t\t#else\n"
        "\t\treturn js.Lib.global.escape(s);\n"
        "\t\t#end\n"
        "\t}\n\n"
        "\tpublic static inline function unescape(s:String):String {\n"
        "\t\t#if flash\n"
        "\t\treturn untyped __global__[\"unescape\"](s);\n"
        "\t\t#else\n"
        "\t\treturn js.Lib.global.unescape(s);\n"
        "\t\t#end\n"
        "\t}\n",
        1,
        "provide legacy unescape compatibility",
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
