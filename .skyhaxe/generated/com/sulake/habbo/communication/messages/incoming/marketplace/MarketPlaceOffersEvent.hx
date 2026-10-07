package com.sulake.habbo.communication.messages.incoming.marketplace
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.marketplace.MarketPlaceOffersParser;

     class MarketPlaceOffersEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MarketPlaceOffersParser);
        }

        public function getParser():MarketPlaceOffersParser
        {
            return Std.downcast(_parser , MarketPlaceOffersParser);
        }
    }

