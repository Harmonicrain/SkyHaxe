package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.CallForHelpDisabledNotifyMessageParser;

     class CallForHelpDisabledNotifyMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CallForHelpDisabledNotifyMessageParser);
        }

        public function getParser():CallForHelpDisabledNotifyMessageParser
        {
            return Std.downcast(_parser , CallForHelpDisabledNotifyMessageParser);
        }
    }

