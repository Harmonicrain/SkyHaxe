package com.sulake.core.assets.swf;

import haxe.Json;
import haxe.ds.StringMap;
import haxe.io.Bytes;
#if (js && html5)
import lime.app.Future;
import lime.app.Promise;
#end

private typedef HabEntry = {
	var name:String;
	var mime:String;
	var data:Bytes;
	var params:Dynamic;
}

/**
 * Reads a `.hab` bundle -- Habbo's HTML5 replacement for asset SWFs, produced here by swf2hab
 * (`C:\habbo\swf2hab`) -- into the same `SwfFile` export table the SWF reader builds, so every
 * loader (LibraryLoader, SwfAssetLibrary, SkyRoomContentLoader) works unchanged.
 *
 * Container: "HAB\0", u16 version 1, u16 flags 1, u32 index zlib length, u32 index JSON length,
 * u32 payload length, zlib(JSON index), payload. Every check below mirrors Habbo's own reader.
 *
 * Mapping back to SWF exports:
 *   - spritesheet frames are already keyed by the full SymbolClass name; one character per
 *     distinct rectangle, shared by aliases exactly like SWF characters exported twice;
 *   - raw binary/image/sound entries carry the symbol name minus the `<library>_` prefix,
 *     which is put back;
 *   - library-layout bundles (room content) keep the manifest in the index and list bitmap
 *     aliases as `{name, ref}`.
 */
class HabReader {
	static inline final HEADER = 20;

	public static function isHab(raw:Bytes):Bool {
		return raw != null && raw.length >= HEADER && raw.get(0) == 0x48 && raw.get(1) == 0x41
			&& raw.get(2) == 0x42 && raw.get(3) == 0;
	}

	public static function read(raw:Bytes):SwfFile {
		var version = raw.getUInt16(4);
		var flags = raw.getUInt16(6);
		if (version != 1) throw new SwfError('unsupported .hab version $version');
		if (flags != 1) throw new SwfError('unsupported .hab flags $flags');
		var stored = raw.getInt32(8);
		var original = raw.getInt32(12);
		var payloadLength = raw.getInt32(16);
		if (HEADER + stored + payloadLength != raw.length)
			throw new SwfError('.hab length mismatch: header says ${HEADER + stored + payloadLength}, got ${raw.length}');
		var indexBytes = SwfFile.inflate(raw.sub(HEADER, stored), true);
		if (indexBytes.length != original) throw new SwfError(".hab index length mismatch");
		var index:Dynamic = Json.parse(indexBytes.getString(0, indexBytes.length));
		if (index.format != "hab" || index.version != 1 || index.entries == null)
			throw new SwfError(".hab index has an invalid format");

		var payloadStart = HEADER + stored;
		var entries = new StringMap<HabEntry>();
		var order:Array<String> = [];
		var described:Array<Dynamic> = index.entries;
		for (item in described) {
			var name:String = item.name;
			var offset:Int = item.offset;
			var storedLength:Int = item.storedLength;
			if (name == null || name == "" || entries.exists(name)) throw new SwfError('.hab entry "$name" is invalid or duplicated');
			if (offset < 0 || storedLength < 0 || offset + storedLength > payloadLength)
				throw new SwfError('.hab entry "$name" exceeds the payload');
			var blob = raw.sub(payloadStart + offset, storedLength);
			if (item.compression == "deflate") blob = SwfFile.inflate(blob, true);
			else if (item.compression != "none") throw new SwfError('.hab entry "$name" uses ${item.compression}');
			entries.set(name, {name: name, mime: item.mimeType, data: blob, params: item.params});
			order.push(name);
		}

		var file = new SwfFile();
		file.signature = "HAB";
		file.frameRate = 0;
		file.bodyBytes = raw.length;
		var library:String = index.name;
		var prefix = library + "_";
		var nextId = 1;
		var consumed = new StringMap<Bool>();

		// ---------------------------------------------------------------- atlas frames
		var sheetEntry:Null<HabEntry> = null;
		for (name in order) {
			var entry = entries.get(name);
			if (entry.mime == "application/json") {
				sheetEntry = entry;
				break;
			}
		}
		if (sheetEntry != null) {
			consumed.set(sheetEntry.name, true);
			var data:Dynamic = Json.parse(sheetEntry.data.getString(0, sheetEntry.data.length));
			var sheet:Dynamic = data.spritesheet;
			if (sheet != null && sheet.frames != null) {
				var mainImage:String = sheet.meta.image;
				var atlases = new StringMap<HabAtlas>();
				var rects = new StringMap<SwfCharacter>();
				for (symbol in Reflect.fields(sheet.frames)) {
					var spec:Dynamic = Reflect.field(sheet.frames, symbol);
					var image:String = spec.image != null ? spec.image : mainImage;
					var atlas = atlases.get(image);
					if (atlas == null) {
						var png = entries.get(image);
						if (png == null) throw new SwfError('.hab frame $symbol refers to missing atlas $image');
						atlas = new HabAtlas(image, png.data);
						atlases.set(image, atlas);
						consumed.set(image, true);
					}
					var f:Dynamic = spec.frame;
					var trim:Dynamic = spec.spriteSourceSize;
					var source:Dynamic = spec.sourceSize;
					var key = '$image:${f.x},${f.y},${f.w},${f.h}:${trim.x},${trim.y}:${source.w},${source.h}';
					var character = rects.get(key);
					if (character == null) {
						character = SwfCharacter.atlasFrame(nextId++,
							new HabFrame(atlas, f.x, f.y, f.w, f.h, trim.x, trim.y, source.w, source.h));
						rects.set(key, character);
					}
					if (character.name == null) character.name = symbol;
					file.symbols.set(symbol, character);
				}
				file.atlases = [for (atlas in atlases) atlas];
				file.mainAtlas = atlases.get(mainImage);
			}
		}

		// ---------------------------------------------------------------- raw symbols
		for (name in order) {
			if (consumed.exists(name)) continue;
			var entry = entries.get(name);
			var symbol = prefix + name;
			if (file.symbols.exists(symbol)) continue;
			var id = nextId++;
			var character = if (StringTools.startsWith(entry.mime, "image/")) {
				// Same container the SWF reader uses for embedded PNG/JPEG: u16 id, then the image.
				var payload = Bytes.alloc(entry.data.length + 2);
				payload.setUInt16(0, id);
				payload.blit(2, entry.data, 0, entry.data.length);
				SwfCharacter.bitmap(id, SwfTag.DEFINE_BITS_JPEG2, payload);
			} else if (entry.mime == "sound/mp3") {
				SwfCharacter.sound(id, defineSound(id, entry));
			} else {
				SwfCharacter.binary(id, entry.data);
			}
			character.name = symbol;
			file.symbols.set(symbol, character);
		}

		// ---------------------------------------------------------------- library layout extras
		var manifest:Null<String> = index.manifest;
		if (manifest != null && !file.symbols.exists(prefix + "manifest")) {
			var character = SwfCharacter.binary(nextId++, Bytes.ofString(manifest));
			character.name = prefix + "manifest";
			file.symbols.set(prefix + "manifest", character);
		}
		var aliases:Array<Dynamic> = index.aliases;
		if (aliases != null) for (alias in aliases) {
			var target = file.symbols.get(prefix + alias.ref);
			if (target != null && !file.symbols.exists(prefix + alias.name))
				file.symbols.set(prefix + alias.name, target);
		}
		return file;
	}

	#if (js && html5)
	/**
	 * Parse, then decode the main atlas off the main thread before completing, so lazily
	 * constructed bitmaps (LibraryLoader) can be cut out synchronously.
	 */
	public static function readAsync(raw:Bytes):Future<SwfFile> {
		var file:SwfFile = null;
		try {
			file = read(raw);
		} catch (error:Dynamic) {
			return cast Future.withError(error);
		}
		SwfLoadMetrics.count("habFilesParsed");
		if (file.mainAtlas == null) return Future.withValue(file);
		var promise = new Promise<SwfFile>();
		// A failed worker decode is retried synchronously on first use, so complete either way.
		file.mainAtlas.pixelsAsync().onComplete(function(_) {
			promise.complete(file);
		}).onError(function(_) {
			promise.complete(file);
		});
		return promise.future;
	}
	#end

	/** Rebuild a DefineSound(MP3) payload: u16 id, flags, u32 samples, s16 seek, MP3 frames. */
	static function defineSound(id:Int, entry:HabEntry):Bytes {
		var p:Dynamic = entry.params;
		var rates = [5512, 11025, 22050, 44100];
		var rate = p != null && p.rate != null ? rates.indexOf(p.rate) : 3;
		if (rate < 0) rate = 3;
		var flags = (2 << 4) | (rate << 2) | ((p == null || p.bits == null || p.bits == 16) ? 2 : 0)
			| ((p == null || p.channels == null || p.channels == 2) ? 1 : 0);
		var payload = Bytes.alloc(9 + entry.data.length);
		payload.setUInt16(0, id);
		payload.set(2, flags);
		payload.setInt32(3, p != null && p.sampleCount != null ? p.sampleCount : 0);
		payload.setUInt16(7, p != null && p.seekSamples != null ? (p.seekSamples & 0xFFFF) : 0);
		payload.blit(9, entry.data, 0, entry.data.length);
		return payload;
	}
}
