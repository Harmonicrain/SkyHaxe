package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RentableSpaceRentOkMessageParser implements IMessageParser
    {
        var _expiryTime:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._expiryTime = k.readInteger();
            return true;
        }

        public var expiryTime(get,never):Int;
public function  get_expiryTime():Int
        {
            return this._expiryTime;
        }

	public function new() {}
    }

