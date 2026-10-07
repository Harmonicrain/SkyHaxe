package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.OpenConnectionMessageParser;

     class OpenConnectionMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, OpenConnectionMessageParser);
        }

        public function getParser():OpenConnectionMessageParser
        {
            return Std.downcast(_parser , OpenConnectionMessageParser);
        }
    }

