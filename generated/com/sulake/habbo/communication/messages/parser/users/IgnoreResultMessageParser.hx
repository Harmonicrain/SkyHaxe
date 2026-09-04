package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IgnoreResultMessageParser implements IMessageParser
    {
        var _result:Int = 0;
        var _name:String;

        public function new()
        {
            this._result = -1;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._result = k.readInteger();
            this._name = k.readString();
            return true;
        }

        public var result(get,never):Int;
function  get_result():Int
        {
            return this._result;
        }

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }
    }

