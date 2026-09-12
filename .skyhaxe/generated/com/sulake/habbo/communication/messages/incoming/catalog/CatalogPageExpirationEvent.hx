package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.CatalogPageExpirationParser;

     class CatalogPageExpirationEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CatalogPageExpirationParser);
        }

        public function getParser():CatalogPageExpirationParser
        {
            return Std.downcast(this._parser , CatalogPageExpirationParser);
        }
    }

