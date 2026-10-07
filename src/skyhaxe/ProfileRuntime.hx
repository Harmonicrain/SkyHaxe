package skyhaxe;

#if (js && html5 && skyhaxe_profile)
import com.sulake.core.assets.swf.SwfLoadMetrics;
import haxe.Json;
import js.Browser;
import openfl.display.Stage;
import openfl.events.Event;

/** Lightweight, opt-in profiler for repeatable room benchmarks. */
class ProfileRuntime {
    static inline final FRAME_TARGET_MS:Float = 33.333333;
    static inline final MAX_SAMPLES:Int = 20000;
    static var enabled = false;
    static var initialized = false;
    static var recording = false;
    static var completed = false;
    static var readyAt:Null<Float>;
    static var startedAt:Null<Float>;
    static var previousFrame:Null<Float>;
    static var frames:Array<Float> = [];
    static var samples:Dynamic = {};
    static var counters:Dynamic = {};
    static var gauges:Dynamic = {};
    static var metadata:Dynamic = {};
    static var scenario = "manual";
    static var warmupMs = 5000;
    static var durationMs = 15000;
    static var preparationStarted = false;
    static var renderedFrameSerial = 0;

    public static function init(stage:Stage):Void {
        if (initialized) return;
        initialized = true;
        enabled = parameter("profile") == "1";
        if (!enabled) return;

        scenario = stringParameter("profileScenario", "manual");
        warmupMs = intParameter("profileWarmupMs", 5000, 0, 60000);
        durationMs = intParameter("profileDurationMs", 15000, 1000, 120000);
        metadata = {
            schema: 1,
            scenario: scenario,
            browser: Browser.navigator.userAgent,
            viewport: {width: Browser.window.innerWidth, height: Browser.window.innerHeight},
            devicePixelRatio: Browser.window.devicePixelRatio,
            frameTargetMs: FRAME_TARGET_MS,
            gpuTimer: "unavailable"
        };
        Browser.window.fetch("profile-build.json").then(function(response) {
            return response.ok ? response.json() : null;
        }).then(function(build) {
            if (build != null) Reflect.setField(metadata, "build", build);
            return null;
        }).catchError(function(_) return null);
        Reflect.setField(Browser.window, "__skyhaxeProfileState", "waiting-room");
        Reflect.setField(Browser.window, "__skyhaxeProfileStop", stop);
        Reflect.setField(Browser.window, "__skyhaxeProfilePrepareDone", prepareDone);
        Reflect.setField(Browser.window, "__skyhaxeProfileGauge", function(name:String) return Reflect.field(gauges, name));
        stage.addEventListener(Event.ENTER_FRAME, onFrame);
        installWebGlCounters();
        Browser.console.info("SKYHAXE_PROFILE waiting for explicit room-ready signal");
    }

    public static function roomReady():Void {
        if (!enabled || completed || readyAt != null) return;
        readyAt = now();
        Reflect.setField(Browser.window, "__skyhaxeProfileState", "setup");
        if (parameter("profileManaged") != "1") prepareDone();
    }

    public static function prepareDone():Void {
        if (!enabled || completed || preparationStarted) return;
        preparationStarted = true;
        Reflect.setField(Browser.window, "__skyhaxeProfileState", "warming-up");
        Browser.window.setTimeout(start, warmupMs);
    }

    public static inline function begin():Float return enabled && recording ? now() : -1;

    public static function end(name:String, began:Float):Void {
        if (began < 0 || !recording) return;
        addSample(name, now() - began);
    }

    public static function count(name:String, amount:Int = 1):Void {
        if (!enabled || !recording) return;
        var old:Dynamic = Reflect.field(counters, name);
        Reflect.setField(counters, name, (old == null ? 0 : Std.int(old)) + amount);
    }

    public static function gauge(name:String, value:Float):Void {
        if (!enabled) return;
        Reflect.setField(gauges, name, value);
    }

    public static inline function frameSerial():Int return renderedFrameSerial;

    static function start():Void {
        if (!enabled || completed) return;
        frames = [];
        samples = {};
        counters = {};
        previousFrame = null;
        renderedFrameSerial = 0;
        startedAt = now();
        recording = true;
        Reflect.setField(Browser.window, "__skyhaxeProfileState", "recording");
        Browser.console.info("SKYHAXE_PROFILE recording " + scenario);
        Browser.window.setTimeout(stop, durationMs);
    }

    public static function stop():Void {
        if (!enabled || completed || !recording) return;
        recording = false;
        completed = true;
        var ended = now();
        var result:Dynamic = {
            schema: 1,
            metadata: metadata,
            timing: {
                roomReadyMs: readyAt,
                recordingStartedMs: startedAt,
                durationMs: startedAt == null ? 0 : ended - startedAt
            },
            frames: summarize(frames),
            sections: summarizeFields(samples),
            counters: counters,
            gauges: gauges,
            assets: SwfLoadMetrics.snapshot(),
            raw: {frameIntervalsMs: frames.copy()}
        };
        Reflect.setField(Browser.window, "__skyhaxeProfileResult", result);
        Reflect.setField(Browser.window, "__skyhaxeProfileState", "complete");
        Browser.document.documentElement.setAttribute("data-skyhaxe-profile-state", "complete");
        Browser.console.info("SKYHAXE_PROFILE_RESULT " + Json.stringify(result));
    }

    static function onFrame(_:Event):Void {
        if (!recording) return;
        renderedFrameSerial++;
        var current = now();
        if (previousFrame != null && frames.length < MAX_SAMPLES) frames.push(current - previousFrame);
        previousFrame = current;
    }

    static function addSample(name:String, value:Float):Void {
        var values:Array<Float> = cast Reflect.field(samples, name);
        if (values == null) {
            values = [];
            Reflect.setField(samples, name, values);
        }
        if (values.length < MAX_SAMPLES) values.push(value);
    }

    static function summarizeFields(value:Dynamic):Dynamic {
        var result:Dynamic = {};
        for (name in Reflect.fields(value))
            Reflect.setField(result, name, summarize(cast Reflect.field(value, name)));
        return result;
    }

    static function summarize(values:Array<Float>):Dynamic {
        if (values == null || values.length == 0)
            return {count: 0, medianMs: null, p95Ms: null, p99Ms: null, maxMs: null, overTarget: 0};
        var sorted = values.copy();
        sorted.sort(function(a, b) return a < b ? -1 : (a > b ? 1 : 0));
        var over = 0;
        var total = 0.0;
        for (value in values) {
            total += value;
            if (value > FRAME_TARGET_MS) over++;
        }
        return {
            count: values.length,
            meanMs: total / values.length,
            medianMs: percentile(sorted, 0.5),
            p95Ms: percentile(sorted, 0.95),
            p99Ms: percentile(sorted, 0.99),
            maxMs: sorted[sorted.length - 1],
            overTarget: over
        };
    }

    static function percentile(sorted:Array<Float>, p:Float):Float {
        return sorted[Std.int(Math.min(sorted.length - 1, Math.ceil(sorted.length * p) - 1))];
    }

    static inline function now():Float return Browser.window.performance.now();

    static function stringParameter(name:String, fallback:String):String {
        var value = parameter(name);
        return value == null || value == "" ? fallback : value;
    }

    static function intParameter(name:String, fallback:Int, minimum:Int, maximum:Int):Int {
        var parsed = Std.parseInt(parameter(name));
        if (parsed == null) return fallback;
        return Std.int(Math.max(minimum, Math.min(maximum, parsed)));
    }

    static function parameter(name:String):Null<String> {
        var search = new js.html.URLSearchParams(Browser.window.location.search).get(name);
        if (search != null) return search;
        var hash = Browser.window.location.hash;
        if (hash != null && hash.length > 1)
            return new js.html.URLSearchParams(hash.substr(1)).get(name);
        return null;
    }

    static function installWebGlCounters():Void {
        for (className in ["WebGLRenderingContext", "WebGL2RenderingContext"]) {
            wrapPrototype(className, ["drawArrays", "drawElements"], "webglDrawCalls");
            wrapPrototype(className, ["bindTexture"], "textureBinds");
            wrapPrototype(className, ["texImage2D", "texSubImage2D"], "textureUploads");
        }
        wrapPrototype("CanvasRenderingContext2D", ["drawImage", "fillRect", "strokeRect", "fill", "stroke"], "canvasDrawCalls");
        wrapPrototype("CanvasRenderingContext2D", ["putImageData", "createImageData"], "canvasPixelOperations");
    }

    static function wrapPrototype(className:String, methods:Array<String>, counter:String):Void {
        var constructor:Dynamic = Reflect.field(Browser.window, className);
        if (constructor == null) return;
        var prototype:Dynamic = Reflect.field(constructor, "prototype");
        for (method in methods) {
            var marker = "__skyhaxeProfile_" + method;
            if (Reflect.field(prototype, marker) == true) continue;
            var original:Dynamic = Reflect.field(prototype, method);
            if (original == null) continue;
            Reflect.setField(prototype, marker, true);
            // Capture each native method in its own closure. A closure written directly in this
            // loop shares Haxe's emitted `var original`, causing every wrapper to call the final
            // method from the list (for example Canvas `stroke()` calling `createImageData()`).
            var wrapper:Dynamic = js.Syntax.code(
                "(function(original, count, counter){ return function(){ count(counter, 1); return original.apply(this, arguments); }; })({0}, {1}, {2})",
                original, count, counter);
            Reflect.setField(prototype, method, wrapper);
        }
    }
}
#else
import openfl.display.Stage;

class ProfileRuntime {
    public static inline function init(stage:Stage):Void {}
    public static inline function roomReady():Void {}
    public static inline function prepareDone():Void {}
    public static inline function begin():Float return -1;
    public static inline function end(name:String, began:Float):Void {}
    public static inline function count(name:String, amount:Int = 1):Void {}
    public static inline function gauge(name:String, value:Float):Void {}
    public static inline function frameSerial():Int return 0;
}
#end
