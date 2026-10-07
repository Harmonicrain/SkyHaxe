package com.sulake.habbo.communication.messages.incoming.marketplace
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.marketplace.MarketplaceMakeOfferResultParser;

     class MarketplaceMakeOfferResult extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MarketplaceMakeOfferResultParser);
        }

        public function getParser():MarketplaceMakeOfferResultParser
        {
            return Std.downcast(_parser , MarketplaceMakeOfferResultParser);
        }
    }

