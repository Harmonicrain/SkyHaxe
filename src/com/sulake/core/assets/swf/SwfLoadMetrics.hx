package com.sulake.core.assets.swf;

#if html5
import js.Browser;

/** Small cumulative boot probe, exposed in the DOM so headless and interactive runs can read it. */
class SwfLoadMetrics {
    static final libraries:Array<Dynamic> = [];
    static final values:Dynamic = createValues();
    static var publishScheduled = false;

    static function createValues():Dynamic {
        var result:Dynamic = {};
        Reflect.setField(result, "libraries", libraries);
        return result;
    }

    public static function add(name:String, value:Float):Void {
        var current:Dynamic = Reflect.field(values, name);
        Reflect.setField(values, name, (current == null ? 0.0 : current) + value);
        schedulePublish();
    }

    public static function count(name:String, amount:Int = 1):Void add(name, amount);

    public static function snapshot():Dynamic return values;

    /** Record a navigation-relative lifecycle boundary once. */
    public static function mark(name:String):Void {
        if (Reflect.field(values, name) != null) return;
        Reflect.setField(values, name, now());
        schedulePublish();
    }

    /** Create a query-free per-library timeline and return its stable index. */
    public static function beginLibrary(name:String, url:String):Int {
        var entry:Dynamic = {name: name, path: safePath(url), createdMs: now()};
        libraries.push(entry);
        schedulePublish();
        return libraries.length - 1;
    }

    public static function libraryMark(index:Int, name:String):Void {
        if (index < 0 || index >= libraries.length) return;
        Reflect.setField(libraries[index], name, now());
        schedulePublish();
    }

    public static function libraryValue(index:Int, name:String, value:Dynamic):Void {
        if (index < 0 || index >= libraries.length) return;
        Reflect.setField(libraries[index], name, value);
        schedulePublish();
    }

    static function schedulePublish():Void {
        if (publishScheduled) return;
        publishScheduled = true;
        Browser.window.setTimeout(function() {
            publishScheduled = false;
            publish();
        }, 100);
    }

    static function publish():Void {
        Browser.document.documentElement.setAttribute("data-skyhaxe-swf-metrics",
            haxe.Json.stringify(values));
    }

    static function safePath(value:String):String {
        try {
            return new js.html.URL(value, Browser.location.href).pathname;
        } catch (_:Dynamic) {
            return value == null ? "" : value.split("?")[0];
        }
    }

    static inline function now():Float return Browser.window.performance.now();
}
#end
