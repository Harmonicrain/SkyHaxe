#!/usr/bin/env python3
"""Measure the component runtime ownership boundary and record its Haxe contract."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


PATTERNS = {
    "iid_implementations": re.compile(r"\bimplements\s+IID\b"),
    "iid_constructions": re.compile(r"\bnew\s+IID[A-Za-z0-9_]*\s*\("),
    "component_dependency_constructions": re.compile(r"\bnew\s+ComponentDependency\s*\("),
    "component_subclasses": re.compile(r"\bextends\s+(?:[A-Za-z0-9_]+\.)?Component\b"),
    "queue_interface_occurrences": re.compile(r"\bqueueInterface\s*\("),
}


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
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_runtime_contract.json"),
    )
    args = parser.parse_args()

    files = sorted(args.client_src.rglob("*.as"))
    counts = {name: 0 for name in PATTERNS}
    files_by_pattern = {name: set() for name in PATTERNS}
    for path in files:
        relative = path.relative_to(args.client_src).as_posix()
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        for name, pattern in PATTERNS.items():
            matches = pattern.findall(text)
            if matches:
                counts[name] += len(matches)
                files_by_pattern[name].add(relative)

    manifest_files = sorted((args.client_src / "binaryData").glob("*_manifest.bin"))
    manifest_component_classes: list[str] = []
    manifest_iids: list[str] = []
    manifest_components_without_iids: list[str] = []
    for path in manifest_files:
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        component_blocks = re.findall(
            r"<component\b[^>]*\bclass=[\"']([^\"']+)[\"'][^>]*>(.*?)</component\s*>",
            text,
            flags=re.DOTALL | re.IGNORECASE,
        )
        for class_name, body in component_blocks:
            manifest_component_classes.append(class_name)
            iids = re.findall(
                r"<interface\b[^>]*\biid=[\"']([^\"']+)[\"']",
                body,
                flags=re.IGNORECASE,
            )
            manifest_iids.extend(iids)
            if not iids:
                manifest_components_without_iids.append(class_name)

    implementation = [
        args.skyhaxe / "src/com/sulake/core/runtime/IID.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/IUnknown.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/ComponentDependency.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/InterfaceStruct.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/InterfaceStructList.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/ComponentInterfaceQueue.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/ComponentManifest.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/ComponentDependencyLifecycle.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/ComponentInterfaceBroker.hx",
        args.skyhaxe / "test/G1dRuntimeTest.hx",
    ]
    result = {
        "gate": "G1d-component-runtime-primitives",
        "files_scanned": len(files),
        "lexical_counts": counts,
        "files_with_pattern": {
            name: len(paths) for name, paths in files_by_pattern.items()
        },
        "embedded_manifest_contract": {
            "manifest_files": len(manifest_files),
            "component_declarations": len(manifest_component_classes),
            "unique_component_classes": len(set(manifest_component_classes)),
            "interface_declarations": len(manifest_iids),
            "unique_iid_classes": len(set(manifest_iids)),
            "components_without_interfaces": manifest_components_without_iids,
        },
        "semantic_decisions": [
            "IID remains a marker interface; identity is the AS3-compatible qualified class name, not object identity",
            "InterfaceStruct reserve/release is explicit and release floors at zero",
            "InterfaceStructList preserves insertion order, duplicate providers, and implementor identity matching",
            "disposing an interface struct clears the record but does not dispose its implementor",
            "deferred interface receivers preserve AS3 registration order via unshift plus pop",
            "embedded manifest component and IID names resolve through the explicit DCE-safe DefinitionRegistry",
            "the Component dependency lifecycle is platform-neutral: required injection controls locking while optional injection may arrive later",
            "dependency disposal clears setters, detaches listeners, and releases each acquired interface exactly once",
            "the context broker queues unavailable interfaces by IID class name and fulfills receivers in registration order",
            "locked providers attach without announcing and explicitly announce all exported interfaces when unlocked",
            "detaching a provider removes all of its interface records without disposing the provider",
            "the final Component/ComponentContext OpenFL shell remains separate because it crosses assets, events, loaders, and configuration",
        ],
        "rewrite_rules": [
            "Vector.<InterfaceStruct> -> Array<InterfaceStruct> while preserving ordered traversal",
            "uint reference counters -> non-negative Int counters on Haxe targets",
            "getQualifiedClassName(iid) comparisons -> ClassUtils.getQualifiedClassName(iid)",
            "Function interface callbacks -> typed InterfaceReceiver",
            "Function dependency setters -> DependencySetter at the runtime boundary, with typed adapters at component call sites",
            "Component dependency injection -> ComponentDependencyLifecycle with explicit request and listener adapters",
            "ComponentContext interface routing -> ComponentInterfaceBroker attach/detach/announce operations",
        ],
        "haxe_sha256": {
            str(path.relative_to(args.skyhaxe)).replace("\\", "/"): sha256(path)
            for path in implementation
        },
        "verification": {"test_script": "scripts/test-g1d-runtime.ps1"},
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
