package com.sulake.core.assets.swf;

import com.sulake.core.assets.swf.SwfBitmap.SwfPixels;
import haxe.io.Bytes;
#if (js && html5)
import lime.app.Future;
#end

/**
 * One exported bitmap inside a .hab atlas (a Pixi spritesheet frame).
 *
 * Atlases are trimmed: `x/y/w/h` is the opaque rectangle in the sheet, and `offsetX/offsetY` put
 * it back inside the original `sourceWidth` x `sourceHeight` bitmap, so the BitmapData handed to
 * the engine has exactly the SWF symbol's size and registration.
 */
class HabFrame {
	final atlas:HabAtlas;
	final x:Int;
	final y:Int;
	final w:Int;
	final h:Int;
	final offsetX:Int;
	final offsetY:Int;
	public final sourceWidth:Int;
	public final sourceHeight:Int;

	public function new(atlas:HabAtlas, x:Int, y:Int, w:Int, h:Int, offsetX:Int, offsetY:Int,
			sourceWidth:Int, sourceHeight:Int) {
		this.atlas = atlas;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.sourceWidth = sourceWidth;
		this.sourceHeight = sourceHeight;
		atlas.addFrame();
	}

	public function pixels():SwfPixels {
		return cut(atlas.pixels());
	}

	#if (js && html5)
	public function pixelsAsync():Future<SwfPixels> {
		return atlas.pixelsAsync().then(function(sheet) return Future.withValue(cut(sheet)));
	}
	#end

	function cut(sheet:SwfPixels):SwfPixels {
		var out = Bytes.alloc(sourceWidth * sourceHeight * 4);   // zero-filled: transparent margins
		var rowBytes = w * 4;
		for (row in 0...h) {
			out.blit(((offsetY + row) * sourceWidth + offsetX) * 4, sheet.rgba,
				((y + row) * sheet.width + x) * 4, rowBytes);
		}
		atlas.frameCut();
		return {width: sourceWidth, height: sourceHeight, rgba: out};
	}
}
