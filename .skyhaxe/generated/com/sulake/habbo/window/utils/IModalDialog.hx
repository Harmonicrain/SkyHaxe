package com.sulake.habbo.window.utils
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;

     interface IModalDialog extends IDisposable
    {
        var rootWindow(get,never):IWindow;
        var background(get,never):IBitmapWrapperWindow;
    }

