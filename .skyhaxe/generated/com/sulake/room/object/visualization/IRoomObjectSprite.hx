package com.sulake.room.object.visualization
;
    import flash.display.BitmapData;

     interface IRoomObjectSprite 
    {
                var asset(get,set):BitmapData;
                var assetName(get,set):String;
                var libraryAssetName(get,set):String;
                var assetPosture(get,set):String;
                var visible(get,set):Bool;
                var tag(get,set):String;
                var alpha(get,set):Int;
                var color(get,set):Int;
                var blendMode(get,set):String;
                var filters(get,set):Array<ASAny>;
                var skipMouseHandling(get,set):Bool;
                var flipH(get,set):Bool;
                var flipV(get,set):Bool;
                var direction(get,set):Int;
                var offsetX(get,set):Int;
                var offsetY(get,set):Int;
        var width(get,never):Int;
        var height(get,never):Int;
                var relativeDepth(get,set):Float;
                var varyingDepth(get,set):Bool;
                var clickHandling(get,set):Bool;
        var instanceId(get,never):Int;
        var updateId(get,never):Int;
                var spriteType(get,set):Int;
                var objectType(get,set):String;
                var alphaTolerance(get,set):Int;
                var planeId(get,set):Int;
    }

