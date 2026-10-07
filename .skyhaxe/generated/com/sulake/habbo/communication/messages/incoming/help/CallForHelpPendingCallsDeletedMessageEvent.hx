package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.CallForHelpPendingCallsDeletedMessageParser;

     class CallForHelpPendingCallsDeletedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CallForHelpPendingCallsDeletedMessageParser);
        }

        public function getParser():CallForHelpPendingCallsDeletedMessageParser
        {
            return Std.downcast(_parser , CallForHelpPendingCallsDeletedMessageParser);
        }
    }

