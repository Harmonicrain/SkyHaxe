package com.sulake.core.window.theme;

import com.sulake.core.utils.xml.XML;
import haxe.ds.StringMap;

/**
 * The `habbo_window_layout_*` documents, keyed by the name the element table refers to them by.
 *
 * A control's visible structure is not written in code. `button_shiny_thick`'s internal layout is
 * a single `_BTN_TEXT` label carrying `text_style="button_shiny_bold"` and 10px left/right
 * margins; `header_3`'s is a container holding a centred `_TITLE` label plus help and close
 * buttons. Roughly thirty of these ship with the client and they use the same `<layout><window>`
 * schema as application layouts, so the existing parser reads them unchanged.
 *
 * Registration is left to the host: SkyHaxe pages package these as OpenFL assets, and the real
 * client embeds them, but neither detail belongs in the window toolkit.
 */
class InternalLayouts {
	static var documents:StringMap<XML> = new StringMap();

	public static var count(default, null):Int = 0;

	public static function register(name:String, xml:XML):Void {
		if (!documents.exists(name)) count++;
		documents.set(name, xml);
	}

	public static function find(name:Null<String>):Null<XML> {
		return name == null ? null : documents.get(name);
	}

	public static function clear():Void {
		documents = new StringMap();
		count = 0;
	}
}
