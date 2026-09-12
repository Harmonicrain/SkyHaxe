package skyhaxe;

#if html5
import js.Browser;
import js.html.DivElement;

/** One line of the readout. `warn` turns the value red once it leaves its healthy range. */
typedef HudRow = {
    var label:String;
    var value:String;
    var ?warn:Bool;
}

/**
 * Host-supplied settings. Both defaults describe the original `HabboCommunicationDemo` slice,
 * so a caller that passes nothing keeps the behaviour this class was written with.
 */
typedef HudOptions = {
    /**
     * Where Volter is served from, relative to the page.
     *
     * Each host lays its output out differently: the original slice copies the client's `fonts/`
     * directory beside `index.html`, while the v32 candidate serves the same faces from the
     * Truffle mount and ships no `fonts/` at all. A `@font-face` whose `src` 404s fails *silently*
     * into the next family in the stack, so the wrong path costs a fringed pixel font and no
     * error -- which is worth a parameter rather than a guess.
     */
    var ?fontUrl:String;
    /**
     * Turn the `fps` row red below this.
     *
     * It cannot be derived here. The ceiling is whatever the host set on `Stage.frameRate`, and
     * reading that would mean importing the display list this class deliberately stays outside of.
     * A host that caps itself below the default has to say so, or the row sits red while the
     * client is in fact hitting its own target.
     *
     * Compare it against `Stage.frameRate` and nothing else. The row it governs counts frames the
     * renderer drew, so it shares that ceiling -- which is the only reason the threshold means
     * anything. Set against the display's refresh rate instead it can never fire, because a
     * saturated client bottoms out at the frame-rate cap and no lower.
     */
    var ?warnBelowFps:Float;
}

/**
 * Development read-out for the running client.
 *
 * This is SkyHaxe's own instrument, not a port of anything -- `habbo-client-clean` has no
 * counterpart and none should be written for it. It lives outside `com/sulake/**` on purpose:
 * `test/SourceResolutionGuard` exists because a generated type and a hand-written one sharing a
 * fully-qualified name silently resolve to whichever the class path reaches first, and a debug
 * tool must never be able to enter that competition.
 *
 * It is a DOM overlay rather than a `Sprite` for two reasons. The stage forwards its five mouse
 * events straight into `RoomEngine` (`ConvertedRoomInput`), so anything added to the display list
 * competes with room interaction and with the canvas' own depth sort; and measuring frame cost
 * from inside the display list being measured is its own distortion. `pointer-events: none`
 * keeps every click going to the room underneath.
 *
 * What it reports is chosen from what has actually been hard to see:
 *
 *   * **fps** counts the engine's own frames -- `ENTER_FRAME` -- not animation-frame callbacks.
 *     Those are different numbers and the difference is the whole point: `requestAnimationFrame`
 *     fires at the *display's* refresh rate, so on a 75Hz monitor an idle client reads 75 and a
 *     saturated one reads 30, while the engine runs at its `Stage.frameRate` cap either way.
 *     Counting callbacks therefore reports spare capacity under the name of a frame rate, and a
 *     room dense enough to use its whole budget looks like it has halved when nothing has changed.
 *   * **head** is that callback rate, kept as its own row because it is genuinely useful once it
 *     is labelled: at the refresh rate the main thread is finishing early, and collapsed onto
 *     **fps** it has no slack left, which is the warning that comes *before* frames are lost.
 *   * **fps** and **tick** are separate numbers. The room's clock is a `haxe.Timer`, the render
 *     is `requestAnimationFrame`, and they fail independently -- a browser throttles a hidden
 *     tab's timers to 1/s while animation frames keep coming, which reads as "the engine hung"
 *     unless both are on screen.
 *   * **err/s** is the headline. An exception thrown inside `RoomEngine.update` aborts the rest
 *     of that tick, so a fault in one object stops every object scheduled behind it while the
 *     page carries on looking alive. That failure is silent, and it has cost this port whole
 *     debugging sessions; a counter makes it the first thing you see.
 *   * **worst** is the longest frame in the sampling window, which is what a stutter actually is.
 */
class PerformanceHud {
    /** Volter at its design size. The face is a pixel font; any other size fringes it. */
    static inline var FONT_SIZE = 9;
    /** Sampling window. Long enough to be stable, short enough to react to a stall. */
    static inline var SAMPLE_MS = 500.0;
    /** The original slice's layout: the client's own `fonts/` copied beside `index.html`. */
    static inline var DEFAULT_FONT_URL = "fonts/Volter.ttf";
    /** Half of OpenFL's default 60, which is the rate the original slice runs at. */
    static inline var DEFAULT_WARN_BELOW_FPS = 30.0;

    static var instance:Null<PerformanceHud>;

    final root:DivElement;
    final extraRows:Void->Array<HudRow>;
    final warnBelowFps:Float;

    var frames = 0;
    var renderedFrames = 0;
    var worstFrameMs = 0.0;
    var lastFrameAt = 0.0;
    var windowStartedAt = 0.0;
    var errorsThisWindow = 0;
    var errorsTotal = 0;
    var fps = 0.0;
    var headroomFps = 0.0;
    var errorsPerSecond = 0.0;
    var reportedWorstMs = 0.0;
    var visible = true;

    /**
     * Show the read-out.
     *
     * `extraRows` is a callback rather than a reference to the engine so this class imports
     * nothing from the port: the caller owns what it can see, and the HUD keeps working when the
     * engine is still starting or has been disposed.
     */
    public static function show(?extraRows:Void->Array<HudRow>, ?options:HudOptions):PerformanceHud {
        if (instance != null) return instance;
        instance = new PerformanceHud(extraRows == null ? function() return [] : extraRows,
            options == null ? {} : options);
        return instance;
    }

    public static function toggle():Void {
        if (instance != null) instance.setVisible(!instance.visible);
    }

    function new(extraRows:Void->Array<HudRow>, options:HudOptions) {
        this.extraRows = extraRows;
        this.warnBelowFps = options.warnBelowFps == null
            ? DEFAULT_WARN_BELOW_FPS : options.warnBelowFps;
        installFont(options.fontUrl == null ? DEFAULT_FONT_URL : options.fontUrl);

        root = Browser.document.createDivElement();
        root.setAttribute("data-skyhaxe-hud", "performance");
        var css = root.style;
        css.position = "fixed";
        css.left = "4px";
        css.top = "4px";
        css.zIndex = "2147483647";
        // Every click belongs to the room; this overlay only ever draws.
        css.pointerEvents = "none";
        css.font = FONT_SIZE + 'px Volter, "Courier New", monospace';
        css.setProperty("-webkit-font-smoothing", "none");
        css.setProperty("font-smooth", "never");
        css.lineHeight = "11px";
        css.whiteSpace = "pre";
        css.color = "#ffffff";
        css.background = "rgba(0, 0, 0, 0.62)";
        css.padding = "4px 6px";
        css.border = "1px solid rgba(255, 255, 255, 0.22)";
        css.textShadow = "1px 1px 0 rgba(0, 0, 0, 0.9)";
        Browser.document.body.appendChild(root);

        // Counted here rather than at each throw site: an uncaught error that escapes
        // RoomEngine.update never reaches any of the port's own handlers.
        Browser.window.addEventListener("error", function(_) {
            errorsThisWindow++;
            errorsTotal++;
        });

        watchFrames();

        var now = Browser.window.performance.now();
        lastFrameAt = now;
        windowStartedAt = now;
        Browser.window.requestAnimationFrame(onFrame);
    }

    public function setVisible(value:Bool):Void {
        visible = value;
        root.style.display = value ? "block" : "none";
    }

    /**
     * Volter, from the AS3 client's own `fonts/` directory.
     *
     * `habbo-client-clean` embeds this face itself -- `[Embed(source="Volter.ttf",
     * fontName="Volter", embedAsCFF="false")]` in `fonts/_Str_10363.as`, registered through
     * `FontEnum.registerFont` -- so the read-out is set in the same face the client uses for
     * BattleBall, the marketplace chart and the wired menus rather than a browser default.
     *
     * Registered here even when the host has already declared the same family. A second
     * `@font-face` naming the same file is not a conflict -- the browser resolves the family from
     * whichever source loads -- and it keeps the read-out self-sufficient, which is the same
     * reason `extraRows` is a callback: this class must not stop working because the caller
     * changed the order in which it sets its own things up.
     */
    function installFont(url:String):Void {
        var id = "skyhaxe-hud-font";
        if (Browser.document.getElementById(id) != null) return;
        var style = Browser.document.createStyleElement();
        style.id = id;
        style.textContent = "@font-face{font-family:'Volter';"
            + "src:url('" + url + "') format('truetype');"
            + "font-display:block;}";
        Browser.document.head.appendChild(style);
    }

    /**
     * Count the frames the engine actually runs.
     *
     * `ENTER_FRAME` is the frame. Lime gates its animation-frame loop on `Stage.frameRate` and
     * dispatches update and render together behind that gate, so this fires once per engine frame
     * and falls off when a frame overruns -- measured at 29.9/s against `Stage.__render`'s 29.9/s
     * on an idle client, and it is the same event `CoreComponentContext.onFrameUpdate` advances the
     * room on, so it is the client's own animation rate rather than an approximation of it.
     *
     * An earlier version of this counted draw calls on the graphics context instead, reasoning that
     * a frame which reached the GPU was a frame that happened. That undercounts badly: OpenFL draws
     * nothing at all when nothing changed, so a quiet room read 17.8 while the engine was serving a
     * true 30. Idle is not a dropped frame, and the read-out must not call it one.
     *
     * Listening on the stage is not joining the display list. Nothing is added to it, so none of
     * the mouse routing this class stays clear of is affected -- and unlike the context wrappers it
     * replaces, one listener per frame costs nothing next to the thousands of per-draw calls those
     * added. The stage may not exist yet, since the host shows the read-out before Lime has built
     * one, so this retries rather than giving up.
     */
    function watchFrames():Void {
        var stage = try openfl.Lib.current.stage catch (_:Dynamic) null;
        if (stage == null) {
            Browser.window.requestAnimationFrame(function(_) watchFrames());
            return;
        }
        stage.addEventListener(openfl.events.Event.ENTER_FRAME, function(_) renderedFrames++);
        framesObservable = true;
    }

    /** Until the stage is reachable there is no frame count, and `fps` says so rather than zero. */
    var framesObservable = false;

    function onFrame(_):Void {
        var now = Browser.window.performance.now();
        var delta = now - lastFrameAt;
        lastFrameAt = now;
        frames++;
        if (delta > worstFrameMs) worstFrameMs = delta;

        var elapsed = now - windowStartedAt;
        if (elapsed >= SAMPLE_MS) {
            fps = renderedFrames / (elapsed / 1000);
            headroomFps = frames / (elapsed / 1000);
            errorsPerSecond = errorsThisWindow / (elapsed / 1000);
            reportedWorstMs = worstFrameMs;
            frames = 0;
            renderedFrames = 0;
            errorsThisWindow = 0;
            worstFrameMs = 0;
            windowStartedAt = now;
            if (visible) render();
        }
        Browser.window.requestAnimationFrame(onFrame);
    }

    function render():Void {
        var rows:Array<HudRow> = [
            {label: "fps", value: framesObservable ? format(fps, 1) : "?",
                warn: framesObservable && fps < warnBelowFps},
            // Spare capacity, not a second frame rate. It sits at the display's refresh rate while
            // the main thread finishes early and falls to meet `fps` once it no longer does, so the
            // two rows converging is the signal -- it happens while output is still on target, and
            // is the last warning before frames start being lost.
            {label: "head", value: format(headroomFps, 1)
                + (fps > 0 && headroomFps <= fps * 1.1 ? " (none)" : ""),
                warn: fps > 0 && headroomFps <= fps * 1.1},
            {label: "worst", value: format(reportedWorstMs, 1) + "ms", warn: reportedWorstMs > 50},
            {label: "err/s", value: format(errorsPerSecond, 1)
                + (errorsTotal > 0 ? " (" + errorsTotal + ")" : ""), warn: errorsTotal > 0}
        ];
        var heap = heapMegabytes();
        if (heap != null) rows.push({label: "heap", value: heap + "mb"});
        for (row in extraRows()) rows.push(row);

        var width = 0;
        for (row in rows) if (row.label.length > width) width = row.label.length;
        var html = new StringBuf();
        for (row in rows) {
            var label = row.label;
            while (label.length < width) label += " ";
            html.add('<div style="color:' + (row.warn == true ? "#ff6b6b" : "#ffffff") + '">');
            html.add(escape(label) + " " + escape(row.value));
            html.add("</div>");
        }
        root.innerHTML = html.toString();
    }

    /** Chrome-only, and absent under some privacy settings, so it is a row that may not appear. */
    function heapMegabytes():Null<Int> {
        var memory = untyped Browser.window.performance.memory;
        if (memory == null) return null;
        return Math.round(memory.usedJSHeapSize / 1048576);
    }

    static function format(value:Float, decimals:Int):String {
        var scale = Math.pow(10, decimals);
        return Std.string(Math.round(value * scale) / scale);
    }

    /** Row values come from the caller; none of them may become markup. */
    static function escape(value:String):String {
        return StringTools.replace(StringTools.replace(StringTools.replace(value,
            "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
    }
}
#end
