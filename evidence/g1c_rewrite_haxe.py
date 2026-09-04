#!/usr/bin/env python3
"""Apply measured Haxe-side repairs after ax3 generates the G1c canary."""

from __future__ import annotations

import argparse
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    args = parser.parse_args()

    root = args.source.resolve()
    if "SkyHaxe/.toolchain/g1c" not in root.as_posix():
        raise ValueError(f"refusing to rewrite outside SkyHaxe/.toolchain/g1c: {root}")

    path = root / "com/sulake/core/window/utils/WindowParser.hx"
    content = path.read_text(encoding="utf-8")
    old = "import com.sulake.core.window.enum.WindowParam;"
    new = "import com.sulake.core.window.enums.WindowParam;"
    actual = content.count(old)
    if actual != 1:
        raise ValueError(f"{path}: expected one reserved-package import, found {actual}")
    path.write_text(content.replace(old, new), encoding="utf-8", newline="\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
