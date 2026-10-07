package com.sulake.room.object.visualization
;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.IRoomGeometry;

     interface IRoomPlane 
    {
        var uniqueId(get,never):Int;
        var location(get,never):IVector3d;
        var leftSide(get,never):IVector3d;
        var rightSide(get,never):IVector3d;
        var color(get,never):UInt;
        function getDrawingDatas(_arg_1:IRoomGeometry):Array<ASAny>;
    }

