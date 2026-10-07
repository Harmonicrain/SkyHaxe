package com.sulake.habbo.communication.messages.parser.room.session
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GamePlayerValueMessageParser implements IMessageParser
    {
        var _userId:Int = 0;
        var _value:Int = 0;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var value(get,never):Int;
public function  get_value():Int
        {
            return this._value;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._userId = k.readInteger();
            this._value = k.readInteger();
            return true;
        }

	public function new() {}
    }

