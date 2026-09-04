package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueDeletedMessageParser;

     class IssueDeletedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, IssueDeletedMessageParser);
        }

        public function getParser():IssueDeletedMessageParser
        {
            return Std.downcast(_parser , IssueDeletedMessageParser);
        }
    }

