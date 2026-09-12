package com.sulake.habbo.avatar
;
    import flash.display.BitmapData;

     interface IHabboAvatarEditorAvatarEffect 
    {
        var amount(get,never):Int;
        var type(get,never):Int;
        var subType(get,never):Int;
        var secondsRemaining(get,never):Int;
        var duration(get,never):Int;
        var isPermanent(get,never):Bool;
        var isActive(get,never):Bool;
        var isInUse(get,never):Bool;
                var icon(get,set):BitmapData;
                var Selected(get,set):Bool;
    }

