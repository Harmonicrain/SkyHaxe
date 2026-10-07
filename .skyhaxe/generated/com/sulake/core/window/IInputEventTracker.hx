package com.sulake.core.window
;
    import com.sulake.core.window.events.WindowEvent;

     interface IInputEventTracker 
    {
        function eventReceived(_arg_1:WindowEvent, _arg_2:IWindow):Void;
    }

