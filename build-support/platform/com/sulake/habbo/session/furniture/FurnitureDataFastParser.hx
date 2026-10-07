package com.sulake.habbo.session.furniture;

/** Thrown internally when the input leaves the simple furnidata shape; the caller falls back. */
private class Bail {
    public final reason:String;
    public function new(reason:String) this.reason = reason;
}

private class Item {
    public final attributes = new Map<String, String>();
    public final fields = new Map<String, Array<String>>();
    public final colors:Array<String> = [];
    public function new() {}
}

/**
 * DOM-free reader for XML furnidata, used by the build-support/platform override of FurnitureDataParser.
 *
 * It produces exactly what `parseFloorItem` / `parseWallItem` produce from the E4X tree, by
 * extracting the same strings E4X would (`XMLList.toString()` of each field: text and CDATA
 * concatenated, whitespace-only text nodes dropped, entities decoded by Haxe's own parser) and
 * then applying the very same ASCompat conversions. Anything it does not model -- a DOCTYPE,
 * markup inside a field, a duplicate attribute, malformed input -- returns null so the original
 * DOM path runs and reports errors exactly as before.
 */
class FurnitureDataFastParser {
    final s:String;
    final n:Int;
    var p = 0;

    function new(data:String) {
        s = data;
        n = data.length;
    }

    /** All floor items in document order, then all wall items; null to use the DOM path. */
    public static function parse(data:String):Null<Array<FurnitureData>> {
        if (data == null) return null;
        try {
            return new FurnitureDataFastParser(data).run();
        } catch (bail:Bail) {
            #if js
            js.Browser.console.info("SKYHAXE_FURNIDATA_FAST_PATH_SKIPPED " + bail.reason);
            #end
            return null;
        }
    }

    function run():Array<FurnitureData> {
        var floor:Array<Item> = [];
        var wall:Array<Item> = [];
        skipProlog();
        var root = openTag();
        if (!root.selfClosing) {
            while (true) {
                skipNonElements();
                if (closeTagAhead()) {
                    closeTag(root.name);
                    break;
                }
                var child = openTag();
                if (child.name == "roomitemtypes") section(child, floor);
                else if (child.name == "wallitemtypes") section(child, wall);
                else skipElement(child);
            }
        }
        var result:Array<FurnitureData> = [];
        for (item in floor) result.push(floorItem(item));
        for (item in wall) result.push(wallItem(item));
        return result;
    }

    // ------------------------------------------------------------------ structure

    function section(tag:Tag, into:Array<Item>):Void {
        if (tag.selfClosing) return;
        while (true) {
            skipNonElements();
            if (closeTagAhead()) {
                closeTag(tag.name);
                return;
            }
            var child = openTag();
            if (child.name == "furnitype") into.push(item(child));
            else skipElement(child);
        }
    }

    function item(tag:Tag):Item {
        var result = new Item();
        for (name => value in tag.attributes) result.attributes.set(name, value);
        if (tag.selfClosing) return result;
        while (true) {
            skipNonElements();
            if (closeTagAhead()) {
                closeTag(tag.name);
                return result;
            }
            var child = openTag();
            if (child.name == "partcolors") {
                partColors(child, result.colors);
            } else {
                var list = result.fields.get(child.name);
                if (list == null) result.fields.set(child.name, list = []);
                list.push(simpleText(child));
            }
        }
    }

    function partColors(tag:Tag, into:Array<String>):Void {
        if (tag.selfClosing) return;
        while (true) {
            skipNonElements();
            if (closeTagAhead()) {
                closeTag(tag.name);
                return;
            }
            var child = openTag();
            if (child.name == "color") into.push(simpleText(child));
            else skipElement(child);
        }
    }

    /** E4X toString() of an element with simple content. Markup inside it is not modelled. */
    function simpleText(tag:Tag):String {
        if (tag.selfClosing) return "";
        var text = new StringBuf();
        while (true) {
            if (p >= n) throw new Bail("unterminated <" + tag.name + ">");
            var c = StringTools.fastCodeAt(s, p);
            if (c != "<".code) {
                var end = s.indexOf("<", p);
                if (end < 0) throw new Bail("unterminated text");
                addText(text, s.substring(p, end));
                p = end;
            } else if (startsWith("</")) {
                closeTag(tag.name);
                return text.toString();
            } else if (startsWith("<![CDATA[")) {
                var end = s.indexOf("]]>", p + 9);
                if (end < 0) throw new Bail("unterminated CDATA");
                text.add(s.substring(p + 9, end));
                p = end + 3;
            } else if (startsWith("<!--")) {
                skipComment();
            } else if (startsWith("<?")) {
                skipProcessingInstruction();
            } else {
                throw new Bail("markup inside <" + tag.name + ">");
            }
        }
    }

    /** One PCData node: dropped if whitespace-only (after decoding), as XML.ignoreWhitespace does. */
    function addText(buffer:StringBuf, raw:String):Void {
        var value = raw.indexOf("&") >= 0 ? decodeText(raw) : raw;
        for (index in 0...value.length) {
            switch (StringTools.fastCodeAt(value, index)) {
                case 0x20, 0x09, 0x0D, 0x0A:
                default:
                    buffer.add(value);
                    return;
            }
        }
    }

    function skipElement(tag:Tag):Void {
        if (tag.selfClosing) return;
        var depth = 1;
        while (depth > 0) {
            var next = s.indexOf("<", p);
            if (next < 0) throw new Bail("unterminated <" + tag.name + ">");
            p = next;
            if (startsWith("<!--")) skipComment();
            else if (startsWith("<![CDATA[")) {
                var end = s.indexOf("]]>", p + 9);
                if (end < 0) throw new Bail("unterminated CDATA");
                p = end + 3;
            } else if (startsWith("<?")) skipProcessingInstruction();
            else if (startsWith("</")) {
                var end = s.indexOf(">", p);
                if (end < 0) throw new Bail("unterminated close tag");
                p = end + 1;
                depth--;
            } else {
                var inner = openTag();
                if (!inner.selfClosing) depth++;
            }
        }
    }

    // ------------------------------------------------------------------ tokens

    function skipProlog():Void {
        while (true) {
            skipWhitespace();
            if (startsWith("<?")) skipProcessingInstruction();
            else if (startsWith("<!--")) skipComment();
            else if (startsWith("<!")) throw new Bail("DOCTYPE");
            else return;
        }
    }

    /** Between elements only whitespace, comments and processing instructions are expected. */
    function skipNonElements():Void {
        while (true) {
            if (p >= n) throw new Bail("unexpected end of document");
            var c = StringTools.fastCodeAt(s, p);
            if (c != "<".code) {
                var end = s.indexOf("<", p);
                if (end < 0) throw new Bail("unexpected end of document");
                p = end;   // stray text between elements is ignored by child() in the DOM path too
            } else if (startsWith("<!--")) skipComment();
            else if (startsWith("<?")) skipProcessingInstruction();
            else if (startsWith("<![CDATA[")) {
                var end = s.indexOf("]]>", p + 9);
                if (end < 0) throw new Bail("unterminated CDATA");
                p = end + 3;
            } else return;
        }
    }

    function openTag():Tag {
        if (!startsWith("<") || startsWith("</") || startsWith("<!") || startsWith("<?"))
            throw new Bail("expected an element at " + p);
        p++;
        var name = readName();
        var tag = new Tag(name);
        while (true) {
            skipWhitespace();
            if (p >= n) throw new Bail("unterminated <" + name);
            var c = StringTools.fastCodeAt(s, p);
            if (c == ">".code) {
                p++;
                return tag;
            }
            if (c == "/".code) {
                if (p + 1 >= n || StringTools.fastCodeAt(s, p + 1) != ">".code) throw new Bail("bad empty tag");
                p += 2;
                tag.selfClosing = true;
                return tag;
            }
            var attribute = readName();
            skipWhitespace();
            if (p >= n || StringTools.fastCodeAt(s, p) != "=".code) throw new Bail("attribute without value");
            p++;
            skipWhitespace();
            var quote = p < n ? StringTools.fastCodeAt(s, p) : 0;
            if (quote != '"'.code && quote != "'".code) throw new Bail("unquoted attribute");
            var end = s.indexOf(String.fromCharCode(quote), p + 1);
            if (end < 0) throw new Bail("unterminated attribute");
            var raw = s.substring(p + 1, end);
            p = end + 1;
            if (tag.attributes.exists(attribute)) throw new Bail("duplicate attribute " + attribute);
            if (raw.indexOf("<") >= 0) throw new Bail("< in attribute");
            tag.attributes.set(attribute, raw.indexOf("&") >= 0 ? decodeAttribute(raw, quote) : raw);
        }
    }

    function closeTagAhead():Bool return startsWith("</");

    function closeTag(name:String):Void {
        if (!startsWith("</")) throw new Bail("expected </" + name + ">");
        p += 2;
        var closing = readName();
        skipWhitespace();
        if (closing != name || p >= n || StringTools.fastCodeAt(s, p) != ">".code)
            throw new Bail("mismatched </" + closing + "> for <" + name + ">");
        p++;
    }

    function readName():String {
        var start = p;
        while (p < n) {
            var c = StringTools.fastCodeAt(s, p);
            if ((c >= "a".code && c <= "z".code) || (c >= "A".code && c <= "Z".code)
                    || (c >= "0".code && c <= "9".code) || c == "_".code || c == ":".code
                    || c == ".".code || c == "-".code) p++;
            else break;
        }
        if (p == start) throw new Bail("expected a name at " + start);
        return s.substring(start, p);
    }

    function skipWhitespace():Void {
        while (p < n) {
            switch (StringTools.fastCodeAt(s, p)) {
                case 0x20, 0x09, 0x0D, 0x0A: p++;
                default: return;
            }
        }
    }

    function skipComment():Void {
        var end = s.indexOf("-->", p + 4);
        if (end < 0) throw new Bail("unterminated comment");
        p = end + 3;
    }

    function skipProcessingInstruction():Void {
        var end = s.indexOf("?>", p + 2);
        if (end < 0) throw new Bail("unterminated processing instruction");
        p = end + 2;
    }

    function startsWith(prefix:String):Bool {
        var length = prefix.length;
        if (p + length > n) return false;
        for (index in 0...length)
            if (StringTools.fastCodeAt(s, p + index) != StringTools.fastCodeAt(prefix, index)) return false;
        return true;
    }

    // Entity decoding is delegated to Haxe's own XML parser so edge cases match exactly.
    static function decodeText(raw:String):String {
        var node = Xml.parse("<a>" + raw + "</a>").firstElement().firstChild();
        return node == null ? "" : node.nodeValue;
    }

    static function decodeAttribute(raw:String, quote:Int):String {
        var q = String.fromCharCode(quote);
        var value = Xml.parse("<a v=" + q + raw + q + "/>").firstElement().get("v");
        return value == null ? "" : value;
    }

    // ------------------------------------------------------------------ FurnitureData

    static inline function text(item:Item, name:String):String {
        var list = item.fields.get(name);
        return list == null ? "" : list.join("");
    }

    /** XML.equalsStringOperands(xmlList, "1"): exactly one element whose text is "1". */
    static inline function isOne(item:Item, name:String):Bool {
        var list = item.fields.get(name);
        return list != null && list.length == 1 && list[0] == "1";
    }

    static inline function attribute(item:Item, name:String):String {
        var value = item.attributes.get(name);
        return value == null ? "" : value;
    }

    static function floorItem(item:Item):FurnitureData {
        var id = ASCompat.parseInt(attribute(item, "id"));
        var colors = new Array<ASAny>();
        for (color in item.colors) {
            var value = color;
            if (value.charAt(0) == "#") {
                value = ASCompat.stringReplace(value, "#", "");
                colors.push(ASCompat.parseInt(value, 16));
            } else {
                colors.push(-ASCompat.parseInt(value));
            }
        }
        var className = attribute(item, "classname");
        var parts:Array<ASAny> = cast className.split("*");
        var baseName = parts[0];
        var colorIndex = parts.length > 1 ? ASCompat.parseInt(parts[1]) : 0;
        var hasColorIndex:ASAny = (parts.length > 1);
        return new FurnitureData(FurnitureData.S, id, className, baseName, text(item, "name"),
            text(item, "description"), ASCompat.toInt(text(item, "revision")), ASCompat.toInt(text(item, "xdim")),
            ASCompat.toInt(text(item, "ydim")), 0, colors, hasColorIndex, colorIndex, text(item, "adurl"),
            ASCompat.toInt(text(item, "offerid")), isOne(item, "buyout"), ASCompat.toInt(text(item, "rentofferid")),
            isOne(item, "rentbuyout"), isOne(item, "bc"), text(item, "customparams"),
            ASCompat.toInt(text(item, "specialtype")), isOne(item, "canstandon"), isOne(item, "cansiton"),
            isOne(item, "canlayon"), isOne(item, "excludeddynamic"), text(item, "furniline"),
            ASCompat.toInt(text(item, "bcofferid")), isOne(item, "tradeable"));
    }

    static function wallItem(item:Item):FurnitureData {
        var id = ASCompat.parseInt(attribute(item, "id"));
        var className = attribute(item, "classname");
        return new FurnitureData(FurnitureData.I, id, className, className, text(item, "name"),
            text(item, "description"), ASCompat.toInt(text(item, "revision")), 0, 0, 0, null, false, 0,
            text(item, "adurl"), ASCompat.toInt(text(item, "offerid")), isOne(item, "buyout"),
            ASCompat.toInt(text(item, "rentofferid")), isOne(item, "rentbuyout"), isOne(item, "bc"), null,
            ASCompat.toInt(text(item, "specialtype")), false, false, false, isOne(item, "excludeddynamic"),
            text(item, "furniline"), ASCompat.toInt(text(item, "bcofferid")), isOne(item, "tradeable"));
    }

    #if js
    /** Compare the fast path with the DOM path field by field and log the outcome (?furnidataVerify=1). */
    public static function verify(data:String, parseFloor:com.sulake.core.utils.xml.XML->FurnitureData,
            parseWall:com.sulake.core.utils.xml.XML->FurnitureData):Void {
        var started = js.Browser.window.performance.now();
        var fast = parse(data);
        var fastMs = js.Browser.window.performance.now() - started;
        started = js.Browser.window.performance.now();
        var xml = new com.sulake.core.utils.xml.XML(data);
        var dom:Array<FurnitureData> = [];
        for (item in xml.child("roomitemtypes").child("furnitype")) dom.push(parseFloor(item));
        for (item in xml.child("wallitemtypes").child("furnitype")) dom.push(parseWall(item));
        var domMs = js.Browser.window.performance.now() - started;
        var problems:Array<String> = [];
        if (fast == null) problems.push("fast path declined");
        else if (fast.length != dom.length) problems.push('count ${fast.length} != ${dom.length}');
        else for (index in 0...dom.length) {
            var a:Dynamic = fast[index], b:Dynamic = dom[index];
            for (field in Reflect.fields(b)) {
                var x:Dynamic = Reflect.field(a, field), y:Dynamic = Reflect.field(b, field);
                if (haxe.Json.stringify(x) != haxe.Json.stringify(y) && problems.length < 20)
                    problems.push('#$index ${Reflect.field(b, "_className")}.$field: ${haxe.Json.stringify(x)} != ${haxe.Json.stringify(y)}');
            }
        }
        js.Browser.console.info("SKYHAXE_FURNIDATA_VERIFY items=" + dom.length + " fastMs=" + Math.round(fastMs)
            + " domMs=" + Math.round(domMs) + (problems.length == 0 ? " IDENTICAL" : " DIFF " + problems.join(" | ")));
    }
    #end
}

private class Tag {
    public final name:String;
    public final attributes = new Map<String, String>();
    public var selfClosing = false;
    public function new(name:String) this.name = name;
}
