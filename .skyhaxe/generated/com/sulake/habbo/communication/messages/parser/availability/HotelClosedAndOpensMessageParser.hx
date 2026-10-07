package com.sulake.habbo.communication.messages.parser.availability
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HotelClosedAndOpensMessageParser implements IMessageParser 
    {
        var _openHour:Int = 0;
        var _openMinute:Int = 0;


        public var openHour(get,never):Int;
public function  get_openHour():Int
        {
            return this._openHour;
        }

        public var openMinute(get,never):Int;
public function  get_openMinute():Int
        {
            return this._openMinute;
        }

        public function flush():Bool
        {
            this._openHour = 0;
            this._openMinute = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._openHour = k.readInteger();
            this._openMinute = k.readInteger();
            return true;
        }

	public function new() {}
    }

