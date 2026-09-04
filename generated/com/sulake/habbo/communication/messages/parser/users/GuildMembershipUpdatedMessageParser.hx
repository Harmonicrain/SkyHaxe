package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.MemberData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildMembershipUpdatedMessageParser implements IMessageParser
    {
        var _guildId:Int = 0;
        var _data:MemberData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._guildId = k.readInteger();
            this._data = new MemberData(k);
            return true;
        }

        public var guildId(get,never):Int;
function  get_guildId():Int
        {
            return this._guildId;
        }

        public var data(get,never):MemberData;
function  get_data():MemberData
        {
            return this._data;
        }

	public function new() {}
    }

