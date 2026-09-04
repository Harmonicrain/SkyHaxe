package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.CallForHelpReplyMessageParser;

     class CallForHelpReplyMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CallForHelpReplyMessageParser);
        }

        public function getParser():CallForHelpReplyMessageParser
        {
            return Std.downcast(_parser , CallForHelpReplyMessageParser);
        }
    }

