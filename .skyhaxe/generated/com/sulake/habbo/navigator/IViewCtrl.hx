package com.sulake.habbo.navigator
;
    import com.sulake.core.window.IWindowContainer;

     interface IViewCtrl 
    {
        function refresh():Void;
                var content(get,set):IWindowContainer;
    }

