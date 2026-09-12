package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;

     interface IDropListItemWindow extends IButtonWindow 
    {
        var menu(get,never):IDropMenuWindow;
                var value(get,set):IWindow;
    }

