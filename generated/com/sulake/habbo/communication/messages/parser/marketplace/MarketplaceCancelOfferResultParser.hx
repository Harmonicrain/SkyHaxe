package com.sulake.habbo.communication.messages.parser.marketplace
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MarketplaceCancelOfferResultParser implements IMessageParser
    {
        var _offerId:Int = 0;
        var _success:Bool = false;


        public var success(get,never):Bool;
function  get_success():Bool
        {
            return this._success;
        }

        public var offerId(get,never):Int;
function  get_offerId():Int
        {
            return this._offerId;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._offerId = k.readInteger();
            this._success = k.readBoolean();
            return true;
        }

	public function new() {}
    }

