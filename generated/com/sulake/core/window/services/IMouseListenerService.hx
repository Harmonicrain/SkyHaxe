package com.sulake.core.window.services
;
    import com.sulake.core.window.IWindow;

     interface IMouseListenerService 
    {
        var eventTypes(get,never):Array<ASAny>;
                var _Str_14321(get,set):UInt;
        function dispose():Void;
        function begin(_arg_1:IWindow, _arg_2:UInt=0):IWindow;
        function end(_arg_1:IWindow):IWindow;
    }

