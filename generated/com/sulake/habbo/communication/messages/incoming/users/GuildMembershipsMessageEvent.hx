package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildMembershipsMessageParser;

     class GuildMembershipsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildMembershipsMessageParser);
        }

        public var guilds(get,never):Array<ASAny>;
function  get_guilds():Array<ASAny>
        {
            return cast(_parser, GuildMembershipsMessageParser).guilds;
        }
    }

