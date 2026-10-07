package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWidget;

     interface ICountdownWidget extends IWidget 
    {
                var colorStyle(get,set):Int;
                var running(get,set):Bool;
                var digits(get,set):UInt;
                var seconds(get,set):Int;
    }

