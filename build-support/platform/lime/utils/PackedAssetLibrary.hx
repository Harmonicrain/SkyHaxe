package lime.utils;

import haxe.io.Bytes;
import haxe.io.Path;
import lime.app.Event;
import lime.app.Future;
import lime.app.Promise;
import lime.media.AudioBuffer;
import lime.graphics.Image;
import lime.net.HTTPRequest;
import lime.text.Font;
import lime.utils.AssetType;
import lime.utils.Bytes;
#if flash
import flash.display.BitmapData;
import flash.media.Sound;
#end

/*
 * SkyHaxe override of Lime 8.3.2's PackedAssetLibrary (build-support/platform).
 *
 * Stock Lime preloads every image in the pack through an <img>/blob decode before the app
 * starts: for SkyHaxe's 2,960 embedded images that was ~2.5 s of boot main-thread time, and every
 * image stayed resident. Here PNGs (and text/binary entries) are served on demand from the packed
 * bytes; a PNG is decoded synchronously and exactly (HabPng, straight RGBA) the first time
 * something asks for it. That also yields DATA-backed images, which colorTransform/getPixels can
 * use without a canvas readback. Images HabPng cannot decode (JPEG, 16-bit, interlaced) still
 * preload exactly as before.
 */
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
// Pinned to the Lime 8.3.2 original: the build fails if it changes, so this copy cannot mask an upgrade.
@:build(skyhaxe.GeneratedPin.check(".haxelib/lime/8,3,2/src/lime/utils/PackedAssetLibrary.hx",
	"8b4191fcde85d1b9222ef0c06b03e6d62cb36838ea330435d06f16c46728bfb2"))
@:keep class PackedAssetLibrary extends AssetLibrary
{
	@:noCompletion private var id:String;
	@:noCompletion private var lengths = new Map<String, Int>();
	@:noCompletion private var packedData:Bytes;
	@:noCompletion private var positions = new Map<String, Int>();
	@:noCompletion private var type:String;
	@:noCompletion private var rootPath:String;

	public function new(id:String, type:String)
	{
		super();

		this.id = id;
		this.type = type;
	}

	public static function fromBytes(bytes:Bytes, rootPath:String = null):PackedAssetLibrary
	{
		return cast fromManifest(AssetManifest.fromBytes(bytes, rootPath));
	}

	public static function fromFile(path:String, rootPath:String = null):PackedAssetLibrary
	{
		return cast fromManifest(AssetManifest.fromFile(path, rootPath));
	}

	public static function fromManifest(manifest:AssetManifest):PackedAssetLibrary
	{
		return cast AssetLibrary.fromManifest(manifest);
	}

	public override function getAudioBuffer(id:String):AudioBuffer
	{
		#if (js && html5)
		return super.getAudioBuffer(id);
		#else
		if (cachedAudioBuffers.exists(id))
		{
			return cachedAudioBuffers.get(id);
		}
		else
		{
			// TODO: More efficient method
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return AudioBuffer.fromBytes(bytes);
		}
		#end
	}

	public override function getBytes(id:String):Bytes
	{
		if (cachedBytes.exists(id))
		{
			return cachedBytes.get(id);
		}
		else if (cachedText.exists(id))
		{
			var bytes = Bytes.ofString(cachedText.get(id));
			cachedBytes.set(id, bytes);
			return bytes;
		}
		else
		{
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return bytes;
		}
	}

	public override function getFont(id:String):Font
	{
		#if (js && html5)
		return super.getFont(id);
		#else
		if (cachedFonts.exists(id))
		{
			return cachedFonts.get(id);
		}
		else
		{
			// TODO: More efficient method
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return Font.fromBytes(bytes);
		}
		#end
	}

	public override function getImage(id:String):Image
	{
		if (cachedImages.exists(id))
		{
			return cachedImages.get(id);
		}
		#if (js && html5)
		else if (isLazyImage(id))
		{
			return decodeLazyImage(id);
		}
		#end
		else
		{
			// TODO: More efficient method
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return Image.fromBytes(bytes);
		}
	}

	#if (js && html5)
	@:noCompletion private var lazyImageCheck:Map<String, Bool>;

	/** True for a pack entry that HabPng decodes exactly (8-bit, non-interlaced PNG). */
	@:noCompletion private function isLazyImage(id:String):Bool
	{
		if (packedData == null || type == "gzip" || type == "zip" || type == "deflate" || !positions.exists(id)) return false;
		if (lazyImageCheck == null) lazyImageCheck = new Map();
		var known = lazyImageCheck.get(id);
		if (known != null) return known;
		var result = com.sulake.core.assets.swf.HabPng.supports(packedData, positions[id], lengths[id]);
		lazyImageCheck.set(id, result);
		return result;
	}

	@:noCompletion private function decodeLazyImage(id:String):Image
	{
		var started = js.Browser.window.performance.now();
		var bytes = Bytes.alloc(lengths[id]);
		bytes.blit(0, packedData, positions[id], lengths[id]);
		var pixels = com.sulake.core.assets.swf.HabPng.decode(bytes);
		var buffer = new lime.graphics.ImageBuffer(new lime.utils.UInt8Array(pixels.rgba.getData()),
			pixels.width, pixels.height, 32, lime.graphics.PixelFormat.RGBA32);
		buffer.premultiplied = false;
		var image = new Image(buffer, 0, 0, pixels.width, pixels.height, null, lime.graphics.ImageType.DATA);
		cachedImages.set(id, image);
		com.sulake.core.assets.swf.SwfLoadMetrics.count("packImageDecodes");
		com.sulake.core.assets.swf.SwfLoadMetrics.add("packImageDecodeMs", js.Browser.window.performance.now() - started);
		return image;
	}
	#end

	public override function getText(id:String):String
	{
		if (cachedText.exists(id))
		{
			return cachedText.get(id);
		}
		else if (type == "gzip" || type == "zip" || type == "deflate")
		{
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return bytes.getString(0, bytes.length);
		}
		else
		{
			return packedData.getString(positions[id], lengths[id]);
		}
	}

	public override function isLocal(id:String, type:String):Bool
	{
		return true;
	}

	public override function load():Future<AssetLibrary>
	{
		if (loaded)
		{
			return Future.withValue(cast this);
		}

		if (promise == null)
		{
			promise = new Promise<AssetLibrary>();
			bytesLoadedCache = new Map();

			// TODO: Handle `preload` for individual assets
			// TODO: Do not preload bytes on native, if we can read from it instead (all non-Android targets?)

			assetsLoaded = 0;
			assetsTotal = 2; //for our initial __assetLoaded(null) call and __assetLoaded(this.id)

			for (id in preload.keys())
			{
				if (!preload.get(id)) continue;

				switch (types.get(id))
				{
					case BINARY, FONT, IMAGE, TEXT:
						assetsTotal++;

					case MUSIC, SOUND:
						Log.verbose("Preloading asset: " + id + " [" + types.get(id) + "]");
						assetsTotal++;

						var future = loadAudioBuffer(id);
						future.onProgress(load_onProgress.bind(id));
						future.onError(loadAudioBuffer_onError.bind(id));
						future.onComplete(loadAudioBuffer_onComplete.bind(id));

					default:
				}
			}

			var packedData_onComplete = function(data:Bytes)
			{
				cachedBytes.set(id, data);
				packedData = data;

				__assetLoaded(this.id);

				for (id in preload.keys())
				{
					if (!preload.get(id)) continue;

					#if (js && html5)
					// Served on demand from packedData (see the class note): count as loaded now.
					var kind = types.get(id);
					if (kind == BINARY || kind == TEXT || (kind == IMAGE && isLazyImage(id)))
					{
						__assetLoaded(id);
						continue;
					}
					#end

					switch (types.get(id))
					{
						case BINARY:
							Log.verbose("Preloading asset: " + id + " [" + types.get(id) + "]");
							var future = loadBytes(id);
							// future.onProgress (load_onProgress.bind (id));
							future.onError(load_onError.bind(id));
							future.onComplete(loadBytes_onComplete.bind(id));

						case FONT:
							Log.verbose("Preloading asset: " + id + " [" + types.get(id) + "]");
							var future = loadFont(id);
							// future.onProgress (load_onProgress.bind (id));
							future.onError(load_onError.bind(id));
							future.onComplete(loadFont_onComplete.bind(id));

						case IMAGE:
							Log.verbose("Preloading asset: " + id + " [" + types.get(id) + "]");
							var future = loadImage(id);
							// future.onProgress (load_onProgress.bind (id));
							future.onError(load_onError.bind(id));
							future.onComplete(loadImage_onComplete.bind(id));

						case TEXT:
							Log.verbose("Preloading asset: " + id + " [" + types.get(id) + "]");
							var future = loadText(id);
							// future.onProgress (load_onProgress.bind (id));
							future.onError(load_onError.bind(id));
							future.onComplete(loadText_onComplete.bind(id));

						default:
					}
				}
			};

			__assetLoaded(null);

			if (cachedBytes.exists(id))
			{
				packedData_onComplete(cachedBytes.get(id));
			}
			else
			{
				var basePath = rootPath == null || rootPath == "" ?  "" : Path.addTrailingSlash(rootPath);
				var libPath = getPath(id);
				if (libPath == null) libPath = id;

				var path = Path.join([basePath, libPath]);
				path = __cacheBreak(path);

				var packedData_onProgress = load_onProgress.bind(this.id);

				Bytes.loadFromFile(path).onProgress(packedData_onProgress).onError(promise.error).onComplete(packedData_onComplete);
			}
		}

		return promise.future;
	}

	public override function loadAudioBuffer(id:String):Future<AudioBuffer>
	{
		#if (js && html5)
		return super.loadAudioBuffer(id);
		#else
		if (cachedAudioBuffers.exists(id))
		{
			return Future.withValue(cachedAudioBuffers.get(id));
		}
		else
		{
			// TODO: More efficient method, use `loadFromBytes` method
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return Future.withValue(AudioBuffer.fromBytes(bytes));
		}
		#end
	}

	public override function loadBytes(id:String):Future<Bytes>
	{
		if (cachedBytes.exists(id))
		{
			return Future.withValue(cachedBytes.get(id));
		}
		else
		{
			// TODO: More efficient method
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return Future.withValue(bytes);
		}
	}

	public override function loadFont(id:String):Future<Font>
	{
		#if (js && html5)
		return super.loadFont(id);
		#else
		if (cachedFonts.exists(id))
		{
			return Future.withValue(cachedFonts.get(id));
		}
		else
		{
			// TODO: More efficient method
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return Font.loadFromBytes(bytes);
		}
		#end
	}

	public static function loadFromBytes(bytes:Bytes, rootPath:String = null):Future<PackedAssetLibrary>
	{
		return AssetLibrary.loadFromBytes(bytes, rootPath).then(function(library)
		{
			var assetLibrary:PackedAssetLibrary = cast library;
			return Future.withValue(assetLibrary);
		});
	}

	public static function loadFromFile(path:String, rootPath:String = null):Future<PackedAssetLibrary>
	{
		return AssetLibrary.loadFromFile(path, rootPath).then(function(library)
		{
			var assetLibrary:PackedAssetLibrary = cast library;
			return Future.withValue(assetLibrary);
		});
	}

	public static function loadFromManifest(manifest:AssetManifest):Future<PackedAssetLibrary>
	{
		return AssetLibrary.loadFromManifest(manifest).then(function(library)
		{
			var assetLibrary:PackedAssetLibrary = cast library;
			return Future.withValue(assetLibrary);
		});
	}

	public override function loadImage(id:String):Future<Image>
	{
		if (cachedImages.exists(id))
		{
			return Future.withValue(cachedImages.get(id));
		}
		#if (js && html5)
		else if (isLazyImage(id))
		{
			return Future.withValue(decodeLazyImage(id));
		}
		#end
		else
		{
			// TODO: More efficient method
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return Image.loadFromBytes(bytes);
		}
	}

	public override function loadText(id:String):Future<String>
	{
		if (cachedText.exists(id))
		{
			return Future.withValue(cachedText.get(id));
		}
		else if (cachedBytes.exists(id))
		{
			var bytes = getBytes(id);

			if (bytes == null)
			{
				return cast Future.withValue(null);
			}
			else
			{
				var text = bytes.getString(0, bytes.length);
				cachedText.set(id, text);
				return Future.withValue(text);
			}
		}
		else if (type == "gzip" || type == "deflate")
		{
			var bytes = Bytes.alloc(lengths[id]);
			bytes.blit(0, packedData, positions[id], lengths[id]);
			if (type == "gzip") bytes = bytes.decompress(GZIP);
			else if (type == "zip" || type == "deflate") bytes = bytes.decompress(DEFLATE);
			return Future.withValue(bytes.getString(0, bytes.length));
		}
		else
		{
			return Future.withValue(packedData.getString(positions[id], lengths[id]));
		}
	}

	public override function unload():Void {}

	@:noCompletion private override function __fromManifest(manifest:AssetManifest):Void
	{
		rootPath = manifest.rootPath;

		super.__fromManifest(manifest);

		var packedBytesTotal = 0;
		bytesTotal = 0;

		for (asset in manifest.assets)
		{
			var id = asset.id;

			if (Reflect.hasField(asset, "position"))
			{
				positions.set(id, Reflect.field(asset, "position"));
			}

			if (Reflect.hasField(asset, "length"))
			{
				var length = Reflect.field(asset, "length");
				lengths.set(id, length);

				//for individual packed assets, the size represents the work done unpacking them
				//since this is likely to be much faster than downloading, set it to something
				//small like the packed length / 10.
				sizes.set(id, Math.floor(length / 10));

				packedBytesTotal += length;
			}

			if (preload.exists(id) && preload.get(id) && sizes.exists(id))
			{
				bytesTotal += sizes.get(id);
			}
		}

		sizes.set(this.id, packedBytesTotal);
		bytesTotal += packedBytesTotal;
	}

	@:noCompletion private override function __assetLoaded(id:String):Void
	{
		assetsLoaded++;

		if (id != null)
		{
			Log.verbose("Loaded asset: " + id + " [" + types.get(id) + "] (" + (assetsLoaded - 1) + "/" + (assetsTotal - 1) + ")");
		}

		if (id != null)
		{
			var size = sizes.exists(id) ? sizes.get(id) : 0;

			if (!bytesLoadedCache.exists(id))
			{
				bytesLoaded += size;
			}
			else
			{
				var cache = bytesLoadedCache.get(id);

				if (cache < size)
				{
					bytesLoaded += (size - cache);
				}
			}

			bytesLoadedCache.set(id, size);
		}

		if (assetsLoaded < assetsTotal)
		{
			promise.progress(bytesLoaded, bytesTotal);
		}
		else
		{
			loaded = true;
			promise.progress(bytesTotal, bytesTotal);
			promise.complete(this);
		}
	}
}
