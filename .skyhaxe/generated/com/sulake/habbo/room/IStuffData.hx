package com.sulake.habbo.room
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObjectModelController;

     interface IStuffData 
    {
        function initializeFromIncomingMessage(_arg_1:IMessageDataWrapper):Void;
        function initializeFromRoomObjectModel(_arg_1:IRoomObjectModel):Void;
        function writeRoomObjectModel(_arg_1:IRoomObjectModelController):Void;
        function getLegacyString():String;
        function getJSONValue(_arg_1:String):String;
        function compare(_arg_1:IStuffData):Bool;
        var flags(never,set):Int;
                var uniqueSerialNumber(get,set):Int;
                var uniqueSeriesSize(get,set):Int;
        var rarityLevel(get,never):Int;
        var contentsCount(get,never):Int;
        var chestName(get,never):String;
        var state(get,never):Int;
    }

