package com.sulake.core.communication.util
;
    /** Marks a composer value that must be encoded as one signed protocol byte. */
     final class Byte
    {
        var _value:Int = 0;
        public function new(value:Int) { this._value = value; }
        public var value(get,never):Int;
public function  get_value():Int { return this._value; }
    }

