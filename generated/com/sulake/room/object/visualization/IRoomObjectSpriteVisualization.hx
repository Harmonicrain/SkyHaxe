package com.sulake.room.object.visualization
;
     interface IRoomObjectSpriteVisualization extends IRoomObjectGraphicVisualization 
    {
        var spriteCount(get,never):Int;
        function getSprite(_arg_1:Int):IRoomObjectSprite;
        function getSpriteList():Array<ASAny>;
    }

