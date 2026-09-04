package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ApproveNameMessageParser implements IMessageParser
    {
        var _result:Int = 0;
        var _nameValidationInfo:String;


        public var result(get,never):Int;
function  get_result():Int
        {
            return this._result;
        }

        public var nameValidationInfo(get,never):String;
function  get_nameValidationInfo():String
        {
            return this._nameValidationInfo;
        }

        public function flush():Bool
        {
            this._result = -1;
            this._nameValidationInfo = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._result = k.readInteger();
            this._nameValidationInfo = k.readString();
            return true;
        }

	public function new() {}
    }

