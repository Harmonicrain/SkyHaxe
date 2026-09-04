package com.sulake.habbo.communication.messages.parser.gifts
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TryPhoneNumberResultParser implements IMessageParser 
    {
        var _resultCode:Int = 0;
        var _millisToAllowProcessReset:Int = 0;


        public var resultCode(get,never):Int;
function  get_resultCode():Int
        {
            return this._resultCode;
        }

        public var millisToAllowProcessReset(get,never):Int;
function  get_millisToAllowProcessReset():Int
        {
            return this._millisToAllowProcessReset;
        }

        public function flush():Bool
        {
            this._resultCode = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._resultCode = k.readInteger();
            this._millisToAllowProcessReset = k.readInteger();
            return true;
        }

	public function new() {}
    }

