package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.ChatReviewSessionVotingStatusMessageParser;

     class ChatReviewSessionVotingStatusMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ChatReviewSessionVotingStatusMessageParser);
        }

        public function getParser():ChatReviewSessionVotingStatusMessageParser
        {
            return Std.downcast(_parser , ChatReviewSessionVotingStatusMessageParser);
        }
    }

