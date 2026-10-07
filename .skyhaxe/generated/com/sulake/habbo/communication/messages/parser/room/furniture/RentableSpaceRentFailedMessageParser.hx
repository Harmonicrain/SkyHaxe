package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RentableSpaceRentFailedMessageParser implements IMessageParser
    {
        var _reason:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._reason = k.readInteger();
            return true;
        }

        public var reason(get,never):Int;
public function  get_reason():Int
        {
            return this._reason;
        }

	public function new() {}
    }

