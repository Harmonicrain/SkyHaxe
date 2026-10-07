package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueInfoMessageParser;

     class IssueInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, IssueInfoMessageParser);
        }

        public function getParser():IssueInfoMessageParser
        {
            return Std.downcast(_parser , IssueInfoMessageParser);
        }
    }

