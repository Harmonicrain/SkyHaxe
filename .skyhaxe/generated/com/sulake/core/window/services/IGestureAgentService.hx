package com.sulake.core.window.services
;
    import com.sulake.core.window.IWindow;

     interface IGestureAgentService 
    {
        function dispose():Void;
        function begin(_arg_1:IWindow, _arg_2:ASFunction, _arg_3:UInt, _arg_4:Int, _arg_5:Int):IWindow;
        function end(_arg_1:IWindow):IWindow;
    }

