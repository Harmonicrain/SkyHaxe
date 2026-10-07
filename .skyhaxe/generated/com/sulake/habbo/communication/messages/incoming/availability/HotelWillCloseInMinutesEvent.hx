package com.sulake.habbo.communication.messages.incoming.availability
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.availability.HotelWillCloseInMinutesMessageParser;

     class HotelWillCloseInMinutesEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, HotelWillCloseInMinutesMessageParser);
        }

        public function getParser():HotelWillCloseInMinutesMessageParser
        {
            return Std.downcast(_parser , HotelWillCloseInMinutesMessageParser);
        }
    }

