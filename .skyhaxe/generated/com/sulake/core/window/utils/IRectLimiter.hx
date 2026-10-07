package com.sulake.core.window.utils
;
     interface IRectLimiter 
    {
                var minWidth(get,set):Int;
                var maxWidth(get,set):Int;
                var minHeight(get,set):Int;
                var maxHeight(get,set):Int;
        var isEmpty(get,never):Bool;
        function setEmpty():Void;
        function limit():Void;
    }

