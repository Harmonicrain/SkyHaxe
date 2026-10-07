package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.moderation.RoomVisitsData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomVisitsMessageParser implements IMessageParser
    {
        var _data:RoomVisitsData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new RoomVisitsData(k);
            return true;
        }

        public var data(get,never):RoomVisitsData;
public function  get_data():RoomVisitsData
        {
            return this._data;
        }

	public function new() {}
    }

