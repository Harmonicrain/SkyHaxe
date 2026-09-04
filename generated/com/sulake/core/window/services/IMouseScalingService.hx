package com.sulake.core.window.services
;
    import com.sulake.core.window.IWindow;

     interface IMouseScalingService 
    {
        function dispose():Void;
        function begin(_arg_1:IWindow, _arg_2:UInt=0):IWindow;
        function end(_arg_1:IWindow):IWindow;
    }

