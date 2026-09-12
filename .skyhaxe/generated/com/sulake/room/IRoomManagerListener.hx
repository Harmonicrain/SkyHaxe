package com.sulake.room
;
     interface IRoomManagerListener 
    {
        function roomManagerInitialized(_arg_1:Bool):Void;
        function contentLoaded(_arg_1:String, _arg_2:Bool):Void;
        function objectInitialized(_arg_1:String, _arg_2:Int, _arg_3:Int):Void;
        function objectsInitialized(_arg_1:String):Void;
    }

