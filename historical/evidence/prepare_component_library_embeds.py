#!/usr/bin/env python3
"""Materialize Flex ``[Embed]`` fields declared by the client component libraries.

The AS3 compiler turns every ``[Embed] public static var/const foo:Class`` declaration into a
small generated class.  ax3 correctly preserves the owner and field, but the compiler-generated
class cannot be recovered from source and the Haxe field would otherwise stay null.  This script
pins that missing compiler input for the HTML5 boundary: a macro assigns an equivalent asset
constructor to each converted field, while OpenFL preloads the original bytes under stable IDs.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from xml.etree import ElementTree as ET

REPO = Path(__file__).resolve().parent.parent
CLIENT_SRC = Path(r"C:\habbo\client\habbo-client-clean\src")
GENERATED = REPO / ".toolchain/v32/generated"
MANIFEST = REPO / "evidence/component_library_embeds.json"
ASSET_XML = REPO / ".toolchain/v32/component-library-assets.xml"

EMBED = re.compile(
    r'\[Embed\((?P<args>[^\]]+)\)\]\s*public\s+static\s+(?:var|const)\s+'
    r'(?P<field>[A-Za-z_$][\w$]*):Class',
    re.DOTALL,
)
SOURCE = re.compile(r'source\s*=\s*"([^"]+)"')
BITMAP_SUFFIXES = {".png", ".jpg", ".jpeg", ".gif"}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def component_libraries() -> list[Path]:
    """
    Every component library HabboMain prepares, not just the *Com ones.

    `ComponentContext.prepareComponent` reads the library class's static `manifest` field and
    returns null the moment it is absent -- silently, with no error and no component. The nine
    *Lib libraries (CoreCommunicationFrameworkLib, HabboAvatarRenderLib, RoomManagerLib and the
    rest) carry an [Embed] manifest exactly as the *Com ones do, so omitting them left their
    manifests null and every IID they provide unregistered: no communication manager, so no
    connection, so no authentication, so localization never loaded its texts and every component
    waiting behind HabboConfigurationManager stayed locked for ever.
    """
    return sorted(list(CLIENT_SRC.glob("*Com.as")) + list(CLIENT_SRC.glob("*Lib.as")))

def main() -> None:
    owners: dict[str, dict[str, object]] = {}
    total_bytes = 0

    for source in component_libraries():
        text = source.read_text(encoding="utf-8-sig")
        fields: dict[str, object] = {}
        for match in EMBED.finditer(text):
            source_match = SOURCE.search(match.group("args"))
            if source_match is None:
                raise SystemExit(f"Embed without source in {source}: {match.group(0)!r}")
            relative = source_match.group(1).replace("/", str(Path("/")).replace("/", "\\"))
            asset = CLIENT_SRC / Path(relative)
            if not asset.is_file():
                raise SystemExit(f"Missing component embed {asset}")
            field = match.group("field")
            suffix = asset.suffix.lower()
            kind = "bitmap" if suffix in BITMAP_SUFFIXES else "bytes"
            asset_id = f"skyhaxe/component/{source.stem}/{field}{suffix}"
            if field in fields:
                raise SystemExit(f"Duplicate embedded field {source.stem}.{field}")
            fields[field] = {
                "id": asset_id,
                "kind": kind,
                "asset": str(asset),
                "asset_sha256": sha256(asset),
            }
            total_bytes += asset.stat().st_size

        if not fields:
            continue
        generated = GENERATED / f"{source.stem}.hx"
        if not generated.is_file():
            raise SystemExit(f"Converted component wrapper missing: {generated}")
        generated_text = generated.read_text(encoding="utf-8")
        for field in fields:
            if not re.search(rf"public static var {re.escape(field)}:Class<Dynamic>;", generated_text):
                raise SystemExit(f"Converted embedded field missing: {source.stem}.{field}")
        owners[source.stem] = {
            "source": str(source),
            "source_sha256": sha256(source),
            "fields": fields,
        }

    count = sum(len(owner["fields"]) for owner in owners.values())
    expected = sum(
        len(EMBED.findall(path.read_text(encoding="utf-8-sig")))
        for path in component_libraries()
    )
    if count != expected:
        raise SystemExit(f"Only materialized {count}/{expected} component embeds")

    MANIFEST.write_text(json.dumps({
        "gate": "component-library-embed-contract",
        "owners": owners,
        "counts": {"owners": len(owners), "assets": count, "bytes": total_bytes},
    }, indent=2) + "\n", encoding="utf-8")

    project = ET.Element("project")
    for owner in owners.values():
        for record in owner["fields"].values():
            ET.SubElement(project, "assets", {
                "path": record["asset"],
                "rename": record["id"],
                "type": "image" if record["kind"] == "bitmap" else "binary",
            })
    ET.indent(project, space="    ")
    ASSET_XML.parent.mkdir(parents=True, exist_ok=True)
    ET.ElementTree(project).write(ASSET_XML, encoding="unicode", xml_declaration=True)
    with ASSET_XML.open("a", encoding="utf-8") as output:
        output.write("\n")

    print(f"COMPONENT_EMBEDS_PASS owners={len(owners)} assets={count} bytes={total_bytes}")


if __name__ == "__main__":
    main()
