package com.sulake.habbo.communication.messages.parser.marketplace
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MarketplaceCanMakeOfferResultParser implements IMessageParser
    {
        var _tokenCount:Int = 0;
        var _result:Int = 0;


        public var _Str_24601(get,never):Int;
public function  get__Str_24601():Int
        {
            return this._tokenCount;
        }

        public var resultCode(get,never):Int;
public function  get_resultCode():Int
        {
            return this._result;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._result = k.readInteger();
            this._tokenCount = k.readInteger();
            return true;
        }

	public function new() {}
    }

