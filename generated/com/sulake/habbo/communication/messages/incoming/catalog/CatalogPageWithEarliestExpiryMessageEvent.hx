package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.CatalogPageWithEarliestExpiryMessageParser;

     class CatalogPageWithEarliestExpiryMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CatalogPageWithEarliestExpiryMessageParser);
        }

        public function getParser():CatalogPageWithEarliestExpiryMessageParser
        {
            return Std.downcast(this._parser , CatalogPageWithEarliestExpiryMessageParser);
        }
    }

