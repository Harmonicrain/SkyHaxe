package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.utils.IIterable;
    import com.sulake.core.window.IWidget;

     interface IWidgetWindow extends IWindow extends  IIterable 
    {
        var widget(get,never):IWidget;
                var rootWindow(get,set):IWindow;
    }

