package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomSearchResultData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuestRoomSearchResultMessageParser implements IMessageParser
    {
        var _data:GuestRoomSearchResultData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new GuestRoomSearchResultData(k);
            return true;
        }

        public var data(get,never):GuestRoomSearchResultData;
public function  get_data():GuestRoomSearchResultData
        {
            return this._data;
        }

	public function new() {}
    }

