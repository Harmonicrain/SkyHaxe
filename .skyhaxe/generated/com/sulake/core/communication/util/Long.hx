package com.sulake.core.communication.util
;
    /**
     * Marks a composer value that must be encoded as one signed protocol
     * 64-bit integer. ActionScript Number remains exact for the database IDs
     * used by the client (up to 2^53).
     */
     final class Long
    {
        var _value:Float = Math.NaN;

        public function new(value:Float)
        {
            this._value = value;
        }

        public var high(get,never):Int;
public function  get_high():Int
        {
            return Std.int(Math.ffloor(this._value / 4294967296));
        }

        public var low(get,never):UInt;
public function  get_low():UInt
        {
            return ASCompat.toUInt(this._value - this.high * 4294967296);
        }

        public var value(get,never):Float;
public function  get_value():Float
        {
            return this._value;
        }
    }

