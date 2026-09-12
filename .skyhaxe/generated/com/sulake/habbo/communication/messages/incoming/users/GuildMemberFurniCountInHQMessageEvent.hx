package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.GuildMemberFurniCountInHQMessageParser;

     class GuildMemberFurniCountInHQMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildMemberFurniCountInHQMessageParser);
        }

        public function userId():Int
        {
            return cast(_parser, GuildMemberFurniCountInHQMessageParser).userId;
        }

        public function furniCount():Int
        {
            return cast(_parser, GuildMemberFurniCountInHQMessageParser).furniCount;
        }
    }

