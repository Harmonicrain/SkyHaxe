package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.moderation.UserChatlogData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserChatlogMessageParser implements IMessageParser
    {
        var _data:UserChatlogData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new UserChatlogData(k);
            return true;
        }

        public var data(get,never):UserChatlogData;
public function  get_data():UserChatlogData
        {
            return this._data;
        }

	public function new() {}
    }

