package com.sulake.habbo.toolbar
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import com.sulake.core.window.motion.Motion;
    import com.sulake.core.window.IWindow;

     interface IHabboToolbar extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
        function getIconLocation(_arg_1:String):Rectangle;
        function createTransitionToIcon(_arg_1:String, _arg_2:BitmapData, _arg_3:Int, _arg_4:Int):Motion;
        function updateVisibility(_arg_1:String):Void;
        function setAssetUri(_arg_1:String, _arg_2:BitmapData):Void;
        function getRect():Rectangle;
        var extensionView(get,never):IExtensionView;
        function setIconVisibility(_arg_1:String, _arg_2:Bool):Void;
        function toggleWindowVisibility(_arg_1:String):Void;
        var onDuty(never,set):Bool;
        var toolBarAreaWidth(get,never):Int;
        function _Str_6621(_arg_1:String):IWindow;
    }

