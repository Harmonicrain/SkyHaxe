package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.moderation.CfhChatlogData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CfhChatlogMessageParser implements IMessageParser
    {
        var _data:CfhChatlogData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new CfhChatlogData(k);
            return true;
        }

        public var data(get,never):CfhChatlogData;
function  get_data():CfhChatlogData
        {
            return this._data;
        }

	public function new() {}
    }

