package com.sulake.core.assets.swf;

import haxe.io.Bytes;

typedef SwfMp3 = {
	var rateHz:Int;
	var bits:Int;
	var channels:Int;
	var sampleCount:Int;
	var seekSamples:Int;
	var mp3:Bytes;
}

/** Decode the measured DefineSound(MP3) header and expose the original MP3 frame bytes. */
class SwfSound {
	static var RATES = [5512, 11025, 22050, 44100];

	public static function decodeMp3(character:SwfCharacter):SwfMp3 {
		if (character.tag != SwfTag.DEFINE_SOUND) throw new SwfError("not a DefineSound character");
		var payload = character.payload;
		if (payload.length < 9) throw new SwfError("truncated DefineSound payload");
		var flags = payload.get(2);
		var format = flags >> 4;
		if (format != 2) throw new SwfError('unsupported DefineSound format $format; G2 scope is MP3');
		return {
			rateHz: RATES[(flags >> 2) & 3],
			bits: (flags & 2) != 0 ? 16 : 8,
			channels: (flags & 1) != 0 ? 2 : 1,
			sampleCount: payload.getInt32(3),
			seekSamples: signed16(payload.getUInt16(7)),
			mp3: payload.sub(9, payload.length - 9)
		};
	}

	static inline function signed16(value:Int):Int return value >= 0x8000 ? value - 0x10000 : value;
}
