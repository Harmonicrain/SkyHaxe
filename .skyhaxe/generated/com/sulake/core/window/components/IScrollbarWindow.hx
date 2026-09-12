package com.sulake.core.window.components
;
     interface IScrollbarWindow extends IInteractiveWindow 
    {
                var scrollH(get,set):Float;
                var scrollV(get,set):Float;
                var scrollable(get,set):IScrollableWindow;
        function scrollWithWheel(_arg_1:Int):Bool;
        var vertical(get,never):Bool;
        var horizontal(get,never):Bool;
    }

