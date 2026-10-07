#!/usr/bin/env python3
"""Regenerate update-candidate Embed manifests from its discovered, snapshotted AS3 closure."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from xml.etree import ElementTree as ET

EMBED_CLASS = re.compile(r'\[Embed\((?P<args>[^\]]+)\)\]', re.S)
EMBED_FIELD = re.compile(r'\[Embed\((?P<args>[^\]]+)\)\]\s*public\s+static\s+(?:var|const)\s+(?P<field>[A-Za-z_$][\w$]*):Class', re.S)
SOURCE = re.compile(r'source\s*=\s*["\']([^"\']+)["\']')
EXTENDS = re.compile(r'extends\s+(ByteArrayAsset|BitmapAsset|FontAsset)\b')
BITMAPS = {".png", ".jpg", ".jpeg", ".gif"}
MARKER = "${SKYHAXE_SOURCE_ROOT}/src/"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def declared(path: Path, source_root: Path) -> str:
    return MARKER + path.relative_to(source_root).as_posix()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--candidate", type=Path, required=True)
    args = parser.parse_args()
    root = args.candidate.resolve(); source_root = root / "upstream/src"
    closure = json.loads((root / "closures/v32_component_graph_boot_closure.json").read_text(encoding="utf-8"))
    output = root / "build-support/assets"; output.mkdir(parents=True, exist_ok=True)
    records, fonts, component, asset_xml, component_xml = {}, {}, {}, [], []

    for relative in closure["closure"]:
        source = source_root / relative
        text = source.read_text(encoding="utf-8-sig", errors="replace")
        identity = relative[:-3].replace("/", ".")
        kind_match = EXTENDS.search(text)
        embeds = list(EMBED_CLASS.finditer(text))
        if kind_match and embeds:
            match = embeds[0]; source_match = SOURCE.search(match.group("args"))
            if source_match is None: raise RuntimeError(f"Embed without source: {relative}")
            asset = (source.parent / source_match.group(1)).resolve(); asset.relative_to(source_root.resolve())
            if not asset.is_file(): raise RuntimeError(f"Missing embedded asset: {asset}")
            kind = kind_match.group(1); identifier = "skyhaxe/embed/" + relative[:-3] + asset.suffix
            record = {"source": declared(source, source_root), "source_sha256": digest(source),
                      "asset": declared(asset, source_root), "asset_sha256": digest(asset),
                      "kind": kind, "id": identifier}
            if kind == "FontAsset":
                family = re.search(r'(?:fontName|fontFamily)\s*=\s*["\']([^"\']+)', match.group("args"))
                if family is None: raise RuntimeError(f"Embedded font has no family: {relative}")
                bold = bool(re.search(r'fontWeight\s*=\s*["\']bold', match.group("args"), re.I))
                italic = bool(re.search(r'fontStyle\s*=\s*["\']italic', match.group("args"), re.I))
                fonts[identity] = {**record, "name": family.group(1),
                                   "style": "boldItalic" if bold and italic else "bold" if bold else "italic" if italic else "regular"}
            else:
                records[identity] = record
                asset_xml.append((asset, identifier, "image" if kind == "BitmapAsset" else "binary"))

        fields = {}
        for match in EMBED_FIELD.finditer(text):
            source_match = SOURCE.search(match.group("args"))
            if source_match is None: raise RuntimeError(f"Component Embed without source: {relative}")
            asset = (source.parent / source_match.group(1)).resolve(); asset.relative_to(source_root.resolve())
            if not asset.is_file(): raise RuntimeError(f"Missing component asset: {asset}")
            identifier = f"skyhaxe/component/{source.stem}/{match.group('field')}{asset.suffix.lower()}"
            kind = "bitmap" if asset.suffix.lower() in BITMAPS else "bytes"
            fields[match.group("field")] = {"id": identifier, "kind": kind,
                "asset": declared(asset, source_root), "asset_sha256": digest(asset)}
            component_xml.append((asset, identifier, "image" if kind == "bitmap" else "binary"))
        if fields:
            component[source.stem] = {"source": declared(source, source_root),
                                      "source_sha256": digest(source), "fields": fields}

    def emit_xml(path: Path, rows: list[tuple[Path, str, str]]) -> None:
        project = ET.Element("project")
        for asset, identifier, kind in rows:
            ET.SubElement(project, "assets", path=declared(asset, source_root), rename=identifier, type=kind)
        ET.indent(project, space="  ")
        path.write_text(ET.tostring(project, encoding="unicode") + "\n", encoding="utf-8", newline="\n")

    (output / "embedded-assets-manifest.json").write_text(json.dumps(records, indent=2) + "\n", encoding="utf-8")
    (output / "component-library-embeds.json").write_text(json.dumps({"gate": "component-library-embed-contract", "owners": component,
        "counts": {"owners": len(component), "assets": len(component_xml), "bytes": sum(row[0].stat().st_size for row in component_xml)}}, indent=2) + "\n", encoding="utf-8")
    (output / "embedded-fonts.json").write_text(json.dumps(fonts, indent=2) + "\n", encoding="utf-8")
    cases = "\n".join(
        f'            case "{identity}": {{name: {json.dumps(record["name"])}, style: "{record["style"]}"}};'
        for identity, record in sorted(fonts.items()))
    (root / "EmbeddedFontCatalog.hx").write_text(
        "package skyhaxe.assets;\n\n"
        "/** Generated from the update candidate's pinned FontAsset declarations; HabboText renders them. */\n"
        "class EmbeddedFontCatalog {\n"
        "    public static function metadataFor(className:String):{name:String, style:String} {\n"
        "        return switch (className) {\n" + cases + "\n"
        "            default: throw new haxe.Exception('Unregistered embedded font class: ' + className);\n"
        "        };\n    }\n}\n", encoding="utf-8", newline="\n")
    emit_xml(output / "embedded-assets.xml", asset_xml)
    emit_xml(output / "component-library-assets.xml", component_xml)
    print(json.dumps({"embedded": len(records), "fonts": len(fonts), "component_owners": len(component),
                      "component_assets": len(component_xml)}, indent=2))
    return 0


if __name__ == "__main__": raise SystemExit(main())
