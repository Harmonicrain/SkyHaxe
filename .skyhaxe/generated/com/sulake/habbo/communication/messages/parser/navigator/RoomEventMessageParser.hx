package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomEventData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomEventMessageParser implements IMessageParser
    {
        var _data:RoomEventData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new RoomEventData(k);
            return true;
        }

        public var data(get,never):RoomEventData;
public function  get_data():RoomEventData
        {
            return this._data;
        }

	public function new() {}
    }

