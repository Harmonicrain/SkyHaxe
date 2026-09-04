package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.CompetitionRoomsData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CompetitionRoomsDataMessageParser implements IMessageParser
    {
        var _data:CompetitionRoomsData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new CompetitionRoomsData(k);
            return true;
        }

        public var data(get,never):CompetitionRoomsData;
function  get_data():CompetitionRoomsData
        {
            return this._data;
        }

	public function new() {}
    }

