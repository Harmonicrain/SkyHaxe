package com.sulake.habbo.communication.messages.incoming.callforhelp
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.callforhelp.SanctionStatusMessageParser;

     class SanctionStatusEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, SanctionStatusMessageParser);
        }

        public function getParser():SanctionStatusMessageParser
        {
            return Std.downcast(_parser , SanctionStatusMessageParser);
        }
    }

