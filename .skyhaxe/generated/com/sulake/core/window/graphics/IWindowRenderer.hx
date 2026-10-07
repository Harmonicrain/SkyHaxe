package com.sulake.core.window.graphics
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindowContext;
    import flash.display.BitmapData;

     interface IWindowRenderer extends IDisposable 
    {
        var debug(never,set):Bool;
        function render():Void;
        function _Str_18389(_arg_1:IWindow, _arg_2:Rectangle, _arg_3:UInt):Void;
        function _Str_22792():Void;
        function invalidate(_arg_1:IWindowContext, _arg_2:Rectangle):Void;
        function _Str_19855(_arg_1:IWindow):BitmapData;
        function purge(_arg_1:IWindow=null, _arg_2:Bool=true):Void;
    }

