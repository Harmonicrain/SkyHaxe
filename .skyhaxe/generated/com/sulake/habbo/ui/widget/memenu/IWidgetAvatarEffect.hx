package com.sulake.habbo.ui.widget.memenu
;
    import flash.display.BitmapData;

     interface IWidgetAvatarEffect 
    {
        var amount(get,never):Int;
        var type(get,never):Int;
        var secondsRemaining(get,never):Int;
        var duration(get,never):Int;
        var isActive(get,never):Bool;
        var isInUse(get,never):Bool;
        var icon(get,never):BitmapData;
    }

