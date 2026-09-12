package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageProductData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ClubGiftSelectedParser implements IMessageParser
    {
        var _productCode:String;
        var _products:Array<ASAny>;


        public function flush():Bool
        {
            this._products = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._products = new Array<ASAny>();
            this._productCode = k.readString();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._products.push(new CatalogPageMessageProductData(k));
                _local_3++;
            }
            return true;
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }

        public var products(get,never):Array<ASAny>;
public function  get_products():Array<ASAny>
        {
            return this._products;
        }

	public function new() {}
    }

