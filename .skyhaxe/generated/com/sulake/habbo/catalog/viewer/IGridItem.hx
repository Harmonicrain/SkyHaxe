package com.sulake.habbo.catalog.viewer
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;

     interface IGridItem extends IDisposable 
    {
                var view(get,set):IWindowContainer;
        var grid(never,set):_Str_4311;
        function _Str_16497(_arg_1:Bool):Void;
        function activate():Void;
        function deactivate():Void;
    }

