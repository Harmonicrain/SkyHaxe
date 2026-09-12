package com.sulake.room.object.visualization
;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

     interface IRoomObjectVisualization 
    {
                var object(get,set):IRoomObject;
        function dispose():Void;
        function initialize(_arg_1:IRoomObjectVisualizationData):Bool;
        function update(_arg_1:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool):Void;
        var image(get,never):BitmapData;
        function getImage(_arg_1:Int, _arg_2:Int):BitmapData;
        var boundingRectangle(get,never):Rectangle;
        function getInstanceId():Int;
        function getUpdateID():Int;
    }

