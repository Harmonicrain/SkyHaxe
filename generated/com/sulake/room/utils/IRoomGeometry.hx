package com.sulake.room.utils
;
    import flash.geom.Point;
    import com.sulake.room.utils.IVector3d;

     interface IRoomGeometry 
    {
        var scale(get,never):Float;
        var directionAxis(get,never):IVector3d;
        var direction(get,never):IVector3d;
        function getCoordinatePosition(_arg_1:IVector3d):IVector3d;
        function getScreenPoint(_arg_1:IVector3d):Point;
        function getScreenPosition(_arg_1:IVector3d):IVector3d;
        function getPlanePosition(_arg_1:Point, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:IVector3d):Point;
        function setDisplacement(_arg_1:IVector3d, _arg_2:IVector3d):Void;
        function adjustLocation(_arg_1:IVector3d, _arg_2:Float):Void;
        function performZoom():Void;
        function performZoomOut():Void;
        function performZoomIn():Void;
        function isZoomedIn():Bool;
        var updateId(get,never):Int;
        var z_scale(never,set):Float;
    }

