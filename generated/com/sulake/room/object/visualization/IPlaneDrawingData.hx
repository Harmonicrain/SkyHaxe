package com.sulake.room.object.visualization
;
    import flash.geom.Point;

     interface IPlaneDrawingData 
    {
                var z(get,set):Float;
                var cornerPoints(get,set):Vector<Point>;
        var color(get,never):UInt;
        var maskAssetNames(get,never):Array<ASAny>;
        var maskAssetLocations(get,never):Array<ASAny>;
        var maskAssetFlipHs(get,never):Array<ASAny>;
        var maskAssetFlipVs(get,never):Array<ASAny>;
        function isBottomAligned():Bool;
        var assetNameColumns(get,never):Array<ASAny>;
    }

