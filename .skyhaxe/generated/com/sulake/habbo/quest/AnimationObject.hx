package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Point;
    import flash.display.BitmapData;

     interface AnimationObject extends IDisposable 
    {
        function getPosition(_arg_1:Int):Point;
        function getBitmap(_arg_1:Int):BitmapData;
        function _Str_22065(_arg_1:Int):Bool;
        function _Str_21940():Void;
    }

