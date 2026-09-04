package com.sulake.habbo.room
;
    import flash.display.BitmapData;

     interface IGetImageListener 
    {
        function imageReady(_arg_1:Int, _arg_2:BitmapData):Void;
        function imageFailed(_arg_1:Int):Void;
    }

