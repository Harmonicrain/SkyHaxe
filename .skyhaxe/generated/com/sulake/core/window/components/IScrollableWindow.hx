package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import flash.geom.Rectangle;

     interface IScrollableWindow extends IWindow 
    {
                var scrollH(get,set):Float;
                var scrollV(get,set):Float;
                var scrollStepH(get,set):Float;
                var scrollStepV(get,set):Float;
        var maxScrollH(get,never):Int;
        var maxScrollV(get,never):Int;
        var visibleRegion(get,never):Rectangle;
        var scrollableRegion(get,never):Rectangle;
    }

