"""Define the original Flash loading-screen closure without pulling in onboarding screens."""
import json
import re
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")
TARGET = REPO / "evidence/v33_loading_screen_closure.json"


def main() -> None:
    files = {
        "HabboLoadingScreen.as",
        "splash/PhotoSplashScreen.as",
        "onBoardingHcUi/LoaderUI.as",
        "onBoardingHcUi/NineSplitSprite.as",
        "onBoardingHcUi/_Str_666.as",
        "onBoardingHcUi/_Str_771.as",
        "onBoardingHcUi/_Str_955.as",
        "onBoardingHcUi/_Str_1000.as",
    }
    files.update(
        path.relative_to(CLIENT).as_posix()
        for path in (CLIENT / "splash/images").glob("*.as")
    )
    # LoaderUI and NineSplitSprite import the whole image package. Keep only the image wrappers
    # they actually name so the preloader does not drag the unrelated onboarding flow back in.
    for owner in ("LoaderUI", "NineSplitSprite"):
        text = (CLIENT / f"onBoardingHcUi/{owner}.as").read_text(encoding="utf-8-sig")
        for name in sorted(set(re.findall(rf"\b{owner}__Str_\d+\b", text))):
            files.add(f"onBoardingHcUi/images/{name}.as")
    missing = [relative for relative in sorted(files) if not (CLIENT / relative).is_file()]
    if missing:
        raise SystemExit("missing loading-screen source: " + repr(missing))
    payload = {
        "gate": "V33-original-loading-screen",
        "state": "Original Flash preloader implementation and its exact embedded assets.",
        "roots": ["HabboLoadingScreen.as"],
        "closure": sorted(files),
        "context": ["com/sulake/habbo/utils/_Str_988.as", "IHabboLoadingScreen.as"],
        "closure_files": len(files),
    }
    TARGET.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(json.dumps({"closure_files": len(files)}))


if __name__ == "__main__":
    main()
