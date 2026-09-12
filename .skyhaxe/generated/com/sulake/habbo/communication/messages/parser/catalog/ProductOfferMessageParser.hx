package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageOfferData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ProductOfferMessageParser implements IMessageParser
    {
        var offerData:CatalogPageMessageOfferData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this.offerData = new CatalogPageMessageOfferData(k);
            return true;
        }

        public var _Str_17889(get,never):CatalogPageMessageOfferData;
public function  get__Str_17889():CatalogPageMessageOfferData
        {
            return this.offerData;
        }

	public function new() {}
    }

