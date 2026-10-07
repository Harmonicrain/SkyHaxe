package com.sulake.habbo.communication.messages.incoming.marketplace
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.marketplace.MarketplaceCancelOfferResultParser;

     class MarketplaceCancelOfferResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MarketplaceCancelOfferResultParser);
        }

        public function getParser():MarketplaceCancelOfferResultParser
        {
            return Std.downcast(_parser , MarketplaceCancelOfferResultParser);
        }
    }

