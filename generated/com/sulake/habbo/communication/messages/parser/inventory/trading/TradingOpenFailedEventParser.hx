package com.sulake.habbo.communication.messages.parser.inventory.trading
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TradingOpenFailedEventParser implements IMessageParser 
    {
        public static inline final _Str_18150= 7;
        public static inline final _Str_18383= 8;

        var _reason:Int = 0;
        var _Str_10068:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._reason = k.readInteger();
            this._Str_10068 = k.readString();
            return true;
        }

        public var reason(get,never):Int;
function  get_reason():Int
        {
            return this._reason;
        }

        public var _Str_17035(get,never):String;
function  get__Str_17035():String
        {
            return this._Str_10068;
        }

	public function new() {}
    }

