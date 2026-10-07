package com.sulake.core.window.components
;
    import com.sulake.core.runtime.IDisposable;

     interface IFocusWindow extends IDisposable 
    {
        var focused(get,never):Bool;
        function focus():Bool;
        function unfocus():Bool;
    }

