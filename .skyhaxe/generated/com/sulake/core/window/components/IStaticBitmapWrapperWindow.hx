package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.utils.IBitmapDataContainer;

     interface IStaticBitmapWrapperWindow extends IWindow extends  IBitmapDataContainer 
    {
                var assetUri(get,set):String;
    }

