"""Measure the original room desktop/widget owners above the compiled window foundation.

No files are converted or promoted by this inventory. Reachable UI stays in scope; this does
not prune other widgets out of RoomDesktop or introduce a handwritten widget bus.
"""
import importlib.util
import json
from collections import Counter
from collections import deque
from functools import lru_cache
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")
ROOTS = ["com/sulake/habbo/ui/RoomDesktop.as", "com/sulake/habbo/ui/RoomUI.as",
         "com/sulake/habbo/ui/widget/RoomWidgetFactory.as"]


def main():
    spec = importlib.util.spec_from_file_location("walker", REPO / "scripts/generate-closure-context.py")
    walker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(walker)
    # Source is read-only during this inventory. Reuse the parsed reference graph across roots.
    walker.references = lru_cache(maxsize=None)(walker.references)
    names = ["v20_infostand", "v21_window_runtime", "v22_window_manager"]
    predecessors = [json.loads((REPO / f"evidence/{name}_closure.json").read_text()) for name in names]
    declared = {key: value for batch in predecessors for key, value in batch.get("seams", {}).items()}
    retired = {path.lower() for batch in predecessors for path in batch.get("retired_exceptions", [])}
    seams = {path for path in walker.seam_sources() | set(declared) if path.lower() not in retired}
    owned = {path.lower() for batch in predecessors for path in batch["closure"]}
    owned.update((path.relative_to(REPO / "generated").as_posix()[:-3] + ".as")
                 .replace("/_enum/", "/enum/").lower() for path in (REPO / "generated").rglob("*.hx"))
    seen = set(walker.context_for(ROOTS, seams)) | set(ROOTS)
    closure = sorted(path for path in seen if path.lower() not in owned)
    parent = {root: None for root in ROOTS}
    queue = deque(ROOTS)
    while queue:
        path = queue.popleft()
        for reference in sorted(walker.references(path)):
            child = reference + ".as"
            if child not in seen or child in parent:
                continue
            parent[child] = path
            queue.append(child)
    chains = {}
    for prefix in ("org/", "deng/", "com/hurlant/", "com/sulake/habbo/navigator/"):
        candidates = [path for path in closure if path.startswith(prefix)]
        paths = []
        for path in candidates:
            chain = []
            while path is not None:
                chain.append(path)
                path = parent.get(path)
            paths.append(list(reversed(chain)))
        if paths:
            chains[prefix] = min(paths, key=lambda chain: (len(chain), chain))
    per_root = {}
    for root in ROOTS:
        root_seen = set(walker.context_for([root], seams)) | {root}
        per_root[root] = sum(path.lower() not in owned for path in root_seen)
    result = {
        "gate": "V23-original-room-ui", "roots": ROOTS, "closure": closure,
        "closure_files": len(closure),
        "closure_source_lines": sum(len((CLIENT / path).read_text(encoding="utf-8-sig").splitlines()) for path in closure),
        "context": sorted(seen - set(closure)), "seams": declared,
        "predecessors": [name + "_closure.json" for name in names],
        "packages": dict(Counter("/".join(path.split("/")[:-1]) for path in closure).most_common()),
        "state": "measured, not converted or compiled",
        "additional_files_by_root": per_root,
        "dependency_chains": chains,
        "note": "Original desktop/widget bus dependency batch. No handwritten widget-owner substitute and no new product exclusions.",
    }
    Path(__file__).with_suffix(".json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(f"V23 room UI: {len(closure)} additional files / {result['closure_source_lines']} source lines")
    print(json.dumps(dict(list(result["packages"].items())[:12]), indent=2))


if __name__ == "__main__":
    main()
