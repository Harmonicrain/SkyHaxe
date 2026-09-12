package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.PopularRoomTagsData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PopularRoomTagsResultMessageParser implements IMessageParser
    {
        var _data:PopularRoomTagsData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new PopularRoomTagsData(k);
            return true;
        }

        public var data(get,never):PopularRoomTagsData;
public function  get_data():PopularRoomTagsData
        {
            return this._data;
        }

	public function new() {}
    }

