package com.sulake.habbo.communication.messages.parser.marketplace
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MarketplaceMakeOfferResultParser implements IMessageParser
    {
        var _result:Int = 0;


        public var result(get,never):Int;
public function  get_result():Int
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
            return true;
        }

	public function new() {}
    }

