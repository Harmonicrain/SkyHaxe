package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildCreationInfoMessageParser;

     class GuildCreationInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildCreationInfoMessageParser);
        }

        public var data(get,never):GuildCreationData;
function  get_data():GuildCreationData
        {
            return cast(_parser, GuildCreationInfoMessageParser).data;
        }
    }

