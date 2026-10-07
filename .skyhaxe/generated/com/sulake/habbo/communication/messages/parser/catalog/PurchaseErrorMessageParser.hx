package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PurchaseErrorMessageParser implements IMessageParser
    {
        var _errorCode:Int = 0;


        public var errorCode(get,never):Int;
public function  get_errorCode():Int
        {
            return this._errorCode;
        }

        public function flush():Bool
        {
            this._errorCode = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._errorCode = k.readInteger();
            return true;
        }

	public function new() {}
    }

