package com.sulake.room.renderer
;
     interface IRoomRenderer extends IRoomRendererBase 
    {
        var roomObjectVariableAccurateZ(never,set):String;
        function createCanvas(_arg_1:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int):IRoomRenderingCanvas;
        function getCanvas(_arg_1:Int):IRoomRenderingCanvas;
        function disposeCanvas(_arg_1:Int):Bool;
    }

