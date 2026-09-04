package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.RentableSpaceStatusMessageParser;

     class RentableSpaceStatusMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RentableSpaceStatusMessageParser);
        }

        public function getParser():RentableSpaceStatusMessageParser
        {
            return Std.downcast(parser , RentableSpaceStatusMessageParser);
        }
    }

