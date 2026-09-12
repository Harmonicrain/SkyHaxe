package skyhaxe;

/** Navigation-relative phase markers, readable without reaching into client internals. */
class BootMetrics {
    static final phases:Dynamic = {};
    public static function mark(name:String):Void {
        var elapsed = Math.round(js.Browser.window.performance.now());
        Reflect.setField(phases, name, elapsed);
        js.Browser.window.performance.mark("skyhaxe:" + name);
        js.Browser.document.documentElement.setAttribute("data-skyhaxe-boot-ms", haxe.Json.stringify(phases));
    }
}
