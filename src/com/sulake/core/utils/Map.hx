package com.sulake.core.utils;

import com.sulake.core.runtime.IDisposable;

/**
 * Ordered, dynamically keyed map matching the clean client's AS3 Map contract.
 *
 * AS3 Proxy property reads/writes are intentionally exposed as getValue/setValue.
 * Haxe iteration yields keys, matching AS3 `for (key in map)`; converted AS3
 * `for each` loops must iterate getValues() explicitly.
 */
class Map implements IDisposable {
    private var _length:Int;
    private var _values:Array<Dynamic>;
    private var _keys:Array<Dynamic>;

    #if js
    private var _dictionary:Null<js.lib.Map<Dynamic, Dynamic>>;
    #else
    private var _dictionaryKeys:Null<Array<Dynamic>>;
    private var _dictionaryValues:Null<Array<Dynamic>>;
    #end

    public var length(get, never):Int;
    public var disposed(get, never):Bool;

    public function new() {
        _length = 0;
        _values = [];
        _keys = [];
        createDictionary();
    }

    private function get_length():Int {
        return _length;
    }

    private function get_disposed():Bool {
        #if js
        return _dictionary == null;
        #else
        return _dictionaryKeys == null;
        #end
    }

    public function dispose():Void {
        if (!disposed) {
            clearDictionary();
            #if js
            _dictionary = null;
            #else
            _dictionaryKeys = null;
            _dictionaryValues = null;
            #end
        }

        _length = 0;
        _values = null;
        _keys = null;
    }

    public function reset():Void {
        requireActive();
        clearDictionary();
        _length = 0;
        _values = [];
        _keys = [];
    }

    public function unshift(key:Dynamic, value:Dynamic):Bool {
        requireActive();
        // Deliberately value-based: the AS3 implementation permits duplicate
        // keys when their current Dictionary value is null.
        if (dictionaryGet(key) != null) {
            return false;
        }

        dictionarySet(key, value);
        _values.unshift(value);
        _keys.unshift(key);
        _length++;
        return true;
    }

    public function add(key:Dynamic, value:Dynamic):Bool {
        requireActive();
        // See unshift(): this preserves the clean client's null-value quirk.
        if (dictionaryGet(key) != null) {
            return false;
        }

        dictionarySet(key, value);
        _values[_length] = value;
        _keys[_length] = key;
        _length++;
        return true;
    }

    public function remove(key:Dynamic):Dynamic {
        requireActive();
        var value = dictionaryGet(key);
        if (value == null) {
            return null;
        }

        // This intentionally mirrors Map.as: removal locates the first matching
        // value, not the requested key. Some maps contain shared value objects.
        var objectIndex = indexOf(value);
        if (objectIndex >= 0) {
            _values.splice(objectIndex, 1);
            _keys.splice(objectIndex, 1);
            _length--;
        }
        dictionaryDelete(key);
        return value;
    }

    public function getWithIndex(index:Int):Dynamic {
        requireActive();
        return index < 0 || index >= _length ? null : _values[index];
    }

    public function getKey(index:Int):Dynamic {
        requireActive();
        return index < 0 || index >= _length ? null : _keys[index];
    }

    public function getKeys():Array<Dynamic> {
        requireActive();
        return _keys.copy();
    }

    public function hasKey(key:Dynamic):Bool {
        requireActive();
        return indexIn(_keys, key) > -1;
    }

    public function getValue(key:Dynamic):Dynamic {
        requireActive();
        return dictionaryGet(key);
    }

    public function setValue(key:Dynamic, value:Dynamic):Void {
        requireActive();
        dictionarySet(key, value);
        var keyIndex = indexIn(_keys, key);
        if (keyIndex == -1) {
            _values[_length] = value;
            _keys[_length] = key;
            _length++;
        } else {
            _values[keyIndex] = value;
        }
    }

    public function getValues():Array<Dynamic> {
        requireActive();
        return _values.copy();
    }

    public function hasValue(value:Dynamic):Bool {
        requireActive();
        return indexOf(value) > -1;
    }

    public function indexOf(value:Dynamic):Int {
        requireActive();
        return indexIn(_values, value);
    }

    public function concatenate(newValues:Map):Void {
        requireActive();
        for (key in newValues.getKeys()) {
            add(key, newValues.getValue(key));
        }
    }

    public function clone():Map {
        requireActive();
        var copy = new Map();
        copy.concatenate(this);
        return copy;
    }

    /** Enables `for (key in map)` with the same key order as AS3 Proxy. */
    public function iterator():Iterator<Dynamic> {
        return getKeys().iterator();
    }

    public function toString():String {
        return "Map";
    }

    private function requireActive():Void {
        if (disposed) {
            throw new haxe.Exception("Map is disposed");
        }
    }

    private function createDictionary():Void {
        #if js
        _dictionary = new js.lib.Map<Dynamic, Dynamic>();
        #else
        _dictionaryKeys = [];
        _dictionaryValues = [];
        #end
    }

    private function clearDictionary():Void {
        #if js
        var dictionary = _dictionary;
        if (dictionary != null) {
            dictionary.clear();
        }
        #else
        var keys = _dictionaryKeys;
        var values = _dictionaryValues;
        if (keys != null) {
            keys.resize(0);
        }
        if (values != null) {
            values.resize(0);
        }
        #end
    }

    private function dictionaryGet(key:Dynamic):Dynamic {
        key = canonicalDictionaryKey(key);
        #if js
        var dictionary = _dictionary;
        return dictionary == null || !dictionary.has(key) ? null : dictionary.get(key);
        #else
        var keys = _dictionaryKeys;
        var values = _dictionaryValues;
        if (keys == null || values == null) {
            return null;
        }
        var index = indexIn(keys, key);
        return index == -1 ? null : values[index];
        #end
    }

    private function dictionarySet(key:Dynamic, value:Dynamic):Void {
        key = canonicalDictionaryKey(key);
        #if js
        var dictionary = _dictionary;
        if (dictionary != null) {
            dictionary.set(key, value);
        }
        #else
        var keys = _dictionaryKeys;
        var values = _dictionaryValues;
        if (keys != null && values != null) {
            var index = indexIn(keys, key);
            if (index == -1) {
                keys.push(key);
                values.push(value);
            } else {
                values[index] = value;
            }
        }
        #end
    }

    private function dictionaryDelete(key:Dynamic):Void {
        key = canonicalDictionaryKey(key);
        #if js
        var dictionary = _dictionary;
        if (dictionary != null) {
            dictionary.delete(key);
        }
        #else
        var keys = _dictionaryKeys;
        var values = _dictionaryValues;
        if (keys != null && values != null) {
            var index = indexIn(keys, key);
            if (index >= 0) {
                keys.splice(index, 1);
                values.splice(index, 1);
            }
        }
        #end
    }

    private static function indexIn(values:Array<Dynamic>, sought:Dynamic):Int {
        for (index in 0...values.length) {
            if (same(values[index], sought)) {
                return index;
            }
        }
        return -1;
    }

    private static inline function same(left:Dynamic, right:Dynamic):Bool {
        #if js
        return js.Syntax.strictEq(left, right);
        #else
        return left == right;
        #end
    }

    /**
     * AS3 Dictionary square-bracket access treats a numeric property key and its
     * decimal string as the same slot. The clean client relies on that behaviour:
     * several Maps add an Int key but deliberately read it through String(id).
     * JavaScript Map uses strict key identity, so preserve the AVM2 coercion at
     * this platform boundary while leaving object keys identity-based.
     */
    private static function canonicalDictionaryKey(key:Dynamic):Dynamic {
        return switch (Type.typeof(key)) {
            case TInt | TFloat: Std.string(key);
            default: key;
        }
    }
}
