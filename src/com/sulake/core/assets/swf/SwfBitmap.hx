package com.sulake.core.assets.swf;

import haxe.io.Bytes;
import lime.app.Future;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

/** A decoded bitmap as straight (un-premultiplied) RGBA8888, row-major, 4 bytes per pixel. */
typedef SwfPixels = {
	var width:Int;
	var height:Int;
	var rgba:Bytes;
}

/**
 * `DefineBitsLossless` / `DefineBitsLossless2` decoding -- the zlib bitmap family, 267,507 of the
 * corpus's characters.
 *
 * Two details here are where a reimplementation normally goes wrong, so they are stated rather
 * than implied:
 *
 *  1. Lossless2 stores **premultiplied** alpha. `BitmapData` exposes straight alpha, so the
 *     colour channels are divided back out. Skipping this leaves every semi-transparent edge
 *     visibly too dark, which is easy to miss on a single screenshot and obvious across a room.
 *  2. Scanlines are padded to a 32-bit boundary for the 8-bit and 15-bit formats. Dropping the
 *     padding shears the image progressively -- again fine on a width that happens to be a
 *     multiple of four.
 *
 * The reference implementation in `evidence/g2_reader_contract.py` computes the same contract
 * independently, in Python, and the browser test compares SHA-256 of these bytes against it.
 */
class SwfBitmap {
	/** Convert the reader's straight RGBA contract into OpenFL's ARGB pixel stream. */
	public static function toBitmapData(pixels:SwfPixels):BitmapData {
		var bytes = new ByteArray();
		// Flash/AIR ByteArray defaults to big-endian, but OpenFL follows the host and therefore
		// defaults to little-endian in browsers. BitmapData.setPixels reads ARGB32 according to
		// this flag; leaving it implicit swaps channels and alpha on HTML5.
		bytes.endian = Endian.BIG_ENDIAN;
		var source = pixels.rgba;
		var offset = 0;
		while (offset < source.length) {
			bytes.writeByte(source.get(offset + 3));
			bytes.writeByte(source.get(offset));
			bytes.writeByte(source.get(offset + 1));
			bytes.writeByte(source.get(offset + 2));
			offset += 4;
		}
		bytes.position = 0;
		var bitmap = new BitmapData(pixels.width, pixels.height, true, 0);
		bitmap.setPixels(new Rectangle(0, 0, pixels.width, pixels.height), bytes);
		return bitmap;
	}

	public static function decode(character:SwfCharacter):SwfPixels {
		var payload = character.payload;
		var format = payload.get(2);
		var width = payload.getUInt16(3);
		var height = payload.getUInt16(5);
		var hasAlpha = character.tag == SwfTag.DEFINE_BITS_LOSSLESS2;

		var cursor = 7;
		var tableSize = 0;
		if (format == 3) {
			tableSize = payload.get(cursor) + 1;
			cursor++;
		}
		var data = SwfFile.inflate(payload.sub(cursor, payload.length - cursor), true);
		var rgba = Bytes.alloc(width * height * 4);

		switch (format) {
			case 3:
				decodeColorMapped(data, rgba, width, height, tableSize, hasAlpha);
			case 4:
				decodePix15(data, rgba, width, height);
			case 5:
				decodePix24(data, rgba, width, height, hasAlpha);
			case other:
				throw new SwfError('unsupported lossless bitmap format $other');
		}
		return {width: width, height: height, rgba: rgba};
	}

	/**
	 * Decode any measured bitmap family. Encoded PNG/JPEG payloads use OpenFL's asynchronous
	 * browser image decoder; lossless SWF bitmaps stay on the deterministic synchronous path.
	 */
	public static function decodeAsync(character:SwfCharacter):Future<SwfPixels> {
		if (character.encoding() == "zlib") {
			return Future.withValue(decode(character));
		}
		var encoding = character.encoding();
		if (encoding != "png" && encoding != "jpeg") {
			return cast Future.withError(new SwfError('unsupported embedded image encoding $encoding'));
		}
		var encoded = character.imageData();
		// Old authoring tools sometimes wrote EOI+SOI in front of the real JPEG stream. Flash and
		// PIL ignore it; browsers are less uniform, so normalize it explicitly.
		if (encoding == "jpeg" && encoded.length >= 4 && encoded.get(0) == 0xFF
			&& encoded.get(1) == 0xD9 && encoded.get(2) == 0xFF && encoded.get(3) == 0xD8) {
			encoded = encoded.sub(4, encoded.length - 4);
		}
		var alpha:Null<ByteArray> = null;
		var compressedAlpha = character.alphaData();
		if (compressedAlpha != null) {
			alpha = ByteArray.fromBytes(SwfFile.inflate(compressedAlpha, true));
		}
		return BitmapData.loadFromBytes(ByteArray.fromBytes(encoded), alpha).then(function(bitmap) {
			if (bitmap == null) throw new SwfError('$encoding decoder returned no bitmap');
			var pixels = bitmap.getPixels(new Rectangle(0, 0, bitmap.width, bitmap.height));
			pixels.position = 0;
			var rgba = Bytes.alloc(bitmap.width * bitmap.height * 4);
			var out = 0;
			while (pixels.bytesAvailable >= 4) {
				var alpha = pixels.readUnsignedByte();
				rgba.set(out, pixels.readUnsignedByte());
				rgba.set(out + 1, pixels.readUnsignedByte());
				rgba.set(out + 2, pixels.readUnsignedByte());
				rgba.set(out + 3, alpha);
				out += 4;
			}
			var result:SwfPixels = {width: bitmap.width, height: bitmap.height, rgba: rgba};
			bitmap.dispose();
			return Future.withValue(result);
		});
	}

	static function decodeColorMapped(data:Bytes, rgba:Bytes, width:Int, height:Int,
			tableSize:Int, hasAlpha:Bool):Void {
		var entry = hasAlpha ? 4 : 3;
		var tableBytes = tableSize * entry;
		var stride = (width + 3) & ~3; // indices are one byte, padded to 32 bits
		var out = 0;
		for (y in 0...height) {
			var row = tableBytes + y * stride;
			for (x in 0...width) {
				var base = tableBytes + data.get(row + x) * entry;
				if (hasAlpha) {
					// Colormapped Lossless2 entries are premultiplied RGBA, not ARGB.
					var alpha = data.get(base + 3);
					rgba.set(out, unpremultiply(data.get(base), alpha));
					rgba.set(out + 1, unpremultiply(data.get(base + 1), alpha));
					rgba.set(out + 2, unpremultiply(data.get(base + 2), alpha));
					rgba.set(out + 3, alpha);
				} else {
					rgba.set(out, data.get(base));
					rgba.set(out + 1, data.get(base + 1));
					rgba.set(out + 2, data.get(base + 2));
					rgba.set(out + 3, 255);
				}
				out += 4;
			}
		}
	}

	static function decodePix15(data:Bytes, rgba:Bytes, width:Int, height:Int):Void {
		var stride = (width * 2 + 3) & ~3;
		var out = 0;
		for (y in 0...height) {
			var row = y * stride;
			for (x in 0...width) {
				// Big-endian 0RRRRRGG GGGBBBBB; 5 bits widened to 8 the way Flash does it.
				var value = (data.get(row + x * 2) << 8) | data.get(row + x * 2 + 1);
				rgba.set(out, widen5((value >> 10) & 0x1F));
				rgba.set(out + 1, widen5((value >> 5) & 0x1F));
				rgba.set(out + 2, widen5(value & 0x1F));
				rgba.set(out + 3, 255);
				out += 4;
			}
		}
	}

	static function decodePix24(data:Bytes, rgba:Bytes, width:Int, height:Int, hasAlpha:Bool):Void {
		var out = 0;
		var count = width * height;
		for (index in 0...count) {
			var base = index * 4;
			if (hasAlpha) {
				var alpha = data.get(base); // ARGB, premultiplied
				rgba.set(out, unpremultiply(data.get(base + 1), alpha));
				rgba.set(out + 1, unpremultiply(data.get(base + 2), alpha));
				rgba.set(out + 2, unpremultiply(data.get(base + 3), alpha));
				rgba.set(out + 3, alpha);
			} else {
				rgba.set(out, data.get(base + 1)); // PIX24: reserved, R, G, B
				rgba.set(out + 1, data.get(base + 2));
				rgba.set(out + 2, data.get(base + 3));
				rgba.set(out + 3, 255);
			}
			out += 4;
		}
	}

	static inline function widen5(five:Int):Int {
		return (five << 3) | (five >> 2);
	}

	static inline function unpremultiply(channel:Int, alpha:Int):Int {
		if (alpha == 0) {
			return 0;
		}
		var value = Std.int((channel * 255 + (alpha >> 1)) / alpha);
		return value > 255 ? 255 : value;
	}
}
