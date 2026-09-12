package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.CallForHelpResultMessageParser;

     class CallForHelpResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CallForHelpResultMessageParser);
        }

        public function getParser():CallForHelpResultMessageParser
        {
            return Std.downcast(_parser , CallForHelpResultMessageParser);
        }
    }

