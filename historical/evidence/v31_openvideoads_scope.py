"""Derive the fast OpenVideoAds converter canary from the authoritative full scope."""
import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]


def main() -> None:
    source = json.loads((REPO / "evidence/v31_full_client_candidate_closure.json").read_text(encoding="utf-8"))
    closure = [path for path in source["closure"] if path.startswith("org/openvideoads/")]
    payload = {
        "gate": "V31-openvideoads-converter-canary",
        "closure": closure,
        "context": [],
        "source_scope": "evidence/v31_full_client_candidate_closure.json",
        "note": "Fast converter canary for the original VAST model/runtime. Browser playback remains a later narrow media boundary.",
    }
    (REPO / "evidence/v31_openvideoads_closure.json").write_text(
        json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n"
    )
    print("OpenVideoAds canary files:", len(closure))


if __name__ == "__main__":
    main()
