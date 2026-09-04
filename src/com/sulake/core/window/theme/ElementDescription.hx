package com.sulake.core.window.theme;

import com.sulake.core.utils.xml.XML;
import haxe.ds.StringMap;

/** One `<window>` row of the element-description table. */
typedef ElementEntry = {
	var type:String;
	var intent:String;
	var style:Int;
	var ?renderer:String;
	var ?asset:String;
	/** Name of the bitmap-slicing layout inside the skin XML. */
	var ?layout:String;
	/** Name of the internal *window* layout that supplies this control's child windows. */
	var ?windowLayout:String;
	var ?color:Null<Int>;
	var ?threshold:Null<Int>;
	var ?widthMin:Null<Float>;
	var ?heightMin:Null<Float>;
	var ?background:Bool;
}

/**
 * The client's control theme, read from `habbo_element_description_xml.bin`.
 *
 * This is the table that says what a control *is*: which skin asset draws it, which bitmap layout
 * slices that asset, and -- the part that matters most here -- which internal window layout
 * supplies its child windows.
 *
 *     <window type="button_thick" intent="default" style="3"
 *             asset="habbo_skin_button_shiny_thick_xml"
 *             window_layout="habbo_window_layout_button_shiny_thick_xml"
 *             layout="button_shiny_thick" />
 *
 * 332 rows ship with the client. Reading them is why a button knows it is bold and a frame title
 * knows it is centred: those facts live in the internal layouts this table points at, not in the
 * renderer. Hardcoding them per control was how the port ended up with a too-wide, non-bold
 * button and a left-aligned title.
 */
class ElementDescription {
	static var entries:StringMap<ElementEntry> = new StringMap();
	static var loaded = false;

	public static var rowCount(default, null):Int = 0;

	public static function load(xml:XML):Void {
		entries = new StringMap();
		rowCount = 0;
		for (node in xml.children()) {
			if (node.localName() != "window") continue;
			var type = attribute(node, "type");
			if (type == null) continue;
			var entry:ElementEntry = {
				type: type,
				intent: attribute(node, "intent") == null ? "default" : attribute(node, "intent"),
				style: intAttribute(node, "style", 0),
				renderer: attribute(node, "renderer"),
				asset: attribute(node, "asset"),
				layout: attribute(node, "layout"),
				windowLayout: attribute(node, "window_layout"),
				color: optionalInt(node, "color"),
				threshold: optionalInt(node, "treshold"),
				widthMin: optionalFloat(node, "width_min"),
				heightMin: optionalFloat(node, "height_min"),
				background: attribute(node, "background") == "true",
			};
			// Later rows win, matching a linear scan that keeps the last match.
			entries.set(key(entry.type, entry.style), entry);
			rowCount++;
		}
		loaded = true;
	}

	public static function isLoaded():Bool return loaded;

	/**
	 * The entry for a control, or null.
	 *
	 * Keyed by type and style only. `intent` is a human label in the shipped data -- the same
	 * style number never carries two intents for one type -- so it is recorded but not matched on.
	 */
	public static function find(type:String, style:Int):Null<ElementEntry> {
		var direct = entries.get(key(type, style));
		if (direct != null) return direct;
		return entries.get(key(type, 0));
	}

	static inline function key(type:String, style:Int):String return type + "|" + style;

	static function attribute(xml:XML, name:String):Null<String> {
		var value = xml.attribute(name);
		return value.length() == 0 ? null : value.toString();
	}

	static function intAttribute(xml:XML, name:String, fallback:Int):Int {
		var raw = attribute(xml, name);
		if (raw == null) return fallback;
		var parsed = Std.parseInt(raw);
		return parsed == null ? fallback : parsed;
	}

	static function optionalInt(xml:XML, name:String):Null<Int> {
		var raw = attribute(xml, name);
		return raw == null ? null : Std.parseInt(raw);
	}

	static function optionalFloat(xml:XML, name:String):Null<Float> {
		var raw = attribute(xml, name);
		if (raw == null) return null;
		var parsed = Std.parseFloat(raw);
		return Math.isNaN(parsed) ? null : parsed;
	}
}
