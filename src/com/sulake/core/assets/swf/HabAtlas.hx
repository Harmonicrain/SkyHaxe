package com.sulake.core.assets.swf;

import com.sulake.core.assets.swf.SwfBitmap.SwfPixels;
import haxe.io.Bytes;
#if (js && html5)
import lime.app.Future;
#end

/**
 * One atlas PNG of a .hab bundle. Decoded once (in the worker pool when possible), then sliced
 * per exported bitmap by `HabFrame`. The decoded pixels are dropped as soon as every frame of the
 * atlas has been cut out, so a library does not keep its whole sheet alive afterwards.
 */
class HabAtlas {
	public final name:String;
	final png:Bytes;
	var decoded:Null<SwfPixels>;
	var frames = 0;
	var cut = 0;
	#if (js && html5)
	var pending:Null<Future<SwfPixels>>;
	#end

	public function new(name:String, png:Bytes) {
		this.name = name;
		this.png = png;
	}

	public function addFrame():Void frames++;

	public var isDecoded(get, never):Bool;
	function get_isDecoded():Bool return decoded != null;

	/** Pixels now, decoding on this thread if the worker has not already done it. */
	public function pixels():SwfPixels {
		if (decoded == null) {
			#if (js && html5)
			var started = js.Browser.window.performance.now();
			#end
			decoded = HabPng.decode(png);
			#if (js && html5)
			SwfLoadMetrics.count("habAtlasSyncDecodes");
			SwfLoadMetrics.add("habAtlasSyncDecodeMs", js.Browser.window.performance.now() - started);
			#end
		}
		return decoded;
	}

	#if (js && html5)
	public function pixelsAsync():Future<SwfPixels> {
		if (decoded != null) return Future.withValue(decoded);
		if (pending == null) {
			var started = js.Browser.window.performance.now();
			pending = SwfDecodeWorkerPool.decodePng(png, function() return HabPng.decode(png)).then(function(result) {
				if (decoded == null) decoded = result;
				SwfLoadMetrics.count("habAtlasDecodes");
				SwfLoadMetrics.add("habAtlasDecodeWallMs", js.Browser.window.performance.now() - started);
				return Future.withValue(decoded);
			});
		}
		return pending;
	}
	#end

	/** Called after a frame has been copied out; frees the sheet once all frames have been. */
	public function frameCut():Void {
		if (++cut >= frames) {
			decoded = null;
			#if (js && html5)
			pending = null;
			#end
			cut = 0;
		}
	}
}
