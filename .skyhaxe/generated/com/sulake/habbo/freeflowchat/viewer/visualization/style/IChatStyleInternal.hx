package com.sulake.habbo.freeflowchat.viewer.visualization.style
;
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.text.StyleSheet;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     interface IChatStyleInternal 
    {
        function getNewBackgroundSprite(_arg_1:UInt=0xFFFFFF):Sprite;
        var textFormat(get,never):TextFormat;
        var styleSheet(get,never):StyleSheet;
        var pointer(get,never):BitmapData;
        var _Str_8470(get,never):Int;
        var pointerOffsetToBubbleBottom(get,never):Int;
        function getPointerLeftMargin(_arg_1:Int):Int;
        function getPointerRightMargin(_arg_1:Int):Int;
        var _Str_5505(get,never):Point;
        var faceOffset(get,never):Point;
        function getEmblem(_arg_1:Bool=false):BitmapData;
        function getEmblemOffset(_arg_1:Bool=false):Point;
        var iconImage(get,never):BitmapData;
        var textFieldMargins(get,never):Rectangle;
        var overlap(get,never):Rectangle;
        var allowHTML(get,never):Bool;
        var _Str_4931(get,never):Bool;
        var isAnonymous(get,never):Bool;
        var isSystemStyle(get,never):Bool;
        var isNotification(get,never):Bool;
    }

