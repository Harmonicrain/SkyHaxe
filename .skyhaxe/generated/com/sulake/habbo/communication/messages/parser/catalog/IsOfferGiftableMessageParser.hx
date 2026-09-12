package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IsOfferGiftableMessageParser implements IMessageParser
    {
        var _offerId:Int = 0;
        var _Str_21271:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._offerId = k.readInteger();
            this._Str_21271 = k.readBoolean();
            return true;
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return this._offerId;
        }

        public var _Str_18028(get,never):Bool;
public function  get__Str_18028():Bool
        {
            return this._Str_21271;
        }

	public function new() {}
    }

