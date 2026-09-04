package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.ScrSendKickbackInfoMessageParser;

     class ScrSendKickbackInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ScrSendKickbackInfoMessageParser);
        }

        public function getParser():ScrSendKickbackInfoMessageParser
        {
            return Std.downcast(_parser , ScrSendKickbackInfoMessageParser);
        }
    }

