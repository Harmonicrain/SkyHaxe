package com.sulake.habbo.avatar.animation
;
     interface ISpriteDataContainer 
    {
        var animation(get,never):IAnimation;
        var id(get,never):String;
        var ink(get,never):Int;
        var member(get,never):String;
        var hasDirections(get,never):Bool;
        var hasStaticY(get,never):Bool;
        function getDirectionOffsetX(_arg_1:Int):Int;
        function getDirectionOffsetY(_arg_1:Int):Int;
        function getDirectionOffsetZ(_arg_1:Int):Int;
    }

