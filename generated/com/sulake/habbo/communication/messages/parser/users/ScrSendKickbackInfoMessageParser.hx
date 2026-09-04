package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.ScrKickbackData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ScrSendKickbackInfoMessageParser implements IMessageParser
    {
        var _data:ScrKickbackData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new ScrKickbackData(k);
            return true;
        }

        public var data(get,never):ScrKickbackData;
function  get_data():ScrKickbackData
        {
            return this._data;
        }

	public function new() {}
    }

