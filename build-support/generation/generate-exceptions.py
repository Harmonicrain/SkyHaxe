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
    python build-support/generation/generate-exceptions.py
"""
from __future__ import annotations

import hashlib
import json
import os
import re
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CLIENT = Path(os.environ["SKYHAXE_SOURCE_ROOT"])
CORE_HX = REPO / "src/com/sulake/core"
OUT = Path(__file__).resolve().with_name("exceptions.json")

EXTRA_PLATFORM_FILES = {
    "src/Habbo.hx": {
        "reason": "HTML5 document-root boundary for converted HabboMain. The original Habbo.as "
                  "is a Flash MovieClip preloader; this host retains its component-visible "
                  "progress-log and crash-report contract without recreating SWF preloading.",
        "contract_tests": ["test/V32HabboHostTest.hx", "historical/projects/project.v32-component-graph.xml"],
    },
    "src/openfl/events/GesturePhase.hx": {
        "reason": "AIR event vocabulary missing from OpenFL. HTML5 never advertises AIR mobile or synthesizes these gestures.",
        "contract_tests": ["test/V24PlatformBoundaryTest.hx"],
    },
    "src/openfl/events/TransformGestureEvent.hx": {
        "reason": "Explicit unsupported AIR gesture type boundary for the original Android controller's non-AIR path; construction throws rather than pretending browser pinch support exists.",
        "contract_tests": ["test/V24PlatformBoundaryTest.hx"],
    },
    "src/skyhaxe/assets/LazySwfBitmap.hx": {
        "reason": "Flash exposed a lossless SymbolClass immediately and materialized its pixels on "
                  "construction. Preserves that contract so a downloaded component SWF does not "
                  "decode every bitmap it contains up front.",
        "contract_tests": ["test/SwfBitmapDecodeTest.hx"],
    },
    "src/skyhaxe/assets/NativeImageDecodeQueue.hx": {
        "reason": "Bounded decode queue for SWF-embedded PNG/JPEG symbols. Lime routes blob images "
                  "through the same 17-slot queue as HTTP, so a component SWF burst of two thousand "
                  "images delays unrelated client traffic; this keeps native browser decoding but "
                  "isolates it from networking.",
        "contract_tests": ["test/SwfBitmapDecodeTest.hx"],
    },
    "src/skyhaxe/assets/DeferredStaticMacro.hx": {
        "reason": "Narrow AVM2/OpenFL boot boundary for the original stage-dependent Motions timer; retains its initializer and evaluates once on first use, not at JS script load.",
        "contract_tests": ["test/V22WindowRuntimeTest.hx"],
    },
    "src/mx/core/BitmapAsset.hx": {
        "reason": "Flex Embed bitmap VM boundary. Generated data subclasses receive hash-checked preloaded original pixels, not a feature reimplementation.",
        "contract_tests": ["test/V22EmbeddedAssetsTest.hx"],
    },
    "src/mx/core/ByteArrayAsset.hx": {
        "reason": "Flex Embed binary VM boundary. Generated data subclasses receive hash-pinned compile-time bytes, available before the preloader, with Flash endianness and position.",
        "contract_tests": ["test/V22EmbeddedAssetsTest.hx"],
    },
    "src/mx/core/FontAsset.hx": {
        "reason": "Flex embedded-font identity boundary. Generated FontAsset subclasses retain "
                  "their hash-pinned AS3 family/style metadata while Truffle owns all browser "
                  "glyph measurement and rasterization.",
        "contract_tests": ["test/V21FontCoverageTest.hx", "historical/evidence/prepare_embedded_candidate.py"],
    },
    "src/mx/core/SimpleApplication.hx": {
        "reason": "Flex SWF document-root boundary. Generated component-library wrappers require its Sprite lifecycle and compile-time Embed materialization; HTML preloading and frame construction are owned by the browser boot pipeline.",
        "contract_tests": ["test/V21ConverterRegressionTest.hx", "historical/projects/project.compile-all.xml", "historical/projects/project.v32-component-graph.xml"],
    },
    "src/skyhaxe/assets/ComponentLibraryEmbedMacro.hx": {
        "reason": "Compile-time Flex [Embed] boundary for original *Com component owners. It restores their generated static asset-class initializers from a hash-pinned source/asset manifest; component behavior remains generated.",
        "contract_tests": ["historical/evidence/prepare_component_library_embeds.py", "historical/projects/project.v32-component-graph.xml"],
    },
    "src/skyhaxe/assets/ComponentLibraryEmbedFactory.hx": {
        "reason": "Runtime Flex anonymous Embed-class boundary used by generated component manifests and assets. It returns JavaScript constructors with Haxe class identity and the original ByteArray/BitmapAsset content contract.",
        "contract_tests": ["historical/evidence/prepare_component_library_embeds.py", "historical/projects/project.v32-component-graph.xml"],
    },
    "src/skyhaxe/assets/SwfEmbedFactory.hx": {
        "reason": "Runtime class factory for assets decoded from library SWFs on HTML5. Flash created SymbolClass constructors while loading; the browser adapter must expose the same class-shaped resource values.",
        "contract_tests": ["test/G2SwfReaderBrowserMain.hx", "historical/projects/project.v32-runtime.xml"],
    },
    "src/skyhaxe/assets/EmbeddedAssetMacro.hx": {
        "reason": "Compile-time translation of AS3 Embed wrappers using a hash-pinned source/asset manifest; rejects drift, embeds static binary bytes and requires bitmap predecoding.",
        "contract_tests": ["test/V22EmbeddedAssetsTest.hx", "historical/evidence/prepare_embedded_candidate.py"],
    },
    "src/ASError.hx": {
        "reason": "Global-name-safe AS3 Error boundary. Generated code maps the Flash root Error "
                  "type here because defining a global Haxe Error breaks compiler/OpenFL code.",
        "contract_tests": ["test/M2RuntimeCompileMain.hx"],
    },
}

# A seam may replace an AS3 class only when the entire class identity is intrinsically a platform
# boundary. Core, IAssetLibrary and AssetLibraryCollection were previously listed here, but they
# also own the original component lifecycle and asset contracts. Keeping partial substitutes made
# the full candidate structurally incomplete. They are generated now; browser download/SWF work is
# implemented by narrower adapters that have no source-client class identity.
SEAM_REPLACEMENTS = {}

ANNOTATIONS = {
    "assets/SoundAsset.hx":
        "Platform adapter for the sound/mp3 asset type on the SWF-library path. Flash embedded an "
        "MP3 as a class extending Sound and decoded it in the VM; nothing constructs a Sound on "
        "HTML5, so the frames SwfSound extracts are handed to one explicitly and lazily. The "
        "component-library path reaches Sound through ComponentLibraryEmbedFactory instead, which "
        "is where the missing sound support was actually crashing playSound.",
    "assets/loaders/Html5AssetLoader.hx": "Unavoidable browser individual-file transport and image decode boundary, exposing the original AssetLoaderStruct event contract without Flash LibraryLoader/FZip.",
    "utils/ASProxy.hx": "Flash VM enumeration adapter: invokes the converted nextNameIndex/nextValue hooks for window IIterator values; never enumerates implementation fields.",
    "utils/ASNumericType.hx": "AS3 numeric type-test boundary: Haxe UInt is an erased abstract on JavaScript, "
        "so uint instance tests require a numeric/range check rather than a class object.",
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
    "assets/swf/SwfByteCache.hx":
        "Browser SWF transport boundary. It deduplicates immutable response bytes and keeps a "
        "bounded revision-aware session cache; mutable decoded assets remain separately owned.",
    "assets/swf/SwfDecodeWorkerPool.hx":
        "Browser worker scheduler for the existing deterministic lossless SWF decoder. Flash "
        "decoded these images natively; HTML5 must keep that CPU work off the UI/network thread.",
    "assets/swf/SwfLoadMetrics.hx":
        "Browser-only phase telemetry for measuring SWF fetch, parse, decode and registration "
        "without changing the converted client lifecycle.",
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
    if rel == "assets/loaders/Html5AssetLoader.hx":
        return ["test/V22AssetLoadingTest.hx", "historical/tooling/scripts/verify-window-services.ps1"]
    if rel in ("utils/ASNumericType.hx", "utils/ASProxy.hx"):
        return ["test/V21ConverterRegressionTest.hx", "historical/tooling/scripts/verify-window-text.ps1"]
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
        return ["test/V5AvatarCompileMain.hx", "historical/evidence/v5_avatar_closure.json", "test/V22WindowRuntimeTest.hx"]
    if rel.startswith("communication/"):
        # The wire-format boundary is exercised end to end by the transport and login gates
        # rather than by a unit test: an incorrect reader shows up as a failed handshake.
        return ["historical/evidence/g1b_websocket_transport.json", "historical/evidence/v2_login_verification.json"]
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
        "generated_by": "build-support/generation/generate-exceptions.py",
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
