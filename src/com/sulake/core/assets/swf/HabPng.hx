package com.sulake.core.assets.swf;

import com.sulake.core.assets.swf.SwfBitmap.SwfPixels;
import haxe.io.Bytes;

/**
 * Synchronous PNG -> straight RGBA decoder for .hab atlases.
 *
 * The worker pool decodes atlases off the main thread; this is the path for the rare atlas that
 * a synchronous caller (a lazily constructed bitmap) needs before its worker decode has run, and
 * for browsers without workers. It decodes exactly -- no canvas, so no premultiply round trip --
 * and supports every 8-bit, non-interlaced PNG: truecolour, grey, with or without alpha, palette.
 */
class HabPng {
	/** Whether `decode` handles the PNG at `offset`: 8-bit, non-interlaced, any colour type. */
	public static function supports(data:Bytes, offset:Int, length:Int):Bool {
		if (length < 33 || data.get(offset) != 0x89 || data.get(offset + 1) != 0x50
			|| data.get(offset + 2) != 0x4E || data.get(offset + 3) != 0x47) return false;
		var depth = data.get(offset + 24);
		var colorType = data.get(offset + 25);
		var interlace = data.get(offset + 28);
		return depth == 8 && interlace == 0
			&& (colorType == 0 || colorType == 2 || colorType == 3 || colorType == 4 || colorType == 6);
	}

	public static function decode(png:Bytes):SwfPixels {
		if (png.length < 33 || png.get(0) != 0x89 || png.get(1) != 0x50 || png.get(2) != 0x4E || png.get(3) != 0x47)
			throw new SwfError("atlas is not a PNG");
		var pos = 8;
		var width = 0, height = 0, colorType = -1;
		var palette:Null<Bytes> = null;
		var transparency:Null<Bytes> = null;
		var idat = new haxe.io.BytesBuffer();
		while (pos + 8 <= png.length) {
			var length = readBE32(png, pos);
			var kind = png.getString(pos + 4, 4);
			var start = pos + 8;
			switch (kind) {
				case "IHDR":
					width = readBE32(png, start);
					height = readBE32(png, start + 4);
					var depth = png.get(start + 8);
					colorType = png.get(start + 9);
					if (depth != 8 || png.get(start + 12) != 0)
						throw new SwfError('unsupported PNG (depth $depth, interlaced ${png.get(start + 12)})');
				case "PLTE":
					palette = png.sub(start, length);
				case "tRNS":
					transparency = png.sub(start, length);
				case "IDAT":
					idat.addBytes(png, start, length);
				case "IEND":
					break;
				default:
			}
			pos = start + length + 4;
		}
		var bpp = switch (colorType) {
			case 6: 4;
			case 2: 3;
			case 3: 1;
			case 4: 2;
			case 0: 1;
			default: throw new SwfError('unsupported PNG colour type $colorType');
		}
		var raw = SwfFile.inflate(idat.getBytes(), true);
		var stride = width * bpp;
		var cur = Bytes.alloc(stride * height);
		var ip = 0;
		for (y in 0...height) {
			var filter = raw.get(ip++);
			var row = y * stride;
			var prev = row - stride;
			for (x in 0...stride) {
				var v = raw.get(ip++);
				var a = x >= bpp ? cur.get(row + x - bpp) : 0;
				var b = y > 0 ? cur.get(prev + x) : 0;
				var value = switch (filter) {
					case 0: v;
					case 1: v + a;
					case 2: v + b;
					case 3: v + ((a + b) >> 1);
					case 4:
						var c = (x >= bpp && y > 0) ? cur.get(prev + x - bpp) : 0;
						var p = a + b - c;
						var pa = p > a ? p - a : a - p;
						var pb = p > b ? p - b : b - p;
						var pc = p > c ? p - c : c - p;
						v + ((pa <= pb && pa <= pc) ? a : (pb <= pc ? b : c));
					default: throw new SwfError('bad PNG filter $filter');
				}
				cur.set(row + x, value & 0xFF);
			}
		}
		if (colorType == 6) return {width: width, height: height, rgba: cur};
		var rgba = Bytes.alloc(width * height * 4);
		// tRNS on truecolour/grey PNGs is a single transparent colour key (16-bit samples).
		var keyR = -1, keyG = -1, keyB = -1;
		if (transparency != null && colorType == 2 && transparency.length >= 6) {
			keyR = transparency.get(1);
			keyG = transparency.get(3);
			keyB = transparency.get(5);
		} else if (transparency != null && colorType == 0 && transparency.length >= 2) {
			keyR = keyG = keyB = transparency.get(1);
		}
		for (i in 0...width * height) {
			var o = i * 4;
			if (colorType == 2) {
				var r = cur.get(i * 3), g = cur.get(i * 3 + 1), b = cur.get(i * 3 + 2);
				rgba.set(o, r);
				rgba.set(o + 1, g);
				rgba.set(o + 2, b);
				rgba.set(o + 3, (r == keyR && g == keyG && b == keyB) ? 0 : 255);
			} else if (colorType == 0) {
				var v = cur.get(i);
				rgba.set(o, v);
				rgba.set(o + 1, v);
				rgba.set(o + 2, v);
				rgba.set(o + 3, v == keyR ? 0 : 255);
			} else if (colorType == 4) {
				var v = cur.get(i * 2);
				rgba.set(o, v);
				rgba.set(o + 1, v);
				rgba.set(o + 2, v);
				rgba.set(o + 3, cur.get(i * 2 + 1));
			} else {
				var k = cur.get(i);
				rgba.set(o, palette.get(k * 3));
				rgba.set(o + 1, palette.get(k * 3 + 1));
				rgba.set(o + 2, palette.get(k * 3 + 2));
				rgba.set(o + 3, transparency != null && k < transparency.length ? transparency.get(k) : 255);
			}
		}
		return {width: width, height: height, rgba: rgba};
	}

	static inline function readBE32(b:Bytes, pos:Int):Int {
		return (b.get(pos) << 24) | (b.get(pos + 1) << 16) | (b.get(pos + 2) << 8) | b.get(pos + 3);
	}
}
