package com.sulake.habbo.communication.messages.parser.availability
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HotelClosesAndWillOpenAtMessageParser implements IMessageParser 
    {
        var _openHour:Int = 0;
        var _openMinute:Int = 0;
        var _userThrownOutAtClose:Bool = false;


        public var openHour(get,never):Int;
function  get_openHour():Int
        {
            return this._openHour;
        }

        public var openMinute(get,never):Int;
function  get_openMinute():Int
        {
            return this._openMinute;
        }

        public var userThrownOutAtClose(get,never):Bool;
function  get_userThrownOutAtClose():Bool
        {
            return this._userThrownOutAtClose;
        }

        public function flush():Bool
        {
            this._openHour = 0;
            this._openMinute = 0;
            this._userThrownOutAtClose = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._openHour = k.readInteger();
            this._openMinute = k.readInteger();
            this._userThrownOutAtClose = k.readBoolean();
            return true;
        }

	public function new() {}
    }

