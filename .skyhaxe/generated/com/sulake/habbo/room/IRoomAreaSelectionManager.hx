package com.sulake.habbo.room
;
    import com.sulake.habbo.room.events.RoomObjectTileMouseEvent;

     interface IRoomAreaSelectionManager
    {
        function activate(_arg_1:ASFunction, _arg_2:String):Bool;
        function deactivate():Void;
        function startSelecting():Void;
        function handleTileMouseEvent(_arg_1:RoomObjectTileMouseEvent):Void;
        function finishSelecting():Bool;
        function clearHighlight():Void;
        function setHighlight(_arg_1:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int):Void;
        var areaSelectionState(get,never):Int;
        function dispose():Void;
    }

