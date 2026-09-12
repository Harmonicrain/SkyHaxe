"""Measure an explicit original-widget build slice independently of the full V23 batch."""
import importlib.util
import json
from functools import lru_cache
from pathlib import Path
import sys

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "scripts"))
import widget_build_profile as profile


def main():
    spec = importlib.util.spec_from_file_location("walker", REPO / "scripts/generate-closure-context.py")
    walker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(walker)
    original_refs = walker.references
    records = {}

    @lru_cache(maxsize=None)
    def refs(relative):
        text = (walker.CLIENT / relative).read_text(encoding="utf-8-sig")
        projected, record = profile.project(relative, text)
        if record: records[relative] = record
        return original_refs(relative, projected)

    walker.references = refs
    full = json.loads((REPO / "evidence/v23_room_ui_closure.json").read_text())
    roots = full["roots"]
    seams = walker.seam_sources() | set(full["seams"])
    owned = set(full["context"])
    seen = set(walker.context_for(roots, seams)) | set(roots)
    closure = sorted(seen - owned)
    result = dict(full, gate="V24-original-infostand-profile", closure=closure,
                  context=sorted(seen - set(closure)), closure_files=len(closure),
                  source_profile="infostand", state="measured, not converted or compiled")
    for key in ("packages", "additional_files_by_root", "dependency_chains", "closure_source_lines"):
        result.pop(key, None)
    result["note"] = "Explicit Infostand/avatar-info factory profile; original desktop routing and enabled case bodies retained. Full V23 batch unchanged."
    (REPO / "evidence/v24_infostand_profile_closure.json").write_text(json.dumps(result, indent=2) + "\n")
    profile.MANIFEST.write_text(json.dumps({"profile": "infostand", "enabled_widgets": sorted(profile.ENABLED),
                                          "owners": records}, indent=2) + "\n")
    print(json.dumps({"additional_files": len(closure), "typing_context": len(result["context"]),
                      "video_dependencies": [p for p in closure if p.startswith(("org/", "com/vimeo/", "deng/"))]}, indent=2))


if __name__ == "__main__":
    main()
