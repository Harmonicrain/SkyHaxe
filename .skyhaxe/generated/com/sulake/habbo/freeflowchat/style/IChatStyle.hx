package com.sulake.habbo.freeflowchat.style
;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;

     interface IChatStyle 
    {
        var selectorPreview(get,never):BitmapData;
        var isSystemStyle(get,never):Bool;
        var isHcOnly(get,never):Bool;
        var purchasable(get,never):Bool;
        var isAmbassadorOnly(get,never):Bool;
        var isStaffOverrideable(get,never):Bool;
        var isNotification(get,never):Bool;
        function getNewBackgroundSprite(_arg_1:UInt=0xFFFFFF):Sprite;
        var overlap(get,never):Rectangle;
        var textFormat(get,never):TextFormat;
    }

