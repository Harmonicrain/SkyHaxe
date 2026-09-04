import com.sulake.core.assets.swf.SwfBitmap;
import com.sulake.core.assets.swf.SwfCharacter;
import com.sulake.core.assets.swf.SwfFile;
import com.sulake.core.assets.swf.SwfSound;
import com.sulake.core.assets.swf.SwfSound.SwfMp3;
import com.sulake.core.assets.swf.SwfTag;
import haxe.Json;
import haxe.crypto.Sha256;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import js.Browser;
import js.lib.Uint8Array;
import openfl.utils.Assets;

/**
 * G2 -- does the Haxe SWF reader return the same bytes as an independent decoder, for real Habbo
 * content, fetched over HTTP?
 *
 * The reference in `evidence/g2_reader_contract.json` was produced by a separate Python
 * implementation (zlib/lzma + PIL). Agreement between two implementations written against the
 * same spec is what this proves; parity with the Flash client itself is a separate comparison
 * that CHECKLIST.md tracks on its own.
 *
 * Files whose container or codec is not implemented yet are **declared**, not skipped: the
 * expected deferral set is asserted, so quietly losing coverage fails the gate.
 */
class G2SwfReaderTest {
	public static var assertions(default, null):Int = 0;
	public static var comparisons(default, null):Int = 0;
	public static var report(default, null):Dynamic;
	public static var playbackSound(default, null):Null<SwfMp3>;

	static var DEFERRED_CONTAINERS:Array<String> = [];
	static var DEFERRED_ENCODINGS = ["gif"];

	static var reference:Dynamic;
	static var results:Array<Dynamic>;
	static var coldSeconds:Float = 0;
	static var warmSeconds:Float = 0;
	static var comparedEncodings:Map<String, Int>;
	static var jpegMaxDifference:Int = 0;
	static var jpegTotalDifference:Float = 0;
	static var jpegRgbChannels:Int = 0;
	static var jpegAlphaDifferences:Int = 0;
	static var soundExports:Int = 0;

	static var onError:Dynamic->Void;

	public static function run(onDone:String->Void, onFailure:Dynamic->Void):Void {
		assertions = 0;
		comparisons = 0;
		results = [];
		comparedEncodings = new Map();
		jpegMaxDifference = 0;
		jpegTotalDifference = 0;
		jpegRgbChannels = 0;
		jpegAlphaDifferences = 0;
		soundExports = 0;
		playbackSound = null;
		onError = onFailure;
		duplicateSymbolClassAliasRegression();
		reference = Json.parse(Assets.getText("fixtures/g2_reader_contract.json"));

		var names:Array<String> = Reflect.fields(reference.files);
		names.sort(Reflect.compare);
		next(names, 0, onDone);
	}

	/** A real public-room SWF exports one character id under several bitmap names. */
	static function duplicateSymbolClassAliasRegression():Void {
		var raw = Bytes.alloc(45);
		raw.set(0, "F".code);
		raw.set(1, "W".code);
		raw.set(2, "S".code);
		raw.set(3, 8);
		raw.setInt32(4, raw.length);
		var body = 8;
		raw.set(body, 0); // zero-bit RECT
		raw.set(body + 1, 0);
		raw.set(body + 2, 24); // frame rate
		raw.set(body + 3, 1);
		raw.set(body + 4, 0); // frame count
		raw.setUInt16(body + 5, (SwfTag.DEFINE_BINARY_DATA << 6) | 7);
		raw.setUInt16(body + 7, 42);
		raw.set(body + 13, 0x7F);
		raw.setUInt16(body + 14, (SwfTag.SYMBOL_CLASS << 6) | 19);
		raw.setUInt16(body + 16, 2);
		raw.setUInt16(body + 18, 42);
		raw.blit(body + 20, Bytes.ofString("first\x00"), 0, 6);
		raw.setUInt16(body + 26, 42);
		raw.blit(body + 28, Bytes.ofString("second\x00"), 0, 7);
		raw.setUInt16(body + 35, 0); // End

		var file = SwfFile.read(raw);
		var first = file.symbols.get("first");
		var second = file.symbols.get("second");
		truth(first != null, "first duplicate SymbolClass alias is retained");
		truth(second != null, "second duplicate SymbolClass alias is retained");
		truth(first == second, "duplicate SymbolClass aliases resolve to one character");
	}

	static function next(names:Array<String>, index:Int, onDone:String->Void):Void {
		if (index >= names.length) {
			guard(function() finish(onDone));
			return;
		}
		var relative = names[index];
		var expected = Reflect.field(reference.files, relative);
		fetchBytes("/ngh/" + relative, function(cold:Bytes, coldTime:Float) {
			// Second fetch of the same URL measures the warm path: the browser cache plus a
			// re-parse. Cold-only timing hides how the client will actually behave.
			fetchBytes("/ngh/" + relative, function(warm:Bytes, warmTime:Float) {
				guard(function() {
					coldSeconds += coldTime;
					warmSeconds += warmTime;
					check(relative, expected, cold, function(result) {
						results.push(result);
						next(names, index + 1, onDone);
					});
				});
			});
		});
	}

	/**
	 * Assertions run inside promise callbacks, where a thrown error would otherwise be swallowed
	 * by the rejected promise and the page would sit on "fetching…" looking like a hang.
	 */
	static function guard(body:Void->Void):Void {
		try {
			body();
		} catch (error:Dynamic) {
			onError(error);
		}
	}

	static function fetchBytes(url:String, onBytes:(Bytes, Float) -> Void):Void {
		var started = haxe.Timer.stamp();
		Browser.window.fetch(url).then(function(response) {
			if (!response.ok) {
				throw 'HTTP ${response.status} for $url';
			}
			return response.arrayBuffer();
		}).then(function(buffer) {
			var array = new Uint8Array(buffer);
			var bytes = Bytes.alloc(array.length);
			for (i in 0...array.length) {
				bytes.set(i, array[i]);
			}
			onBytes(bytes, haxe.Timer.stamp() - started);
			return null;
		});
	}

	static function check(relative:String, expected:Dynamic, raw:Bytes, onChecked:Dynamic->Void):Void {
		var container:String = expected.signature;
		if (DEFERRED_CONTAINERS.indexOf(container.split("-")[0]) >= 0) {
			// Declared, not skipped: the deferral list itself is asserted below.
			onChecked({file: relative, container: container, status: "deferred", compared: 0});
			return;
		}

		var file = SwfFile.read(raw);
		equal(container, file.signature, '$relative container');

		var compared = 0;
		var deferred = 0;
		var encoded:Array<Dynamic> = [];
		var symbols:Array<Dynamic> = expected.symbols;
		for (symbol in symbols) {
			var character = file.symbols.get(symbol.name);
			truth(character != null, '$relative exports ${symbol.name}');
			if (character == null) {
				continue;
			}
			equal(symbol.character_id, character.id, '${symbol.name} character id');
			equal(symbol.tag, character.tagName(), '${symbol.name} tag');

			switch (symbol.kind) {
				case "binary":
					equal(symbol.bytes, character.payload.length, '${symbol.name} binary length');
					equal(symbol.sha256, Sha256.make(character.payload).toHex(),
						'${symbol.name} binary sha256');
					compared++;
				case "bitmap":
					var encoding = character.encoding();
					equal(symbol.encoding, encoding, '${symbol.name} encoding');
					if (DEFERRED_ENCODINGS.indexOf(encoding) >= 0) {
						deferred++;
						continue;
					}
					if (encoding == "zlib") {
						comparePixels(symbol, character, SwfBitmap.decode(character));
						compared++;
					} else {
						encoded.push({symbol: symbol, character: character, encoding: encoding});
					}
				case "sound":
					var sound = SwfSound.decodeMp3(character);
					equal(symbol.format, "MP3", '${symbol.name} format');
					equal(symbol.rate_hz, sound.rateHz, '${symbol.name} sample rate');
					equal(symbol.bits, sound.bits, '${symbol.name} sample bits');
					equal(symbol.channels, sound.channels, '${symbol.name} channels');
					equal(symbol.sample_count, sound.sampleCount, '${symbol.name} sample count');
					equal(symbol.seek_samples, sound.seekSamples, '${symbol.name} seek samples');
					equal(symbol.mp3_bytes, sound.mp3.length, '${symbol.name} MP3 byte length');
					equal(symbol.mp3_sha256, Sha256.make(sound.mp3).toHex(), '${symbol.name} MP3 sha256');
				if (playbackSound == null || sound.mp3.length > playbackSound.mp3.length) playbackSound = sound;
					soundExports++;
					compared++;
				default:
					deferred++;
			}
		}
		decodeEncoded(encoded, 0, function(encodedCompared) {
			compared += encodedCompared;
			comparisons += compared;
			onChecked({
				file: relative, container: container, status: "compared",
				compared: compared, deferred: deferred
			});
		});
	}

	static function decodeEncoded(items:Array<Dynamic>, index:Int, onDone:Int->Void):Void {
		if (index >= items.length) {
			onDone(items.length);
			return;
		}
		var item = items[index];
		SwfBitmap.decodeAsync(item.character).onComplete(function(pixels) {
			guard(function() {
				comparePixels(item.symbol, item.character, pixels);
				var count = comparedEncodings.get(item.encoding);
				comparedEncodings.set(item.encoding, count == null ? 1 : count + 1);
				decodeEncoded(items, index + 1, onDone);
			});
		}).onError(onError);
	}

	static function comparePixels(symbol:Dynamic, character:SwfCharacter, pixels:SwfPixels):Void {
		equal(symbol.width, pixels.width, '${symbol.name} width');
		equal(symbol.height, pixels.height, '${symbol.name} height');
		if (character.encoding() == "zlib") {
			equal(symbol.rgba_sha256, Sha256.make(pixels.rgba).toHex(),
				'${symbol.name} straight-RGBA sha256');
			return;
		}

		var expected = SwfFile.inflate(Base64.decode(symbol.reference_rgba_zlib_base64), true);
		equal(expected.length, pixels.rgba.length, '${symbol.name} reference pixel length');
		var maxDifference = 0;
		var totalDifference = 0.0;
		var alphaDifferences = 0;
		var rgbChannels = 0;
		for (index in 0...expected.length) {
			var difference = Std.int(Math.abs(expected.get(index) - pixels.rgba.get(index)));
			if (index % 4 == 3) {
				if (difference != 0) alphaDifferences++;
			} else {
				rgbChannels++;
				totalDifference += difference;
				if (difference > maxDifference) maxDifference = difference;
			}
		}
		var meanDifference = totalDifference / rgbChannels;
		if (character.encoding() == "png") {
			if (maxDifference != 0 || alphaDifferences != 0) {
				throw new haxe.Exception('${symbol.name} PNG decoder delta: '
					+ 'max=$maxDifference mean=$meanDifference alpha_differences=$alphaDifferences');
			}
			return;
		}
		if (maxDifference > jpegMaxDifference) jpegMaxDifference = maxDifference;
		jpegTotalDifference += totalDifference;
		jpegRgbChannels += rgbChannels;
		jpegAlphaDifferences += alphaDifferences;
		equal(0, alphaDifferences, '${symbol.name} JPEG3 alpha exactness');
		truth(maxDifference <= 2, '${symbol.name} browser/Pillow JPEG max channel delta <= 2 (got $maxDifference)');
		truth(meanDifference <= 0.5, '${symbol.name} browser/Pillow JPEG mean channel delta <= 0.5 (got $meanDifference)');
	}

	static function finish(onDone:String->Void):Void {
		// The raw decoder contract is RGBA, while BitmapData.setPixels consumes big-endian ARGB.
		// OpenFL ByteArray defaults to host endian outside Flash, so this explicitly guards the
		// final upload boundary that a raw-byte hash cannot see.
		var upload = SwfBitmap.toBitmapData({
			width: 1,
			height: 1,
			rgba: Bytes.ofHex("375044FF")
		});
		equal(0xFF375044, upload.getPixel32(0, 0),
			"RGBA to BitmapData preserves the netcafe green sample");
		upload.dispose();
		// Coverage must be asserted, or a reader that silently returns nothing "passes".
		truth(comparisons >= 20, 'at least 20 assets compared (got $comparisons)');

		var containers = new Map<String, Bool>();
		var deferredFiles = 0;
		for (result in results) {
			containers.set(result.container, true);
			if (result.status == "deferred") {
				deferredFiles++;
			}
		}
		truth(containers.exists("FWS"), "FWS container exercised");
		truth(containers.exists("CWS"), "CWS container exercised");
		truth(containers.exists("CWS-no-adler"), "checksumless CWS container exercised");
		equal(0, deferredFiles, "all three ZWS canaries decode in the browser");
		truth(containers.exists("ZWS"), "ZWS container exercised");
		truth((comparedEncodings.get("jpeg") ?? 0) > 0, "browser JPEG decoder exercised");
		truth((comparedEncodings.get("png") ?? 0) > 0, "browser PNG decoder exercised");
		equal(24, soundExports, "all 24 reachable Gordon MP3 exports extracted");
		truth(playbackSound != null, "browser playback canary selected");

		report = {
			assertions: assertions,
			comparisons: comparisons,
			cold_fetch_parse_seconds: round(coldSeconds),
			warm_fetch_parse_seconds: round(warmSeconds),
			browser_decoded: {
				jpeg: comparedEncodings.get("jpeg") ?? 0,
				png: comparedEncodings.get("png") ?? 0,
				jpeg_max_rgb_channel_difference: jpegMaxDifference,
				jpeg_mean_rgb_channel_difference: round(jpegTotalDifference / jpegRgbChannels),
				jpeg_alpha_differences: jpegAlphaDifferences
			},
			sound_exports: soundExports,
			files: results
		};
		onDone("G2_SWF_READER_PASS assertions=" + assertions + " compared=" + comparisons);
	}

	static function round(value:Float):Float {
		return Math.round(value * 10000) / 10000;
	}

	static function truth(value:Bool, message:String):Void {
		equal(true, value, message);
	}

	static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
		assertions++;
		if (!js.Syntax.strictEq(expected, actual)) {
			throw new haxe.Exception('$message: expected ${Std.string(expected)}, '
				+ 'got ${Std.string(actual)}');
		}
	}
}
