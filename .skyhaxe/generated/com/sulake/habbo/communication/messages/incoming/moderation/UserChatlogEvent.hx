package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.UserChatlogMessageParser;

     class UserChatlogEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UserChatlogMessageParser);
        }

        public function getParser():UserChatlogMessageParser
        {
            return Std.downcast(_parser , UserChatlogMessageParser);
        }
    }

