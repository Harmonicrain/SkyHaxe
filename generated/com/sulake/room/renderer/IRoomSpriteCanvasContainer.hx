package com.sulake.room.renderer
;
    import com.sulake.room.object.IRoomObject;

     interface IRoomSpriteCanvasContainer 
    {
        var roomObjectVariableAccurateZ(get,never):String;
        function getRoomObject(_arg_1:String):IRoomObject;
        function getRoomObjectWithIndex(_arg_1:Int):IRoomObject;
        function getRoomObjectIdWithIndex(_arg_1:Int):String;
        function getRoomObjectCount():Int;
        function getRoomObjectIdentifier(_arg_1:IRoomObject):String;
    }

