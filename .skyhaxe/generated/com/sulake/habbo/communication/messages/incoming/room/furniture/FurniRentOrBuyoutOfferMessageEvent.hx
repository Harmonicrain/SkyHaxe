package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.FurniRentOrBuyoutOfferMessageParser;

     class FurniRentOrBuyoutOfferMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FurniRentOrBuyoutOfferMessageParser);
        }

        public function getParser():FurniRentOrBuyoutOfferMessageParser
        {
            return Std.downcast(_parser , FurniRentOrBuyoutOfferMessageParser);
        }
    }

