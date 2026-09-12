package com.sulake.core.utils.xml;

class XMLList {
    private var _items:Array<XML>;

    public function new(?items:Array<XML>) {
        _items = items == null ? [] : items.copy();
    }

    /** AS3 `XMLList(value)` coercion. */
    public static function coerce(value:Dynamic):XMLList {
        if (Std.isOfType(value, XMLList)) {
            return cast value;
        }
        if (Std.isOfType(value, XML)) {
            return new XMLList([cast value]);
        }
        return new XMLList([XML.coerce(value)]);
    }

    public function length():Int {
        return _items.length;
    }

    public function at(index:Int):Null<XML> {
        return index < 0 || index >= _items.length ? null : _items[index];
    }

    public function child(name:Dynamic):XMLList {
        return flatten(function(item) return item.child(name));
    }

    public function children():XMLList {
        return flatten(function(item) return item.children());
    }

    public function descendants(name:String = "*"):XMLList {
        return flatten(function(item) return item.descendants(name));
    }

    public function text():XMLList {
        return flatten(function(item) return item.text());
    }

    public function attribute(name:String):XMLList {
        return flatten(function(item) return item.attribute(name));
    }

    public function filterAttributeEquals(name:String, value:String):XMLList {
        return new XMLList([for (item in _items)
            if (item.attribute(name).toString() == value) item]);
    }

    /** The normalized form of JSONEncoder's describeType E4X predicate. */
    public function filterVariablesAndReadableAccessors():XMLList {
        return new XMLList([for (item in _items)
            if (item.localName() == "variable"
                || (item.localName() == "accessor"
                    && StringTools.startsWith(item.attribute("access").toString(), "r"))) item]);
    }

    public function setAttribute(name:String, value:Dynamic):XMLList {
        for (item in _items) {
            item.setAttribute(name, value);
        }
        return this;
    }

    public function name():Null<String> {
        return _items.length == 1 ? _items[0].name() : null;
    }

    public function localName():Null<String> {
        return _items.length == 1 ? _items[0].localName() : null;
    }

    public function parent():Null<XML> {
        return _items.length == 0 ? null : _items[0].parent();
    }

    public function hasOwnProperty(property:String):Bool {
        var index = Std.parseInt(property);
        if (index != null && Std.string(index) == property) {
            return index >= 0 && index < _items.length;
        }
        for (item in _items) {
            if (item.hasOwnProperty(property)) {
                return true;
            }
        }
        return false;
    }

    public function appendChild(value:Dynamic):XMLList {
        for (item in _items) {
            item.appendChild(value);
        }
        return this;
    }

    public function replace(property:Dynamic, value:Dynamic):XMLList {
        for (item in _items) {
            item.replace(property, value);
        }
        return this;
    }

    public function copy():XMLList {
        return new XMLList([for (item in _items) item.copy()]);
    }

    public function toXMLString():String {
        return [for (item in _items) item.toXMLString()].join("\n");
    }

    public function toString():String {
        return [for (item in _items) item.toString()].join("");
    }

    public function iterator():Iterator<XML> {
        return _items.copy().iterator();
    }

    private function flatten(select:XML->XMLList):XMLList {
        var result:Array<XML> = [];
        for (item in _items) {
            for (selected in select(item)) {
                result.push(selected);
            }
        }
        return new XMLList(result);
    }
}
