package com.sulake.core.window
;
    import flash.geom.Rectangle;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.utils.INotify;

     interface ICoreWindowManager 
    {
        function create(_arg_1:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:Rectangle, _arg_6:ASFunction=null, _arg_7:String="", _arg_8:UInt=0, _arg_9:Array<ASAny>=null, _arg_10:IWindow=null, _arg_11:Array<ASAny>=null, _arg_12:String=""):IWindow;
        function destroy(_arg_1:IWindow):Void;
        function buildFromXML(_arg_1:com.sulake.core.utils.xml.XML, _arg_2:UInt=1, _arg_3:Map=null):IWindow;
        function windowToXMLString(_arg_1:IWindow):String;
        function getDesktop(_arg_1:UInt):IDesktopWindow;
        function notify(_arg_1:String, _arg_2:String, _arg_3:ASFunction, _arg_4:UInt=0):INotify;
        function findWindowByName(_arg_1:String):IWindow;
        function findWindowByTag(_arg_1:String):IWindow;
        function groupWindowsWithTag(_arg_1:String, _arg_2:Array<ASAny>, _arg_3:Int=0):UInt;
    }

