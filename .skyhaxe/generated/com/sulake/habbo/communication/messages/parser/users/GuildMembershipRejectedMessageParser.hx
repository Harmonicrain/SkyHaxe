package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildMembershipRejectedMessageParser implements IMessageParser
    {
        var _guildId:Int = 0;
        var _userId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._guildId = k.readInteger();
            this._userId = k.readInteger();
            return true;
        }

        public var guildId(get,never):Int;
public function  get_guildId():Int
        {
            return this._guildId;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

	public function new() {}
    }

