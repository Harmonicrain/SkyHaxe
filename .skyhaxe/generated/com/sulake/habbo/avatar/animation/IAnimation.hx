package com.sulake.habbo.avatar.animation
;
     interface IAnimation 
    {
        function hasAvatarData():Bool;
        function hasDirectionData():Bool;
        function hasAddData():Bool;
        var id(get,never):String;
        var spriteData(get,never):Array<ASAny>;
        var removeData(get,never):Array<ASAny>;
        var addData(get,never):Array<ASAny>;
        var resetOnToggle(get,never):Bool;
    }

