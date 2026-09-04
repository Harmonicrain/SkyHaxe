#!/usr/bin/env python3
"""Measure the AS3 dependency closure of the guest-room render path.

A public room is a pre-authored SWF: 44 ready-made layers, loaded and blitted. A guest room has
no SWF at all. Its floor and walls are rasterized at runtime from the heightmap the server sends,
which is why entering one renders nothing today -- there is no code path, not a broken one.

Seeded from the three producers a guest room needs: the room shell, the plane that shell is built
from, and the furniture visualization that puts objects on it.

Usage:
    python evidence/v7_guest_room_closure.py [--json out.json]
"""
from __future__ import annotations

import argparse
import collections
import json
import re
from pathlib import Path

CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")

SEEDS = [
    # The procedural shell: floor and wall planes rasterized from the heightmap.
    "com/sulake/habbo/room/object/visualization/room/RoomVisualization.as",
    "com/sulake/habbo/room/object/visualization/room/RoomPlane.as",
    # Floor furniture and wall items.
    "com/sulake/habbo/room/object/visualization/furniture/FurnitureVisualization.as",
    # Public rooms are not a separate renderer in the clean client -- they are a 109-line
    # subclass of RoomVisualization that overrides two depth constants, initialize and update.
    # Converting it means one engine drives both room types, as Flash does, instead of the
    # bespoke public-room loader SkyHaxe grew to get a room on screen quickly.
    "com/sulake/habbo/room/object/visualization/room/publicroom/PublicRoomVisualization.as",
    # What a visualization is attached to and reads from. RoomVisualization needs an IRoomObject
    # carrying the room's model, and a GraphicAssetCollection to resolve its plane bitmaps --
    # both are ordinary client classes rather than platform boundaries, so they convert.
    "com/sulake/room/object/RoomObject.as",
    "com/sulake/room/object/RoomObjectModel.as",
    "com/sulake/room/object/visualization/utils/GraphicAssetCollection.as",
]

# Where the port stops following the AS3 and substitutes its own implementation. These are not
# "skip the hard ones": each is a class SkyHaxe already replaces, or must, because the AS3 does
# something the target has no equivalent of.
#
# Measured 2026-09-02: without this the closure is 115 files and drags in the entire AS3 component
# runtime -- Core, CoreComponentContext, the profiler, LibraryLoader and its vendored FZip zip
# reader. None of it is reachable at runtime in SkyHaxe, which reads SWFs with its own SwfFile, and
# all of it fails to compile for reasons that have nothing to do with avatars.
#
# The edge is thinner than it looks. `EventDispatcherWrapper` needs `Core` for two calls to
# `Core.crash` in an error handler, and that single reference is what pulls the rest in.
SEAM = {
    "com/sulake/core/Core.as":
        "reached only for Core.crash() from EventDispatcherWrapper's error handler. Pulls the "
        "whole component runtime, the profiler and the AS3 SWF loader behind it",
    "com/sulake/core/assets/AssetLibraryCollection.as":
        "the AS3 asset registry, backed by LibraryLoader and FZip. SkyHaxe reads SWFs with "
        "SwfFile and keeps its own AssetLibrary",
    "com/sulake/habbo/avatar/AvatarAssetDownloadLibrary.as":
        "wraps LibraryLoader to fetch and unzip one hh_human_*.swf. SkyHaxe fetches the same "
        "bytes and reads them with SwfFile, so this is the download seam itself",
    "com/sulake/habbo/avatar/EffectAssetDownloadLibrary.as":
        "the same wrapper for effect libraries",
    "com/sulake/habbo/avatar/EffectAssetDownloadManager.as":
        "downloads optional effect libraries through AssetLoaderStruct. A standing avatar does "
        "not use an effect; SkyHaxe supplies a fail-closed no-effect seam until the effect asset "
        "path is implemented after the first visible avatar",
    "com/sulake/core/assets/IAssetLibrary.as":
        "declares its loader methods in terms of LibraryLoader, which is the remaining edge into "
        "the AS3 SWF loader. SkyHaxe has its own AssetLibrary, and the avatar code uses only the "
        "asset-lookup half of this interface",
    "com/sulake/habbo/avatar/AvatarRenderManager.as":
        "an IHabboComponent: its constructor, dependency wiring and configuration reads "
        "are all component-framework machinery the port does not have. Nothing in the "
        "closure calls more than two of its members -- events and isReady -- so the port "
        "supplies its own",
    "com/sulake/habbo/utils/HabboWebTools.as":
        "browser bridge for error reporting and navigation; ExternalInterface calls with no place "
        "in the port yet",
}

IMPORT = re.compile(r"(?m)^\s*import\s+([\w.]+)\s*;")
# Imports alone under-report the closure: a subclass in the same package needs no import, so
# `StuffDataBase` was invisible even though every StuffData class extends it. Following the
# inheritance clause and resolving bare names against the file's own package closes that hole.
# Both declaration forms. V4 matched only `class`, so an interface's bases were never followed:
# `interface ICore extends IContext, IHabboConfigurationManager` looked like a leaf, and the second
# base -- same package, so no import to fall back on -- was missing from the closure entirely. An
# interface can extend several, hence the shared comma-separated group.
INHERITS = re.compile(
    r"\bclass\s+\w+\s+(?:extends\s+([\w.]+))?\s*(?:implements\s+([\w.,\s]+))?"
    r"|\binterface\s+\w+\s+extends\s+([\w.,\s]+?)\s*\{")
PACKAGE = re.compile(r"(?m)^\s*package\s+([\w.]+)")
# AS3 does not require imports for classes in the current package. Imports + inheritance therefore
# still miss helpers such as ItemsMessageParser -> ItemDataParser and JSONDecoder -> JSONTokenizer.
#
# V4 followed every capitalized identifier that had a matching .as file beside the source, on the
# reasoning that a superset is safe. For a small package it is. For `com/sulake/core/utils` it is
# not: one file there drags in the whole directory -- the profiler, the AS3 SWF loader and its
# vendored FZip -- because a word like `Player` or `Map` appears somewhere in a comment or a
# string. That made the avatar closure 115 files no matter which three seeds it was given, and
# the extra files are ones SkyHaxe deliberately replaces with a native reader.
#
# Follow a same-package name only where AS3 syntax says it is a type: a declared or returned type,
# a `new`, a cast, or a static member access.
LOCAL_TYPE = re.compile(
    r":\s*([A-Z][A-Za-z0-9_]*)"          # var x:Type, function f():Type
    r"|\bnew\s+([A-Z][A-Za-z0-9_]*)"     # new Type(...)
    r"|\b(?:as|is)\s+([A-Z][A-Za-z0-9_]*)"  # x as Type, x is Type
    r"|\b([A-Z][A-Za-z0-9_]*)\s*\."      # Type.CONSTANT
)


def to_path(qualified: str) -> Path:
    return CLIENT / (qualified.replace(".", "/") + ".as")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", type=Path,
                    default=Path(__file__).resolve().parent / "v7_guest_room_closure.json")
    args = ap.parse_args()

    # Files with a hand-maintained override must not be converted on top of it. Sol's cutover
    # finding: generated code normally wins, but a genuine semantic boundary -- the Proxy-backed
    # `Map` is the example -- keeps its hand-written implementation. Converting it anyway puts a
    # generated copy earlier on the class path and shadows the exception silently.
    manifest = json.loads(
        (Path(__file__).resolve().parent / "m2_exceptions.json").read_text(encoding="utf-8"))
    overridden = {
        entry["as3_source"] for entry in manifest["exceptions"] if entry.get("as3_source")
    }
    overridden = {source[len("src/"):] if source.startswith("src/") else source
                  for source in overridden}

    overridden |= set(SEAM)

    seen: set[str] = set()
    hand_written: set[str] = set()
    missing: set[str] = set()
    queue = list(SEEDS)

    while queue:
        relative = queue.pop()
        if relative in seen:
            continue
        path = CLIENT / relative
        if not path.is_file():
            missing.add(relative)
            continue
        if relative in overridden:
            hand_written.add(relative)
            continue
        seen.add(relative)
        text = path.read_text(encoding="utf-8-sig", errors="replace")

        # Base classes and interfaces, which may be bare names resolved against this file's package.
        own_package = PACKAGE.search(text)
        inherits = INHERITS.search(text)
        if inherits:
            names = [inherits.group(1)] if inherits.group(1) else []
            for group in (inherits.group(2), inherits.group(3)):
                if group:
                    names += [n.strip() for n in group.split(",")]
            for name in filter(None, names):
                if "." not in name and own_package:
                    name = own_package.group(1) + "." + name
                candidate = to_path(name)
                if candidate.is_file():
                    queue.append(candidate.relative_to(CLIENT).as_posix())

        if own_package:
            package_path = CLIENT / own_package.group(1).replace(".", "/")
            for groups in LOCAL_TYPE.findall(text):
                type_name = next(filter(None, groups), None)
                if type_name is None:
                    continue
                candidate = package_path / (type_name + ".as")
                if candidate.is_file() and candidate != path:
                    queue.append(candidate.relative_to(CLIENT).as_posix())

        for qualified in IMPORT.findall(text):
            # flash.* and __AS3__ are runtime types the target supplies, not client source.
            if qualified.startswith(("flash.", "__AS3__", "mx.", "fl.")):
                continue
            candidate = to_path(qualified)
            if candidate.is_file():
                queue.append(candidate.relative_to(CLIENT).as_posix())
            else:
                missing.add(qualified)

    packages = collections.Counter(
        "/".join(relative.split("/")[:-1]) for relative in seen)
    lines = sum(
        len((CLIENT / relative).read_text(encoding="utf-8-sig", errors="replace").splitlines())
        for relative in seen)

    result = {
        "gate": "V7-guest-room-dependency-closure",
        "seeds": SEEDS,
        "closure_files": len(seen),
        "closure": sorted(seen),
        "closure_source_lines": lines,
        "packages": dict(packages.most_common()),
        "unresolved_imports": sorted(missing),
        "hand_written_overrides_skipped": sorted(hand_written),
        "seam": SEAM,
        "note": "This is the generated avatar compositor plus the two room-user packet parsers "
                "that drive it. Package-at-a-time conversion cannot be ordered without this "
                "measured closure.",
    }
    args.json.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")

    print("closure: {} files, {} source lines, {} packages".format(
        len(seen), lines, len(packages)))
    for package, count in packages.most_common(12):
        print("   {:<58} {:>4}".format(package, count))
    if missing:
        print("\nunresolved imports:", len(missing))
    print("\nwritten to", args.json)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
