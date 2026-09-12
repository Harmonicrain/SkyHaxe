package com.sulake.habbo.friendbar.view.tabs
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;

     interface ITab extends IDisposable 
    {
        var window(get,never):IWindowContainer;
        var selected(get,never):Bool;
        var _Str_6044(get,never):Bool;
        function select(_arg_1:Bool):Void;
        function deselect(_arg_1:Bool):Void;
        function recycle():Void;
    }

