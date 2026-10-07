package com.sulake.core.window.graphics.renderer
;
    import com.sulake.core.window.utils.IChildEntityArray;
    import flash.geom.Rectangle;

     interface ISkinLayout extends IChildEntityArray 
    {
        var name(get,never):String;
        var width(get,never):UInt;
        var height(get,never):UInt;
        var blendMode(get,never):String;
        var transparent(get,never):Bool;
        function dispose():Void;
        function isFixedWidth():Bool;
        function isFixedHeight():Bool;
        function getDefaultRegion(_arg_1:String, _arg_2:Rectangle):Void;
    }

