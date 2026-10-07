package com.sulake.habbo.communication.messages.incoming.availability
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.availability.HotelClosesAndWillOpenAtMessageParser;

     class HotelClosesAndWillOpenAtEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, HotelClosesAndWillOpenAtMessageParser);
        }

        public function getParser():HotelClosesAndWillOpenAtMessageParser
        {
            return Std.downcast(_parser , HotelClosesAndWillOpenAtMessageParser);
        }
    }

