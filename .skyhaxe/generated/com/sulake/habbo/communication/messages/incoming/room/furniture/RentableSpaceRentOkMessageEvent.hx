package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.RentableSpaceRentOkMessageParser;

     class RentableSpaceRentOkMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RentableSpaceRentOkMessageParser);
        }

        public function getParser():RentableSpaceRentOkMessageParser
        {
            return Std.downcast(parser , RentableSpaceRentOkMessageParser);
        }
    }

