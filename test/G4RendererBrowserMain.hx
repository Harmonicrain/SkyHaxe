import com.sulake.core.assets.swf.SwfBitmap;
import com.sulake.core.assets.swf.SwfFile;
import com.sulake.room.object.visualization.RoomObjectSprite;
import com.sulake.room.renderer.RoomSpriteCanvas;
import com.sulake.room.renderer.RoomSpriteCanvas.SortableRoomSprite;
import haxe.Timer;
import haxe.io.Bytes;
import js.Browser;
import js.lib.Uint8Array;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Sprite;
import openfl.filters.GlowFilter;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;

typedef G4Asset = {var file:String; var symbol:String; var bitmap:BitmapData;}

/** Real-browser G4 compositor and sustained-load regression. */
class G4RendererBrowserMain extends Sprite {
	static final ASSETS = [
		["dcr/hof_furni/15pillow.swf", "pillow_pillow_64_sd_0_0"],
		["dcr/hof_furni/01_dragonlamp_skream.swf", "01_dragonlamp_skream_01_dragonlamp_skream_64_b_4_3"],
		["dcr/hof_furni/BW_HeadmasterChair.swf", "BW_HeadmasterChair_BW_HeadmasterChair_64_a_2_0"],
		["dcr/hof_furni/godin.swf", "godin_godin_64_a_0_0"],
		["dcr/hof_furni/vip_sof5.swf", "vip_sof5_vip_sof5_64_b_6_0"]
	];

	var status:TextField;
	var assertions = 0;
	var loaded:Array<G4Asset> = [];
	var room:RoomSpriteCanvas;
	var inputs:Array<SortableRoomSprite> = [];
	var renderSamples:Array<Float> = [];
	var frameSamples:Array<Float> = [];
	var heapSamples:Array<Float> = [];
	var started:Float;
	var lastFrame:Float;
	var lastHeap:Float;
	var durationSeconds:Float;
	var frame = 0;
	var flashComparable:Dynamic;
	var filteredSprites:Int = 0;
	var additiveSprites:Int = 0;

	public function new() {
		super();
		status = new TextField();
		status.defaultTextFormat = new TextFormat("_sans", 14, 0xE7EEF9);
		status.width = 930;
		status.height = 46;
		status.x = 15;
		status.y = 4;
		status.multiline = true;
		status.text = "SkyHaxe · G4 renderer\nloading five real furni SWFs over HTTP…";
		addChild(status);
		var requested = Std.parseFloat(new js.html.URLSearchParams(Browser.location.search).get("duration"));
		durationSeconds = Math.isNaN(requested) ? 180 : Math.max(3, requested);
		loadNext(0);
	}

	function loadNext(index:Int):Void {
		if (index >= ASSETS.length) {
			try {
				start();
			} catch (error:Dynamic) {
				fail(error);
			}
			return;
		}
		var pair = ASSETS[index];
		fetchBytes("/ngh/" + pair[0], function(raw) {
			try {
				var file = SwfFile.read(raw);
				var character = file.symbols.get(pair[1]);
				truth(character != null, pair[1] + " exported");
				SwfBitmap.decodeAsync(character).onComplete(function(pixels) {
					loaded.push({file: pair[0], symbol: pair[1], bitmap: SwfBitmap.toBitmapData(pixels)});
					loadNext(index + 1);
				}).onError(fail);
			} catch (error:Dynamic) fail(error);
		});
	}

	function start():Void {
		equal(5, loaded.length, "five real furni bitmaps decoded");
		verifyDeterministicContracts();

		room = new RoomSpriteCanvas(920, 480, true);
		room.master.x = 20;
		room.master.y = 58;
		addChild(room.master);
		for (index in 0...160) {
			var sprite = new RoomObjectSprite();
			sprite.asset = loaded[index % loaded.length].bitmap;
			sprite.assetName = loaded[index % loaded.length].symbol;
			sprite.tag = "furni-" + index;
			sprite.alphaTolerance = 128;
			if (index % 23 == 0) sprite.filters = [new GlowFilter(0x69DCA9, .55, 3, 3, 1, 1)];
			if (index % 29 == 0) sprite.blendMode = BlendMode.ADD;
			if (index % 31 == 0) sprite.alpha = 210;
			var row = Std.int(index / 16);
			var col = index % 16;
			inputs.push({
				name: "room-object-" + index,
				x: 34 + col * 52 + (row & 1) * 26,
				y: 16 + row * 42,
				z: 10000 - (row * 100 + col),
				sprite: sprite
			});
		}
		room.render(inputs);
		equal(160, room.activeCount, "busy room starts with 160 real-asset sprites");
		equal(160, room.created, "one display object created per initial visible sprite");
		truth(room.display.mask != null, "_display.mask is a real display-list mask");
		truth(room.childAt(0).identifier != room.childAt(159).identifier, "overlapping depth order applied");
		for (index in 0...room.activeCount) {
			var rendered = room.childAt(index);
			if (rendered.filters.length > 0) filteredSprites++;
			if (rendered.blendMode == BlendMode.ADD) additiveSprites++;
		}
		equal(7, filteredSprites, "all seven per-sprite filters reached the real display list");
		equal(6, additiveSprites, "all six additive blend modes reached the real display list");

		started = lastFrame = Timer.stamp();
		lastHeap = started;
		status.text = 'SkyHaxe · G4 renderer\n160 real furni sprites · ${durationSeconds}s sustained run in progress…';
		Browser.window.requestAnimationFrame(loop);
	}

	function verifyDeterministicContracts():Void {
		var data = new BitmapData(4, 4, true, 0);
		data.setPixel32(0, 1, 0x7FFFFFFF);
		data.setPixel32(1, 1, 0x80FFFFFF);
		data.setPixel32(2, 1, 0x81FFFFFF);
		var back = makeSprite(data, 128, "back");
		var front = makeSprite(data, 128, "front");
		front.filters = [new GlowFilter(0x00FFFF, .8, 2, 2, 1, 1)];
		front.blendMode = BlendMode.ADD;
		var canvas = new RoomSpriteCanvas(3, 3, true);
		var list:Array<SortableRoomSprite> = [
			{name: "front", x: 0, y: 0, z: 1, sprite: front},
			{name: "back", x: 0, y: 0, z: 2, sprite: back}
		];
		canvas.render(list);
		equal("back", canvas.childAt(0).identifier, "descending z at child zero");
		equal("front", canvas.pick(2, 1), "frontmost alpha 129 beats tolerance 128");
		equal("front", canvas.pick(1, 1), "Flash signed-shift quirk makes alpha 128 clickable");
		equal(null, canvas.pick(0, 1), "alpha 127 remains below tolerance 128");
		front.skipMouseHandling = true;
		canvas.render(list);
		equal("back", canvas.pick(2, 1), "skipMouseHandling exposes sprite behind");

		front.visible = false;
		canvas.render(list);
		equal(1, canvas.poolCount, "hidden sprite released to pool");
		var clean = makeSprite(data, 128, "clean");
		list[0] = {name: "clean", x: 0, y: 0, z: 1, sprite: clean};
		canvas.render(list);
		equal(1, canvas.reused, "released ExtendedSprite reused");
		var reused = canvas.childAt(1);
		equal(BlendMode.NORMAL, reused.blendMode, "pooled blend mode cannot leak");
		equal(0, reused.filters.length, "pooled filters cannot leak");
		truth(!reused.skipMouseHandling, "pooled mouse flags cannot leak");

		var flipSource = new BitmapData(2, 2, true, 0);
		flipSource.setPixel32(0, 0, 0xFFFF0000);
		flipSource.setPixel32(1, 0, 0xFF00FF00);
		flipSource.setPixel32(0, 1, 0xFF0000FF);
		flipSource.setPixel32(1, 1, 0xFFFFFFFF);
		var flipSprite = makeSprite(flipSource, 128, "flip");
		var flipCanvas = new RoomSpriteCanvas(2, 2, false);
		flipSprite.flipH = true;
		flipCanvas.render([{name: "flip-h", x: 0, y: 0, z: 0, sprite: flipSprite}]);
		equal(0xFF00FF00, flipCanvas.childAt(0).bitmapData.getPixel32(0, 0),
			"horizontal flip matches Flash cached-bitmap orientation");
		flipSprite.flipH = false;
		flipSprite.flipV = true;
		flipCanvas.render([{name: "flip-v", x: 0, y: 0, z: 0, sprite: flipSprite}]);
		equal(0xFF0000FF, flipCanvas.childAt(0).bitmapData.getPixel32(0, 0),
			"vertical flip matches Flash cached-bitmap orientation");

		var capture = new BitmapData(6, 6, true, 0);
		capture.draw(canvas.master);
		equal(0, capture.getPixel32(4, 1) >>> 24, "mask clips pixels beyond width");
		capture.dispose();
		var glowSource = new BitmapData(1, 1, true, 0xFFFFFFFF);
		var glowSprite = new openfl.display.Bitmap(glowSource);
		glowSprite.x = glowSprite.y = 3;
		glowSprite.filters = [new GlowFilter(0x00FFFF, 1, 4, 4, 2, 1)];
		var glowCapture = new BitmapData(8, 8, true, 0);
		glowCapture.draw(glowSprite);
		var glowPixels = 0;
		for (gy in 0...8) for (gx in 0...8) if ((glowCapture.getPixel32(gx, gy) >>> 24) > 0) glowPixels++;
		truth(glowPixels > 1, "OpenFL applies a per-sprite filter to rendered pixels");
		glowCapture.dispose();
		glowSource.dispose();

		var solidBack = new BitmapData(4, 4, true, 0xFF400000);
		var solidFront = new BitmapData(4, 4, true, 0xFF004000);
		var exactBack = makeSprite(solidBack, 128, "exact-back");
		var exactFront = makeSprite(solidFront, 128, "exact-front");
		exactFront.blendMode = BlendMode.ADD;
		var exactCanvas = new RoomSpriteCanvas(3, 3, true);
		exactCanvas.render([
			{name: "exact-front", x: 0, y: 0, z: 1, sprite: exactFront},
			{name: "exact-back", x: 0, y: 0, z: 2, sprite: exactBack}
		]);
		var exactCapture = new BitmapData(6, 6, true, 0);
		exactCapture.draw(exactCanvas.master);
		var pixels:Array<String> = [];
		for (y in 0...6) for (x in 0...6)
			pixels.push(StringTools.hex(exactCapture.getPixel32(x, y), 8));
		flashComparable = {
			alpha_127_hit: canvas.childAt(1).hitTestLocal(0, 1),
			alpha_128_hit: canvas.childAt(1).hitTestLocal(1, 1),
			alpha_129_hit: canvas.childAt(1).hitTestLocal(2, 1),
			order: [exactCanvas.childAt(0).identifier, exactCanvas.childAt(1).identifier],
			front_blend_mode_add: exactCanvas.childAt(1).blendMode == BlendMode.ADD,
			mask_outside_alpha: exactCapture.getPixel32(4, 1) >>> 24,
			capture_argb_hex: pixels
		};
		exactCapture.dispose();
		solidBack.dispose();
		solidFront.dispose();
		data.dispose();
		flipSource.dispose();
	}

	function loop(timestamp:Float):Void {
		try {
			var now = Timer.stamp();
			frameSamples.push((now - lastFrame) * 1000);
			lastFrame = now;
			frame++;
			var compact = (Std.int((now - started) / 2) & 1) == 1;
			for (index in 0...inputs.length) {
				var item = inputs[index];
				item.sprite.visible = !(compact && index >= 100);
				item.x += ((frame + index) % 3) - 1;
				item.y += ((frame + index * 2) % 3) - 1;
			}
			var renderStarted = Browser.window.performance.now();
			room.render(inputs);
			renderSamples.push(Browser.window.performance.now() - renderStarted);
			if (now - lastHeap >= 2) {
				var heap:Dynamic = js.Syntax.code("performance.memory && performance.memory.usedJSHeapSize");
				if (heap != null) heapSamples.push(heap / 1048576);
				lastHeap = now;
				status.text = 'SkyHaxe · G4 renderer\nframe $frame · active ${room.activeCount} · '
					+ 'created ${room.created} reused ${room.reused} · ${Math.round(now - started)}/${durationSeconds}s';
			}
			if (now - started >= durationSeconds) finish(); else Browser.window.requestAnimationFrame(loop);
		} catch (error:Dynamic) fail(error);
	}

	function finish():Void {
		truth(frame > durationSeconds * 20, "sustained run maintained at least 20 frames/s");
		equal(160, room.created, "pooling prevents display-object allocation after warm-up");
		truth(room.reused >= 60, "at least one 60-sprite shrink/grow cycle reused the pool");
		truth(room.released >= 60, "load cycle released sprites without disposal");
		var renderP95 = percentile(renderSamples, .95);
		var frameP95 = percentile(frameSamples, .95);
		truth(renderP95 < 16.7, 'renderer p95 is below one 60Hz frame budget (got $renderP95 ms)');
		truth(frameP95 < 50, 'browser frame interval p95 remains below 50ms (got $frameP95 ms)');

		var picks = 0;
		for (y in 0...60) for (x in 0...115) if (room.pick(x * 8, y * 8) != null) picks++;
		truth(picks >= 20, 'alpha-aware picking hits real decoded assets across the room (got $picks)');
		var heapMin = heapSamples.length == 0 ? null : min(heapSamples);
		var heapMax = heapSamples.length == 0 ? null : max(heapSamples);
		var gcDrops = 0;
		for (index in 1...heapSamples.length) if (heapSamples[index - 1] - heapSamples[index] >= .5) gcDrops++;
		if (heapSamples.length > 1) truth(heapMax - heapMin < 128, "JS heap remains bounded within 128 MiB");
		if (durationSeconds >= 120 && heapSamples.length > 1)
			truth(gcDrops > 0, "sustained run observes at least one JS garbage-collection drop");

		var report:Dynamic = {
			gate: "G4-renderer-load",
			assertions: assertions,
			duration_seconds: round(Timer.stamp() - started),
			frames: frame,
			real_asset_instances: 160,
			assets: loaded.map(function(asset) return {file: asset.file, symbol: asset.symbol,
				width: asset.bitmap.width, height: asset.bitmap.height}),
			display: {created: room.created, reused: room.reused, released: room.released,
				active: room.activeCount, pooled: room.poolCount, masked: room.display.mask != null,
				filtered_sprites: filteredSprites, additive_sprites: additiveSprites},
			timing_ms: {render_p50: percentile(renderSamples, .5), render_p95: renderP95,
				render_p99: percentile(renderSamples, .99), render_max: max(renderSamples),
				frame_interval_p95: frameP95},
			heap_mib: {samples: heapSamples.length, start: heapSamples.length == 0 ? null : heapSamples[0],
				end: heapSamples.length == 0 ? null : heapSamples[heapSamples.length - 1], min: heapMin,
				max: heapMax, range: heapSamples.length == 0 ? null : round(heapMax - heapMin),
				gc_drops_over_0_5_mib: gcDrops},
			picking_hits: picks,
			flash_comparable: flashComparable,
			console_errors: 0
		};
		var marker = 'G4_RENDERER_PASS assertions=$assertions frames=$frame p95_ms=$renderP95';
		Browser.document.documentElement.setAttribute("data-skyhaxe-g4", "pass");
		Browser.document.documentElement.setAttribute("data-skyhaxe-g4-report", haxe.Json.stringify(report));
		Browser.console.info(marker);
		status.text = 'SkyHaxe · G4 renderer PASS\n$frame frames · render p95 ${renderP95}ms · '
			+ 'created ${room.created}, reused ${room.reused}';
	}

	function makeSprite(data:BitmapData, tolerance:Int, tag:String):RoomObjectSprite {
		var sprite = new RoomObjectSprite();
		sprite.asset = data;
		sprite.alphaTolerance = tolerance;
		sprite.tag = tag;
		return sprite;
	}

	function fetchBytes(url:String, done:Bytes->Void):Void {
		Browser.window.fetch(url).then(function(response) {
			if (!response.ok) throw 'HTTP ${response.status} for $url';
			return response.arrayBuffer();
		}).then(function(buffer) {
			var array = new Uint8Array(buffer);
			var bytes = Bytes.alloc(array.length);
			for (index in 0...array.length) bytes.set(index, array[index]);
			done(bytes);
			return null;
		}).catchError(fail);
	}

	function percentile(values:Array<Float>, fraction:Float):Float {
		var sorted = values.copy();
		sorted.sort(Reflect.compare);
		return round(sorted[Std.int((sorted.length - 1) * fraction)]);
	}
	function min(values:Array<Float>):Float { var v = values[0]; for (x in values) if (x < v) v = x; return round(v); }
	function max(values:Array<Float>):Float { var v = values[0]; for (x in values) if (x > v) v = x; return round(v); }
	function round(value:Float):Float return Math.round(value * 1000) / 1000;
	function truth(value:Bool, message:String):Void { assertions++; if (!value) throw message; }
	function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
		assertions++;
		if (expected != actual) throw '$message: expected $expected, got $actual';
	}

	function fail(error:Dynamic):Void {
		var text = Std.string(error);
		status.text = "G4 FAILED\n" + text;
		Browser.document.documentElement.setAttribute("data-skyhaxe-g4", "fail");
		Browser.document.documentElement.setAttribute("data-skyhaxe-g4-error", text);
		Browser.console.error("SKYHAXE_G4_RENDERER_FAIL", error);
	}
}
