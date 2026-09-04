#!/usr/bin/env python3
"""Measure the remaining com.sulake.core migration surface for the M2 re-cost."""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
import hashlib
import json
from pathlib import Path
import re


CLIENT = Path(r"C:\habbo\client\habbo-client-clean")
SKYHAXE = Path(r"C:\habbo\client\SkyHaxe")

PATTERNS = {
    "embed": re.compile(r"\[Embed\b"),
    "dictionary": re.compile(r"\bDictionary\b"),
    "vector": re.compile(r"\bVector\.<"),
    "xml_or_xmllist": re.compile(r"\b(?:XML|XMLList)\b"),
    "proxy": re.compile(r"\bProxy\b|flash\.utils\.Proxy"),
    "namespace": re.compile(r"\bnamespace\b|::"),
    "reflection": re.compile(r"\b(?:describeType|getDefinitionByName|getQualifiedClassName|getQualifiedSuperclassName)\b"),
    "for_each": re.compile(r"\bfor\s+each\s*\("),
    "dynamic_star": re.compile(r"(?::|\bas\s+)\s*\*\b"),
    "flash_display": re.compile(r"\bflash\.display\."),
    "flash_events": re.compile(r"\bflash\.events\."),
    "flash_filters": re.compile(r"\bflash\.filters\."),
    "flash_geom": re.compile(r"\bflash\.geom\."),
    "flash_net": re.compile(r"\bflash\.net\."),
    "flash_sound": re.compile(r"\bflash\.media\."),
    "flash_text": re.compile(r"\bflash\.text\."),
    "flash_utils": re.compile(r"\bflash\.utils\."),
    "html_text": re.compile(r"\bhtmlText\b"),
    "mask": re.compile(r"\.mask\b|\bmask\s*="),
    "scroll": re.compile(r"\bscroll[HV]?\b|scrollRect|scrollV|scrollH", re.I),
    "filters": re.compile(r"\.filters\b|\bBitmapFilter\b"),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def as_functions(path: Path) -> set[str]:
    text = path.read_text(encoding="utf-8-sig", errors="replace")
    found = set()
    for accessor, name in re.findall(r"\bfunction\s+(?:(get|set)\s+)?([A-Za-z_$][\w$]*)\s*\(", text):
        if name == path.stem:
            found.add("new")
        else:
            found.add(f"{accessor}:{name}" if accessor else name)
    return found


def hx_functions(path: Path) -> set[str]:
    text = path.read_text(encoding="utf-8-sig", errors="replace")
    return set(re.findall(r"\bfunction\s+([A-Za-z_$][\w$]*)\s*\(", text))


def subsystem(relative: Path) -> str:
    return relative.parts[0] if len(relative.parts) > 1 else relative.stem


def stats(files: list[Path], root: Path) -> dict:
    per_subsystem: dict[str, dict] = defaultdict(lambda: {"files": 0, "source_lines": 0})
    feature_files: dict[str, list[str]] = defaultdict(list)
    feature_occurrences = Counter()
    total_lines = 0
    imports = Counter()
    internal_edges = Counter()
    subsystem_feature_files: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    kinds = Counter()
    line_bands = Counter()
    path_groups: dict[str, dict[str, int]] = defaultdict(lambda: {"files": 0, "source_lines": 0})
    low_risk_candidate_files = []
    high_risk_names = {
        "dictionary", "xml_or_xmllist", "proxy", "namespace", "reflection",
        "flash_display", "flash_filters", "flash_net", "flash_sound", "flash_text",
    }
    for path in files:
        relative = path.relative_to(root)
        rel = relative.as_posix()
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        lines = len(text.splitlines())
        total_lines += lines
        group = subsystem(relative)
        per_subsystem[group]["files"] += 1
        per_subsystem[group]["source_lines"] += lines
        second = relative.parts[1] if len(relative.parts) > 2 else "<root>"
        path_group = f"{group}/{second}"
        path_groups[path_group]["files"] += 1
        path_groups[path_group]["source_lines"] += lines
        if re.search(r"\bpublic\s+interface\b", text):
            kinds["interface"] += 1
        elif re.search(r"\bpublic\s+(?:final\s+)?class\b", text):
            kinds["class"] += 1
        else:
            kinds["other"] += 1
        if lines <= 80:
            line_bands["001-080"] += 1
        elif lines <= 160:
            line_bands["081-160"] += 1
        elif lines <= 320:
            line_bands["161-320"] += 1
        else:
            line_bands["321+"] += 1
        matched_features = {name for name, pattern in PATTERNS.items() if pattern.search(text)}
        if lines <= 100 and not (matched_features & high_risk_names):
            low_risk_candidate_files.append(rel)
        for name, pattern in PATTERNS.items():
            matches = pattern.findall(text)
            if matches:
                feature_files[name].append(rel)
                feature_occurrences[name] += len(matches)
                subsystem_feature_files[group][name] += 1
        for match in re.finditer(r"^\s*import\s+([\w.]+)", text, re.M):
            imported = match.group(1)
            prefix = imported.split(".")[0]
            imports[prefix] += 1
            core_prefix = "com.sulake.core."
            if imported.startswith(core_prefix):
                target = imported[len(core_prefix) :].split(".")[0]
                internal_edges[(group, target)] += 1
    return {
        "files": len(files),
        "source_lines": total_lines,
        "subsystems": dict(sorted(per_subsystem.items())),
        "path_groups": dict(sorted(path_groups.items())),
        "type_kinds": dict(sorted(kinds.items())),
        "line_bands": dict(sorted(line_bands.items())),
        "low_semantic_pressure_candidate_heuristic": {
            "definition": "<=100 lines and no Dictionary/XML/Proxy/namespace/reflection or Flash display/filter/net/sound/text use",
            "limitation": "This does not prove dependency-graph leaves; order candidates by measured internal dependencies before conversion.",
            "files": len(low_risk_candidate_files),
            "paths": low_risk_candidate_files,
        },
        "feature_file_counts": {name: len(feature_files[name]) for name in PATTERNS},
        "feature_occurrences": {name: feature_occurrences[name] for name in PATTERNS},
        "feature_files": {name: feature_files[name] for name in PATTERNS if feature_files[name]},
        "subsystem_feature_file_counts": {
            group: dict(sorted(counts.items()))
            for group, counts in sorted(subsystem_feature_files.items())
        },
        "import_roots": dict(imports.most_common()),
        "internal_import_edges": [
            {"from": source, "to": target, "imports": count}
            for (source, target), count in sorted(internal_edges.items())
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--client", type=Path, default=CLIENT)
    parser.add_argument("--skyhaxe", type=Path, default=SKYHAXE)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).with_name("m2_core_recost.json"),
    )
    args = parser.parse_args()
    source_root = args.client / "src" / "com" / "sulake" / "core"
    target_root = args.skyhaxe / "src" / "com" / "sulake" / "core"
    source_files = sorted(source_root.rglob("*.as"))
    target_files = sorted(target_root.rglob("*.hx"))
    source_rel = {path.relative_to(source_root).with_suffix("").as_posix() for path in source_files}
    target_rel = {path.relative_to(target_root).with_suffix("").as_posix() for path in target_files}
    direct_overlap = sorted(source_rel & target_rel)
    target_only = sorted(target_rel - source_rel)
    remaining = sorted(source_rel - target_rel)
    overlap_by_subsystem = Counter(path.split("/", 1)[0] for path in direct_overlap)
    remaining_by_subsystem = Counter(path.split("/", 1)[0] for path in remaining)
    overlap_surface = []
    for rel in direct_overlap:
        source_path = source_root / f"{rel}.as"
        target_path = target_root / f"{rel}.hx"
        source_functions = as_functions(source_path)
        target_functions = hx_functions(target_path)
        overlap_surface.append(
            {
                "class": rel,
                "source_lines": len(source_path.read_text(encoding="utf-8-sig", errors="replace").splitlines()),
                "haxe_lines": len(target_path.read_text(encoding="utf-8-sig", errors="replace").splitlines()),
                "source_declared_functions": len(source_functions),
                "haxe_declared_functions": len(target_functions),
                "source_function_names_absent_from_haxe": sorted(source_functions - target_functions),
            }
        )
    overlap_surface.sort(
        key=lambda item: len(item["source_function_names_absent_from_haxe"]), reverse=True
    )
    result = {
        "gate": "M2-core-recost",
        "client_root": str(args.client),
        "skyhaxe_root": str(args.skyhaxe),
        "source_tree": stats(source_files, source_root),
        "current_haxe": {
            "files": len(target_files),
            "direct_original_path_overlap": len(direct_overlap),
            "direct_overlap": direct_overlap,
            "direct_overlap_by_subsystem": dict(sorted(overlap_by_subsystem.items())),
            "skyhaxe_only_helpers": target_only,
            "remaining_original_identities": len(remaining),
            "remaining_by_subsystem": dict(sorted(remaining_by_subsystem.items())),
            "overlap_surface_heuristic": overlap_surface,
        },
        "anchors": {
            "client_core_tree_sha256": hashlib.sha256(
                "".join(f"{p.relative_to(source_root).as_posix()}:{sha256(p)}\n" for p in source_files).encode()
            ).hexdigest(),
            "skyhaxe_core_tree_sha256": hashlib.sha256(
                "".join(f"{p.relative_to(target_root).as_posix()}:{sha256(p)}\n" for p in target_files).encode()
            ).hexdigest(),
        },
    }
    assert len(source_files) == 353, len(source_files)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(
        "M2_CORE_RECOST_PASS "
        f"source={len(source_files)} overlap={len(direct_overlap)} remaining={len(remaining)}"
    )


if __name__ == "__main__":
    main()
