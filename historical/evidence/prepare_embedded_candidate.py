"""Translate AS3 Embed declarations into pinned, preloaded OpenFL candidate assets.

Data wrappers are adapted. Font wrappers retain their original family/style identity while all
glyph measurement and rasterization remains owned by Truffle. Their consumers remain converter
output.
"""
import hashlib
import json
from pathlib import Path
import re
import xml.etree.ElementTree as ET

REPO = Path(__file__).resolve().parents[1]
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")


def main():
    closure = json.loads((REPO / "evidence/v31_full_client_candidate_closure.json").read_text())
    loading = REPO / "evidence/v33_loading_screen_closure.json"
    if loading.is_file():
        extra = json.loads(loading.read_text(encoding="utf-8"))
        closure["closure"] = sorted(set(closure["closure"] + extra["closure"]))
        closure["context"] = sorted(set(closure["context"] + extra.get("context", [])))
    records = {}
    fonts = {}
    project = ET.Element("project")
    for relative in sorted(set(closure["closure"] + closure["context"])):
        source = CLIENT / relative
        text = source.read_text(encoding="utf-8-sig")
        embed = re.search(r'\[Embed\(source="([^"]+)"[^\]]*\)\]', text)
        if not embed:
            continue
        kind = re.search(r"extends (ByteArrayAsset|BitmapAsset|FontAsset)\b", text)
        if not kind:
            # Component-library document roots carry their own embedded asset tables. They are
            # not data wrapper classes and are handled by the component asset-library loader.
            if re.search(r"extends SimpleApplication\b", text):
                continue
            raise RuntimeError(f"Unsupported Embed class: {relative}")
        asset = (source.parent / embed[1]).resolve()
        asset.relative_to(CLIENT.resolve())  # Never allow an Embed to escape the source tree.
        identity = relative[:-3].replace("/", ".")
        asset_id = "skyhaxe/embed/" + relative[:-3] + asset.suffix
        record = {"source": source.as_posix(), "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
                  "asset": asset.as_posix(), "asset_sha256": hashlib.sha256(asset.read_bytes()).hexdigest(),
                  "kind": kind[1], "id": asset_id}
        if kind[1] == "FontAsset":
            name = re.search(r'(?:fontName|fontFamily)="([^"]+)"', embed[0])
            weight = re.search(r'fontWeight="([^"]+)"', embed[0])
            style = re.search(r'fontStyle="([^"]+)"', embed[0])
            if name is None:
                raise RuntimeError(f"Embedded font has no family/name: {relative}")
            bold = weight is not None and weight[1].lower() == "bold"
            italic = style is not None and style[1].lower() == "italic"
            records_style = "boldItalic" if bold and italic else "bold" if bold else "italic" if italic else "regular"
            fonts[identity] = {**record, "name": name[1], "style": records_style}
            continue
        records[identity] = record
        ET.SubElement(project, "assets", path=record["asset"], rename=asset_id,
                      type="image" if kind[1] == "BitmapAsset" else "binary")
    target = REPO / ".toolchain/v21/embedded-assets.xml"
    target.parent.mkdir(parents=True, exist_ok=True)
    ET.indent(project)
    target.write_text(ET.tostring(project, encoding="unicode") + "\n", encoding="utf-8")
    (REPO / "evidence/embedded_candidate.json").write_text(json.dumps(records, indent=2) + "\n", encoding="utf-8")
    catalog = REPO / ".toolchain/v21/openfl/skyhaxe/assets/EmbeddedFontCatalog.hx"
    catalog.parent.mkdir(parents=True, exist_ok=True)
    cases = "\n".join(
        f'            case "{identity}": {{name: "{record["name"]}", style: "{record["style"]}"}};'
        for identity, record in sorted(fonts.items()))
    catalog.write_text(
        "package skyhaxe.assets;\n\n"
        "/** Generated from hash-pinned AS3 FontAsset Embed declarations. */\n"
        "class EmbeddedFontCatalog {\n"
        "    public static function metadataFor(className:String):{name:String, style:String} {\n"
        "        return switch (className) {\n" + cases + "\n"
        "            default: throw new haxe.Exception('Unregistered embedded font class: ' + className);\n"
        "        };\n"
        "    }\n"
        "}\n", encoding="utf-8", newline="\n")
    (REPO / "evidence/embedded_font_candidate.json").write_text(
        json.dumps(fonts, indent=2) + "\n", encoding="utf-8")
    print(f"Embedded candidate: {len(records)} data assets and {len(fonts)} Truffle font identities; source and content hashes pinned")


if __name__ == "__main__":
    main()
