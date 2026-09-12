package com.sulake.core.window.text;

import js.Browser;
import js.html.CanvasElement;
import js.lib.Promise;
import js.lib.Uint8ClampedArray;
import openfl.display.BitmapData;

/**
 * Habbo/AIR text rendering, via the `truffle-text` package.
 *
 * OpenFL's `TextField` cannot reproduce the client's typography: the styles in
 * `HabboWindowManagerCom_text_styles_css.bin` are Ubuntu at specific sizes with Flash's
 * `advanced` anti-aliasing, `sharpness: 80` and `thickness: -15`, and a browser `TextField`
 * renders none of that. Truffle ships those fonts with HarfBuzz shaping and FreeType hinting, and
 * -- usefully -- names its styles exactly as the client's stylesheet does (`u_regular`,
 * `u_frame_title`, `u_small`, ...), so layout `text_style` values map straight through.
 *
 * Two things this is used for, and they must agree:
 *   * `measureWidth` feeds the button auto-size rule. A button sized from `_sans` metrics is the
 *     wrong width no matter how correct the rule is.
 *   * `render` produces the pixels actually shown.
 *
 * Loading is asynchronous (WASM plus fetched font and raster payloads), so a page must `load`
 * before parsing any layout. Everything after that is synchronous.
 */
class TruffleText {
	/** Set once `load` resolves. Null means not ready: load before layout, never silently fall back. */
	public static var instance(default, null):Null<TruffleText>;

	final api:Dynamic;

	function new(api:Dynamic) {
		this.api = api;
	}

	/**
	 * Import the bundle and warm the styles the page will use.
	 *
	 * `styles` is passed up front because the packed loader fetches raster chunks per style; the
	 * payload holds far more than any one window needs, and leaving it lazy would mean the first
	 * `measureWidth` call could not answer synchronously.
	 */
	public static function load(base:String, styles:Array<String>, onReady:Void->Void,
			onError:Dynamic->Void):Void {
		if (instance != null) {
			onReady();
			return;
		}
		var moduleUrl = base + "/lib/truffle.js";
		// The import is built rather than written, because `-final` runs the bundle through
		// Google Closure and the compiler.jar lime ships cannot parse a dynamic `import()`:
		// it fails the production build outright, and lime passes no --language_in for us to
		// raise. Constructing the function keeps the runtime behaviour identical -- this is a
		// real ES module import, not a fetch -- while leaving Closure nothing to choke on.
		var importModule:String->Promise<Dynamic> =
			js.Syntax.code("new Function('u', 'return import(u)')");
		var pending = importModule(moduleUrl);
		pending.then(function(module:Dynamic) {
			return module.loadPackedTruffle({base: base, loadCalibration: false});
		}).then(function(api:Dynamic) {
			// The named boot styles already have certified raster chunks. Upstream ensureStyles also
			// enables three legacy fallback tables first, forcing about 50 MiB of JSON through the
			// main thread before HabboMain can start. The bundled boundary exposes this narrower path
			// so Flash-exact baked glyphs remain ready synchronously without loading unrelated tables.
			return api.ensureBakedStyles(styles).then(function(_) return api);
		}).then(function(api:Dynamic) {
			instance = new TruffleText(api);
			onReady();
			return null;
		}).catchError(function(error:Dynamic) {
			onError(error);
		});
	}

	/** Coverage from the loaded font program; never use Lime's null-returning HTML5 glyph API. */
	public static function fontHasGlyphs(font:openfl.text.Font, text:String):Bool {
		if (font == null || text == null) throw new haxe.Exception("Font.hasGlyphs requires a font and text");
		if (text.length == 0) return true;
		// A face the browser draws has no coverage table to consult here. Reporting it as covered
		// leaves the text alone, which is what Flash did for a font that has the glyphs; the
		// alternative is substituting characters that would have rendered perfectly well.
		if (!handles(font.fontName)) return true;
		if (instance == null) throw new haxe.Exception("Font coverage requested before TruffleText.load completed");
		var bold = font.fontStyle == openfl.text.FontStyle.BOLD
			|| font.fontStyle == openfl.text.FontStyle.BOLD_ITALIC
			|| familyImpliesBold(font.fontName);
		var italic = font.fontStyle == openfl.text.FontStyle.ITALIC || font.fontStyle == openfl.text.FontStyle.BOLD_ITALIC;
		var family:String = null;
		var families:Array<String> = instance.api.registry.families();
		for (candidate in families)
			if (sameFamily(candidate, font.fontName)) family = candidate;
		// Coverage must come from the requested face, not the registry's regular-weight fallback.
		var face:Dynamic = family == null ? null : instance.api.registry.getExact(family, bold, italic);
		if (face == null) throw new haxe.Exception('Font coverage unavailable for ${font.fontName} (${font.fontStyle})');
		for (codePoint in new haxe.iterators.StringIteratorUnicode(text))
			if (face.glyphId(codePoint) == 0) return false;
		return true;
	}

	/** All candidate OpenFL text runs rasterize through Truffle, including input/normal AA. */
	/**
	 * Whether two font family names refer to the same face.
	 *
	 * The client's text styles name the face the way Flash did -- "Ubuntu condensed" -- while the
	 * packed bundle registers it as "UbuntuCondensed". Comparing case-insensitively alone leaves
	 * the space, so the lookup missed and the unmatched name reached Truffle, which refuses to
	 * measure a family it has not registered and brought the room down with it.
	 */
	/**
	 * Whether a family name carries its own weight, as Flash's embedded faces do.
	 *
	 * Each `[Embed]` registered a distinct family per weight -- `fonts._Str_10339` is "Volter Bold"
	 * with style *regular* -- while the packed bundle keys that same family's faces as bold. Asking
	 * for "Volter Bold" non-bold therefore matches the family but no face, and the lookup throws
	 * rather than falling back.
	 */
	static function familyImpliesBold(family:String):Bool {
		var name = StringTools.replace(family, " ", "").toLowerCase();
		return StringTools.endsWith(name, "bold");
	}

	/**
	 * Whether Truffle owns this family, or the browser draws it itself.
	 *
	 * Truffle exists for the client's Ubuntu text, where Flash's rasterisation has to be matched
	 * exactly. Volter is a plain pixel face registered as an ordinary CSS font, so it goes through
	 * OpenFL's normal text path -- and asking Truffle about it fails outright, because the bundle
	 * keys "Volter Bold" only as a bold face while the client registers it as a regular one.
	 */
	public static function handles(family:String):Bool {
		if (family == null) return false;
		return StringTools.startsWith(StringTools.replace(family, " ", "").toLowerCase(), "ubuntu");
	}

	static function sameFamily(a:String, b:String):Bool {
		return StringTools.replace(a, " ", "").toLowerCase()
			== StringTools.replace(b, " ", "").toLowerCase();
	}

	/**
	 * The font a `TextField` carries when nothing set one.
	 *
	 * `TextField.__defaultTextFormat` is `new TextFormat("Times New Roman", 12, ...)`, which is
	 * the Flash player default OpenFL reproduces exactly. The player shipped that face, so in
	 * Flash it always resolved; here nothing registers it and Truffle refuses the name.
	 */
	static inline final FLASH_DEFAULT_FONT = "Times New Roman";

	/** Reported once per family, so a warning cannot be lost in the embed system's log volume. */
	static final substitutedFamilies = new Map<String, Bool>();

	/**
	 * Give the Flash player default a face that exists here.
	 *
	 * Converted code inherits Flash's guarantee that every `TextField` has a usable font, and
	 * relies on it in places that never draw. `friendbar.view.utils.TextCropper` is the one that
	 * found this: it keeps a `TextField` off the display list purely to measure a name, and
	 * because `setTextFormat` runs before `text` is assigned, the measurement falls back to
	 * `defaultTextFormat` -- so the *ruler* asks for Times New Roman while the *visible* name is
	 * drawn by the window toolkit in Ubuntu. Flash measured it in the wrong face and produced a
	 * slightly wrong ellipsis position, which nobody noticed. Truffle throws instead, the
	 * exception escapes the `FriendBarUpdateEvent` handler, and the layout that would have
	 * right-aligned the bar never runs.
	 *
	 * Only the player default is substituted. An unregistered family that some code asked for
	 * deliberately still throws, because that is a real mistake and the throw is what surfaced
	 * this one -- and Volter, which the browser draws itself, must keep reaching its own path
	 * rather than being quietly redrawn in Ubuntu.
	 *
	 * The substitute comes from the registered set, never from a system font: the standing rule
	 * bans silent browser fallback because it renders the wrong glyphs, and this stays inside the
	 * faces the client ships.
	 */
	static function substituteDefaultFont(families:Array<String>):Null<String> {
		// `handles` is what decides Truffle owns a family at all, and a bold-keyed family answers
		// no regular face, so an unfiltered first entry can be as unusable as the name it replaces.
		var chosen = null;
		for (candidate in families)
			if (handles(candidate) && !familyImpliesBold(candidate)) { chosen = candidate; break; }
		if (chosen == null) return null;
		if (!substitutedFamilies.exists(chosen)) {
			substitutedFamilies.set(chosen, true);
			Browser.console.warn('TruffleText: a TextField carried the Flash default "'
				+ FLASH_DEFAULT_FONT + '", which is not registered here; using "' + chosen
				+ '". The caller never set a font -- see TruffleText.substituteDefaultFont.');
		}
		return chosen;
	}

	public static function openFLStyle(field:openfl.text.TextField, format:openfl.text.TextFormat):Dynamic {
		if (instance == null) throw new haxe.Exception("Text layout requested before TruffleText.load completed");
		var family = format.font;
		var families:Array<String> = instance.api.registry.families();
		if (family != null && sameFamily(family, FLASH_DEFAULT_FONT)) {
			var substitute = substituteDefaultFont(families);
			if (substitute != null) family = substitute;
		}
		for (candidate in families) if (sameFamily(candidate, family)) family = candidate;
		return {fontFamily: family, size: format.size, color: format.color,
			bold: format.bold == true || familyImpliesBold(family), italic: format.italic == true,
			antiAliasType: Std.string(field.antiAliasType), gridFitType: Std.string(field.gridFitType),
			sharpness: field.antiAliasType == openfl.text.AntiAliasType.ADVANCED ? field.sharpness : 0,
			thickness: field.antiAliasType == openfl.text.AntiAliasType.ADVANCED ? Reflect.getProperty(field, "thickness") : 0,
			kerning: format.kerning == true, letterSpacing: format.letterSpacing == null ? 0 : format.letterSpacing};
	}

	public static function openFLPositions(field:openfl.text.TextField, format:openfl.text.TextFormat, text:String):Array<Float> {
		if (text == "") return [];
		var layout:Dynamic = instance.api.measure(text, openFLStyle(field, format), {});
		var bounds:Array<Dynamic> = layout.charBounds;
        return [for (index in 0...text.length) bounds[index] == null ? 0.0 : (cast bounds[index].width : Float)];
	}

	public static function openFLMetrics(field:openfl.text.TextField, format:openfl.text.TextFormat):Dynamic {
		return instance.api.measure("M", openFLStyle(field, format), {}).metrics;
	}

	/** All candidate OpenFL text runs rasterize through Truffle, including input/normal AA. */
	public static function drawOpenFLRun(field:openfl.text.TextField, context:js.html.CanvasRenderingContext2D,
			format:openfl.text.TextFormat, text:String, x:Float, baseline:Float):Void {
		if (text == "") return;
		if (instance == null) throw new haxe.Exception("Text rendering requested before TruffleText.load completed");
		var fill = Std.string(context.fillStyle);
		var color = fill.charAt(0) == "#" ? Std.parseInt("0x" + fill.substring(1)) : format.color;
		var style = openFLStyle(field, format);
		style.color = color;
		var buffer:Dynamic = instance.api.renderToBuffer(text, style, {});
		if (buffer.width <= 0 || buffer.height <= 0) return;
		var surface = Browser.document.createCanvasElement();
		surface.width = buffer.width;
		surface.height = buffer.height;
		var ctx = surface.getContext2d();
		var pixels = ctx.createImageData(buffer.width, buffer.height);
		pixels.data.set(cast buffer.data);
		ctx.putImageData(pixels, 0, 0);
		// Truffle buffers include Flash's two-pixel text gutter. Align its measured baseline
		// to the existing OpenFL run origin; drawImage retains the renderer's clip/transform.
		context.drawImage(surface, x - 2, baseline - buffer.layout.lines[0].baseline);
	}

	/** Advance width of `text`, in the same style `render` will draw it. */
	public function measureWidth(text:String, style:Dynamic, ?opts:Dynamic):Float {
		if (text == "") return 0;
		return api.measure(text, style, options(opts)).textWidth;
	}

	public function measureHeight(text:String, style:Dynamic, ?opts:Dynamic):Float {
		if (text == "") return 0;
		return api.measure(text, style, options(opts)).textHeight;
	}

	/**
	 * Rasterise `text` into a `BitmapData`.
	 *
	 * Truffle returns straight RGBA in a `Uint8ClampedArray`. That goes through an `ImageData` on
	 * a scratch canvas rather than `setPixels`, because `setPixels` expects OpenFL's own channel
	 * order and the canvas path cannot get it wrong.
	 */
	public function render(text:String, style:Dynamic, ?opts:Dynamic):Null<BitmapData> {
		if (text == "") return null;
		var buffer:Dynamic = api.renderToBuffer(text, style, options(opts));
		var width:Int = buffer.width;
		var height:Int = buffer.height;
		if (width <= 0 || height <= 0) return null;

		// A fresh canvas per caption: `BitmapData.fromCanvas` wraps the canvas rather than copying
		// it, so a shared scratch canvas leaves every caption showing whatever was drawn last.
		var surface:CanvasElement = Browser.document.createCanvasElement();
		surface.width = width;
		surface.height = height;
		var context = surface.getContext2d();
		var pixels:Uint8ClampedArray = buffer.data;
		var image = context.createImageData(width, height);
		image.data.set(pixels);
		context.putImageData(image, 0, 0);
		return BitmapData.fromCanvas(surface);
	}

	/**
	 * Truffle reads fields off the options object directly, so an explicit `null` -- which Haxe
	 * passes for an omitted optional -- throws rather than falling back to its defaults.
	 */
	static inline function options(opts:Dynamic):Dynamic {
		return opts == null ? {} : opts;
	}

	/** Style object for Truffle: a catalog name plus the per-window overrides the layout carries. */
	public static function style(name:String, color:Int, ?size:Null<Int>):Dynamic {
		var result:Dynamic = {styleName: name, color: color};
		if (size != null) result.size = size;
		return result;
	}
}
