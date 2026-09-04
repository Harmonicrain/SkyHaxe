package com.sulake.habbo.room.object.visualization.room.rasterizer
;
    import flash.display.BitmapData;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.object.visualization.room.utils.PlaneBitmapData;

     interface IPlaneRasterizer 
    {
        function initializeDimensions(_arg_1:Int, _arg_2:Int):Bool;
        function render(_arg_1:BitmapData, _arg_2:String, _arg_3:Float, _arg_4:Float, _arg_5:Float, _arg_6:IVector3d, _arg_7:Bool, _arg_8:Float=0, _arg_9:Float=0, _arg_10:Float=0, _arg_11:Float=0, _arg_12:Int=0):PlaneBitmapData;
        function getTextureIdentifier(_arg_1:Float, _arg_2:IVector3d):String;
        function getLayers(_arg_1:String):Array<ASAny>;
        function reinitialize():Void;
    }

