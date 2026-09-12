#!/usr/bin/env python3
"""Emit a compile-only root that names every generated message parser.

238 generated files that do not compile are worth nothing, and `generated/` is not on the client's
class path yet, so nothing else would catch it. Naming each type in one root forces the compiler to
resolve all of them; the build either passes or names the file that broke.

Mirrors `test/M2RuntimeCompileMain.hx`, which does the same job for the generated core frontier.

Usage:
    python scripts/generate-parser-compile-root.py
"""
from __future__ import annotations

from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
GENERATED = REPO / "generated"
PARSERS = GENERATED / "com/sulake/habbo/communication/messages/parser"
OUT = REPO / "test/M2ParserCompileMain.hx"


def main() -> int:
    types = sorted(
        path.relative_to(GENERATED).with_suffix("").as_posix().replace("/", ".")
        for path in PARSERS.rglob("*.hx")
    )
    lines = [
        "/** Compile-only root for the generated message parsers. Regenerate with",
        " *  scripts/generate-parser-compile-root.py -- do not edit by hand. */",
        "class M2ParserCompileMain {",
    ]
    for index, qualified in enumerate(types):
        lines.append(f"    static var parser{index}:{qualified};")
    lines.extend([
        "",
        "    public static function main():Void {",
        f"        // {len(types)} generated parsers referenced above.",
        "    }",
        "}",
        "",
    ])
    OUT.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    print(f"named {len(types)} generated parsers in {OUT.relative_to(REPO)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
