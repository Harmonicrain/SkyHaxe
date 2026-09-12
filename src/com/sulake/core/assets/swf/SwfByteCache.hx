package com.sulake.core.assets.swf;

#if html5
import haxe.ds.StringMap;
import haxe.io.Bytes;
import js.Browser;
import js.lib.Promise;

/** Shared, bounded transport cache for browser-loaded SWFs. */
class SwfByteCache {
    static final cached = new StringMap<Bytes>();
    static final pending = new StringMap<Promise<Bytes>>();
    static final order:Array<String> = [];
    static var size = 0;
    static inline final BUDGET = 64 * 1024 * 1024;

    public static function fetch(url:String):Promise<Bytes> {
        var hit = cached.get(url);
        if (hit != null) {
            touch(url);
            SwfLoadMetrics.count("fetchCacheHits");
            return Promise.resolve(hit);
        }
        var flight = pending.get(url);
        if (flight != null) {
            SwfLoadMetrics.count("fetchJoins");
            return flight;
        }
        var started = now();
        flight = Browser.window.fetch(url).then(function(response) {
            if (!response.ok) throw 'HTTP ${response.status} for $url';
            return response.arrayBuffer();
        }).then(function(buffer) {
            // Bytes.ofData wraps the fetched ArrayBuffer on JS instead of copying it byte by byte.
            var bytes = Bytes.ofData(buffer);
            pending.remove(url);
            SwfLoadMetrics.add("fetchMs", now() - started);
            SwfLoadMetrics.add("fetchedBytes", bytes.length);
            store(url, bytes);
            return bytes;
        }).catchError(function(error) {
            pending.remove(url);
            throw error;
        });
        pending.set(url, flight);
        return flight;
    }

    static function store(url:String, bytes:Bytes):Void {
        if (bytes.length > BUDGET) return;
        while (size + bytes.length > BUDGET && order.length > 0) {
            var oldest = order.shift();
            var removed = cached.get(oldest);
            if (removed != null) size -= removed.length;
            cached.remove(oldest);
        }
        cached.set(url, bytes);
        order.push(url);
        size += bytes.length;
    }

    static function touch(url:String):Void {
        order.remove(url);
        order.push(url);
    }

    static inline function now():Float return Browser.window.performance.now();
}
#end
