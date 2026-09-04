package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class DiceValueMessageParser implements IMessageParser
    {
        var _id:Int = 0;
        var _value:Int = 0;


        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var value(get,never):Int;
function  get_value():Int
        {
            return this._value;
        }

        public function flush():Bool
        {
            this._id = -1;
            this._value = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._id = k.readInteger();
            this._value = k.readInteger();
            return true;
        }

	public function new() {}
    }

