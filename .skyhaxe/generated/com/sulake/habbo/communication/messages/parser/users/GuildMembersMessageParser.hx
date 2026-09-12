package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMemberData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildMembersMessageParser implements IMessageParser
    {
        var _data:GuildMemberData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new GuildMemberData(k);
            return true;
        }

        public var data(get,never):GuildMemberData;
public function  get_data():GuildMemberData
        {
            return this._data;
        }

	public function new() {}
    }

