package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.UserBannedMessageParser;

     class UserBannedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UserBannedMessageParser);
        }

        public function getParser():UserBannedMessageParser
        {
            return Std.downcast(_parser , UserBannedMessageParser);
        }
    }

