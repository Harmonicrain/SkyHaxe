package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.utils.IMargins;

     interface IFrameWindow extends IWindowContainer 
    {
        var title(get,never):ILabelWindow;
        var header(get,never):IHeaderWindow;
        var content(get,never):IWindowContainer;
        var margins(get,never):IMargins;
        var scaler(get,never):IScalerWindow;
        function _Str_5665():Void;
        var _Str_21008(never,set):ASFunction;
                var _Str_7032(get,set):String;
    }

