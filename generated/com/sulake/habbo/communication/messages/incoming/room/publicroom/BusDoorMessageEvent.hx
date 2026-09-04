package com.sulake.habbo.communication.messages.incoming.room.publicroom
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.publicroom.BusDoorMessageParser;

     class BusDoorMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BusDoorMessageParser);
        }

        public function getParser():BusDoorMessageParser
        {
            return Std.downcast(_parser , BusDoorMessageParser);
        }
    }

