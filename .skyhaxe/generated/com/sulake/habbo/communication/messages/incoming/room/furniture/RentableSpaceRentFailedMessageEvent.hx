package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.RentableSpaceRentFailedMessageParser;

     class RentableSpaceRentFailedMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RentableSpaceRentFailedMessageParser);
        }

        public function getParser():RentableSpaceRentFailedMessageParser
        {
            return Std.downcast(parser , RentableSpaceRentFailedMessageParser);
        }
    }

