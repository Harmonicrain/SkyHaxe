#!/usr/bin/env python3
"""Regenerate the M2 exception manifest from what is actually on disk.

M2's rule 8: every original core class ends in exactly one state -- generated or declared
exception -- with no implicit omission. The first hand-written manifest listed five files out of
forty-three, which read as complete and was not. Deriving it from the tree removes the chance of
that happening again.

Classification is mechanical:

  * a Haxe file whose class name matches an AS3 class under `com/sulake/core` is a **port**. It is
    hand-written today and must become converter output; the AS3 hash is pinned so an upstream
    edit fails the sync.
  * a Haxe file with no AS3 counterpart is a **platform exception**: an adapter that exists
    because HTML5 needs something Flash got from the VM.

Reasons are held in ANNOTATIONS below, so regenerating never discards the human explanation of
why an exception is legitimate.

Usage:
    python evidence/m2_build_exceptions.py
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
CLIENT = Path(r"C:\habbo\client\habbo-client-clean")
CORE_HX = REPO / "src/com/sulake/core"
OUT = REPO / "evidence/m2_exceptions.json"

EXTRA_PLATFORM_FILES = {
    "src/ASError.hx": {
        "reason": "Global-name-safe AS3 Error boundary. Generated code maps the Flash root Error "
                  "type here because defining a global Haxe Error breaks compiler/OpenFL code.",
        "contract_tests": ["test/M2RuntimeCompileMain.hx"],
    },
}

# Classes with an AS3 counterpart that the port deliberately replaces, permanently.
#
# The default reading of "hand-written Haxe with an AS3 twin" is a port that has not been converted
# yet, and rightly so -- that is what most of them are. These are not. Each one is AS3 written
# against something the target does not have: the Flash player running a loaded SWF, a
# component-framework context, an ExternalInterface bridge. Converting them faithfully would import
# machinery the port has already replaced, which is how the avatar closure came to contain a zip
# decoder while SkyHaxe reads SWFs with SwfFile.
#
# The distinction matters because it changes what "done" means. A port is measured against becoming
# generated output; a seam is measured against the AS3 hash it was designed from, and reviewed if
# that hash moves. Both fail closed. Only one is a debt.
#
# evidence/v5_avatar_closure.py holds the matching SEAM table, which is what stops the walker
# following these into the closure.
SEAM_REPLACEMENTS = {
    "Core.hx":
        "The AS3 Core is the component runtime -- context, registry, profiler and SWF loader. The "
        "avatar closure reaches it only for Core.crash and Core.error, and following it pulls in "
        "the whole runtime plus its vendored FZip. This is the error-reporting half alone.",
    "assets/IAssetLibrary.hx":
        "Three of the AS3 interface's members are declared in terms of LibraryLoader, the AS3 SWF "
        "downloader. That is the edge that drags the loader stack into any closure naming a "
        "library. This keeps the members that read a loaded library and drops the ones that fetch "
        "one; loading is the port's own concern.",
    "assets/AssetLibraryCollection.hx":
        "The AS3 registry is built on LibraryLoader and FZip. What the avatar compositor asks a "
        "collection for is read-only -- getManifests and getAssetByName -- so that is what this "
        "implements, over libraries the caller registers.",
}

ANNOTATIONS = {
    "window/text/TruffleText.hx":
        "Platform adapter. Flash rasterised text in the VM; HTML5 needs an explicit engine to "
        "reproduce Ubuntu at advanced anti-aliasing with sharpness 80 and thickness -15.",
    "window/theme/ElementDescription.hx":
        "Loader for habbo_element_description_xml.bin. The AS3 reaches this table through "
        "SkinParserUtil and the component factory; SkyHaxe reads it directly.",
    "window/theme/InternalLayouts.hx":
        "Registry for the habbo_window_layout_* documents. Registration is host-specific: SkyHaxe "
        "packages them as OpenFL assets, the client embeds them.",
    "assets/swf/SwfFile.hx": "SWF container reader. Flash loaded SWFs natively; nothing in the "
        "AS3 corresponds to parsing one by hand.",
    "assets/swf/SwfBitmap.hx": "SWF bitmap decoding, as above.",
    "assets/swf/SwfCharacter.hx": "SWF character model, as above.",
    "assets/swf/SwfSound.hx": "SWF sound extraction, as above.",
    "assets/swf/SwfTag.hx": "SWF tag constants, as above.",
    "assets/swf/SwfError.hx": "SWF reader error type, as above.",
    "assets/swf/SwfAssetLibrary.hx":
        "Turns a library SWF into an AssetLibrary of named bitmaps. Flash got this from Loader "
        "plus the SymbolClass tag binding each character to a class; with no player, the port has "
        "to read the container and register the exports itself. Every avatar part is addressed by "
        "its exported name, so this mapping is the whole contract between the asset SWFs and the "
        "compositor.",
    "runtime/ComponentDependencyLifecycle.hx":
        "HTML5 lifecycle helper used by the G1d component-shell contract. It separates the "
        "generated component API from host scheduling and has no AS3 class identity.",
    "runtime/ComponentInterfaceBroker.hx":
        "HTML5 interface-broker helper used by the G1d component-shell contract. The clean "
        "client obtains this behavior through WindowContext/runtime wiring rather than a class "
        "with this identity.",
    "runtime/ComponentManifest.hx":
        "Typed representation of component XML manifests for the HTML5 host. Flash supplied the "
        "embedded-resource boundary; SkyHaxe must parse it explicitly.",
    "utils/ByteArray.hx":
        "HTML5 replacement for flash.utils.ByteArray, whose VM implementation is unavailable on "
        "the JavaScript target.",
    "utils/DefinitionRegistry.hx":
        "HTML5 replacement for Flash runtime definition lookup. JavaScript has no application "
        "domain class registry equivalent, so generated reflection calls route through it.",
    "utils/xml/XML.hx":
        "HTML5 E4X compatibility adapter. Haxe/JavaScript has no native AS3 XML type.",
    "utils/xml/XMLList.hx":
        "HTML5 E4X XMLList compatibility adapter. It implements the measured clean-client API "
        "surface rather than duplicating a clean-client class.",
    "window/graphics/WindowSkinRenderer.hx":
        "HTML5 bitmap-skin renderer. AIR's window stack consumed the same theme data through "
        "Flash display APIs; the JavaScript target needs an explicit OpenFL renderer.",
}

SOURCE_OVERRIDES = {
    "window/enums/WindowParam.hx": "window/enum/WindowParam.as",
}


def contract_tests(rel: str) -> list[str]:
    if rel.startswith("assets/swf/"):
        return ["test/G2SwfReaderTest.hx", "test/G2SwfReaderBrowserMain.hx"]
    if rel == "assets/AssetLibrary.hx":
        return ["test/G1dAssetLibraryTest.hx", "test/G1dAssetLibraryBrowserMain.hx"]
    if rel == "assets/BitmapDataAsset.hx":
        return ["test/G1dBitmapDataAssetTest.hx", "test/G1dBitmapDataAssetBrowserMain.hx"]
    if rel.startswith("assets/"):
        return ["test/G1dAssetsTest.hx", "test/G1dAssetsBrowserMain.hx"]
    if rel.startswith("runtime/"):
        return ["test/G1dRuntimeTest.hx", "test/G1dComponentShellTest.hx"]
    if rel.startswith("utils/xml/"):
        return ["test/G1dXmlTest.hx"]
    if rel == "utils/ByteArray.hx":
        return ["test/G1dByteArrayTest.hx", "test/G1dByteArrayBrowserMain.hx"]
    if rel in ("utils/ClassUtils.hx", "utils/DefinitionRegistry.hx"):
        return ["test/G1dReflectionTest.hx"]
    if rel in ("utils/Map.hx", "utils/SingleWriteMap.hx"):
        return ["test/G1dMapTest.hx"]
    if rel.startswith("localization/"):
        # The text table has no unit test of its own: what it has to get right is that a layout's
        # ${key} captions resolve, which the window-layout gate already renders end to end.
        return ["test/G1dWindowLayoutTest.hx", "test/G4bWindowBrowserMain.hx"]
    if rel.startswith("window/"):
        return ["test/G1dWindowLayoutTest.hx", "test/G4bWindowBrowserMain.hx"]
    if rel == "Core.hx":
        # Error reporting only. Nothing asserts on a console message; what this file has to get
        # right is that the avatar closure compiles and runs without the AS3 component runtime,
        # which is exactly what the avatar compile gate measures.
        return ["test/V5AvatarCompileMain.hx", "evidence/v5_avatar_closure.json"]
    if rel.startswith("communication/"):
        # The wire-format boundary is exercised end to end by the transport and login gates
        # rather than by a unit test: an incorrect reader shows up as a failed handshake.
        return ["evidence/g1b_websocket_transport.json", "evidence/v2_login_verification.json"]
    raise RuntimeError(f"no contract test classification for {rel}")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def find_as3(rel: str) -> Path | None:
    """Resolve by class identity, never by basename search.

    Basename search silently picks the first match if two packages gain the same class name. A
    refresh contract has to bind a Haxe file to one exact clean-client path.
    """
    source_rel = SOURCE_OVERRIDES.get(rel, str(Path(rel).with_suffix(".as")).replace("\\", "/"))
    candidate = CLIENT / "src/com/sulake/core" / source_rel
    return candidate if candidate.is_file() else None


def declared_functions(path: Path, haxe: bool) -> list[str]:
    text = path.read_text(encoding="utf-8-sig", errors="replace")
    if haxe:
        return sorted(set(re.findall(r"\bfunction\s+([A-Za-z_$][\w$]*)\s*\(", text)))
    result = set()
    for accessor, name in re.findall(
            r"\bfunction\s+(?:(get|set)\s+)?([A-Za-z_$][\w$]*)\s*\(", text):
        result.add((accessor + ":" + name) if accessor else ("new" if name == path.stem else name))
    return sorted(result)


def main() -> int:
    ports, platform = [], []
    for path in sorted(CORE_HX.rglob("*.hx")):
        rel = path.relative_to(CORE_HX).as_posix()
        as3 = find_as3(rel)
        entry = {
            "haxe": path.relative_to(REPO).as_posix(),
            "haxe_sha256": sha256(path),
            "reason": ANNOTATIONS.get(rel),
            "contract_tests": contract_tests(rel),
        }
        if as3 and rel in SEAM_REPLACEMENTS:
            # A deliberate replacement, not a conversion debt. The AS3 hash is still pinned: if
            # upstream changes the class this seam was designed against, that is worth a look.
            entry["as3_source"] = as3.relative_to(CLIENT).as_posix()
            entry["as3_sha256"] = sha256(as3)
            entry["state"] = "seam -- AS3 counterpart deliberately not converted"
            entry["reason"] = SEAM_REPLACEMENTS[rel]
            entry["api_surface_check"] = {
                "mode": "intentional subset of the AS3 surface",
                "status": "covered by declared contract tests",
                "source_declared": declared_functions(as3, False),
                "haxe_declared": declared_functions(path, True),
            }
            platform.append(entry)
        elif as3:
            entry["as3_source"] = as3.relative_to(CLIENT).as_posix()
            entry["as3_sha256"] = sha256(as3)
            entry["state"] = "hand-written port -- must become converter output"
            entry["retire_at"] = "M2b/M2d"
            source_api = declared_functions(as3, False)
            haxe_api = declared_functions(path, True)
            entry["api_surface_check"] = {
                "mode": "declared-function-name comparison",
                "status": "transitional subset" if set(source_api) - set(haxe_api) else "covered by name",
                "source_declared": source_api,
                "haxe_declared": haxe_api,
                "source_names_absent_from_haxe": sorted(set(source_api) - set(haxe_api)),
            }
            if not entry["reason"]:
                # These are G1d/G2-G4b contract slices: written to prove OpenFL could carry the
                # behaviour, before a conversion pipeline existed. None is a designed exception.
                entry["reason"] = ("Phase 2 contract slice, written before the sync pipeline "
                                   "existed. Not a designed exception: replace with generated "
                                   "output.")
            ports.append(entry)
        else:
            entry["as3_source"] = None
            entry["state"] = "platform exception -- no AS3 counterpart"
            entry["api_surface_check"] = {
                "mode": "platform adapter with no AS3 class identity",
                "status": "covered by declared contract tests",
            }
            platform.append(entry)

    for rel, annotation in EXTRA_PLATFORM_FILES.items():
        path = REPO / rel
        entry = {
            "haxe": rel,
            "haxe_sha256": sha256(path),
            "reason": annotation["reason"],
            "contract_tests": annotation["contract_tests"],
            "as3_source": None,
            "state": "platform exception -- mapped AS3 VM type with no client class counterpart",
            "api_surface_check": {
                "mode": "platform adapter with no AS3 client class identity",
                "status": "covered by generated OpenFL compile contract",
            },
        }
        platform.append(entry)

    manifest = {
        "gate": "M2a-exception-manifest",
        "generated_by": "evidence/m2_build_exceptions.py",
        "rule": "Every hand-maintained Haxe file under com/sulake/core is listed. Files with an "
                "AS3 counterpart pin that source's hash: the sync stops if it changes.",
        "core_haxe_files": sum(1 for path in CORE_HX.rglob("*.hx")),
        "tracked_haxe_files": len(ports) + len(platform),
        "hand_written_ports": len(ports),
        "platform_exceptions": len(platform),
        "unannotated": [e["haxe"] for e in ports + platform if not e["reason"]],
        "note": "Ports are not legitimate exceptions. They are the current cost of having reached "
                "G2-G4b before the conversion pipeline existed, and M2b/M2d must replace them "
                "with generated output.",
        "exceptions": ports + platform,
    }
    OUT.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print("core Haxe files    :", manifest["core_haxe_files"])
    print("hand-written ports :", manifest["hand_written_ports"])
    print("platform exceptions:", manifest["platform_exceptions"])
    print("unannotated        :", len(manifest["unannotated"]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
