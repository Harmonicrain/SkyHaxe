"""Measure the original room-session owner required by the live original Room UI."""
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
    previous_names = ("v20_infostand", "v21_window_runtime", "v22_window_manager",
                      "v24_infostand_profile", "v25_infostand_services")
    previous = [json.loads((REPO / "evidence" / (name + "_closure.json")).read_text())
                for name in previous_names]
    declared = {key: value for batch in previous for key, value in batch.get("seams", {}).items()}
    retired = {p.lower() for batch in previous for p in batch.get("retired_exceptions", [])}
    seams = {p for p in walker.seam_sources() | set(declared) if p.lower() not in retired}
    owned = {p.lower() for batch in previous for p in batch["closure"]}
    owned.update((p.relative_to(REPO / "generated").as_posix()[:-3] + ".as")
                 .replace("/_enum/", "/enum/").lower()
                 for p in (REPO / "generated").rglob("*.hx"))
    roots = ["com/sulake/habbo/session/RoomSessionManager.as"]
    seen = set(walker.context_for(roots, seams)) | set(roots)
    closure = sorted(p for p in seen if p.lower() not in owned)
    result = {
        "gate": "V26-live-infostand-room-session",
        "roots": roots,
        "closure": closure,
        "context": sorted(seen - set(closure)),
        "seams": declared,
        "closure_files": len(closure),
        "state": "Inventory only; consult sync/build evidence for conversion status.",
        "note": "Original room-session lifecycle and outgoing interaction messages; no inert room-session host."
    }
    Path(__file__).with_name("v26_room_session_services_closure.json").write_text(
        json.dumps(result, indent=2) + "\n")
    print(json.dumps({"additional_files": len(closure), "files": closure}, indent=2))


if __name__ == "__main__":
    main()
