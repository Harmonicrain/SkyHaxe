package com.sulake.habbo.communication.messages.incoming.marketplace
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.marketplace.MarketplaceBuyOfferResultParser;

     class MarketplaceBuyOfferResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MarketplaceBuyOfferResultParser);
        }

        public function getParser():MarketplaceBuyOfferResultParser
        {
            return Std.downcast(_parser , MarketplaceBuyOfferResultParser);
        }
    }

