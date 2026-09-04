package com.sulake.habbo.communication.messages.parser.inventory.trading
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TradingAcceptParser implements IMessageParser 
    {
        var _userID:Int = 0;
        var _userAccepts:Bool = false;


        public var userID(get,never):Int;
function  get_userID():Int
        {
            return this._userID;
        }

        public var _Str_15794(get,never):Bool;
function  get__Str_15794():Bool
        {
            return this._userAccepts;
        }

        public function flush():Bool
        {
            this._userID = -1;
            this._userAccepts = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._userID = k.readInteger();
            this._userAccepts = (k.readInteger() > 0);
            return true;
        }

	public function new() {}
    }

