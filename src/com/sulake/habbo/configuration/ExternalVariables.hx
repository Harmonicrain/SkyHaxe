package com.sulake.habbo.configuration;

#if html5
import haxe.Http;
import haxe.ds.StringMap;

/** Read-only view of the selected NGH external variables file. */
class ExternalVariables {
    public static function load(url:String, onLoaded:ExternalVariables->Void,
            onError:String->Void):Void {
        var request = new Http(url);
        request.onData = function(data:String) onLoaded(parse(data));
        request.onError = onError;
        request.request(false);
    }

    public static function parse(data:String):ExternalVariables {
        var values = new StringMap<String>();
        for (line in data.split("\n")) {
            var clean = StringTools.trim(line);
            if (clean == "" || StringTools.startsWith(clean, "#")) continue;
            var split = clean.indexOf("=");
            if (split <= 0) continue;
            values.set(StringTools.trim(clean.substr(0, split)), clean.substr(split + 1));
        }
        return new ExternalVariables(values);
    }

    public final values:StringMap<String>;

    function new(values:StringMap<String>) this.values = values;

    public function get(key:String, fallback:String = ""):String {
        var value = values.get(key);
        return value == null ? fallback : value;
    }
}
#end
