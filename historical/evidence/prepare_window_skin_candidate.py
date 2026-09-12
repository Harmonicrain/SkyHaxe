"""Package the original window component's Embed table for the runtime canary.

Read-only source/asset inputs. This is packaging, not a second skin/parser implementation.
"""
from pathlib import Path
import hashlib
import json
import re
import xml.etree.ElementTree as ET

REPO = Path(__file__).resolve().parents[1]
CLIENT = Path(r"C:\habbo\client\habbo-client-clean\src")


def prepare(component="HabboWindowManagerCom", prefix="window-service", directory="v21", stem="window", evidence_name="window_skin_candidate"):
    source = CLIENT / (component + ".as")
    pattern = r'\[Embed\(source="([^"]+)"[^\]]*\)\]\s*public static (?:var|const) (\w+):Class;'
    entries = re.findall(pattern, source.read_text(encoding="utf-8-sig"))
    root = ET.Element("project")
    records = {}
    for relative, name in entries:
        asset = (CLIENT / relative).resolve()
        asset.relative_to(CLIENT.resolve())
        identity = prefix + "/" + name + asset.suffix
        records[name] = {"id": identity, "source": asset.as_posix(), "sha256": hashlib.sha256(asset.read_bytes()).hexdigest(),
                         "image": asset.suffix.lower() in (".png", ".jpg", ".jpeg", ".gif")}
        ET.SubElement(root, "assets", path=asset.as_posix(), rename=identity,
                      type="image" if records[name]["image"] else "text")
    output = REPO / ".toolchain" / directory / (stem + "-assets.json")
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(records, indent=2) + "\n", encoding="utf-8")
    ET.SubElement(root, "assets", path=output.as_posix(), rename=prefix + "/assets.json", type="text")
    ET.indent(root)
    (output.parent / (stem + "-assets.xml")).write_text(ET.tostring(root, encoding="unicode") + "\n", encoding="utf-8")
    (REPO / "evidence" / (evidence_name + ".json")).write_text(json.dumps({
        "component": source.as_posix(), "component_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "assets": records, "note": "Asset packaging only; not window initialization or pixel parity evidence."
    }, indent=2) + "\n", encoding="utf-8")
    print(f"{component} resources: {len(records)} original embedded files")


if __name__ == "__main__":
    prepare()
