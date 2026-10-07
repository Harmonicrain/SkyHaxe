package com.sulake.core.window.components
;
    import com.sulake.core.window.utils.IIterable;
    import com.sulake.core.window.IWindow;

     interface IDropListWindow extends IInteractiveWindow extends  IIterable 
    {
                var selection(get,set):Int;
        var numMenuItems(get,never):Int;
        function addMenuItem(_arg_1:IWindow):IWindow;
        function addMenuItemAt(_arg_1:IWindow, _arg_2:Int):IWindow;
        function getMenuItemIndex(_arg_1:IWindow):Int;
        function getMenuItemAt(_arg_1:Int):IWindow;
        function removeMenuItem(_arg_1:IWindow):IWindow;
        function removeMenuItemAt(_arg_1:Int):IWindow;
    }

