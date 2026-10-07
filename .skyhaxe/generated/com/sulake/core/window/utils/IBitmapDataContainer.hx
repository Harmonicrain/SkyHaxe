package com.sulake.core.window.utils
;
    import flash.display.BitmapData;
    import flash.geom.Point;

     interface IBitmapDataContainer 
    {
        var bitmapData(get,never):BitmapData;
                var pivotPoint(get,set):UInt;
                var stretchedX(get,set):Bool;
                var stretchedY(get,set):Bool;
                var zoomX(get,set):Float;
                var zoomY(get,set):Float;
                var greyscale(get,set):Bool;
                var etchingColor(get,set):UInt;
        var etchingPoint(get,never):Point;
                var fitSizeToContents(get,set):Bool;
                var wrapX(get,set):Bool;
                var wrapY(get,set):Bool;
    }

