package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideSessionMessageMessageParser implements IMessageParser
    {
        var _Str_21558:String;
        var _senderId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_21558 = k.readString();
            this._senderId = k.readInteger();
            return true;
        }

        public var _Str_24208(get,never):String;
public function  get__Str_24208():String
        {
            return this._Str_21558;
        }

        public var senderId(get,never):Int;
public function  get_senderId():Int
        {
            return this._senderId;
        }

	public function new() {}
    }

