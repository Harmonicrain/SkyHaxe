package com.sulake.habbo.communication.messages.parser.availability
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AvailabilityTimeMessageParser implements IMessageParser
    {
        var _isOpen:Bool = false;
        var _minutesUntilChange:Int = 0;


        public var isOpen(get,never):Bool;
function  get_isOpen():Bool
        {
            return this._isOpen;
        }

        public var _Str_26363(get,never):Int;
function  get__Str_26363():Int
        {
            return this._minutesUntilChange;
        }

        public function flush():Bool
        {
            this._isOpen = false;
            this._minutesUntilChange = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._isOpen = (k.readInteger() > 0);
            this._minutesUntilChange = k.readInteger();
            return true;
        }

	public function new() {}
    }

