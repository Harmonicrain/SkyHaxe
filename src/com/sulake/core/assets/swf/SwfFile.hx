package com.sulake.core.assets.swf;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.zip.InflateImpl;
import lime.utils.Bytes as LimeBytes;
import lime.utils.CompressionAlgorithm;
#if (js && html5)
import js.lib.Promise as JsPromise;
import js.lib.Uint8Array;
import lime.app.Future;
import lime.app.Promise;
#end

/**
 * Container and tag layer of the SWF reader (gate G2).
 *
 * Decision D1 is that SkyHaxe reads Habbo content SWFs directly, with no conversion pipeline. The
 * client reaches assets only by exported name -- `AssetLibrary.getDefinition(name)` -- so this
 * exposes exactly the characters named in `SymbolClass` and nothing else. A shape or font left
 * over from authoring is unreachable in the Flash client and stays unreachable here.
 *
 * Scope comes from measurement, not assumption. See `historical/evidence/g0_scan_swf_exports.py`,
 * `historical/evidence/g0_gordon_contract.py`, and `historical/evidence/g2_embedded_format_survey.py`.
 */
@:allow(com.sulake.core.assets.swf.HabReader)
class SwfFile {
	/** Exported characters, keyed by the name in SymbolClass. */
	public var symbols(default, null):Map<String, SwfCharacter>;

	/** FWS, CWS, CWS-no-adler, or ZWS. Recorded because the containers behave differently. */
	public var signature(default, null):String;

	public var frameRate(default, null):Float;
	public var bodyBytes(default, null):Int;

	/** Atlases of a .hab bundle (empty for a real SWF); the main one is decoded first. */
	public var atlases(default, null):Array<HabAtlas> = [];
	public var mainAtlas(default, null):Null<HabAtlas>;

	function new() {
		symbols = new Map();
	}

	public static function read(raw:Bytes):SwfFile {
		// A .hab bundle (swf2hab, or Habbo's own HTML5 format) presents the same export table.
		if (HabReader.isHab(raw)) return HabReader.read(raw);
		var file = new SwfFile();
		var declared = raw.getInt32(4) - 8;
		// Byte-wise: getString decodes UTF-8 and would throw on a non-SWF instead of reporting one.
		var signature = String.fromCharCode(raw.get(0)) + String.fromCharCode(raw.get(1))
			+ String.fromCharCode(raw.get(2));
		var body = switch (signature) {
			case "FWS":
				file.signature = "FWS";
				raw.sub(8, raw.length - 8);
			case "CWS":
				inflateCws(file, raw, declared);
			case "ZWS":
				inflateZws(file, raw, declared);
			case other:
				throw new SwfError('unknown SWF container "$other"');
		}
		if (body.length < declared) {
			throw new SwfError('truncated body: ${body.length} bytes, header declares $declared');
		}
		file.bodyBytes = body.length;
		file.readTags(body);
		return file;
	}

	/** Browser-native asynchronous CWS inflate; tag indexing stays deterministic. */
	#if (js && html5)
	public static function readAsync(raw:Bytes):Future<SwfFile> {
		if (HabReader.isHab(raw)) return HabReader.readAsync(raw);
		var signature = String.fromCharCode(raw.get(0)) + String.fromCharCode(raw.get(1))
			+ String.fromCharCode(raw.get(2));
		if (signature != "CWS" || !untyped js.Syntax.code("typeof DecompressionStream !== 'undefined'"))
			return Future.withValue(read(raw));

		var promise = new Promise<SwfFile>();
		var declared = raw.getInt32(4) - 8;
		var compressed = new Uint8Array(raw.sub(8, raw.length - 8).getData());
		var native:JsPromise<js.lib.ArrayBuffer> = untyped js.Syntax.code(
			"new Response(new Blob([{0}]).stream().pipeThrough(new DecompressionStream('deflate'))).arrayBuffer()",
			compressed);
		native.then(function(buffer) {
			try {
				var body = Bytes.ofData(buffer);
				if (body.length < declared)
					throw new SwfError('truncated body: ${body.length} bytes, header declares $declared');
				var file = new SwfFile();
				file.signature = "CWS";
				file.bodyBytes = body.length;
				file.readTags(body);
				promise.complete(file);
			} catch (error:Dynamic) promise.error(error);
			return null;
		}).catchError(function(_) {
			// Some legacy files omit the Adler trailer. The proven reader validates their length.
			try promise.complete(read(raw)) catch (error:Dynamic) promise.error(error);
			return null;
		});
		return promise.future;
	}
	#end

	/**
	 * SWF does not store an ordinary LZMA-alone stream. Its five property bytes start at offset
	 * 12, compressed data at 17, and the eight-byte uncompressed-size field is absent. Rebuild
	 * that field with LZMA's unknown-size sentinel, then verify against the SWF header ourselves.
	 */
	static function inflateZws(file:SwfFile, raw:Bytes, declared:Int):Bytes {
		if (raw.length < 17) throw new SwfError("truncated ZWS header");
		var advertisedCompressed = raw.getInt32(8);
		var actualCompressed = raw.length - 12;
		if (advertisedCompressed != actualCompressed && advertisedCompressed != actualCompressed - 5) {
			throw new SwfError('ZWS compressed length $advertisedCompressed does not match '
				+ 'the ${actualCompressed}-byte properties/data payload');
		}
		var alone = Bytes.alloc(5 + 8 + raw.length - 17);
		alone.blit(0, raw, 12, 5);
		for (index in 5...13) alone.set(index, 0xFF);
		alone.blit(13, raw, 17, raw.length - 17);
		var decoded:haxe.io.Bytes;
		try {
			decoded = decompressLzmaAlone(alone);
		} catch (error:Dynamic) {
			throw new SwfError('ZWS LZMA decode failed: ${Std.string(error)}');
		}
		if (decoded == null || decoded.length != declared) {
			throw new SwfError('ZWS body length ${decoded == null ? 0 : decoded.length} '
				+ 'does not match header declaration $declared');
		}
		file.signature = "ZWS";
		return decoded;
	}

	static function decompressLzmaAlone(alone:Bytes):Bytes {
		#if js
		// Lime 8.3.2 embeds lzma_worker-min.js for HTML5. Its synchronous decoder returns a
		// numeric Array, while Lime's public wrapper feeds that through Bytes.ofData(ArrayBuffer),
		// producing a value with no length. Normalize the pinned decoder's actual return type here.
		var data:Dynamic = js.Syntax.code("LZMA.decompress({0})", new js.lib.Uint8Array(alone.getData()));
		if (Std.isOfType(data, String)) return Bytes.ofString(cast data);
		var length:Int = data.length;
		var result = Bytes.alloc(length);
		for (index in 0...length) result.set(index, data[index] & 0xFF);
		return result;
		#else
		return LimeBytes.fromBytes(alone).decompress(CompressionAlgorithm.LZMA);
		#end
	}

	/**
	 * P1c found six live Gordon files -- `elephants.swf` among them -- that carry the complete
	 * declared body but omit zlib's four-byte Adler-32 trailer. Flash accepts them. So do we, but
	 * only after the inflated length matches the SWF header exactly: that tolerance must not
	 * quietly swallow a genuinely truncated file.
	 */
	static function inflateCws(file:SwfFile, raw:Bytes, declared:Int):Bytes {
		var compressed = raw.sub(8, raw.length - 8);
		try {
			file.signature = "CWS";
			return inflate(compressed, true);
		} catch (_:Dynamic) {
			var body = inflate(compressed, false);
			if (body.length != declared) {
				throw new SwfError('CWS inflate failed and the body is short: '
					+ '${body.length} of $declared bytes');
			}
			file.signature = "CWS-no-adler";
			return body;
		}
	}

	/**
	 * zlib inflate. Uses pako when present -- Lime 8 embeds it in every HTML5 build -- because
	 * the pure-Haxe `InflateImpl` measured 2.3-2.4x slower on this corpus, and this runs
	 * synchronously on the main thread for every lazily constructed lossless bitmap.
	 * `tools/bench` in swf2hab compiles this exact routine to compare the two.
	 */
	public static function inflate(compressed:Bytes, verifyChecksum:Bool):Bytes {
		#if (js && html5)
		if (js.Syntax.code("typeof pako !== 'undefined'")) {
			var input = new Uint8Array(compressed.getData(), 0, compressed.length);
			// pako.inflate checks Adler-32 like InflateImpl(verify=true); without verification
			// the zlib header is skipped and the raw deflate stream ends at its final block.
			var output:Uint8Array = verifyChecksum
				? js.Syntax.code("pako.inflate({0})", input)
				: js.Syntax.code("pako.inflateRaw({0}.subarray(2))", input);
			// pako may hand back a view into a larger chunk buffer; Bytes needs an exact buffer.
			if (output.byteOffset != 0 || output.byteLength != output.buffer.byteLength)
				output = output.slice();
			SwfLoadMetrics.count("pakoInflates");
			return Bytes.ofData(output.buffer);
		}
		#end
		var impl = new InflateImpl(new BytesInput(compressed), true, verifyChecksum);
		var buffer = Bytes.alloc(65536);
		var out = new haxe.io.BytesBuffer();
		while (true) {
			var read = impl.readBytes(buffer, 0, buffer.length);
			out.addBytes(buffer, 0, read);
			if (read < buffer.length) {
				break;
			}
		}
		return out.getBytes();
	}

	function readTags(body:Bytes):Void {
		// FrameRect is bit-packed: 5 bits of "bits per value", then four values of that width.
		var nbits = body.get(0) >> 3;
		var offset = Std.int(((5 + nbits * 4) + 7) / 8);
		frameRate = body.get(offset + 1) + body.get(offset) / 256;
		offset += 4; // frame rate (2) + frame count (2)

		var characters = new Map<Int, SwfCharacter>();
		// One SWF character may be exported under several SymbolClass names. Public-room
		// libraries rely on this for child-object bitmap aliases, so an id -> String map would
		// silently retain only the final alias and make otherwise valid scenery disappear.
		var names = new Map<Int, Array<String>>();

		while (offset < body.length - 1) {
			var record = body.getUInt16(offset);
			offset += 2;
			var code = record >> 6;
			var length = record & 0x3F;
			if (length == 0x3F) {
				length = body.getInt32(offset);
				offset += 4;
			}
			var payload = body.sub(offset, length);
			switch (code) {
				case SwfTag.DEFINE_BITS_LOSSLESS, SwfTag.DEFINE_BITS_LOSSLESS2,
					SwfTag.DEFINE_BITS_JPEG2, SwfTag.DEFINE_BITS_JPEG3:
					var id = payload.getUInt16(0);
					characters.set(id, SwfCharacter.bitmap(id, code, payload));
				case SwfTag.DEFINE_BINARY_DATA:
					var id = payload.getUInt16(0);
					// u16 id, u32 reserved, then the blob.
					characters.set(id, SwfCharacter.binary(id, payload.sub(6, payload.length - 6)));
				case SwfTag.DEFINE_SOUND:
					var id = payload.getUInt16(0);
					characters.set(id, SwfCharacter.sound(id, payload));
				case SwfTag.SYMBOL_CLASS:
					readSymbolClass(payload, names);
				default:
			}
			offset += length;
			if (code == SwfTag.END) {
				break;
			}
		}

		for (id => aliases in names) {
			var character = characters.get(id);
			if (character != null) {
				for (name in aliases) {
					if (character.name == null) character.name = name;
					symbols.set(name, character);
				}
			}
		}
	}

	static function readSymbolClass(payload:Bytes, names:Map<Int, Array<String>>):Void {
		var count = payload.getUInt16(0);
		var cursor = 2;
		for (_ in 0...count) {
			var id = payload.getUInt16(cursor);
			cursor += 2;
			var end = cursor;
			while (end < payload.length && payload.get(end) != 0) {
				end++;
			}
			var aliases = names.get(id);
			if (aliases == null) {
				aliases = [];
				names.set(id, aliases);
			}
			aliases.push(payload.getString(cursor, end - cursor));
			cursor = end + 1;
		}
	}

	public function exportedNames():Array<String> {
		return [for (name in symbols.keys()) name];
	}
}
