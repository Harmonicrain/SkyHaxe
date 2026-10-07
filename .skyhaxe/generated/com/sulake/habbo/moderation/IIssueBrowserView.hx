package com.sulake.habbo.moderation
;
    import com.sulake.core.window.IWindowContainer;

     interface IIssueBrowserView 
    {
        var visible(never,set):Bool;
        function update():Void;
        var view(get,never):IWindowContainer;
    }

