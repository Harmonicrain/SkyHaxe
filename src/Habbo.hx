/** Browser host boundary for the converted HabboMain executable graph. */
class Habbo {
    public static inline final CORE_RATIO:Float = 0.6;

    static function hostCall(method:String, args:Array<Dynamic>):Void {
        #if js
        // The JS host is not always a browser: `test/V32HabboHostTest` exercises this contract
        // directly, and `js.Browser.window` is a bare `window` reference that throws without one.
        if (!js.Browser.supported) return;
        var host:Dynamic = Reflect.field(js.Browser.window, "FlashExternalInterface");
        var callback:Dynamic = host == null ? null : Reflect.field(host, method);
        if (Reflect.isFunction(callback)) {
            try Reflect.callMethod(host, callback, args) catch (_:Dynamic) {}
        }
        #end
    }

    /**
     * The client's own processlog channel, and in practice its only report of a failed boot.
     *
     * `HabboMain.prepareCore` wraps the whole component graph setup in a single try/catch whose
     * only browser-side output is this call -- the other branch is an AIR dialog. So an exception
     * while preparing a component library aborts every remaining `prepareComponent` and leaves no
     * trace at all: the client simply sits on the loading screen with a partial graph.
     *
     * The console alone is not enough to recover it. The component embed system emits one line per
     * asset, over three thousand of them, which evicts anything logged here from the buffer, and a
     * headless run can only read back the DOM. So the recent steps are also kept on the document
     * element, where `scripts/probe-v32-boot.ps1` can find them.
     */
    static final PROCESSLOG_KEPT = 40;
    static var processLog:Array<String> = [];

    public static function trackLoginStep(message:String, detail:String = null):Void {
        #if js
        var line = message + (detail == null ? "" : " " + detail);
        js.Browser.console.info("HABBO_PROCESSLOG " + line);
        processLog.push(line);
        if (processLog.length > PROCESSLOG_KEPT) processLog.shift();
        // Guarded because this file is also the contract test's entry point, which runs outside a
        // browser: `js.Browser.document` is only present when there is a document to mirror onto.
        if (js.Browser.supported) {
            var root = js.Browser.document.documentElement;
            if (root != null) root.setAttribute("data-skyhaxe-processlog", processLog.join(" || "));
        }
        #else
        trace(message);
        #end
        hostCall("logLoginStep", detail == null ? [message] : [message, detail]);
    }

    public static function reportCrash(message:String, category:Int, critical:Bool,
                                       error:ASError = null):Void {
        var payload:Dynamic = {
            error_desc: message,
            error_cat: category,
            is_fatal: critical,
            error_data: error == null ? null : error.getStackTrace()
        };
        #if js
        if (js.Browser.supported) {
            var root = js.Browser.document.documentElement;
            if (root != null) root.setAttribute("data-skyhaxe-crash", haxe.Json.stringify(payload));
        }
        if (critical) js.Browser.console.error("SKYHAXE_CLIENT_CRASH", payload);
        else js.Browser.console.warn("SKYHAXE_CLIENT_ERROR", payload);
        #else
        trace(payload);
        #end
        hostCall(critical ? "logCrash" : "logError", [haxe.Json.stringify(payload)]);
    }
}
