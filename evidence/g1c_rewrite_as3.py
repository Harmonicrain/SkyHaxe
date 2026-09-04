#!/usr/bin/env python3
"""Apply measured, repeatable ax3 pre-conversion rewrites to a copied AS3 canary."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def replace_exact(path: Path, old: str, new: str, expected: int, rule: str) -> dict:
    content = path.read_text(encoding="utf-8-sig")
    actual = content.count(old)
    if actual != expected:
        raise ValueError(f"{path}: {rule}: expected {expected} matches, found {actual}")
    path.write_text(content.replace(old, new), encoding="utf-8", newline="\n")
    return {"rule": rule, "file": path.as_posix(), "replacements": actual}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path, help="Copied canary root; never the clean-client tree")
    parser.add_argument("--json", type=Path)
    args = parser.parse_args()

    root = args.source.resolve()
    if "SkyHaxe/.toolchain/g1c" not in root.as_posix():
        raise ValueError(f"refusing to rewrite outside SkyHaxe/.toolchain/g1c: {root}")

    changes = []
    changes.append(
        replace_exact(
            root / "com/sulake/core/assets/AssetLibrary.as",
            "            var content:ByteArray\n",
            "            var content:ByteArray;\n",
            1,
            "terminate local variable declaration",
        )
    )
    changes.append(
        replace_exact(
            root / "com/sulake/core/assets/AssetLibrary.as",
            '\t\t\tHabbo.trackLoginStep("AssetLibrary:loadErrorHandler: " + this._name + ": " + event.target)\n',
            '\t\t\tHabbo.trackLoginStep("AssetLibrary:loadErrorHandler: " + this._name + ": " + event.target);\n',
            1,
            "terminate expression statement",
        )
    )
    changes.append(
        replace_exact(
            root / "com/sulake/core/runtime/ComponentContext.as",
            "            \tvar requiredDepdencies:Array = []\n",
            "            \tvar requiredDepdencies:Array = [];\n",
            1,
            "terminate initialized local variable declaration",
        )
    )

    asset_library = root / "com/sulake/core/assets/AssetLibrary.as"
    changes.append(
        replace_exact(
            asset_library,
            "                _local_6 = _local_6.child(ASSET);",
            "                _local_6 = XML(_local_6[0]).child(ASSET);",
            2,
            "narrow singleton manifest XMLList before child call",
        )
    )
    changes.append(
        replace_exact(
            asset_library,
            "                manifest = manifest.child(ASSET);",
            "                manifest = XML(manifest[0]).child(ASSET);",
            1,
            "narrow singleton manifest XMLList before child call",
        )
    )
    changes.append(
        replace_exact(
            asset_library,
            "\t\t\tvar typeDeclaration:AssetTypeDeclaration;\n            for (var type:String in this._localListOfTypesByMime)",
            "\t\t\tvar typeDeclaration:AssetTypeDeclaration;\n            var type:String;\n            for (type in this._localListOfTypesByMime)",
            1,
            "hoist for-in variable reused by a later loop",
        )
    )
    for collection_name in ("this._loadedAssets", "this._loadedClasses"):
        changes.append(
            replace_exact(
                asset_library,
                f"            for (name in {collection_name})",
                f"            for (var name:String in {collection_name})",
                1,
                "redeclare function-scoped for-in key for ax3 loop scoping",
            )
        )

    changes.append(
        replace_exact(
            root / "com/sulake/core/communication/messages/MessageClassManager.as",
            "            for (var name:String in messageConfiguration.events)",
            "            var name:String;\n            for each (name in messageConfiguration.events.getKeys())",
            1,
            "iterate custom Map keys through its public getKeys API",
        )
    )
    message_manager = root / "com/sulake/core/communication/messages/MessageClassManager.as"
    for old, new in (
        (
            "            for (name in messageConfiguration.composers)",
            "            for each (name in messageConfiguration.composers.getKeys())",
        ),
        ("messageConfiguration.events[name]", "messageConfiguration.events.getValue(name)"),
        ("messageConfiguration.composers[name]", "messageConfiguration.composers.getValue(name)"),
    ):
        changes.append(
            replace_exact(
                message_manager,
                old,
                new,
                1,
                "use custom Map public API instead of Proxy iteration or indexing",
            )
        )

    component_context = root / "com/sulake/core/runtime/ComponentContext.as"
    changes.append(
        replace_exact(
            component_context,
            "                    assetManifest.library.appendChild(assetList);\n                    assetManifest.library.appendChild(aliasList);",
            "                    XML(assetManifest.child(\"library\")[0]).appendChild(assetList);\n                    XML(assetManifest.child(\"library\")[0]).appendChild(aliasList);",
            1,
            "narrow singleton E4X child list before appendChild calls",
        )
    )

    window_parser = root / "com/sulake/core/window/utils/WindowParser.as"
    for child_name, expected in (("FILTERS", 2), ("PARAMS", 1)):
        changes.append(
            replace_exact(
                window_parser,
                f"xml.child({child_name}).children()",
                f"XML(xml.child({child_name})[0]).children()",
                expected,
                "narrow singleton E4X child list before children call",
            )
        )

    for relative, old, new, expected in (
        (
            "com/sulake/core/assets/XmlAsset.as",
            "(this._unknown as XML)",
            "XML(this._unknown)",
            1,
        ),
        (
            "com/sulake/core/runtime/ComponentContext.as",
            "(source as XML)",
            "XML(source)",
            1,
        ),
        (
            "com/sulake/habbo/window/utils/SkinParserUtil.as",
            "(_local_26.content as XML)",
            "XML(_local_26.content)",
            1,
        ),
        (
            "com/sulake/habbo/window/utils/tableview/TableView.as",
            "(layoutAsset.content as XML)",
            "XML(layoutAsset.content)",
            1,
        ),
        (
            "com/sulake/habbo/window/utils/tableview/TableView.as",
            '(windowManager.assets.getAssetByName("table_view_xml").content as XML)',
            'XML(windowManager.assets.getAssetByName("table_view_xml").content)',
            1,
        ),
    ):
        changes.append(
            replace_exact(
                root / relative,
                old,
                new,
                expected,
                "rewrite unsupported as-XML expression as equivalent XML coercion",
            )
        )

    changes.append(
        replace_exact(
            root / "com/sulake/core/communication/connection/SocketConnection.as",
            "\t\t\ttoProcess = this.splitReceivedMessages();\n            for each (this._lastProcessedMessage in toProcess)\n            {",
            "\t\t\ttoProcess = this.splitReceivedMessages();\n            var processedMessage:IMessageDataWrapper;\n            for each (processedMessage in toProcess)\n            {\n                this._lastProcessedMessage = processedMessage;",
            1,
            "iterate through a local variable before assigning the loop value to a field",
        )
    )

    graphic_assets = root / "com/sulake/room/object/visualization/utils/GraphicAssetCollection.as"
    for map_name in ("_palettes", "_assets"):
        changes.append(
            replace_exact(
                graphic_assets,
                f"                for (k in this.{map_name})",
                f"                for each (k in this.{map_name}.getKeys())",
                1,
                "iterate custom Map keys through its public getKeys API",
            )
        )
    for old, new in (
        ("_local_2 = this._palettes[k];", "_local_2 = this._palettes.getValue(k);"),
        ("_local_3 = this._assets[k];", "_local_3 = this._assets.getValue(k);"),
    ):
        changes.append(
            replace_exact(
                graphic_assets,
                old,
                new,
                1,
                "read custom Map through its public getValue API",
            )
        )

    for relative in (
        "com/sulake/core/assets/BitmapDataAsset.as",
        "com/sulake/core/runtime/Component.as",
        "com/sulake/core/runtime/events/EventDispatcherWrapper.as",
        "com/sulake/core/communication/messages/MessageClassManager.as",
    ):
        changes.append(
            replace_exact(
                root / relative,
                "            super();\n",
                "",
                1,
                "remove redundant Object super call from class with no explicit base",
            )
        )

    component = root / "com/sulake/core/runtime/Component.as"
    for old, new, rule in (
        (
            "this.queueInterface(identifier, function (setter:Function",
            "this.queueInterface(identifier, (function (setter:Function",
            "parenthesize outer immediately-invoked function",
        ),
        (
            "_dependencyDisposalActions.push(function (iid:IID",
            "_dependencyDisposalActions.push((function (iid:IID",
            "parenthesize inner immediately-invoked function",
        ),
        (
            "                    }(identifier, unknown));",
            "                    })(identifier, unknown));",
            "close inner immediately-invoked function before call",
        ),
        (
            "            }(dependencySetter, isRequired, eventListeners, getQualifiedClassName(this)));",
            "            })(dependencySetter, isRequired, eventListeners, getQualifiedClassName(this)));",
            "close outer immediately-invoked function before call",
        ),
    ):
        changes.append(replace_exact(component, old, new, 1, rule))

    alias_collection = root / "com/sulake/habbo/avatar/alias/AssetAliasCollection.as"
    changes.append(
        replace_exact(
            alias_collection,
            '            var _local_5:XML = <alias name="" link="" fliph="0" flipv="0"/>\n',
            '            var _local_5:XML = new XML(\'<alias name="" link="" fliph="0" flipv="0"/>\');\n',
            1,
            "rewrite E4X XML literal as an XML constructor",
        )
    )
    changes.append(
        replace_exact(
            alias_collection,
            "            ;\n            _local_5.@name = k;",
            "            _local_5.@name = k;",
            1,
            "remove semicolon left by decompiled multiline XML literal",
        )
    )

    vector_imports = 0
    vector_wildcard_imports = 0
    namespace_imports = 0
    namespace_uses = 0
    namespace_methods = 0
    for path in root.rglob("*.as"):
        content = path.read_text(encoding="utf-8-sig")
        count = content.count("    import __AS3__.vec.Vector;\n")
        vector_imports += count
        content = content.replace("    import __AS3__.vec.Vector;\n", "")
        count = content.count("    import __AS3__.vec.*;\n")
        vector_wildcard_imports += count
        content = content.replace("    import __AS3__.vec.*;\n", "")

        count = content.count("    import flash.utils.flash_proxy; \n")
        namespace_imports += count
        content = content.replace("    import flash.utils.flash_proxy; \n", "")
        count = content.count("    use namespace flash.utils.flash_proxy;\n")
        namespace_uses += count
        content = content.replace("    use namespace flash.utils.flash_proxy;\n", "")
        count = content.count("override flash_proxy function")
        namespace_methods += count
        content = content.replace("override flash_proxy function", "override public function")
        path.write_text(content, encoding="utf-8", newline="\n")

    expected = {
        "remove explicit Vector imports": (vector_imports, 6),
        "remove wildcard Vector imports": (vector_wildcard_imports, 5),
        "remove flash_proxy imports": (namespace_imports, 5),
        "remove flash_proxy use directives": (namespace_uses, 5),
        "make flash_proxy overrides public": (namespace_methods, 19),
    }
    for rule, (actual, wanted) in expected.items():
        if actual != wanted:
            raise ValueError(f"{rule}: expected {wanted} replacements, found {actual}")
        changes.append({"rule": rule, "file": "<canary corpus>", "replacements": actual})

    report = {"source": root.as_posix(), "rule_count": len(changes), "changes": changes}
    rendered = json.dumps(report, indent=2) + "\n"
    if args.json:
        args.json.write_text(rendered, encoding="utf-8", newline="\n")
    else:
        print(rendered, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
