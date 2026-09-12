package com.sulake.core.window
;
    import com.sulake.core.window.services.IInternalWindowServices;
    import com.sulake.core.window.utils.IWindowParser;
    import com.sulake.core.window.components.IDesktopWindow;
    import flash.geom.Rectangle;

     interface IWindowContext 
    {
        function getWindowServices():IInternalWindowServices;
        function getWindowParser():IWindowParser;
        function getDesktopWindow():IDesktopWindow;
        function registerLocalizationListener(_arg_1:String, _arg_2:IWindow):Void;
        function removeLocalizationListener(_arg_1:String, _arg_2:IWindow):Void;
        function findWindowByName(_arg_1:String):IWindow;
        function findWindowByTag(_arg_1:String):IWindow;
        function groupChildrenWithTag(_arg_1:String, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt;
        function create(_arg_1:String, _arg_2:String, _arg_3:UInt, _arg_4:UInt, _arg_5:UInt, _arg_6:Rectangle, _arg_7:ASFunction, _arg_8:IWindow, _arg_9:UInt, _arg_10:Array<ASAny>=null, _arg_11:String="", _arg_12:Array<ASAny>=null):IWindow;
        function destroy(_arg_1:IWindow):Bool;
        function invalidate(_arg_1:IWindow, _arg_2:Rectangle, _arg_3:UInt):Void;
        function getLastError():ASError;
        function getLastErrorCode():Int;
        function flushError():Void;
        function addMouseEventTracker(_arg_1:IInputEventTracker):Void;
        function removeMouseEventTracker(_arg_1:IInputEventTracker):Void;
    }

