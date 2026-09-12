#!/usr/bin/env python3
"""Reproduce the preserved SkyHaxe v32/v33 generated composition in isolation."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


REPO = Path(__file__).resolve().parents[2]
SUPPORT = Path(__file__).resolve().parent
CONFIG_PATH = SUPPORT / "composition.json"
OPENFL_SOURCE = REPO / ".haxelib/openfl/9,5,2/src"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def file_manifest(root: Path) -> dict:
    files = []
    total = 0
    digest = hashlib.sha256()
    paths = sorted((path for path in root.rglob("*") if path.is_file()),
                   key=lambda path: path.relative_to(root).as_posix().lower())
    for path in paths:
        relative = path.relative_to(root).as_posix()
        size = path.stat().st_size
        file_hash = sha256_file(path)
        total += size
        digest.update(relative.encode("utf-8"))
        digest.update(b"\0")
        digest.update(bytes.fromhex(file_hash))
        files.append({"path": relative, "size": size, "sha256": file_hash})
    return {
        "file_count": len(files),
        "total_bytes": total,
        "aggregate_sha256": digest.hexdigest(),
        "files": files,
    }


def resolve_input(value: str) -> Path:
    if value.startswith("${"):
        end = value.find("}")
        if end < 0:
            raise RuntimeError(f"invalid environment path: {value}")
        variable = value[2:end]
        root = os.environ.get(variable)
        if not root:
            raise RuntimeError(f"set {variable} to resolve pinned input {value}")
        value = root + value[end + 1:]
    path = Path(value)
    return path if path.is_absolute() else REPO / path


def check_hash(path: Path, expected: str, label: str) -> None:
    if not path.is_file():
        raise RuntimeError(f"missing {label}: {path}")
    actual = sha256_file(path)
    if actual.lower() != expected.lower():
        raise RuntimeError(f"{label} hash changed: {path}\nexpected {expected}\nactual   {actual}")


def run(command: list[str], cwd: Path | None = None) -> None:
    print("+", subprocess.list2cmdline(command), flush=True)
    result = subprocess.run(command, cwd=cwd)
    if result.returncode:
        raise RuntimeError(f"command failed with exit code {result.returncode}")


def apply_patch(root: Path, patch: Path) -> None:
    common = ["git", "-c", "core.autocrlf=false", "apply", "--whitespace=nowarn"]
    run(common + ["--check", str(patch)], cwd=root)
    run(common + [str(patch)], cwd=root)


def compare_files(left: dict, right: dict) -> dict:
    left_files = {item["path"]: item for item in left["files"]}
    right_files = {item["path"]: item for item in right["files"]}
    missing = sorted(set(right_files) - set(left_files), key=str.lower)
    extra = sorted(set(left_files) - set(right_files), key=str.lower)
    changed = sorted(
        path for path in set(left_files) & set(right_files)
        if left_files[path]["sha256"] != right_files[path]["sha256"]
        or left_files[path]["size"] != right_files[path]["size"]
    )
    return {"identical": not (missing or extra or changed),
            "missing": missing, "extra": extra, "changed": changed}


def expected_baseline(config: dict) -> dict:
    manifest_path = resolve_input(config["baseline_manifest"])
    if not manifest_path.is_file():
        raise RuntimeError(f"preserved baseline manifest is missing: {manifest_path}")
    payload = json.loads(manifest_path.read_text(encoding="utf-8"))
    roots = payload["roots"]
    return {
        "generated": roots[".toolchain/v32/generated"],
        "platform": roots[".toolchain/v32/platform"],
        "compat": roots[".toolchain/ax3/compat"],
    }


def validate_inputs(config: dict, client_root: Path) -> dict:
    for item in config["tracked_inputs"] + config["binary_inputs"]:
        check_hash(resolve_input(item["path"]), item["sha256"], "pinned input")
    for batch in config["conversion_batches"]:
        check_hash(REPO / batch["closure"], batch["closure_sha256"], "closure")
    for section in ("post_generation_patch", "platform_patch"):
        item = config[section]
        check_hash(REPO / item["path"], item["sha256"], section)
    result = subprocess.run(["git", "-C", str(client_root), "rev-parse", "HEAD"],
                            text=True, capture_output=True, check=True)
    commit = result.stdout.strip()
    if commit != config["authoritative_as3"]["commit"]:
        raise RuntimeError(f"authoritative AS3 commit changed: expected "
                           f"{config['authoritative_as3']['commit']}, got {commit}")
    return {"client_root": str(client_root), "client_commit": commit}


def build_platform(config: dict, generated: Path, destination: Path) -> None:
    platform = config["platform_patch"]
    for item in platform["generated_bases"]:
        source = generated / item["path"]
        check_hash(source, item["sha256"], "generated platform base")
        target = destination / item["path"]
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)
    for item in platform["openfl_bases"]:
        source = OPENFL_SOURCE / item["path"]
        check_hash(source, item["sha256"], "OpenFL platform base")
        target = destination / item["path"]
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)
    apply_patch(destination, REPO / platform["path"])


def assert_expected(name: str, actual: dict, expected: dict) -> None:
    for key in ("file_count", "total_bytes", "aggregate_sha256"):
        if actual[key] != expected[key]:
            raise RuntimeError(f"{name} {key} differs: expected {expected[key]}, got {actual[key]}")


def reproduce_once(config: dict, client_root: Path, run_root: Path,
                   baseline: dict) -> dict:
    if run_root.exists():
        raise RuntimeError(f"isolated run directory already exists: {run_root}")
    run_root.mkdir(parents=True)
    generated = run_root / "generated"
    generated.mkdir()

    sync_manifests = []
    for batch in config["conversion_batches"]:
        workspace = run_root / ("workspace-" + batch["name"])
        manifest = run_root / (batch["name"] + "-sync.json")
        command = [
            sys.executable, str(SUPPORT / "sync.py"),
            "--client-root", str(client_root),
            "--closure", str(REPO / batch["closure"]),
            "--generated-root", str(generated),
            "--workspace-root", str(workspace),
            "--manifest", str(manifest),
            "--check-determinism",
        ]
        run(command, cwd=REPO)
        sync = json.loads(manifest.read_text(encoding="utf-8"))
        if not sync.get("ok") or not sync.get("published") or sync.get("deterministic") is not True:
            raise RuntimeError(f"conversion gate failed for {batch['name']}")
        if sync["runs"][0]["generated_files"] != batch["source_files"]:
            raise RuntimeError(f"unexpected source count for {batch['name']}")
        sync_manifests.append({"batch": batch["name"], "path": manifest.name,
                               "sha256": sha256_file(manifest)})

    apply_patch(generated, REPO / config["post_generation_patch"]["path"])
    platform = run_root / "platform"
    platform.mkdir()
    build_platform(config, generated, platform)
    compat = run_root / "compat"
    shutil.copytree(REPO / config["compatibility_source"], compat)

    trees = {name: file_manifest(path) for name, path in
             (("generated", generated), ("platform", platform), ("compat", compat))}
    comparisons = {}
    for name, tree in trees.items():
        assert_expected(name, tree, config["expected_trees"][name])
        comparison = compare_files(tree, baseline[name])
        if not comparison["identical"]:
            raise RuntimeError(f"{name} differs from preserved working baseline: {comparison}")
        comparisons[name] = comparison

    manifest_payload = {
        "schema": 1,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "run_root": str(run_root),
        "sync_manifests": sync_manifests,
        "trees": trees,
        "baseline_comparison": comparisons,
    }
    output = run_root / "FINAL-MANIFEST.json"
    output.write_text(json.dumps(manifest_payload, indent=2) + "\n", encoding="utf-8", newline="\n")
    return manifest_payload


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-root", type=Path, required=True,
                        help="new external directory that will contain all isolated runs")
    parser.add_argument("--client-root", type=Path)
    parser.add_argument("--runs", type=int, default=2)
    args = parser.parse_args()
    config = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    configured_root = config["authoritative_as3"].get("default_root")
    root_value = args.client_root or os.environ.get("SKYHAXE_SOURCE_ROOT") or configured_root
    if not root_value:
        raise RuntimeError("pass --client-root or set SKYHAXE_SOURCE_ROOT")
    client_root = Path(root_value).resolve()
    outer = args.run_root.resolve()
    try:
        outer.relative_to(REPO.resolve())
        raise RuntimeError("run root must be outside the SkyHaxe repository")
    except ValueError:
        pass
    if outer.exists():
        raise RuntimeError(f"run root must not already exist: {outer}")
    if args.runs < 2:
        raise RuntimeError("at least two isolated runs are required")

    inputs = validate_inputs(config, client_root)
    baseline = expected_baseline(config)
    outer.mkdir(parents=True)
    completed = []
    for index in range(args.runs):
        completed.append(reproduce_once(config, client_root, outer / f"run-{index + 1}", baseline))

    run_comparisons = {}
    first = completed[0]["trees"]
    for index, candidate in enumerate(completed[1:], start=2):
        comparison = {name: compare_files(candidate["trees"][name], first[name])
                      for name in first}
        if not all(item["identical"] for item in comparison.values()):
            raise RuntimeError(f"isolated run {index} differs from run 1: {comparison}")
        run_comparisons[f"run-1-vs-run-{index}"] = comparison

    final = {
        "schema": 1,
        "gate": "SkyHaxe-v32-reproducible-working-generated-client",
        "ok": True,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "composition_sha256": sha256_file(CONFIG_PATH),
        "inputs": inputs,
        "run_root": str(outer),
        "runs": args.runs,
        "run_comparisons": run_comparisons,
        "preserved_baseline_manifest": config["baseline_manifest"],
        "baseline_comparison": completed[0]["baseline_comparison"],
        "trees": {name: {key: value for key, value in tree.items() if key != "files"}
                  for name, tree in first.items()},
        "differences_from_working_baseline": [],
    }
    (outer / "REPRODUCIBILITY-MANIFEST.json").write_text(
        json.dumps(final, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(json.dumps(final, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, RuntimeError, subprocess.CalledProcessError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        raise SystemExit(1)
