package com.sulake.habbo.communication.messages.parser.inventory.purse
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CreditBalanceParser implements IMessageParser
    {
        var _balance:Int = 0;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._balance = ASCompat.toInt(k.readString());
            return true;
        }

        public function flush():Bool
        {
            return true;
        }

        public var balance(get,never):Int;
public function  get_balance():Int
        {
            return this._balance;
        }

	public function new() {}
    }

