package com.sulake.core.window.tools
;
    import com.sulake.core.runtime.IDisposable;

     interface IDevTool extends IDisposable 
    {
        var caption(get,never):String;
                var visible(get,set):Bool;
    }

