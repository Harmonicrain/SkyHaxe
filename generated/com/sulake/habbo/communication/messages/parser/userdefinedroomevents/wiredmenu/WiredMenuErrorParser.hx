package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

    /**
     * July's inspection error response is a signed short:
     * 0 = selected holder disappeared/was invalid, 1/2 = rejected operation.
     */
     final class WiredMenuErrorParser implements IMessageParser
    {
        var _errorCode:Int = 0;

        public function flush():Bool
        {
            this._errorCode = 0;
            return true;
        }

        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 2)
            {
                return false;
            }
            this._errorCode = data.readShort();
            return data.bytesAvailable == 0;
        }

        public var errorCode(get,never):Int;
function  get_errorCode():Int
        {
            return this._errorCode;
        }

	public function new() {}
    }

