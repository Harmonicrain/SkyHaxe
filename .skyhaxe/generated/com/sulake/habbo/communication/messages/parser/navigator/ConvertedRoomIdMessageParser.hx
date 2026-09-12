package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ConvertedRoomIdMessageParser implements IMessageParser
    {
        var _Str_18318:String;
        var _Str_21920:Int = 0;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_18318 = k.readString();
            this._Str_21920 = k.readInteger();
            return true;
        }

        public function flush():Bool
        {
            this._Str_18318 = null;
            return true;
        }

        public var _Str_17914(get,never):String;
public function  get__Str_17914():String
        {
            return this._Str_18318;
        }

        public var _Str_12434(get,never):Int;
public function  get__Str_12434():Int
        {
            return this._Str_21920;
        }

	public function new() {}
    }

