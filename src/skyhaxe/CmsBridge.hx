package skyhaxe;

#if js
import js.Browser;

/** Narrow, optional bridge between the standalone client and an embedding CMS wrapper. */
class CmsBridge {
    public static inline final VERSION:Int = 1;
    static var parentOrigin:Null<String>;
    static var configured = false;

    public static function configure(config:BrowserConfig):Void {
        var candidate = config.get("cms.parent.origin");
        parentOrigin = validOrigin(candidate) ? normalizeOrigin(candidate) : null;
        configured = true;
        if (candidate != null && candidate != "" && parentOrigin == null)
            Browser.console.warn("SKYHAXE_CMS_BRIDGE_DISABLED invalid cms.parent.origin");
    }

    public static function ready():Void {
        com.sulake.core.assets.swf.SwfLoadMetrics.mark("interactiveRoomMs");
        ProfileRuntime.roomReady();
        emit("ready", {});
    }

    public static function disconnected(code:Int, clean:Bool):Void
        emit("disconnected", {code: code, clean: clean});

    public static function fatal(message:String):Void
        emit("fatal", {message: safeMessage(message)});

    public static function returnToWebsite():Void
        emit("navigate", {target: "website"});

    static function emit(event:String, detail:Dynamic):Void {
        if (!configured || parentOrigin == null || Browser.window.parent == Browser.window) return;
        Browser.window.parent.postMessage({
            source: "skyhaxe",
            version: VERSION,
            event: event,
            detail: detail
        }, parentOrigin);
    }

    static function validOrigin(value:Null<String>):Bool {
        if (value == null || value == "") return false;
        try {
            var parsed = new js.html.URL(value);
            return (parsed.protocol == "https:" || parsed.protocol == "http:")
                && parsed.username == "" && parsed.password == ""
                && (parsed.pathname == "/" || parsed.pathname == "")
                && parsed.search == "" && parsed.hash == "";
        } catch (_:Dynamic) {
            return false;
        }
    }

    static function normalizeOrigin(value:String):String return new js.html.URL(value).origin;

    static function safeMessage(value:String):String {
        if (value == null) return "Unknown startup failure";
        return value.length > 300 ? value.substr(0, 300) : value;
    }
}
#end
