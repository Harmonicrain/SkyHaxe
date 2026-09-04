package com.sulake.habbo.communication.messages.parser.gifts
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TryVerificationCodeResultParser implements IMessageParser 
    {
        var _resultCode:Int = 0;
        var _millisecondsToAllowProcessReset:Int = 0;


        public var resultCode(get,never):Int;
function  get_resultCode():Int
        {
            return this._resultCode;
        }

        public var millisecondsToAllowProcessReset(get,never):Int;
function  get_millisecondsToAllowProcessReset():Int
        {
            return this._millisecondsToAllowProcessReset;
        }

        public function flush():Bool
        {
            this._resultCode = -1;
            this._millisecondsToAllowProcessReset = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._resultCode = k.readInteger();
            this._millisecondsToAllowProcessReset = k.readInteger();
            return true;
        }

	public function new() {}
    }

