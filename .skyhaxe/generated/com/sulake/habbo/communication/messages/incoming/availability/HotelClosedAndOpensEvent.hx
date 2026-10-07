package com.sulake.habbo.communication.messages.incoming.availability
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.availability.HotelClosedAndOpensMessageParser;

     class HotelClosedAndOpensEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, HotelClosedAndOpensMessageParser);
        }

        public function getParser():HotelClosedAndOpensMessageParser
        {
            return Std.downcast(_parser , HotelClosedAndOpensMessageParser);
        }
    }

