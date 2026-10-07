package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UnreadForumsCountMessageParser implements IMessageParser
    {
        var _Str_7869:Int = 0;


        public var _Str_9052(get,never):Int;
public function  get__Str_9052():Int
        {
            return this._Str_7869;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_7869 = k.readInteger();
            return true;
        }

	public function new() {}
    }

