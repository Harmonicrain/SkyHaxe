package com.sulake.habbo.communication.messages.incoming.marketplace
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.marketplace.MarketPlaceOwnOffersParser;

     class MarketPlaceOwnOffersEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MarketPlaceOwnOffersParser);
        }

        public function getParser():MarketPlaceOwnOffersParser
        {
            return Std.downcast(_parser , MarketPlaceOwnOffersParser);
        }
    }

