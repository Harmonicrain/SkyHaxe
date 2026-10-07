package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;

     interface ISelectableWindow extends IWindow 
    {
        var selector(get,never):ISelectorWindow;
                var Selected(get,set):Bool;
        function select():Bool;
        function unselect():Bool;
    }

