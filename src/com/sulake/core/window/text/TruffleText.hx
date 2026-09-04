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
	/** Set once `load` resolves. Null means "not ready" -- callers fall back to `TextField`. */
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
			return api.ensureStyles(styles).then(function(_) return api);
		}).then(function(api:Dynamic) {
			instance = new TruffleText(api);
			onReady();
			return null;
		}).catchError(function(error:Dynamic) {
			onError(error);
		});
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
