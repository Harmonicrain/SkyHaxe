package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWidget;

     interface IProductIconWidget extends IWidget
    {
                var productInfo(get,set):IProductDisplayInfo;
                var blend(get,set):Float;
        var unknownImageUri(never,set):String;
    }

