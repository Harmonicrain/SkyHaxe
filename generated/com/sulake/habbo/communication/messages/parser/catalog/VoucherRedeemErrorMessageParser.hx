package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class VoucherRedeemErrorMessageParser implements IMessageParser
    {
        var _errorCode:String = "";


        public function flush():Bool
        {
            this._errorCode = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._errorCode = k.readString();
            return true;
        }

        public var errorCode(get,never):String;
function  get_errorCode():String
        {
            return this._errorCode;
        }

	public function new() {}
    }

