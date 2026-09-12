"""Measure the original friend-list component required by avatar Infostands."""
import importlib.util
import json
from functools import lru_cache
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]


def main():
    spec = importlib.util.spec_from_file_location(
        "walker", REPO / "scripts/generate-closure-context.py")
    walker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(walker)
    walker.references = lru_cache(maxsize=None)(walker.references)
    previous_names = (
        "v20_infostand", "v21_window_runtime", "v22_window_manager",
        "v24_infostand_profile", "v25_infostand_services",
        "v26_room_session_services",
    )
    previous = [
        json.loads((REPO / "evidence" / (name + "_closure.json")).read_text())
        for name in previous_names
    ]
    declared = {
        key: value
        for batch in previous
        for key, value in batch.get("seams", {}).items()
    }
    retired = {
        path.lower()
        for batch in previous
        for path in batch.get("retired_exceptions", [])
    }
    seams = {
        path for path in walker.seam_sources() | set(declared)
        if path.lower() not in retired
    }
    owned = {
        path.lower() for batch in previous for path in batch["closure"]
    }
    owned.update(
        (path.relative_to(REPO / "generated").as_posix()[:-3] + ".as")
        .replace("/_enum/", "/enum/").lower()
        for path in (REPO / "generated").rglob("*.hx")
    )
    roots = ["com/sulake/habbo/friendlist/HabboFriendList.as"]
    seen = set(walker.context_for(roots, seams)) | set(roots)
    closure = sorted(path for path in seen if path.lower() not in owned)
    result = {
        "gate": "V27-live-avatar-infostand-friend-list",
        "roots": roots,
        "closure": closure,
        "context": sorted(seen - set(closure)),
        "seams": declared,
        "closure_files": len(closure),
        "state": "Inventory only; consult sync/build evidence for conversion status.",
        "note": (
            "Original friend-list data, packet handlers and UI owner required by avatar "
            "Infostands; no null-service substitute."
        ),
    }
    Path(__file__).with_name("v27_friend_list_services_closure.json").write_text(
        json.dumps(result, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(json.dumps({"additional_files": len(closure), "files": closure}, indent=2))


if __name__ == "__main__":
    main()
