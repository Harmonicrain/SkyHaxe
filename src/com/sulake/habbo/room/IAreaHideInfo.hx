package com.sulake.habbo.room;

/** Clean-client contract consumed by the generated extended floor-map row. */
interface IAreaHideInfo {
    var furniId(get, never):Int;
    var on(get, never):Bool;
    var rootX(get, never):Int;
    var rootY(get, never):Int;
    var width(get, never):Int;
    var length(get, never):Int;
    var invert(get, never):Bool;
}
