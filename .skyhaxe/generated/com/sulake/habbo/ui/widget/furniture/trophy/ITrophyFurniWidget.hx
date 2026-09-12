package com.sulake.habbo.ui.widget.furniture.trophy
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;

     interface ITrophyFurniWidget 
    {
        var assets(get,never):IAssetLibrary;
        var name(get,never):String;
        var date(get,never):String;
        var color(get,never):Int;
        var windowManager(get,never):IHabboWindowManager;
        var message(get,never):String;
    }

