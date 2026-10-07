package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.utils.IIterable;
    import com.sulake.core.window.IWindowContainer;

     interface ITabContextWindow extends IWindow extends  IIterable 
    {
        var selector(get,never):ISelectorListWindow;
        var container(get,never):IWindowContainer;
        var numTabs(get,never):UInt;
        function _Str_5377(_arg_1:ITabButtonWindow):ITabButtonWindow;
        function _Str_25454(_arg_1:ITabButtonWindow, _arg_2:UInt):ITabButtonWindow;
        function _Str_5897(_arg_1:ITabButtonWindow):Void;
        function getTabButtonAt(_arg_1:UInt):ITabButtonWindow;
        function _Str_19493(_arg_1:String):ITabButtonWindow;
        function _Str_20824(_arg_1:UInt):ITabButtonWindow;
        function _Str_23344(_arg_1:ITabButtonWindow):UInt;
    }

