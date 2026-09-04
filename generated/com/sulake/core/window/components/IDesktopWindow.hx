package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import flash.geom.Point;

     interface IDesktopWindow extends IWindowContainer extends  IDisplayObjectWrapper 
    {
        var mouseX(get,never):Int;
        var mouseY(get,never):Int;
        function getActiveWindow():IWindow;
        function setActiveWindow(_arg_1:IWindow):IWindow;
        function groupParameterFilteredChildrenUnderPoint(_arg_1:Point, _arg_2:Array<ASAny>, _arg_3:UInt=0):Void;
    }

