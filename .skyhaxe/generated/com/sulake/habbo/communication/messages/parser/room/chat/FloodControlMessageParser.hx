package com.sulake.habbo.communication.messages.parser.room.chat
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FloodControlMessageParser implements IMessageParser 
    {
        var _seconds:Int = 0;


        public var seconds(get,never):Int;
public function  get_seconds():Int
        {
            return this._seconds;
        }

        public function flush():Bool
        {
            this._seconds = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._seconds = k.readInteger();
            return true;
        }

	public function new() {}
    }

