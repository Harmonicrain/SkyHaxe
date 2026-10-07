package com.sulake.habbo.ui.widget.memenu
;
    import com.sulake.core.window.IWindowContainer;

     interface IMeMenuView 
    {
        function init(_arg_1:MeMenuWidget, _arg_2:String):Void;
        function dispose():Void;
        var window(get,never):IWindowContainer;
        function _Str_6111(_arg_1:String, _arg_2:Int):Void;
    }

