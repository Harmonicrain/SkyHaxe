import com.sulake.core.window.text.TruffleText;
import com.sulake.habbo.configuration.ExternalVariables;
import com.sulake.habbo.utils.HabboWebTools;
import js.Browser;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;

/** Browser host for the converted HabboMain component graph. */
@:access(com.sulake.core.runtime.ComponentContext)
@:access(com.sulake.core.runtime.Component)
class V32BrowserMain extends Sprite {
    /**
     * Runtime configuration, in the shape NGHWin already uses.
     *
     * The AIR host reads a `config.ini` beside the executable and derives every gamedata URL from
     * `base.url`; this is the same file served next to the page, so the two hosts are configured
     * the same way and neither carries hardcoded URLs. See `skyhaxe.BrowserConfig`.
     */
    static inline final CONFIG_URL = "config.ini";
    /**
     * The same bundle and style set the working host warms (`HabboCommunicationDemo`).
     *
     * Both are needed before any component runs. `WindowParser` measures a caption the moment it
     * builds a window, which reaches `TruffleText.openFLMetrics` -- and unlike `drawOpenFLRun`,
     * which refuses with a clear message, `openFLMetrics` dereferences the instance unguarded. In
     * Flash the faces are embedded in the SWF and are simply present; on HTML5 the host has to
     * fetch them, so the host is what has to wait.
     */
    static final TRUFFLE_BASE = "/assets/truffle";
    /**
     * Faces the browser renders itself, rather than through Truffle.
     *
     * Truffle is the pixel-exact path for the client's Ubuntu text. Volter is a plain bitmap-style
     * face with no such requirement, so it goes through the normal text path -- but `FontAsset`
     * only ever registered a name and a style, never any glyph data, so the family has to exist as
     * a real CSS face before anything can draw with it.
     */
    static final NATIVE_FACES = [
        {family: "Volter", file: "Volter.ttf", weight: "normal"},
        {family: "Volter Bold", file: "Volter-Bold.ttf", weight: "normal"}
    ];
    static final TRUFFLE_STYLES =
        ["u_regular", "u_bold", "u_small", "u_frame_title", "button_shiny_bold"];

    public function new() {
        super();
        if (stage == null) addEventListener(Event.ADDED_TO_STAGE, added);
        else boot();
    }

    function added(_:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, added);
        boot();
    }

    function boot():Void {
        // Flash clips source and destination as one mapping. Lime 8.3.2 clips them in sequence,
        // double-applying paired negative offsets and shifting bottom-aligned room panoramas.
        skyhaxe.compat.BitmapCopyPixels.install();
        // The embed system logs thousands of lines, so the console ring buffer cannot be trusted to
        // still hold a startup error by the time it is read. Keep the first one on window instead.
        untyped js.Syntax.code("window.addEventListener('error', function(e){ if(!window.__skyhaxeFirstError) { window.__skyhaxeFirstError = String(e.message) + ' @ ' + String(e.error && e.error.stack || '').substr(0,4000); document.documentElement.setAttribute('data-skyhaxe-first-error', window.__skyhaxeFirstError); } })");
        // Haxe wraps the whole program in a closure, so nothing inside it can be reached from the
        // console. Publishing the class registry makes the running client inspectable -- the only
        // way to see what generated code actually does at runtime, since it cannot be edited.
        untyped js.Syntax.code("window.__hxClasses = $hxClasses");
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        stage.color = 0x000000;
        // The NGH HabboAir.swf header declares 30fps, and the client's animation is a frame
        // counter rather than a clock: `CoreComponentContext.onFrameUpdate` advances the room once
        // per ENTER_FRAME, so the rate the browser paints at *is* the animation speed. Left at the
        // browser's own ~60Hz every looping furni ran at double speed.
        //
        // Lime honours this on HTML5 -- `HTML5Window.setFrameRate` turns anything under 60 into a
        // frame period for its animation-frame loop -- unlike the `fps` attribute in project.xml,
        // which does not reach it.
        stage.frameRate = 30;
        #if debug
        // Development builds only -- `scripts/build-html5.ps1 -Final` compiles without `debug`, so
        // a release never carries the read-out. F2 hides it when it is over something.
        //
        // Both options exist because this host differs from the one the read-out was written for.
        // The faces live on the Truffle mount rather than in a `fonts/` directory beside the page,
        // and the cap set immediately above is half the default, so the stock threshold would hold
        // the row red while the client was hitting its target exactly.
        skyhaxe.PerformanceHud.show(roomContentRows, {
            fontUrl: TRUFFLE_BASE + "/fonts/Volter.ttf",
            warnBelowFps: 27
        });
        stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN,
            function(event:openfl.events.KeyboardEvent) {
                if (event.keyCode == 113) skyhaxe.PerformanceHud.toggle();
            });
        #end
        Browser.document.documentElement.setAttribute("data-skyhaxe-candidate", "loading-variables");

        // The config decides where the variables live, so it has to arrive first. Everything after
        // it is fetched at once and joined rather than chained, so a slow font bundle does not
        // serialize behind the variables request.
        skyhaxe.BrowserConfig.load(CONFIG_URL, function(config) {
            var variablesUrl = config.get("external.variables.txt");
            var fontsReady = false;
            var loadedVariables:ExternalVariables = null;
            var failed = false;
            function startWhenReady():Void {
                if (!failed && fontsReady && loadedVariables != null) startClient(config, loadedVariables);
            }
            ExternalVariables.load(variablesUrl, function(loaded) {
                loadedVariables = loaded;
                startWhenReady();
            }, function(error) {
                failed = true;
                fail("Could not load " + variablesUrl + ": " + Std.string(error));
            });
            loadNativeFaces();
        TruffleText.load(TRUFFLE_BASE, TRUFFLE_STYLES, function() {
                fontsReady = true;
                startWhenReady();
            }, function(error) {
                failed = true;
                fail("Text renderer failed to load: " + Std.string(error));
            });
        });
    }

    /**
     * Declare the non-Truffle faces to the browser and start fetching them.
     *
     * Not joined into the boot gate: a missing Volter costs a fallback face on some labels, which
     * is not worth holding the whole client for, and the browser re-lays-out text once the face
     * arrives anyway.
     */
    function loadNativeFaces():Void {
        var css = new StringBuf();
        for (face in NATIVE_FACES) {
            css.add("@font-face{font-family:'" + face.family + "';");
            css.add("src:url('" + TRUFFLE_BASE + "/fonts/" + face.file + "') format('truetype');");
            css.add("font-weight:" + face.weight + ";font-style:normal;font-display:block;}");
        }
        var style = Browser.document.createStyleElement();
        style.textContent = css.toString();
        Browser.document.head.appendChild(style);
        for (face in NATIVE_FACES) {
            var fonts:Dynamic = untyped Browser.document.fonts;
            if (fonts != null) fonts.load("9px '" + face.family + "'");
        }
    }

    function startClient(config:skyhaxe.BrowserConfig, variables:ExternalVariables):Void {
        var parameters = new ASObject();
        for (key => value in variables.values)
            ASCompat.setDynamicProperty(parameters, key, value);

        // Config last, so it wins over the variables file. The client keeps every host parameter
        // read-only, so these also survive its own external.variables.txt download.
        for (key in config.keys())
            ASCompat.setDynamicProperty(parameters, key, config.get(key));

        // The URL is the last word, matching NGHWin's "config file < CLI args".
        var ticket = urlValue("sso");
        if (ticket != null && ticket != "")
            ASCompat.setDynamicProperty(parameters, "sso.ticket", ticket);
        var host = urlValue("host");
        if (host != null && host != "")
            ASCompat.setDynamicProperty(parameters, "connection.info.host", host);
        var port = urlValue("port");
        if (port != null && port != "")
            ASCompat.setDynamicProperty(parameters, "connection.info.port", port);
        HabboWebTools.airParameters = parameters;
        HabboWebTools.rootLoaderInfo = loaderInfo;
        HabboWebTools.isSpaWeb = false;

        var starting:Dynamic = ASCompat.getDynamicProperty(parameters, "client.starting");
        if (starting == null || Std.string(starting) == "") starting = "client.starting";
        var revolving:Dynamic = ASCompat.getDynamicProperty(parameters, "client.starting.revolving");
        if (revolving != "client.starting.revolving") revolving = null;
        // This is the converted Flash preloader itself: PhotoSplashScreen, the original random
        // postcard set, Ubuntu text, two-tone progress bar and percentage. Only parameter/stage
        // delivery remains a browser-host responsibility.
        var loading = new HabboLoadingScreen(stage.stageWidth, stage.stageHeight,
            Std.string(starting), revolving == null ? null : Std.string(revolving));
        addChild(loading);
        // No display container: the second argument becomes Core's container, and from there the
        // window manager's mouse root. `Habbo.as` -- the browser host this seam stands in for --
        // passes only the loading screen, so Core uses the stage; `HabboAir.as` passes a container
        // solely on Android. Passing this sprite made the root a child of the stage, and a child
        // only receives MOUSE_UP while the pointer is over its own content, so releasing a dragged
        // window anywhere else never ended the drag.
        var main = new HabboMain(loading);
        addChild(main);
        watchFrameEvents(main);
        probeTypeCheck();
        Browser.document.documentElement.setAttribute("data-skyhaxe-candidate", "component-graph-started");
        Browser.console.info("SKYHAXE_V32_COMPONENT_GRAPH_STARTED");
        watchComponentGraph();
    }

    /**
     * Poll the graph instead of sampling it once.
     *
     * A fixed 1.5s delay fired long before `Core` existed -- the client's own log only reaches
     * "Initializing Core!" around twelve seconds in -- so the sample threw on a null instance and
     * the report never printed. Polling also shows the graph *draining*: the interesting number is
     * which components are still locked once the count stops falling, not which are locked while
     * dependencies are still resolving normally.
     */
    /**
     * Report the interface test the message table is rejected by, rather than inferring it.
     *
     * `MessageClassManager.registerMessageEventClass` refuses any event class that does not answer
     * `ClassUtils.implementsInterface(cls, IMessageEvent)`, and one refusal aborts the rest of
     * `HabboMain.prepareCore` silently. The two sides of that comparison are the describeType
     * document and the qualified name of the interface, so both are printed whole: a mismatch is
     * only diagnosable by seeing what each side actually produced.
     *
     * Classes are looked up by name because a Haxe interface cannot be written as a value here.
     */
    function probeTypeCheck():Void {
        var report = "";
        try {
            var eventClass = Type.resolveClass(
                "com.sulake.habbo.communication.messages.incoming.error.ErrorReportEvent");
            var interfaceClass = Type.resolveClass(
                "com.sulake.core.communication.messages.IMessageEvent");
            report = "eventClass=" + (eventClass != null)
                + " interfaceClass=" + (interfaceClass != null);
            if (eventClass != null && interfaceClass != null) {
                report += " target=" + ASCompat.getQualifiedClassName(interfaceClass)
                    + " result=" + com.sulake.core.utils.ClassUtils.implementsInterface(
                        eventClass, interfaceClass)
                    + " xml=" + ASCompat.describeType(eventClass).toString().substr(0, 500);
            }
        } catch (error:Dynamic) {
            report = "threw " + Std.string(error);
        }
        // The class test is only half of it. registerMessages reads each event class back out of
        // the message table by key, so report what that lookup actually returns for the key that
        // fails -- an absent value reaches implementsInterface as `undefined` and is rejected the
        // same way a genuinely wrong class would be.
        try {
            var messages = new com.sulake.habbo.communication.HabboMessages();
            var events = messages.events;
            var keys = events.getKeys();
            report += " | events=" + keys.length;
            if (keys.length > 0) {
                var first = keys[0];
                var value = events.getValue(first);
                report += " firstKey=" + Std.string(first)
                    + " keyType=" + Std.string(Type.typeof(first))
                    + " value=" + (value == null ? "NULL/UNDEFINED"
                        : Std.string(Type.getClassName(cast value)));
            }
            var byInt = events.getValue(10);
            var byString = events.getValue("10");
            report += " at10Int=" + (byInt == null ? "NULL" : "ok")
                + " at10String=" + (byString == null ? "NULL" : "ok");
        } catch (error:Dynamic) {
            report += " | tableProbeThrew " + Std.string(error);
        }
        Browser.document.documentElement.setAttribute("data-skyhaxe-typecheck", report);
    }

    function watchComponentGraph():Void {
        var elapsed = 0;
        var lastReport = "";
        var timer = new haxe.Timer(2000);
        timer.run = function() {
            elapsed += 2000;
            // Reporting is the whole job here: a throw inside it used to stop the timer, which
            // silently removed the census and the locked list for the rest of the run.
            var report = try {
                probeConfiguration();
                lockedComponents();
            } catch (error:Dynamic) {
                "diagnostic failed: " + Std.string(error);
            }
            if (report != null && report != lastReport) {
                lastReport = report;
                untyped Browser.window.__skyhaxeLocked = {t: elapsed, report: report};
                Browser.document.documentElement.setAttribute("data-skyhaxe-locked",
                    elapsed + "ms " + report);
            }
            if (elapsed >= 60000) timer.stop();
        };
    }

    /**
     * Read the bootstrap properties the deadlock actually depends on.
     *
     * `HabboLocalizationManager` loads `external.texts.txt` through the asset library, and the
     * configuration manager only unlocks once that load completes. The request is never issued and
     * the URL is valid, so the question is whether the property reaches the component at all --
     * this reports it from the live graph rather than inferring it.
     */
    var probed = false;

    /**
     * Count the frame events HabboMain's boot actually depends on.
     *
     * `prepareCore` -- which calls `Core.instantiate` and is therefore the gate on the whole graph
     * -- runs from ADDED_TO_STAGE setting a flag and the next EXIT_FRAME acting on it. Some runs
     * reach it and some do not, so this reports whether those two events are arriving at all rather
     * than inferring it from what failed downstream.
     */
    function watchFrameEvents(main:HabboMain):Void {
        var added = 0;
        var exits = 0;
        var enters = 0;
        main.addEventListener(Event.ADDED_TO_STAGE, function(_) added++);
        main.addEventListener(Event.EXIT_FRAME, function(_) exits++);
        main.addEventListener(Event.ENTER_FRAME, function(_) enters++);
        var startedAt = haxe.Timer.stamp();
        var timer = new haxe.Timer(1000);
        timer.run = function() {
            // HabboMain takes itself off the stage once the room is running -- `Habbo.as` disposes
            // it the same way -- so there is nothing left to report and every later tick would
            // throw reading a null stage straight into the client's own console.
            if (main.stage == null) {
                timer.stop();
                return;
            }
            var report = {
                uptimeS: Math.round(haxe.Timer.stamp() - startedAt),
                addedToStage: added,
                enterFrames: enters,
                exitFrames: exits,
                onStage: main.stage != null,
                coreInstance: com.sulake.core.Core.instance != null,
                // Distinguishes "a frame threw and left the re-entrancy guard set" from "frames are
                // not being driven at all": Stage.__onLimeRender sets this on entry and clears it
                // on the last line, with no try/finally to restore it if a listener throws.
                stageRendering: untyped main.stage.__rendering,
                firstError: untyped Browser.window.__skyhaxeFirstError
            };
            // Mirrored onto the document element, not just logged: the component embed system emits
            // one console line per asset -- over three thousand of them -- which evicts anything
            // logged here long before it can be read, and a headless run can only recover the DOM.
            untyped Browser.window.__skyhaxeFrames = report;
            Browser.document.documentElement.setAttribute("data-skyhaxe-frames",
                haxe.Json.stringify(report));
        };
    }

    function probeConfiguration():Void {
        if (probed) return;
        var core:com.sulake.core.runtime.CoreComponentContext = cast com.sulake.core.Core.instance;
        // `_components` is nulled by ComponentContext.dispose, so a live Core is not enough.
        if (core == null || core._components == null) return;
        probed = true;
        var seeded = ASCompat.getDynamicProperty(
            com.sulake.habbo.utils.HabboWebTools.getParameterMap(null), "external.texts.txt");
        untyped Browser.window.__skyhaxeProbe = {textsParameter: Std.string(seeded)};
        for (component in core._components) {
            var name = Type.getClassName(Type.getClass(component));
            if (name.indexOf("ConfigurationManager") < 0) continue;
            var configuration:com.sulake.habbo.configuration.HabboConfigurationManager = cast component;
            untyped Browser.window.__skyhaxeProbe.configuration = name;
            untyped Browser.window.__skyhaxeProbe.texts =
                Std.string(configuration.getProperty("external.texts.txt"));
            untyped Browser.window.__skyhaxeProbe.clientUrl =
                Std.string(configuration.getProperty("flash.client.url"));
            untyped Browser.window.__skyhaxeProbe.configurationLocked = component.locked;
        }
        var localization = 0;
        for (component in core._components)
            if (Type.getClassName(Type.getClass(component)).indexOf("LocalizationManager") >= 0) localization++;
        untyped Browser.window.__skyhaxeProbe.localizationManagers = localization;
        untyped Browser.window.__skyhaxeProbe.totalComponents = core._components.length;
    }

    #if debug
    /** Resolved once and kept: the graph hands out the same instance for the life of the client. */
    var hudRoomEngine:com.sulake.habbo.room.RoomEngine = null;

    /**
     * What the room is actually carrying, as read-out rows.
     *
     * This lives in the host rather than in `PerformanceHud` because the read-out imports nothing
     * from the port -- `extraRows` is a callback precisely so the caller owns what it can see, and
     * the HUD has to keep working while the graph is still starting or after it is gone.
     *
     * The counts come from `RoomEngine.getRoomObjectCount`, which is the engine's own census by
     * category, so they are the room's contents rather than anything the renderer derived from
     * them. Floor and wall items are split because they are separate categories to the server, to
     * the database and to the user; a single "furni" total would hide which half a heavy room is
     * heavy with.
     *
     * Every step is allowed to fail quietly and yield no rows. This runs twice a second inside the
     * read-out's own frame callback, and a throw here would take the read-out down with it -- which
     * would be the diagnostic removing itself at exactly the moment something is wrong.
     */
    function roomContentRows():Array<skyhaxe.PerformanceHud.HudRow> {
        try {
            if (hudRoomEngine == null) {
                var core:com.sulake.core.runtime.CoreComponentContext = cast com.sulake.core.Core.instance;
                if (core == null || core._components == null) return [];
                for (component in core._components) {
                    if (Std.isOfType(component, com.sulake.habbo.room.RoomEngine)) {
                        hudRoomEngine = cast component;
                        break;
                    }
                }
                if (hudRoomEngine == null) return [];
            }
            var room = hudRoomEngine.activeRoomId;
            if (room == 0) return [];
            var floor = hudRoomEngine.getRoomObjectCount(room,
                com.sulake.habbo.room.object.RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            var wall = hudRoomEngine.getRoomObjectCount(room,
                com.sulake.habbo.room.object.RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            var users = hudRoomEngine.getRoomObjectCount(room,
                com.sulake.habbo.room.object.RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            return [
                {label: "furni", value: Std.string(floor + wall)
                    + " (" + floor + "f " + wall + "w)"},
                {label: "users", value: Std.string(users)}
            ];
        } catch (_:Dynamic) {
            return [];
        }
    }
    #end

    function lockedComponents():Null<String> {
        var core:com.sulake.core.runtime.CoreComponentContext = cast com.sulake.core.Core.instance;
        if (core == null || core._components == null) return null;
        var locked:Array<String> = [];
        // A census of every component, not only the locked ones. The locked list alone is
        // misleading here: the component that matters may be one that was never instantiated, and
        // an absent component cannot appear in a list of things that are waiting.
        var census:Array<String> = [];
        for (component in core._components) {
            var name = Type.getClassName(Type.getClass(component));
            var short = name.split(".").pop();
            census.push(short + (component.locked ? ":locked" : ":ready"));
            if (!component.locked) continue;
            locked.push(name + " waiting=" + component._requiredDependencyIids.toString());
        }
        census.sort(Reflect.compare);
        Browser.document.documentElement.setAttribute("data-skyhaxe-census",
            core._components.length + " components: " + census.join(","));
        return locked.length == 0 ? "none (graph fully resolved)" : locked.join(" | ");
    }

    function urlValue(name:String):String {
        var query = new js.html.URLSearchParams(Browser.location.search).get(name);
        if (query != null && query != "") return query;
        var hash = Browser.location.hash;
        if (StringTools.startsWith(hash, "#")) hash = hash.substr(1);
        return new js.html.URLSearchParams(hash).get(name);
    }

    function fail(message:String):Void {
        Browser.document.documentElement.setAttribute("data-skyhaxe-candidate", "error");
        Browser.console.error("SKYHAXE_V32_VARIABLES_FAILED " + message);
    }
}
