package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MessengerErrorMessageParser implements IMessageParser
    {
        var _Str_19500:Int = 0;
        var _errorCode:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_19500 = k.readInteger();
            this._errorCode = k.readInteger();
            return true;
        }

        public var _Str_23408(get,never):Int;
public function  get__Str_23408():Int
        {
            return this._Str_19500;
        }

        public var errorCode(get,never):Int;
public function  get_errorCode():Int
        {
            return this._errorCode;
        }

	public function new() {}
    }

