package com.sulake.core.assets.swf;

import haxe.io.Bytes;

enum SwfCharacterKind {
	Bitmap;
	Binary;
	Sound;
}

/**
 * One exported SWF character, held as its raw tag payload until something asks for it.
 *
 * Decoding is deferred on purpose. A furni SWF exports a few hundred bitmaps and the room only
 * ever asks for the handful its visualization data names; eagerly decoding every character would
 * cost far more than the file is worth.
 */
class SwfCharacter {
	public var id(default, null):Int;
	public var kind(default, null):SwfCharacterKind;
	public var tag(default, null):Int;
	public var payload(default, null):Bytes;

	/** Set once the SymbolClass table is read; unexported characters never get one. */
	public var name:String;

	/** For a bitmap read from a .hab bundle: its rectangle in the bundle's atlas. */
	public var atlas(default, null):Null<HabFrame>;

	function new(id:Int, kind:SwfCharacterKind, tag:Int, payload:Bytes) {
		this.id = id;
		this.kind = kind;
		this.tag = tag;
		this.payload = payload;
	}

	public static function bitmap(id:Int, tag:Int, payload:Bytes):SwfCharacter {
		return new SwfCharacter(id, Bitmap, tag, payload);
	}

	public static function binary(id:Int, blob:Bytes):SwfCharacter {
		return new SwfCharacter(id, Binary, SwfTag.DEFINE_BINARY_DATA, blob);
	}

	public static function sound(id:Int, payload:Bytes):SwfCharacter {
		return new SwfCharacter(id, Sound, SwfTag.DEFINE_SOUND, payload);
	}

	/** A bitmap that lives in a .hab atlas rather than in its own SWF tag. */
	public static function atlasFrame(id:Int, frame:HabFrame):SwfCharacter {
		var character = new SwfCharacter(id, Bitmap, SwfTag.HAB_ATLAS_FRAME, Bytes.alloc(0));
		character.atlas = frame;
		return character;
	}

	public function tagName():String {
		return switch (tag) {
			case SwfTag.DEFINE_BITS_LOSSLESS: "DefineBitsLossless";
			case SwfTag.DEFINE_BITS_LOSSLESS2: "DefineBitsLossless2";
			case SwfTag.DEFINE_BITS_JPEG2: "DefineBitsJPEG2";
			case SwfTag.DEFINE_BITS_JPEG3: "DefineBitsJPEG3";
			case SwfTag.DEFINE_BINARY_DATA: "DefineBinaryData";
			case SwfTag.DEFINE_SOUND: "DefineSound";
			case SwfTag.HAB_ATLAS_FRAME: "HabAtlasFrame";
			case other: "tag-" + other;
		}
	}

	/**
	 * Which codec the payload actually holds.
	 *
	 * SWF 8 allows PNG and GIF89a inside the "JPEG" tags, and Habbo leans on that: every one of
	 * the 1,468 reachable Gordon `DefineBitsJPEG2` characters is PNG, and three `dcr/` files mix
	 * JPEG and PNG inside a single SWF. The tag id therefore does not identify the codec -- only
	 * the payload magic does. See `historical/evidence/g2_embedded_format_survey.json`.
	 */
	public function encoding():String {
		if (atlas != null) return "atlas";
		return switch (tag) {
			case SwfTag.DEFINE_BITS_LOSSLESS, SwfTag.DEFINE_BITS_LOSSLESS2: "zlib";
			case SwfTag.DEFINE_BITS_JPEG2, SwfTag.DEFINE_BITS_JPEG3: imageMagic();
			default: "n/a";
		}
	}

	function imageMagic():String {
		// Compared byte-wise, not via getString: these payloads are arbitrary binary and
		// Bytes.getString decodes UTF-8, which throws a RangeError on most image data.
		var data = imageData();
		if (data.length >= 4 && data.get(0) == 0x89 && data.get(1) == 0x50
			&& data.get(2) == 0x4E && data.get(3) == 0x47) {
			return "png";
		}
		if (data.length >= 3 && data.get(0) == 0x47 && data.get(1) == 0x49 && data.get(2) == 0x46) {
			return "gif";
		}
		return "jpeg";
	}

	/** The encoded image bytes, without the tag header or the JPEG3 alpha block. */
	public function imageData():Bytes {
		return switch (tag) {
			case SwfTag.DEFINE_BITS_JPEG2:
				payload.sub(2, payload.length - 2);
			case SwfTag.DEFINE_BITS_JPEG3:
				payload.sub(6, payload.getInt32(2));
			default:
				throw new SwfError("not an image-container tag: " + tagName());
		}
	}

	/**
	 * The zlib-compressed alpha channel of a DefineBitsJPEG3, or null.
	 *
	 * Null for PNG and GIF payloads even inside a JPEG3 tag: those carry their own alpha, and
	 * applying this block on top of them corrupts it.
	 */
	public function alphaData():Null<Bytes> {
		if (tag != SwfTag.DEFINE_BITS_JPEG3 || imageMagic() != "jpeg") {
			return null;
		}
		var offset = 6 + payload.getInt32(2);
		return offset < payload.length ? payload.sub(offset, payload.length - offset) : null;
	}
}
