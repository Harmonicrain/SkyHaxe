package com.sulake.habbo.toolbar
;
    import com.sulake.core.window.IWindow;

     interface IExtensionView 
    {
                var visible(get,set):Bool;
        var screenHeight(get,never):UInt;
        function attachExtension(_arg_1:String, _arg_2:IWindow, _arg_3:Int=-1, _arg_4:Array<ASAny>=null):Void;
        function detachExtension(_arg_1:String):Void;
        function hasExtension(_arg_1:String):Bool;
                var extraMargin(get,set):Int;
        function refreshItemWindow():Void;
    }

