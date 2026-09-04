package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildMembershipUpdatedMessageParser;

     class GuildMembershipUpdatedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildMembershipUpdatedMessageParser);
        }

        public var data(get,never):MemberData;
function  get_data():MemberData
        {
            return cast(_parser, GuildMembershipUpdatedMessageParser).data;
        }

        public var guildId(get,never):Int;
function  get_guildId():Int
        {
            return cast(_parser, GuildMembershipUpdatedMessageParser).guildId;
        }
    }

