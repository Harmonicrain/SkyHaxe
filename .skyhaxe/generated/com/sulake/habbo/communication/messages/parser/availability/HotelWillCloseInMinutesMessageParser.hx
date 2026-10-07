package com.sulake.habbo.communication.messages.parser.availability
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HotelWillCloseInMinutesMessageParser implements IMessageParser 
    {
        var _minutes:Int = 0;


        public var minutes(get,never):Int;
public function  get_minutes():Int
        {
            return this._minutes;
        }

        public function flush():Bool
        {
            this._minutes = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._minutes = k.readInteger();
            return true;
        }

	public function new() {}
    }

