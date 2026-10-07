package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ChatReviewSessionStartedMessageParser implements IMessageParser
    {
        var _Str_18898:Int = 0;
        var _Str_8977:String;


        public function flush():Bool
        {
            this._Str_18898 = -1;
            this._Str_8977 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_18898 = k.readInteger();
            this._Str_8977 = k.readString();
            return true;
        }

        public var _Str_23086(get,never):Int;
public function  get__Str_23086():Int
        {
            return this._Str_18898;
        }

        public var _Str_17106(get,never):String;
public function  get__Str_17106():String
        {
            return this._Str_8977;
        }

	public function new() {}
    }

