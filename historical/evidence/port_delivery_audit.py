"""Reproducible source inventory and current delivery-gate evidence, not runtime coverage."""
import json
from pathlib import Path
import re

REPO = Path(__file__).resolve().parents[1]


def inventory(root):
    files = list(root.rglob("*.hx"))
    return {"files": len(files), "lines": sum(len(path.read_text(
        encoding="utf-8-sig").splitlines()) for path in files)}


def identities(root):
    found = {}
    for path in root.rglob("*.hx"):
        if path.name == "import.hx":
            continue
        text = path.read_text(encoding="utf-8-sig")
        package = re.search(r"\bpackage\s+([\w.]+)", text)
        found[(package.group(1) + "." if package else "") + path.stem] = \
            path.relative_to(REPO).as_posix()
    return found


def main():
    source, generated = identities(REPO / "src"), identities(REPO / "generated")
    candidates = identities(REPO / ".toolchain/v21/generated")
    result = {
        "date": "2026-09-05",
        "scope": "Local source inventory; counts are not percentage of features working.",
        "src": inventory(REPO / "src"), "generated": inventory(REPO / "generated"),
        "window_candidate": inventory(REPO / ".toolchain/v21/generated"),
        "published_identity_collisions": {identity: [source[identity], generated[identity]]
                                         for identity in sorted(source.keys() & generated.keys())},
        "candidate_identity_collisions": {identity: [source[identity], candidates[identity]]
                                         for identity in sorted(source.keys() & candidates.keys())},
        "gates": {},
    }
    for name, log in {"concrete_windows": ".toolchain/v21-compile.log",
                      "all_generated": ".toolchain/compile-all.log"}.items():
        path = REPO / log
        diagnostics = [line for line in path.read_text(encoding="utf-8").splitlines()
                       if re.search(r"\.hx:\d+:.* : ", line) and " : ..." not in line
                       and "Warning" not in line] if path.exists() else []
        result["gates"][name] = {"log": log, "primary_diagnostics": diagnostics,
                                   "note": "No runtime claim. Compiler may stop before all errors."}
    for name in ("v20_infostand_sync", "v21_window_runtime_sync", "v22_window_manager_sync", "v7_guest_room_sync"):
        payload = json.loads((REPO / f"evidence/{name}.json").read_text())
        result["gates"][name] = {key: payload.get(key) for key in
                                ("ok", "published", "deterministic", "generated_tree_sha256")}
    for name in ("shadow_verification", "window_graphics_verification", "font_coverage_verification",
                 "window_selection_verification", "window_thickness_verification", "v21_converter_regression",
                 "embedded_verification", "window_host_verification", "window_asset_verification",
                 "window_runtime_verification"):
        payload = json.loads((REPO / f"evidence/{name}.json").read_text(encoding="utf-8-sig"))
        result["gates"][name] = payload
    output = Path(__file__).with_suffix(".json")
    output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: result[key] for key in ("src", "generated", "window_candidate")}, indent=2))
    print("Candidate collisions:", list(result["candidate_identity_collisions"]))
    print("Gate diagnostics:", {name: len(gate.get("primary_diagnostics", []))
                               for name, gate in result["gates"].items() if "log" in gate})


if __name__ == "__main__":
    main()
