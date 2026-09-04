package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.ChatReviewSessionOfferedToGuideMessageParser;

     class ChatReviewSessionOfferedToGuideMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ChatReviewSessionOfferedToGuideMessageParser);
        }

        public function getParser():ChatReviewSessionOfferedToGuideMessageParser
        {
            return Std.downcast(_parser , ChatReviewSessionOfferedToGuideMessageParser);
        }
    }

