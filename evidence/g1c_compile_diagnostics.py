#!/usr/bin/env python3
"""G1c — re-derive the failed converter canary's diagnostic counts from compiler output.

`ax3-canary.md` states 123 source-located diagnostic lines across 12 converted canaries. That
figure previously existed only as prose: the hxml that produced it lives under the gitignored
`.toolchain/g1c/`, so nobody could re-derive it from a checkout. This script closes that gap.

Two modes, because the inputs have different lifetimes:

  --log <file>   parse a saved compiler log. `evidence/g1c_compile_flash.log` is committed, so
                 the figure stays re-derivable after `.toolchain/` is gone.
  --run          invoke Haxe on `.toolchain/g1c/compile-flash.hxml` and save a fresh log first.
                 Only works while the G1c working tree still exists.

A "source-located diagnostic line" is one carrying a `path:line:` location *inside the converted
canary tree*. The compiler also emits location-less cascades while loading the native window
classes from the SWF type library ("Redefinition of variable ... WindowModel"); those describe the
real client's own class hierarchy, not the conversion, and are excluded by that rule rather than
by hand.

Exit code is 0 only when the parsed log still shows the recorded failure. This records a FAILED
gate, so reproducing the failure is the pass condition: a silent change in either direction means
the canary drifted and `ax3-canary.md` needs revisiting.
"""
from __future__ import annotations

import argparse
import collections
import json
import os
import re
import subprocess
import sys
from pathlib import Path

SKYHAXE = Path(__file__).resolve().parent.parent
HXML = SKYHAXE / ".toolchain/g1c/compile-flash.hxml"
CANARY_TREE = "haxe-v18"

# Recorded in ax3-canary.md, reproduced 2026-09-01.
EXPECTED_LINES = 123
EXPECTED_FILES = 12

LOCATED = re.compile(r":\d+: ")


def run_compile(log_path: Path) -> None:
    """Invoke the pinned toolchain on the G1c hxml and save combined output."""
    if not HXML.exists():
        raise SystemExit(
            "{} is missing. `.toolchain/` is gitignored, so --run only works on the machine "
            "that produced the canary. Use --log instead.".format(HXML)
        )
    haxe_root = SKYHAXE / ".toolchain/haxe-4.3.7"
    neko_root = SKYHAXE / ".toolchain/neko-2.4.1"
    env = dict(os.environ)
    env["PATH"] = os.pathsep.join([str(haxe_root), str(neko_root), env.get("PATH", "")])
    env["HAXE_STD_PATH"] = str(haxe_root / "std")
    env["NEKOPATH"] = str(neko_root)
    completed = subprocess.run(
        [str(haxe_root / "haxe.exe"), str(HXML.relative_to(SKYHAXE))],
        cwd=str(SKYHAXE), env=env, capture_output=True, text=True,
    )
    log_path.write_text(completed.stdout + completed.stderr, encoding="utf-8", newline="\n")
    if completed.returncode == 0:
        raise SystemExit("the G1c canary compiled successfully; ax3-canary.md is now wrong")


def parse(log_path: Path) -> dict:
    per_file: collections.Counter = collections.Counter()
    unlocated = 0
    located_elsewhere = 0
    for line in log_path.read_text(encoding="utf-8", errors="replace").splitlines():
        if not LOCATED.search(line):
            unlocated += 1
            continue
        match = re.search(r"[^ ]*" + CANARY_TREE + r"[/\\]([^:]+\.hx)", line)
        if match is None:
            located_elsewhere += 1
            continue
        per_file[match.group(1).replace("\\", "/")] += 1

    total = sum(per_file.values())
    return {
        "gate": "G1c-converter-canary",
        "records": "a FAILED gate; reproducing the failure is the pass condition",
        "source_located_lines_in_canary_tree": total,
        "canary_files_with_diagnostics": len(per_file),
        "per_file": dict(per_file.most_common()),
        "excluded": {
            "lines_without_a_source_location": unlocated,
            "reason": "SWF type-library cascades describing the real client's own class hierarchy "
                      "(\"Redefinition of variable ... WindowModel\"), plus the -swf-header "
                      "deprecation warning",
            "located_lines_outside_the_canary_tree": located_elsewhere,
        },
        "expected": {"lines": EXPECTED_LINES, "files": EXPECTED_FILES},
        "reproduced": total == EXPECTED_LINES and len(per_file) == EXPECTED_FILES,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--log", type=Path, default=SKYHAXE / "evidence/g1c_compile_flash.log")
    ap.add_argument("--run", action="store_true", help="re-invoke the compiler before parsing")
    ap.add_argument("--json", type=Path, default=SKYHAXE / "evidence/g1c_compile_diagnostics.json")
    args = ap.parse_args()

    if args.run:
        run_compile(args.log)
    if not args.log.exists():
        raise SystemExit("no log at {}; pass --run or --log".format(args.log))

    result = parse(args.log)
    result["log"] = str(args.log.relative_to(SKYHAXE)).replace("\\", "/")
    args.json.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")

    print("source-located lines in canary tree :", result["source_located_lines_in_canary_tree"])
    print("canary files with diagnostics       :", result["canary_files_with_diagnostics"])
    print("excluded, no source location        :", result["excluded"]["lines_without_a_source_location"])
    for name, count in result["per_file"].items():
        print("   {:>4}  {}".format(count, name))
    print("\nwritten to", args.json)

    if not result["reproduced"]:
        print("\nG1c DRIFT: expected {} lines across {} files".format(EXPECTED_LINES, EXPECTED_FILES),
              file=sys.stderr)
        return 1
    print("\nG1c: failure reproduced exactly as recorded")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
