"""Measure the real session-data owner required by the live original Infostand."""
import importlib.util
import json
from functools import lru_cache
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]


def main():
    spec = importlib.util.spec_from_file_location("walker", REPO / "scripts/generate-closure-context.py")
    walker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(walker)
    walker.references = lru_cache(maxsize=None)(walker.references)
    previous = [json.loads((REPO / "evidence" / (name + "_closure.json")).read_text())
                for name in ("v20_infostand", "v21_window_runtime", "v22_window_manager", "v24_infostand_profile")]
    declared = {key: value for batch in previous for key, value in batch.get("seams", {}).items()}
    retired = {p.lower() for batch in previous for p in batch.get("retired_exceptions", [])}
    seams = {p for p in walker.seam_sources() | set(declared) if p.lower() not in retired}
    owned = {p.lower() for batch in previous for p in batch["closure"]}
    owned.update((p.relative_to(REPO / "generated").as_posix()[:-3] + ".as").replace("/_enum/", "/enum/").lower()
                 for p in (REPO / "generated").rglob("*.hx"))
    roots = ["com/sulake/habbo/session/SessionDataManager.as"]
    seen = set(walker.context_for(roots, seams)) | set(roots)
    closure = sorted(p for p in seen if p.lower() not in owned)
    # Refresh two already-published parsers whose Array.slice() output predates the shared
    # zero-argument slice fix. Keeping them in this candidate avoids editing old generated files.
    closure = sorted(set(closure) | {
        "com/sulake/habbo/communication/messages/parser/users/IgnoredUsersMessageParser.as",
        "com/sulake/habbo/communication/messages/parser/users/_Str_9277.as",
    })
    result = {"gate": "V25-live-infostand-session-data", "roots": roots, "closure": closure,
              "context": sorted(seen - set(closure)), "seams": declared, "closure_files": len(closure),
              "state": "Inventory only; consult sync/build evidence for conversion status.",
              "note": "Original identity, permissions and furniture metadata; no handwritten session-data replacement."}
    Path(__file__).with_name("v25_infostand_services_closure.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({"additional_files": len(closure), "files": closure}, indent=2))


if __name__ == "__main__":
    main()
