package com.sulake.core.window
;
    import flash.geom.Rectangle;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.utils.DefaultAttStruct;
    import com.sulake.core.window.theme.IThemeManager;
    import com.sulake.core.window.graphics.renderer.ISkinRenderer;

     interface IWindowFactory
    {
        function create(_arg_1:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:Rectangle, _arg_6:ASFunction=null, _arg_7:String="", _arg_8:UInt=0, _arg_9:Array<ASAny>=null, _arg_10:IWindow=null, _arg_11:Array<ASAny>=null, _arg_12:String=""):IWindow;
        function getRendererByTypeAndStyle(_arg_1:UInt, _arg_2:UInt):ISkinRenderer;
        function destroy(_arg_1:IWindow):Void;
        function buildFromXML(_arg_1:com.sulake.core.utils.xml.XML, _arg_2:UInt=1, _arg_3:Map=null):IWindow;
        function windowToXMLString(_arg_1:IWindow):String;
        function _Str_19128(_arg_1:UInt, _arg_2:UInt):com.sulake.core.utils.xml.XML;
        function _Str_20294(_arg_1:UInt, _arg_2:UInt):DefaultAttStruct;
        function getThemeManager():IThemeManager;
    }

