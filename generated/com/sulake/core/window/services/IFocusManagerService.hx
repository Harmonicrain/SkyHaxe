package com.sulake.core.window.services
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFocusWindow;

     interface IFocusManagerService extends IDisposable 
    {
        function registerFocusWindow(_arg_1:IFocusWindow):Void;
        function removeFocusWindow(_arg_1:IFocusWindow):Void;
    }

