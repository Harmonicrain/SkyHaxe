package com.sulake.habbo.navigator
;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.habbo.help.IHabboHelp;

     interface IHabboNewNavigator extends IUnknown 
    {
        function open():Void;
        function performSearch(_arg_1:String, _arg_2:String="", _arg_3:String=""):Void;
        function performTagSearch(_arg_1:String):Void;
        function goToRoom(_arg_1:Int, _arg_2:String="mainview"):Void;
        var isReady(get,never):Bool;
        var legacyNavigator(get,never):IHabboNavigator;
        var habboHelp(get,never):IHabboHelp;
    }

