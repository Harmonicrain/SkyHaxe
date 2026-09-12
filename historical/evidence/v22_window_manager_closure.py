"""Measure the original window service above the V20/V21 candidate, without publishing it.

Includes the actual skin renderer, theme, resource manager and registered widget classes.
Existing HTML5 transport/asset seams are inherited, not replaced by new feature stubs.
"""
import importlib.util
import json
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")
OUT = Path(__file__).with_suffix(".json")
ROOTS = ["com/sulake/habbo/window/HabboWindowManagerComponent.as",
         "com/sulake/habbo/localization/HabboLocalizationManager.as",
         "com/sulake/core/localization/Localization.as"]


def main():
    spec = importlib.util.spec_from_file_location("walker", REPO / "scripts/generate-closure-context.py")
    walker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(walker)
    predecessors = [json.loads((REPO / f"evidence/{name}_closure.json").read_text())
                    for name in ("v20_infostand", "v21_window_runtime")]
    declared_seams = {key: value for batch in predecessors for key, value in batch.get("seams", {}).items()}
    retired = {path.lower() for batch in predecessors for path in batch.get("retired_exceptions", [])}
    retired.add("com/sulake/core/localization/localization.as")
    seams = {path for path in walker.seam_sources() | set(declared_seams) if path.lower() not in retired}
    seen = set(walker.context_for(ROOTS, seams)) | set(ROOTS)
    owned = {path.lower() for batch in predecessors for path in batch["closure"]}
    owned.update((path.relative_to(REPO / "generated").as_posix()[:-3] + ".as")
                 .replace("/_enum/", "/enum/").lower()
                 for path in (REPO / "generated").rglob("*.hx"))
    previous = set(json.loads(OUT.read_text())["closure"]) if OUT.exists() else set()
    closure = sorted({path for path in seen if path.lower() not in owned} | previous | set(ROOTS))
    payload = {
        "gate": "V22-original-window-manager", "roots": ROOTS,
        "closure": closure, "closure_files": len(closure),
        "closure_source_lines": sum(len((CLIENT / path).read_text(encoding="utf-8-sig").splitlines()) for path in closure),
        "context": sorted(seen - set(closure)), "seams": declared_seams,
        "predecessors": ["v20_infostand_closure.json", "v21_window_runtime_closure.json"],
        "retired_exceptions": ["com/sulake/core/localization/Localization.as"],
        "packages": dict(Counter("/".join(path.split("/")[:-1]) for path in closure).most_common()),
        "note": "Candidate only. Conversion/compilation does not mean the manager is initialized or the infostand is wired.",
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(f"V22 manager: {len(closure)} files / {payload['closure_source_lines']} lines; context {len(payload['context'])}")
    print(json.dumps(payload["packages"], indent=2))


if __name__ == "__main__":
    main()
