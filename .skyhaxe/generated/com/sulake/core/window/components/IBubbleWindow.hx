package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.utils.IMargins;

     interface IBubbleWindow extends IWindowContainer 
    {
                var direction(get,set):String;
                var _Str_8006(get,set):Int;
        var margins(get,never):IMargins;
        var content(get,never):IWindowContainer;
    }

