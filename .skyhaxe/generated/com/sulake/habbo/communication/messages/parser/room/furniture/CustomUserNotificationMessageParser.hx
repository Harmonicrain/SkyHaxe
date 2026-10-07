package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CustomUserNotificationMessageParser implements IMessageParser
    {
        var _code:Int = 0;


        public var code(get,never):Int;
public function  get_code():Int
        {
            return this._code;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._code = k.readInteger();
            return true;
        }

	public function new() {}
    }

