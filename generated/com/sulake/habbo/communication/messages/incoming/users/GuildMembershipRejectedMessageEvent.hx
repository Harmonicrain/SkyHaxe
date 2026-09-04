package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildMembershipRejectedMessageParser;

     class GuildMembershipRejectedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildMembershipRejectedMessageParser);
        }

        public function getParser():GuildMembershipRejectedMessageParser
        {
            return cast(_parser, GuildMembershipRejectedMessageParser);
        }
    }

