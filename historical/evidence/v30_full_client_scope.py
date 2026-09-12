"""Build the explicit browser-client source scope from HabboMain's component graph."""
import importlib.util
import json
from functools import lru_cache
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")

# Exact component/library owners prepared by HabboMain. Root-package references are not imports,
# so they are listed explicitly rather than guessed by the dependency walker.
ROOTS = [
    "CoreCommunicationFrameworkLib.as", "HabboRoomObjectLogicLib.as",
    "HabboRoomObjectVisualizationLib.as", "RoomManagerLib.as", "RoomSpriteRendererLib.as",
    "HabboRoomSessionManagerLib.as", "HabboAvatarRenderLib.as", "HabboSessionDataManagerLib.as",
    "HabboConfigurationCom.as", "HabboLocalizationCom.as", "HabboWindowManagerCom.as",
    "HabboCommunicationCom.as", "HabboCommunicationDemoCom.as", "HabboNavigatorCom.as",
    "HabboFriendListCom.as", "HabboMessengerCom.as", "HabboInventoryCom.as", "HabboToolbarCom.as",
    "HabboCatalogCom.as", "HabboRoomEngineCom.as", "HabboRoomUICom.as", "HabboAvatarEditorCom.as",
    "HabboNotificationsCom.as", "HabboHelpCom.as", "HabboAdManagerCom.as", "HabboModerationCom.as",
    "HabboUserDefinedRoomEventsCom.as", "HabboSoundManagerFlash10Com.as", "HabboQuestEngineCom.as",
    "HabboFriendBarCom.as", "HabboGroupsCom.as", "HabboGamesCom.as", "HabboFreeFlowChatCom.as",
    "HabboNewNavigatorCom.as", "HabboTrackingLib.as",
]

# These are not product-feature substitutes. They are either Flash/AIR launch infrastructure or
# retired third-party runtimes whose browser replacement is an explicit platform boundary.
EXCLUDED_PREFIXES = {
    "splash/": "Flash preloader artwork/code; HTML boot owns this lifecycle",
    "onBoardingHc/": "separate Flash onboarding movie loaded outside the main component graph",
    "onBoardingHcSteps/": "separate Flash onboarding movie assets",
    "onBoardingHcUi/": "separate Flash onboarding movie UI",
}


def main():
    spec = importlib.util.spec_from_file_location("walker", REPO / "scripts/generate-closure-context.py")
    walker = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(walker)
    walker.references = lru_cache(maxsize=None)(walker.references)
    # Only deliberate browser/VM boundaries are seams. Transitional files whose exception record
    # says "must become converter output" belong to the candidate even while the stable runnable
    # build still carries its older hand-written implementation.
    seams = walker.seam_sources()
    complete = set(walker.context_for(ROOTS, seams)) | set(ROOTS)
    excluded = {
        path: reason for path in sorted(complete)
        for prefix, reason in EXCLUDED_PREFIXES.items() if path.startswith(prefix)
    }
    closure = sorted(path for path in complete if path not in excluded)
    by_area = {}
    for path in closure:
        parts = path.split("/")
        area = parts[3] if len(parts) > 4 and parts[:3] == ["com", "sulake", "habbo"] else parts[0]
        by_area[area] = by_area.get(area, 0) + 1
    payload = {
        "gate": "V30-browser-full-client-scope",
        "roots": ROOTS,
        "closure": closure,
        "context": [],
        "seams": {path: "existing declared browser/OpenFL boundary" for path in sorted(seams)},
        "excluded_prefixes": EXCLUDED_PREFIXES,
        "excluded_reachable_files": excluded,
        "closure_files": len(closure),
        "counts_by_area": dict(sorted(by_area.items())),
        "states": {
            "converted": "source emitted by ax3 into an isolated candidate root",
            "compiles": "all concrete types named by the candidate compile gate",
            "wired": "original component is reachable through the production dependency graph",
            "verified": "browser interaction matches the fixed acceptance fixture",
        },
        "note": "Scope follows HabboMain's original component owners; exclusions are platform/bootstrap runtimes, not fake services.",
    }
    target = REPO / "evidence/v30_full_client_scope.json"
    target.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")
    candidate = dict(payload)
    candidate.update({
        "gate": "V31-browser-full-client-candidate",
        "source_scope": "evidence/v30_full_client_scope.json",
        "state": "Complete intended client scope; generated and compiled only, never consumed by the runnable client until intentional cutover.",
    })
    (REPO / "evidence/v31_full_client_candidate_closure.json").write_text(
        json.dumps(candidate, indent=2) + "\n", encoding="utf-8", newline="\n"
    )
    print(json.dumps({"scope_files": len(closure), "excluded_reachable": len(excluded), "areas": payload["counts_by_area"]}, indent=2))


if __name__ == "__main__":
    main()
