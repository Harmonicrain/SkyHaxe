#!/usr/bin/env python3
"""Measure the original window runtime needed to retire SkyHaxe's early demo window seams.

The infostand compile gate requires the complete IWindow contract. These five roots are the
hand-written Phase-2 placeholders explicitly marked "must become converter output" in the
exception manifest; their dependencies form the smallest honest generated replacement.
"""
from __future__ import annotations

import importlib.util
import json
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")
OUT = Path(__file__).with_suffix(".json")

ROOTS = [
    "com/sulake/core/window/IWindow.as",
    "com/sulake/core/window/WindowController.as",
    "com/sulake/core/window/enum/WindowParam.as",
    "com/sulake/core/window/utils/ParamCodeTable.as",
    "com/sulake/core/window/utils/WindowParser.as",
]


def load_walker():
    path = REPO / "scripts/generate-closure-context.py"
    spec = importlib.util.spec_from_file_location("closure_context", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def generated_source_paths() -> set[str]:
    result = set()
    for path in (REPO / "generated").rglob("*.hx"):
        relative = path.relative_to(REPO / "generated").as_posix()
        result.add((relative[:-3] + ".as").replace("/_enum/", "/enum/").lower())
    return result


def main() -> int:
    walker = load_walker()
    # These roots are deliberately replacing their same-name temporary Haxe seams now.
    seams = {path.lower() for path in walker.seam_sources() - set(ROOTS)}
    seams.add("com/sulake/core/utils/map.as")
    seen: set[str] = set()
    queue = list(ROOTS)
    while queue:
        relative = queue.pop()
        if relative in seen or relative.lower() in seams or not (CLIENT / relative).is_file():
            continue
        seen.add(relative)
        for reference in walker.references(relative):
            if reference.startswith(walker.SKIP_ROOTS):
                continue
            candidate = reference + ".as"
            if (CLIENT / candidate).is_file():
                queue.append(candidate)

    previous = set(json.loads(OUT.read_text(encoding="utf-8"))["closure"]) if OUT.is_file() else set()
    generated = generated_source_paths()
    closure = sorted(path for path in (
        {path for path in seen if path.lower() not in generated} | previous | set(ROOTS))
        if path.lower() not in seams)
    lines = sum(len((CLIENT / path).read_text(
        encoding="utf-8-sig", errors="replace").splitlines()) for path in closure)
    packages = Counter("/".join(path.split("/")[:-1]) for path in closure)
    payload = {
        "gate": "V21-generated-window-runtime",
        "roots": ROOTS,
        "closure_files": len(closure),
        "closure_source_lines": lines,
        "closure": closure,
        "packages": dict(packages.most_common()),
        "retired_exceptions": ROOTS,
        "seams": {"com/sulake/core/utils/Map.as": "Existing tested Flash Proxy adapter"},
        "note": "Generated replacement for the early partial window contracts blocking V20.",
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"Window runtime closure: {len(closure)} files / {lines} lines")
    print(f"Full transitive closure excluding remaining seams: {len(seen)} files")
    for package, count in packages.most_common(20):
        print(f"  {count:3} {package}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
