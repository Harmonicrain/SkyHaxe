package com.sulake.core.assets.swf;

#if html5
import haxe.io.Bytes;
import js.Browser;
import js.lib.Promise;

/**
 * Where the `.hab` twin of an asset SWF lives, and the hab-first download with SWF fallback.
 *
 * Habbo's own HTML5 client rewrites every `.swf` request to `.hab` at the same path. SkyHaxe
 * keeps the converted tree beside the original corpus instead (`<runtime>/hab/...`), so the
 * mapping is a prefix swap: `asset.hab.source.url` + rest.swf -> `asset.hab.url` + rest.hab.
 *
 * Off unless `asset.hab.url` is configured or the page URL carries `assets=hab`;
 * `assets=swf` forces it off for A/B runs. Any .hab that is missing or fails to download
 * falls back to its SWF, for that file only.
 *
 * Several corpora can be mirrored: both keys accept `|`-separated lists, paired by position,
 * e.g. `asset.hab.source.url=/runtime/|http://localhost/ngh/` with
 * `asset.hab.url=/runtime/hab/|http://localhost/ngh/hab/`.
 */
class HabUrl {
    static var sources:Array<String> = [];
    static var mirrors:Array<String> = [];

    public static function configure(mirrorUrl:Null<String>, sourceUrl:Null<String>, mode:Null<String>):Void {
        sources = [];
        mirrors = [];
        if (mode == "swf") return;
        var sourceList = split(sourceUrl != null && sourceUrl != "" ? sourceUrl : "/runtime/");
        var mirrorList = split(mirrorUrl);
        if (mirrorList.length == 0 && mode == "hab") mirrorList = [for (source in sourceList) source + "hab/"];
        for (index in 0...Std.int(Math.min(sourceList.length, mirrorList.length))) {
            sources.push(sourceList[index]);
            mirrors.push(mirrorList[index]);
        }
        if (mirrors.length > 0)
            Browser.document.documentElement.setAttribute("data-skyhaxe-assets", "hab");
    }

    public static var enabled(get, never):Bool;
    static function get_enabled():Bool return mirrors.length > 0;

    /** The `.hab` URL for an asset SWF URL, or null when HAB loading does not apply. */
    public static function forSwf(url:String):Null<String> {
        if (mirrors.length == 0 || url == null) return null;
        try {
            var parsed = new js.html.URL(url, Browser.location.href);
            var path = parsed.origin + parsed.pathname;
            if (!StringTools.endsWith(path.toLowerCase(), ".swf")) return null;
            for (index in 0...sources.length) {
                var source = sources[index];
                if (StringTools.startsWith(path, source))
                    return mirrors[index] + path.substring(source.length, path.length - 4) + ".hab" + parsed.search;
            }
        } catch (_:Dynamic) {}
        return null;
    }

    static function split(value:Null<String>):Array<String> {
        if (value == null) return [];
        return [for (part in value.split("|")) if (StringTools.trim(part) != "") absolute(StringTools.trim(part))];
    }

    /** Download an asset: its `.hab` twin when enabled, else (or on any failure) the SWF itself. */
    public static function download(url:String):Promise<Bytes> {
        var hab = forSwf(url);
        if (hab == null) return fetch(url);
        return fetch(hab).then(function(bytes) {
            SwfLoadMetrics.count("habFiles");
            SwfLoadMetrics.add("habBytes", bytes.length);
            return bytes;
        }).catchError(function(error) {
            SwfLoadMetrics.count("habFallbacks");
            Browser.console.info("SKYHAXE_HAB_FALLBACK " + url + " (" + Std.string(error) + ")");
            return fetch(url);
        });
    }

    static function fetch(url:String):Promise<Bytes> {
        return Browser.window.fetch(url).then(function(response) {
            if (!response.ok) throw 'HTTP ${response.status} for $url';
            return response.arrayBuffer();
        }).then(function(buffer) {
            // Wrap, do not copy: Bytes.ofData takes the fetched ArrayBuffer as-is.
            return Bytes.ofData(buffer);
        });
    }

    static function absolute(value:String):String {
        var href = new js.html.URL(value, Browser.location.href).href;
        return StringTools.endsWith(href, "/") ? href : href + "/";
    }
}
#end
