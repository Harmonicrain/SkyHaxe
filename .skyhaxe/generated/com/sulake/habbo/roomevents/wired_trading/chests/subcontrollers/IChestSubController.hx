package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;

     interface IChestSubController extends IDisposable
    {
        var type(get,never):Int;
        var title(get,never):String;
        var view(get,never):IWindowContainer;
        var isEmpty(get,never):Bool;
        var itemCount(get,never):Int;
        function clear():Void;
        function updateUI():Void;
        var allowResizing(get,never):Bool;
    }

