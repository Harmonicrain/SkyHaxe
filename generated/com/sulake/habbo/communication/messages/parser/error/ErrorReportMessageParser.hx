package com.sulake.habbo.communication.messages.parser.error
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ErrorReportMessageParser implements IMessageParser 
    {
        var _errorCode:Int = 0;
        var _messageId:Int = 0;
        var _timestamp:String;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._messageId = k.readInteger();
            this._errorCode = k.readInteger();
            this._timestamp = k.readString();
            return true;
        }

        public function flush():Bool
        {
            this._errorCode = 0;
            this._messageId = 0;
            this._timestamp = null;
            return true;
        }

        public var errorCode(get,never):Int;
function  get_errorCode():Int
        {
            return this._errorCode;
        }

        public var messageId(get,never):Int;
function  get_messageId():Int
        {
            return this._messageId;
        }

        public var timestamp(get,never):String;
function  get_timestamp():String
        {
            return this._timestamp;
        }

	public function new() {}
    }

