package com.sulake.core.localization;

#if html5
import haxe.ds.StringMap;
import js.Browser;

/**
 * The hotel's text table, and the `${key}` substitution the window layouts rely on.
 *
 * Layout XML stores captions URL-encoded (`%24%7Bwidgets.chatinput.default%7D`), which the parser
 * decodes to `${widgets.chatinput.default}`. Without a table to resolve it, that token is what
 * ends up on screen -- the chat input read `${widgets.chatinput.default}` rather than
 * "Click here to chat...".
 *
 * The AS3 client reaches this through `ILocalization` on the component context. That whole
 * dependency graph is unconverted, and the table itself is a flat `key=value` file, so this is a
 * small seam over the file rather than a port of the component.
 */
class Localization {
    static var texts:Null<StringMap<String>>;

    /** How many keys the table holds; 0 before it loads. */
    public static var size(default, null):Int = 0;

    public static function load(url:String, onReady:Void->Void, onError:Dynamic->Void):Void {
        Browser.window.fetch(url).then(function(response) {
            if (!response.ok) throw 'HTTP ${response.status} for $url';
            return response.text();
        }).then(function(body) {
            try {
                parse(body);
                onReady();
            } catch (error:Dynamic) {
                onError(error);
            }
            return null;
        }).catchError(onError);
    }

    static function parse(body:String):Void {
        var table = new StringMap<String>();
        var count = 0;
        for (line in body.split("\n")) {
            var text = StringTools.rtrim(line);
            if (text == "" || StringTools.startsWith(text, "#")) continue;
            var split = text.indexOf("=");
            if (split <= 0) continue;
            // The file defines some keys twice; the later definition is the effective one.
            table.set(text.substr(0, split), text.substr(split + 1));
            count++;
        }
        texts = table;
        size = count;
    }

    /** The text for a key, or null when the table has no entry. */
    public static function find(key:String):Null<String> {
        return texts == null ? null : texts.get(key);
    }

    /**
     * Replace every `${key}` in a string.
     *
     * An unknown key is left exactly as it was: a visible token is a far better failure than an
     * empty caption, because it names the key that is missing.
     */
    public static function resolve(value:String):String {
        if (value == null || value.indexOf("${") < 0) return value;
        var out = new StringBuf();
        var index = 0;
        while (index < value.length) {
            var open = value.indexOf("${", index);
            if (open < 0) {
                out.addSub(value, index);
                break;
            }
            var close = value.indexOf("}", open);
            if (close < 0) {
                out.addSub(value, index);
                break;
            }
            out.addSub(value, index, open - index);
            var key = value.substring(open + 2, close);
            var text = find(key);
            out.add(text == null ? value.substring(open, close + 1) : text);
            index = close + 1;
        }
        return out.toString();
    }
}
#end
