package com.sulake.core.utils;

/** AS3 uint type test: JavaScript has no distinct UInt class value for Std.isOfType. */
class ASNumericType {
    public static function isUInt(value:Dynamic):Bool {
        #if js
        return js.Syntax.code("typeof {0} === 'number' && Number.isInteger({0}) && {0} >= 0 && {0} <= 4294967295", value);
        #else
        return (Std.isOfType(value, Int) || Std.isOfType(value, Float))
            && Math.isFinite(value) && value >= 0 && value <= 4294967295.0 && Math.ffloor(value) == value;
        #end
    }
}
