package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class InstantMessageErrorMessageParser implements IMessageParser
    {
        var _errorCode:Int = 0;
        var _userId:Int = 0;
        var _message:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._errorCode = k.readInteger();
            this._userId = k.readInteger();
            this._message = k.readString();
            return true;
        }

        public var errorCode(get,never):Int;
public function  get_errorCode():Int
        {
            return this._errorCode;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var message(get,never):String;
public function  get_message():String
        {
            return this._message;
        }

	public function new() {}
    }

