package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.moderation.RoomModerationData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ModeratorRoomInfoMessageParser implements IMessageParser
    {
        var _data:RoomModerationData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new RoomModerationData(k);
            return true;
        }

        public var data(get,never):RoomModerationData;
public function  get_data():RoomModerationData
        {
            return this._data;
        }

	public function new() {}
    }

