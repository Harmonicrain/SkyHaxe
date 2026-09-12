package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import flash.display.BitmapData;

     interface IBitmapWrapperWindow extends IWindow 
    {
                var bitmap(get,set):BitmapData;
                var bitmapAssetName(get,set):String;
                var disposesBitmap(get,set):Bool;
    }

