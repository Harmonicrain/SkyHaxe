package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.moderation.ChatRecordData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomChatlogMessageParser implements IMessageParser
    {
        var _data:ChatRecordData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new ChatRecordData(k);
            return true;
        }

        public var data(get,never):ChatRecordData;
public function  get_data():ChatRecordData
        {
            return this._data;
        }

	public function new() {}
    }

