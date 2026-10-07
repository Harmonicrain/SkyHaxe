package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.CantConnectMessageParser;

     class CantConnectMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CantConnectMessageParser);
        }

        public function getParser():CantConnectMessageParser
        {
            return Std.downcast(_parser , CantConnectMessageParser);
        }
    }

