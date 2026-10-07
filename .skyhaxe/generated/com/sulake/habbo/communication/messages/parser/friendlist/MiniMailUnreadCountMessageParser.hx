package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MiniMailUnreadCountMessageParser implements IMessageParser
    {
        var _Str_20485:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_20485 = k.readInteger();
            return true;
        }

        public var _Str_22745(get,never):Int;
public function  get__Str_22745():Int
        {
            return this._Str_20485;
        }

	public function new() {}
    }

