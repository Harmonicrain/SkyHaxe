package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWidget;

     interface IRunningNumberWidget extends IWidget 
    {
                var number(get,set):Int;
        var setNumberImmediately(never,set):Int;
                var digits(get,set):UInt;
                var colorStyle(get,set):Int;
                var updateFrequency(get,set):Int;
    }

