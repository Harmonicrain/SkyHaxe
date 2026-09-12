package com.sulake.habbo.help
;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;

     interface INameChangeUI 
    {
        var localization(get,never):IHabboLocalizationManager;
        var assets(get,never):IAssetLibrary;
        var myName(get,never):String;
        function buildXmlWindow(_arg_1:String, _arg_2:UInt=1):IWindow;
        function checkName(_arg_1:String):Void;
        function changeName(_arg_1:String):Void;
        function showView():Void;
        function hideView():Void;
    }

