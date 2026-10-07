package com.sulake.room.renderer
;
    import com.sulake.room.object.IRoomObject;

     interface IRoomRendererBase 
    {
        function dispose():Void;
        function reset():Void;
        function feedRoomObject(_arg_1:IRoomObject):Void;
        function removeRoomObject(_arg_1:IRoomObject):Void;
        function update(_arg_1:UInt):Void;
    }

