package com.sulake.core.utils;

/** Flash VM enumeration boundary. Call the converted Proxy hooks, never JS object fields. */
class ASProxy {
    public static function get(proxy:Dynamic, key:ASAny):ASAny return proxy.getProperty(key);
    public static function set(proxy:Dynamic, key:ASAny, value:ASAny):ASAny {
        proxy.setProperty(key, value);
        return value;
    }
    public static function values(proxy:Dynamic):Iterator<ASAny> {
        var index = 0;
        var prepared = false;
        var done = proxy == null;
        if (!done && (!Reflect.isFunction(Reflect.field(proxy, "nextNameIndex"))
                || !Reflect.isFunction(Reflect.field(proxy, "nextValue"))))
            throw new haxe.Exception("Proxy enumeration requires nextNameIndex and nextValue");
        function prepare():Bool {
            if (!prepared && !done) {
                index = proxy.nextNameIndex(index);
                done = index == 0;
                prepared = true;
            }
            return !done;
        }
        return {
            hasNext: prepare,
            next: function():ASAny {
                if (!prepare()) throw new haxe.Exception("Proxy iterator exhausted");
                var value:ASAny = proxy.nextValue(index);
                prepared = false;
                return value;
            }
        };
    }
}
