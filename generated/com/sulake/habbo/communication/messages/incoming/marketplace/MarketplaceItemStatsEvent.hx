package com.sulake.habbo.communication.messages.incoming.marketplace
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.marketplace.MarketplaceItemStatsParser;

     class MarketplaceItemStatsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MarketplaceItemStatsParser);
        }

        public function getParser():MarketplaceItemStatsParser
        {
            return Std.downcast(_parser , MarketplaceItemStatsParser);
        }
    }

