package com.sulake.habbo.communication.messages.parser.inventory.trading
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TradingCloseParser implements IMessageParser 
    {
        public static inline final ERROR_WHILE_COMMIT= 1;

        var _userId:Int = 0;
        var _reason:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._userId = k.readInteger();
            this._reason = k.readInteger();
            return true;
        }

        public var userID(get,never):Int;
function  get_userID():Int
        {
            return this._userId;
        }

        public var reason(get,never):Int;
function  get_reason():Int
        {
            return this._reason;
        }

	public function new() {}
    }

