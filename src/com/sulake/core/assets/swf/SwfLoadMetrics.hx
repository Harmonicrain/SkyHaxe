package com.sulake.core.assets.swf;

#if html5
import js.Browser;

/** Small cumulative boot probe, exposed in the DOM so headless and interactive runs can read it. */
class SwfLoadMetrics {
    static final values:Dynamic = {};

    public static function add(name:String, value:Float):Void {
        var current:Dynamic = Reflect.field(values, name);
        Reflect.setField(values, name, (current == null ? 0.0 : current) + value);
        publish();
    }

    public static function count(name:String, amount:Int = 1):Void add(name, amount);

    public static function snapshot():Dynamic return values;

    static function publish():Void {
        Browser.document.documentElement.setAttribute("data-skyhaxe-swf-metrics",
            haxe.Json.stringify(values));
    }
}
#end
