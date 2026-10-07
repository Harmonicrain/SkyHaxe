package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.CatalogPageMessageParser;

     class CatalogPageMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CatalogPageMessageParser);
        }

        public function getParser():CatalogPageMessageParser
        {
            return Std.downcast(this._parser , CatalogPageMessageParser);
        }
    }

