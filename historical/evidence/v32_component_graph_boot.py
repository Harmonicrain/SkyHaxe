"""Extend the deterministic v31 component graph with its original executable owner."""
import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
SOURCE = REPO / "evidence/v31_full_client_candidate_closure.json"
TARGET = REPO / "evidence/v32_component_graph_boot_closure.json"


def main() -> None:
    payload = json.loads(SOURCE.read_text(encoding="utf-8"))
    payload.update({
        "gate": "V32-browser-component-graph-boot",
        "source_scope": SOURCE.name,
        "state": "Original HabboMain executable graph; isolated until compile and browser boot pass.",
    })
    payload["roots"] = sorted(set(payload["roots"]) | {
        "HabboMain.as", "ClientEnum.as", "IHabboLoadingScreen.as",
    })
    payload["closure"] = sorted(set(payload["closure"]) | {
        "HabboMain.as", "ClientEnum.as", "IHabboLoadingScreen.as",
    })
    payload["closure_files"] = len(payload["closure"])
    payload["seams"]["Habbo.as"] = (
        "Flash MovieClip preloader/browser host; HTML supplies parameters, process logging and "
        "crash reporting while converted HabboMain owns the original component graph"
    )
    TARGET.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(json.dumps({"roots": len(payload["roots"]), "closure_files": len(payload["closure"])}))


if __name__ == "__main__":
    main()
