package com.sulake.habbo.communication.messages.parser.competition
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SecondsUntilMessageParser implements IMessageParser
    {
        var _Str_8997:String;
        var _Str_21095:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_8997 = k.readString();
            this._Str_21095 = k.readInteger();
            return true;
        }

        public var _Str_23288(get,never):String;
public function  get__Str_23288():String
        {
            return this._Str_8997;
        }

        public var _Str_25497(get,never):Int;
public function  get__Str_25497():Int
        {
            return this._Str_21095;
        }

	public function new() {}
    }

