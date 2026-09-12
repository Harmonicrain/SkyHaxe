package com.sulake.habbo.freeflowchat.history.visualization.entry
;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

     interface IChatHistoryEntryBitmap 
    {
        var bitmap(get,never):BitmapData;
        var overlap(get,never):Rectangle;
        var userId(get,never):Int;
        var roomId(get,never):Int;
        var _Str_6123(get,never):Bool;
        var userName(get,never):String;
    }

