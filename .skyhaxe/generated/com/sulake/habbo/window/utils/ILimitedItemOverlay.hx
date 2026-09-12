package com.sulake.habbo.window.utils
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;

     interface ILimitedItemOverlay extends IDisposable
    {
        var window(get,never):IWindowContainer;
        var serialNumber(never,set):Int;
        var seriesSize(never,set):Int;
    }

