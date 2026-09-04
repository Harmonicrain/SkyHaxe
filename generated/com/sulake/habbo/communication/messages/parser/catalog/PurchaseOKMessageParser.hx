package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseOKMessageOfferData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PurchaseOKMessageParser implements IMessageParser
    {
        var _offer:PurchaseOKMessageOfferData;


        public var offer(get,never):PurchaseOKMessageOfferData;
function  get_offer():PurchaseOKMessageOfferData
        {
            return this._offer;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._offer = new PurchaseOKMessageOfferData(k);
            return true;
        }

	public function new() {}
    }

