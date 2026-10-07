package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildMemberMgmtFailedMessageParser;

     class GuildMemberMgmtFailedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildMemberMgmtFailedMessageParser);
        }

        public var reason(get,never):Int;
public function  get_reason():Int
        {
            return cast(_parser, GuildMemberMgmtFailedMessageParser).reason;
        }

        public var guildId(get,never):Int;
public function  get_guildId():Int
        {
            return cast(_parser, GuildMemberMgmtFailedMessageParser).guildId;
        }
    }

