package com.sulake.habbo.communication.messages.parser.inventory.trading
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TradingOpenParser implements IMessageParser 
    {
        var _Str_8107:Int = 0;
        var _Str_16372:Bool = false;
        var _Str_17246:Int = 0;
        var _Str_8945:Bool = false;


        public var userID(get,never):Int;
public function  get_userID():Int
        {
            return this._Str_8107;
        }

        public var _Str_16764(get,never):Bool;
public function  get__Str_16764():Bool
        {
            return this._Str_16372;
        }

        public var _Str_17613(get,never):Int;
public function  get__Str_17613():Int
        {
            return this._Str_17246;
        }

        public var _Str_13374(get,never):Bool;
public function  get__Str_13374():Bool
        {
            return this._Str_8945;
        }

        public function flush():Bool
        {
            this._Str_8107 = -1;
            this._Str_16372 = false;
            this._Str_17246 = -1;
            this._Str_8945 = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_8107 = k.readInteger();
            this._Str_16372 = (k.readInteger() == 1);
            this._Str_17246 = k.readInteger();
            this._Str_8945 = (k.readInteger() == 1);
            return true;
        }

	public function new() {}
    }

