package com.sulake.core.window.graphics
;
    import flash.display.IBitmapDrawable;
    import flash.events.IEventDispatcher;
    import com.sulake.core.runtime.IDisposable;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;

     interface IGraphicContext extends IBitmapDrawable extends  IEventDispatcher extends  IDisposable 
    {
                var graphicParent(get,set):DisplayObjectContainer;
                var filters(get,set):Array<flash.filters.BitmapFilter>;
                var visible(get,set):Bool;
                var blend(get,set):Float;
                var mouse(get,set):Bool;
        function offSet(_arg_1:Point):Void;
        function getDrawRegion():Rectangle;
        function _Str_15334(_arg_1:Rectangle, _arg_2:Bool, _arg_3:Rectangle):BitmapData;
        function getDisplayObject():DisplayObject;
        function setDisplayObject(_arg_1:DisplayObject):DisplayObject;
        function getAbsoluteMousePosition(_arg_1:Point):Void;
        function getRelativeMousePosition(_arg_1:Point):Void;
        function fetchDrawBuffer():IBitmapDrawable;
        function _Str_23788(_arg_1:Rectangle):Void;
        var _Str_13711(get,never):Int;
        function _Str_22175(_arg_1:IGraphicContext):IGraphicContext;
        function _Str_16175(_arg_1:IGraphicContext, _arg_2:Int):IGraphicContext;
        function _Str_16021(_arg_1:Int):IGraphicContext;
        function _Str_24886(_arg_1:IGraphicContext):Int;
        function _Str_17938(_arg_1:IGraphicContext):IGraphicContext;
        function _Str_19139(_arg_1:Int):IGraphicContext;
        function _Str_19243(_arg_1:IGraphicContext, _arg_2:Int):Void;
        function _Str_20742(_arg_1:IGraphicContext, _arg_2:IGraphicContext):Void;
        function _Str_21032(_arg_1:Int, _arg_2:Int):Void;
    }

