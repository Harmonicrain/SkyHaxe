package com.sulake.habbo.avatar.structure.figure
;
    import flash.geom.ColorTransform;

     interface IPartColor 
    {
        var colorTransform(get,never):ColorTransform;
        var redMultiplier(get,never):Float;
        var greenMultiplier(get,never):Float;
        var blueMultiplier(get,never):Float;
        var _Str_915(get,never):UInt;
        var r(get,never):UInt;
        var g(get,never):UInt;
        var b(get,never):UInt;
        var id(get,never):Int;
        var index(get,never):Int;
        var clubLevel(get,never):Int;
        var isSelectable(get,never):Bool;
    }

