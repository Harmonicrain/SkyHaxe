package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FlatCreatedMessageParser implements IMessageParser
    {
        var _flatId:Int = 0;
        var _Str_17603:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._flatId = k.readInteger();
            this._Str_17603 = k.readString();
            Logger.log([((("FLAT CREATED: " + Std.string(this._flatId)) + ", ") + this._Str_17603)]);
            return true;
        }

        public var flatId(get,never):Int;
public function  get_flatId():Int
        {
            return this._flatId;
        }

        public var _Str_18439(get,never):String;
public function  get__Str_18439():String
        {
            return this._Str_17603;
        }

	public function new() {}
    }

