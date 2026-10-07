package com.sulake.core.window.utils
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.Map;

     interface IWindowParser extends IDisposable 
    {
        function parseAndConstruct(_arg_1:com.sulake.core.utils.xml.XML, _arg_2:IWindow, _arg_3:Map):IWindow;
        function windowToXMLString(_arg_1:IWindow):String;
    }

