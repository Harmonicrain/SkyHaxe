package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.ChatReviewSessionStartedMessageParser;

     class ChatReviewSessionStartedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ChatReviewSessionStartedMessageParser);
        }

        public function getParser():ChatReviewSessionStartedMessageParser
        {
            return Std.downcast(_parser , ChatReviewSessionStartedMessageParser);
        }
    }

