package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideSessionErrorMessageParser implements IMessageParser 
    {
        public static inline final ERROR_GENERIC= 0;
        public static inline final ERROR_GUIDES_REJECT= 1;
        public static inline final ERROR_NOT_ENOUGH_GUIDES= 2;
        public static inline final ERROR_NOT_ENOUGH_VOTES= 3;
        public static inline final ERROR_NO_CHATLOG_FOUND= 4;

        var _errorCode:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._errorCode = k.readInteger();
            return true;
        }

        public var errorCode(get,never):Int;
function  get_errorCode():Int
        {
            return this._errorCode;
        }

	public function new() {}
    }

