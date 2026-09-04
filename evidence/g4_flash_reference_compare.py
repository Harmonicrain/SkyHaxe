#!/usr/bin/env python3
"""Regression-check the saved G4 browser soak against native AIR capture."""
from __future__ import annotations

import argparse
import json
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("browser", type=Path, nargs="?",
                        default=Path(__file__).with_name("g4_verification.json"))
    parser.add_argument("flash", type=Path, nargs="?",
                        default=Path(__file__).with_name("g4_flash_reference.json"))
    args = parser.parse_args()
    saved = json.loads(args.browser.read_text(encoding="utf-8"))
    browser = saved["browser"]
    flash = json.loads(args.flash.read_text(encoding="utf-8"))
    comparable = {key: value for key, value in flash.items() if key != "runtime"}
    if browser["flash_comparable"] != comparable:
        raise SystemExit("OpenFL deterministic capture differs from native Flash capture")
    checks = {
        "duration_seconds": browser["duration_seconds"] >= 180,
        "frames": browser["frames"] >= 3600,
        "real_asset_instances": browser["real_asset_instances"] == 160,
        "filtered_sprites": browser["display"]["filtered_sprites"] == 7,
        "additive_sprites": browser["display"]["additive_sprites"] == 6,
        "allocation_plateau": browser["display"]["created"] == 160,
        "pool_reuse": browser["display"]["reused"] >= 60,
        "mask": browser["display"]["masked"] is True,
        "render_p95_budget": browser["timing_ms"]["render_p95"] < 16.7,
        "bounded_heap": browser["heap_mib"]["range"] < 128,
        "gc_observed": browser["heap_mib"]["gc_drops_over_0_5_mib"] > 0,
        "console": browser["console_errors"] == 0,
    }
    failures = [name for name, passed in checks.items() if not passed]
    if failures:
        raise SystemExit("G4 saved evidence failed: " + ", ".join(failures))
    print("G4_FLASH_REFERENCE_COMPARE_PASS pixels=36 checks={}".format(len(checks)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
