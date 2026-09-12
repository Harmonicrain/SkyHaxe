package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.IssuePickFailedMessageParser;

     class IssuePickFailedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, IssuePickFailedMessageParser);
        }

        public function getParser():IssuePickFailedMessageParser
        {
            return Std.downcast(_parser , IssuePickFailedMessageParser);
        }
    }

