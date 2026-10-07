package com.sulake.habbo.communication.messages.parser.marketplace
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MarketplaceBuyOfferResultParser implements IMessageParser
    {
        var _result:Int = 0;
        var _Str_21768:Int = -1;
        var _Str_20780:Int = -1;
        var _Str_8508:Int = -1;


        public var result(get,never):Int;
public function  get_result():Int
        {
            return this._result;
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return this._Str_21768;
        }

        public var _Str_24839(get,never):Int;
public function  get__Str_24839():Int
        {
            return this._Str_20780;
        }

        public var requestedOfferId(get,never):Int;
public function  get_requestedOfferId():Int
        {
            return this._Str_8508;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._result = k.readInteger();
            this._Str_21768 = k.readInteger();
            this._Str_20780 = k.readInteger();
            this._Str_8508 = k.readInteger();
            return true;
        }

	public function new() {}
    }

