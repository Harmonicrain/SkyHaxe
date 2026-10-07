package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.ChatReviewSessionResultsMessageParser;

     class ChatReviewSessionResultsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ChatReviewSessionResultsMessageParser);
        }

        public function getParser():ChatReviewSessionResultsMessageParser
        {
            return Std.downcast(_parser , ChatReviewSessionResultsMessageParser);
        }
    }

