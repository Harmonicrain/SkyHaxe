#!/usr/bin/env python3
"""Prove that one copied-source edit causes one bounded generated-code delta.

The authoritative clean client is never written. The drill copies only com/sulake/core into a
temporary client root, runs the normal deterministic sync, changes one generated-only leaf, and
runs the same sync again. Any unrelated generated churn fails the drill.
"""
from __future__ import annotations

import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path


REPO = Path(__file__).resolve().parent.parent
CLEAN = Path(r"C:\habbo\client\habbo-client-clean")
EVIDENCE = REPO / "evidence/m2_update_drill.json"
PACKAGE = Path("com/sulake/core")
TARGET_SOURCE = PACKAGE / "runtime/IIDCore.as"
TARGET_GENERATED = (PACKAGE / "runtime/IIDCore.hx").as_posix()
SUBPACKAGES = ("runtime", "assets", "utils")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def file_map(root: Path, suffix: str) -> dict[str, str]:
    return {
        path.relative_to(root).as_posix(): sha256(path)
        for path in sorted(root.rglob("*"))
        if path.is_file() and path.suffix.lower() == suffix
    }


def clean_status() -> bytes:
    return subprocess.run(
        ["git", "-C", str(CLEAN), "status", "--porcelain=v1", "-z"],
        check=True, capture_output=True,
    ).stdout


def run_sync(client: Path, generated: Path, manifest: Path) -> tuple[dict, str]:
    command = [
        sys.executable, str(REPO / "scripts/sync.py"),
        "--client-root", str(client),
        "--generated-root", str(generated),
        "--manifest", str(manifest),
        "--package", PACKAGE.as_posix(),
    ]
    for subpackage in SUBPACKAGES:
        command.extend(("--subpackage", subpackage))
    command.append("--check-determinism")
    result = subprocess.run(command, cwd=REPO, capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(
            "sync failed with exit {}\n{}\n{}".format(
                result.returncode, result.stdout, result.stderr))
    data = json.loads(manifest.read_text(encoding="utf-8"))
    if not data.get("ok"):
        raise AssertionError("sync returned zero but its manifest does not say ok")
    return data, result.stdout


def main() -> int:
    real_status_before = clean_status()
    real_source_before = file_map(CLEAN / "src" / PACKAGE, ".as")
    scratch = REPO / ".toolchain/m2"
    scratch.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="update-drill-", dir=scratch) as temp:
        temp_root = Path(temp)
        fixture = temp_root / "client"
        fixture_package = fixture / "src" / PACKAGE
        shutil.copytree(CLEAN / "src" / PACKAGE, fixture_package)
        fixture_before = file_map(fixture_package, ".as")
        if fixture_before != real_source_before:
            raise AssertionError("copied fixture does not match the authoritative package")

        baseline_out = temp_root / "baseline-hx"
        changed_out = temp_root / "changed-hx"
        baseline, _ = run_sync(fixture, baseline_out, temp_root / "baseline.json")

        target = fixture / "src" / TARGET_SOURCE
        source = target.read_text(encoding="utf-8-sig")
        needle = "    {\n    }"
        replacement = "    {\n        public static const UPDATE_DRILL_MARKER:int = 1;\n    }"
        if source.count(needle) != 1:
            raise AssertionError("IIDCore fixture shape drifted; expected one empty class body")
        target.write_text(source.replace(needle, replacement), encoding="utf-8", newline="\n")

        fixture_after = file_map(fixture_package, ".as")
        source_delta = sorted(
            set(fixture_before) | set(fixture_after),
            key=str.casefold,
        )
        source_delta = [
            name for name in source_delta
            if fixture_before.get(name) != fixture_after.get(name)
        ]
        expected_source = (Path("runtime") / "IIDCore.as").as_posix()
        if source_delta != [expected_source]:
            raise AssertionError("fixture source delta escaped its target: {}".format(source_delta))

        changed, _ = run_sync(fixture, changed_out, temp_root / "changed.json")
        baseline_files = file_map(baseline_out, ".hx")
        changed_files = file_map(changed_out, ".hx")
        generated_delta = sorted(
            name for name in set(baseline_files) | set(changed_files)
            if baseline_files.get(name) != changed_files.get(name)
        )
        if generated_delta != [TARGET_GENERATED]:
            raise AssertionError(
                "one source edit caused unrelated generated churn: {}".format(generated_delta))

        stable_manifest_sections = (
            "package", "subpackages", "scope", "tooling", "rules", "exceptions", "asset_inputs"
        )
        changed_sections = [
            section for section in stable_manifest_sections
            if baseline.get(section) != changed.get(section)
        ]
        if changed_sections:
            raise AssertionError(
                "unrelated manifest contracts changed: {}".format(changed_sections))
        for run in baseline["runs"] + changed["runs"]:
            if run["conversion"]["exit_code"] != 0 or run["unpinned_rules"]:
                raise AssertionError("a drill conversion was not fail-closed and successful")

        result = {
            "gate": "M2a-one-file-update-drill",
            "verified_utc": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
            "status": "pass",
            "scope": baseline["scope"],
            "fixture": "temporary copy of habbo-client-clean/src/com/sulake/core",
            "source_delta": [TARGET_SOURCE.as_posix()],
            "generated_delta": generated_delta,
            "generated_file_count": len(baseline_files),
            "baseline_generated_tree_sha256": baseline["generated_tree_sha256"],
            "changed_generated_tree_sha256": changed["generated_tree_sha256"],
            "both_runs_deterministic": baseline["deterministic"] and changed["deterministic"],
            "stable_manifest_sections": list(stable_manifest_sections),
            "real_clean_client": {
                "modified": False,
                "source_tree_unchanged": real_source_before == file_map(
                    CLEAN / "src" / PACKAGE, ".as"),
                "git_status_unchanged": real_status_before == clean_status(),
            },
        }
        if (result["real_clean_client"]["modified"]
                or not result["real_clean_client"]["source_tree_unchanged"]
                or not result["real_clean_client"]["git_status_unchanged"]):
            raise AssertionError("the authoritative clean client changed during the fixture drill")
        EVIDENCE.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")

    print(
        "M2_UPDATE_DRILL_PASS source={} generated={} files={}".format(
            TARGET_SOURCE.as_posix(), TARGET_GENERATED, result["generated_file_count"]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
