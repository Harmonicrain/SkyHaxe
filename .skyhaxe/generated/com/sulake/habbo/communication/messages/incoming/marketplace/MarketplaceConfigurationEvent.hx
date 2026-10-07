package com.sulake.habbo.communication.messages.incoming.marketplace
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.marketplace.MarketplaceConfigurationMessageParser;

     class MarketplaceConfigurationEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, MarketplaceConfigurationMessageParser);
        }

        public function getParser():MarketplaceConfigurationMessageParser
        {
            return Std.downcast(_parser , MarketplaceConfigurationMessageParser);
        }
    }

