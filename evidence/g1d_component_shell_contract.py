#!/usr/bin/env python3
"""Measure Component/ComponentContext topology and record the OpenFL shell contract."""

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
    parser.add_argument("--client-src", type=Path, default=Path(r"C:\habbo\client\habbo-client-clean\src"))
    parser.add_argument("--skyhaxe", type=Path, default=Path(r"C:\habbo\client\SkyHaxe"))
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(r"C:\habbo\client\SkyHaxe\evidence\g1d_component_shell_contract.json"),
    )
    args = parser.parse_args()

    files = sorted(args.client_src.rglob("*.as"))
    corpus = "\n".join(path.read_text(encoding="utf-8-sig", errors="replace") for path in files)
    implementation = [
        args.skyhaxe / "src/com/sulake/core/runtime/IContext.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/Component.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/ComponentContext.hx",
        args.skyhaxe / "src/com/sulake/core/runtime/ComponentDependencyLifecycle.hx",
        args.skyhaxe / "test/G1dComponentShellTest.hx",
        args.skyhaxe / "test/G1dComponentShellBrowserMain.hx",
        args.skyhaxe / "project.g1d-component-shell.xml",
    ]
    result = {
        "gate": "G1d-component-shell",
        "source_contract": {
            "component_subclasses": len(re.findall(r"\bextends\s+(?:[A-Za-z0-9_]+\.)?Component\b", corpus)),
            "component_context_subclasses": len(re.findall(r"\bextends\s+ComponentContext\b", corpus)),
            "direct_component_context_constructions": len(re.findall(r"\bnew\s+ComponentContext\s*\(", corpus)),
            "queue_interface_occurrences": len(re.findall(r"\bqueueInterface\s*\(", corpus)),
            "component_dependency_constructions": len(re.findall(r"\bnew\s+ComponentDependency\s*\(", corpus)),
            "topology": "CoreComponentContext is the sole ComponentContext subclass and is self-rooted",
        },
        "semantic_decisions": [
            "OpenFL EventDispatcher is the real event surface; no event stub is introduced",
            "each Component owns an AssetLibrary unless one is supplied explicitly",
            "required dependencies lock initialization and announce exported interfaces only after unlock",
            "ComponentContext owns attached components and disposes them with the root context",
            "COMPONENT_FLAG_INTERFACE detaches and disposes a provider when its final interface reference is released",
            "direct component disposal detaches it from the context",
            "late delivery to a disposed dependency waiter immediately releases the already-acquired interface",
        ],
        "rewrite_rules": [
            "AS3 Component dependency getter -> overridable getDependencies():Array<ComponentDependency>",
            "EventDispatcherWrapper boundary -> OpenFL EventDispatcher for the HTML5-first shell",
            "Component requiredDependencyIids -> InterfaceStructList",
            "ComponentContext attach/detach/queue -> ComponentInterfaceBroker",
            "Core self-context constructor -> nullable parent only for COMPONENT_FLAG_CONTEXT, then self-root assignment",
        ],
        "haxe_sha256": {
            str(path.relative_to(args.skyhaxe)).replace("\\", "/"): sha256(path)
            for path in implementation
        },
        "verification": {
            "test_script": "scripts/test-g1d-component-shell.ps1",
            "expected_dom_marker": "data-skyhaxe-g1d-component-shell=pass",
            "lower_runtime_verifier": "scripts/verify-g1d-runtime.ps1",
        },
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
