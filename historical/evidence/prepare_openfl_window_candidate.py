"""Reproducible, isolated OpenFL HTML5 window fixes; never edits the installed library."""
import hashlib
import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
SOURCE = REPO / ".haxelib/openfl/9,5,2/src"
TARGET = REPO / ".toolchain/v21/openfl"

PATCHES = {
    "openfl/text/_internal/TextEngine.hx": {
        "sha256": "2327d18d73fcbd5c1f678864b211eb8dd90351d734bc5d98d55f4475fac65af4",
        "edits": [
            ("return measureText(text);", "return com.sulake.core.window.text.TruffleText.openFLPositions(textField, currentFormat, text).fold((a, b) -> a + b, 0.0);"),
        ],
    },
    "openfl/text/TextField.hx": {
        "sha256": "99942a9340f005ee8fc7c4be18cdc4117bd0434fca356c0313aed13f07d23687",
        "edits": [
            ("\t@:noCompletion private static var __missingFontWarning:Map<String, Bool> = new Map();", """
	/** Flash glyph-edge thickness. The HTML5 raster path forwards it to Truffle. */
	public var thickness(default, set):Float = 0;
	/** OpenFL has no inline-image loader. An image-free field has no image references;
	    fail explicitly for image markup until that browser boundary is implemented. */
	public function getImageReference(id:String):openfl.display.DisplayObject {
		if (id == null) return null;
		if (~/\\x3cimg\\b/i.match(htmlText))
			throw new haxe.Exception("Inline HTML image references are not yet supported by the window text adapter");
		return null;
	}
	private function set_thickness(value:Float):Float {
		value = Math.max(-200, Math.min(200, value));
		if (thickness != value) {
			thickness = value;
			__layoutDirty = true;
			__dirty = true;
			__setRenderDirty();
		}
		return value;
	}
	@:noCompletion private static var __missingFontWarning:Map<String, Bool> = new Map();"""),
            ("\t@:noCompletion private static var __defaultTextFormat:TextFormat;", """
	/** Flash selection visibility while unfocused. HTML5 Canvas/WebGL platform boundary. */
	public var alwaysShowSelection(default, set):Bool = false;
	private function set_alwaysShowSelection(value:Bool):Bool {
		if (alwaysShowSelection != value) {
			alwaysShowSelection = value;
			__dirty = true;
			__setRenderDirty();
		}
		return value;
	}
	@:noCompletion private static var __defaultTextFormat:TextFormat;"""),
            ("\t\t\t__selectionIndex = __caretIndex;\n\t\t\t__dirty = true;\n\t\t\t__setRenderDirty();\n\t\t}\n\t}\n\n\t@:noCompletion private function this_onKeyDown",
             "\t\t\t// Losing focus hides the selection; it must not destroy the selected range.\n\t\t\t__dirty = true;\n\t\t\t__setRenderDirty();\n\t\t}\n\t}\n\n\t@:noCompletion private function this_onKeyDown"),
        ],
    },
    "openfl/display/_internal/CanvasTextField.hx": {
        "sha256": "4cabda18c92f323fa71b189addf482ec49b84e7de68af9f733ba1832048cf5a3",
        "edits": [
            ("if (textField.__caretIndex > -1 && textEngine.selectable)",
             "if (textField.__caretIndex > -1 && textEngine.selectable\n"
             "                            && ((textField.stage != null && textField.stage.focus == textField) || textField.alwaysShowSelection))"),
            ('context.fillStyle = "#000000";\n\t\t\t\t\t\t\t\t\tcontext.fillRect(start.x',
             'context.fillStyle = (textField.stage != null && textField.stage.focus == textField) ? "#000000" : "#808080";\n\t\t\t\t\t\t\t\t\tcontext.fillRect(start.x'),
        ],
    },
    "openfl/ui/Mouse.hx": {
        "sha256": "adce2e45b56dea1e399f49ac2cf5caa1ddea29c760624c3853012015f8d75324",
        "edits": [],
    },
}


def main():
    prepared = []
    for relative, patch in PATCHES.items():
        source = SOURCE / relative
        digest = hashlib.sha256(source.read_bytes()).hexdigest()
        if digest != patch["sha256"]:
            raise RuntimeError(f"Upstream OpenFL source changed: {relative}; review required")
        text = source.read_text(encoding="utf-8")
        for old, new in patch["edits"]:
            if text.count(old) != 1:
                raise RuntimeError(f"Expected exactly one OpenFL patch target: {relative}: {old[:80]}")
            text = text.replace(old, new)
        if relative.endswith("TextEngine.hx"):
            start = text.index("\t\t\tfunction html5Positions():Array<Float>")
            end = text.index("\t\t\t// TODO: Smarter caching for justify", start)
            text = text[:start] + """
			function html5Positions():Array<Float> {
				// Keep the format-run shaping context when OpenFL measures smaller word chunks.
				return com.sulake.core.window.text.TruffleText.openFLPositions(textField, currentFormat,
					text.substring(formatRange.start, formatRange.end)).slice(startIndex - formatRange.start, endIndex - formatRange.start);
			}
""" + text[end:]
            # The native shape cache is keyed by TextFormat, not AA/thickness. Truffle owns
            # its own full-style cache; do not reuse stale native advances across style changes.
            old_cache = "return __shapeCache.cache(formatRange, html5Positions, text.substring(startIndex, endIndex));"
            if text.count(old_cache) != 1: raise RuntimeError("Text shape cache site changed")
            text = text.replace(old_cache, "return html5Positions();")
            start = text.index("\t\t\tif (currentFormat.__ascent != null)", text.index("function setLineMetrics()"))
            end = text.index("\t\t\tleading = currentFormat.leading;", start)
            text = text[:start] + """
			var metrics = com.sulake.core.window.text.TruffleText.openFLMetrics(textField, currentFormat);
			ascent = metrics.ascent;
			descent = metrics.descent;
""" + text[end:]
            # Avoid an extension import just for summation.
            text = text.replace("return com.sulake.core.window.text.TruffleText.openFLPositions(textField, currentFormat, text).fold((a, b) -> a + b, 0.0);",
                "var total = 0.0; for (advance in com.sulake.core.window.text.TruffleText.openFLPositions(textField, currentFormat, text)) total += advance; return total;")
        if relative.endswith("CanvasTextField.hx"):
            if text.count("context.fillText(") != 2:
                raise RuntimeError("OpenFL text run rendering sites changed")
            text = text.replace("context.fillText(",
                "com.sulake.core.window.text.TruffleText.drawOpenFLRun(textField, context, group.format, ")
        if relative.endswith("openfl/ui/Mouse.hx"):
            text = text.replace("#if !flash\n", """#if !flash
#if html5
import haxe.crypto.Base64;
import js.Browser;
import js.html.CanvasElement;
import openfl.display.PNGEncoderOptions;
#end
""", 1)
            text = text.replace("\t@:noCompletion private static var __hidden:Bool;", """
	@:noCompletion private static var __hidden:Bool;
	@:noCompletion private static var __customCursors:Map<String, String> = new Map();""", 1)
            register_start = text.index("\t#if false\n\t/**\n\t\tRegisters a native cursor")
            register_end = text.index("\t#end", register_start) + len("\t#end")
            text = text[:register_start] + """
	/** Register the first Flash native-cursor frame as an HTML5 CSS cursor. */
	public static function registerCursor(name:String, cursor:MouseCursorData):Void
	{
		if (name == null || cursor == null || cursor.data == null || cursor.data.length == 0)
			throw new haxe.Exception("A custom cursor requires a name and bitmap frame");
		#if html5
		var frame = cursor.data[0];
		var png = frame.encode(frame.rect, new PNGEncoderOptions());
		var encoded = Base64.encode(cast png);
		var x = cursor.hotSpot == null ? 0 : Std.int(cursor.hotSpot.x);
		var y = cursor.hotSpot == null ? 0 : Std.int(cursor.hotSpot.y);
		__customCursors.set(name, 'url("data:image/png;base64,$encoded") $x $y, auto');
		#else
		throw new haxe.Exception("Custom bitmap cursors are only available on the HTML5 target");
		#end
	}
""" + text[register_end:]
            unregister_start = text.index("\t#if false\n\t/**\n\t\tUnregisters the native cursor")
            unregister_end = text.index("\t#end", unregister_start) + len("\t#end")
            text = text[:unregister_start] + """
	public static function unregisterCursor(name:String):Void
	{
		if (__cursor == name) cursor = MouseCursor.AUTO;
		__customCursors.remove(name);
	}
""" + text[unregister_end:]
            setter_anchor = "\t\tif (value == null) value = AUTO;\n"
            text = text.replace(setter_anchor, setter_anchor + """

		#if html5
		if (__customCursors.exists(cast value))
		{
			var canvas:CanvasElement = cast Browser.document.querySelector("canvas");
			if (canvas != null) canvas.style.cursor = __customCursors.get(cast value);
			return __cursor = value;
		}
		#end
""", 1)
        prepared.append((relative, text, digest))
    evidence = []
    for relative, text, digest in prepared:
        target = TARGET / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        if not target.exists() or target.read_text(encoding="utf-8") != text:
            target.write_text(text, encoding="utf-8", newline="\n")
        evidence.append({"source": (SOURCE / relative).relative_to(REPO).as_posix(),
                         "source_sha256": digest, "candidate": target.relative_to(REPO).as_posix(),
                         "candidate_sha256": hashlib.sha256(target.read_bytes()).hexdigest()})
    cursor_data = TARGET / "openfl/ui/MouseCursorData.hx"
    cursor_data.parent.mkdir(parents=True, exist_ok=True)
    cursor_data.write_text("""package openfl.ui;

import openfl.display.BitmapData;
import openfl.geom.Point;

/** Flash native-cursor data contract implemented by the HTML5 Mouse candidate adapter. */
class MouseCursorData {
    public var data:Vector<BitmapData>;
    public var frameRate:Float = 0;
    public var hotSpot:Point = new Point();
    public function new() {}
}
""", encoding="utf-8", newline="\n")
    evidence.append({"source": None, "source_sha256": None,
                     "candidate": cursor_data.relative_to(REPO).as_posix(),
                     "candidate_sha256": hashlib.sha256(cursor_data.read_bytes()).hexdigest()})
    (REPO / "evidence/openfl_window_candidate.json").write_text(json.dumps({
        "ok": True, "scope": "candidate only; not installed OpenFL or production", "files": evidence,
        "contracts": ["test/V21SelectionTest.hx", "test/V21ThicknessTest.hx", "project.compile-all.xml"],
        "limitations": ["Canvas/WebGL; DOM renderer not adapted", "Inline HTML images fail explicitly; loader not implemented",
                        "Wrapped/mixed-style metrics still need Flash reference tests"]
    }, indent=2) + "\n", encoding="utf-8")
    print("OPENFL_WINDOW_CANDIDATE_READY files=" + str(len(prepared)))


if __name__ == "__main__":
    main()
