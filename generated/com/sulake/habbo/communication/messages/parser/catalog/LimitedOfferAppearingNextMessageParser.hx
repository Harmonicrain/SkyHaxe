package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class LimitedOfferAppearingNextMessageParser implements IMessageParser
    {
        var _Str_6800:Int = 0;
        var _pageId:Int = 0;
        var _offerId:Int = 0;
        var _productType:String;


        public function flush():Bool
        {
            this._Str_6800 = -1;
            this._pageId = -1;
            this._offerId = -1;
            this._productType = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_6800 = k.readInteger();
            this._pageId = k.readInteger();
            this._offerId = k.readInteger();
            this._productType = k.readString();
            return true;
        }

        public var _Str_23051(get,never):Int;
function  get__Str_23051():Int
        {
            return this._Str_6800;
        }

        public var pageId(get,never):Int;
function  get_pageId():Int
        {
            return this._pageId;
        }

        public var offerId(get,never):Int;
function  get_offerId():Int
        {
            return this._offerId;
        }

        public var productType(get,never):String;
function  get_productType():String
        {
            return this._productType;
        }

	public function new() {}
    }

