package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildMembersMessageParser;

     class GuildMembersEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, GuildMembersMessageParser);
        }

        public var data(get,never):GuildMemberData;
function  get_data():GuildMemberData
        {
            return cast(_parser, GuildMembersMessageParser).data;
        }
    }

