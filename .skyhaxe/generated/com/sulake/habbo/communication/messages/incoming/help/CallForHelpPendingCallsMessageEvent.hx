package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.CallForHelpPendingCallsMessageParser;

     class CallForHelpPendingCallsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CallForHelpPendingCallsMessageParser);
        }

        public function getParser():CallForHelpPendingCallsMessageParser
        {
            return Std.downcast(_parser , CallForHelpPendingCallsMessageParser);
        }
    }

