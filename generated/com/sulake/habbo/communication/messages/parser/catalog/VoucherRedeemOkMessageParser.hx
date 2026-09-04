package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class VoucherRedeemOkMessageParser implements IMessageParser
    {
        var _productName:String = "";
        var _productDescription:String = "";


        public function flush():Bool
        {
            this._productDescription = "";
            this._productName = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._productDescription = k.readString();
            this._productName = k.readString();
            return true;
        }

        public var productName(get,never):String;
function  get_productName():String
        {
            return this._productName;
        }

        public var productDescription(get,never):String;
function  get_productDescription():String
        {
            return this._productDescription;
        }

	public function new() {}
    }

