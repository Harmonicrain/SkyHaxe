package com.sulake.habbo.communication.messages.parser.handshake
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IsFirstLoginOfDayParser implements IMessageParser 
    {
        var isFirstLoginOfDay:Bool = false;


        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this.isFirstLoginOfDay = k.readBoolean();
            return true;
        }

        public var _Str_18128(get,never):Bool;
function  get__Str_18128():Bool
        {
            return this.isFirstLoginOfDay;
        }

	public function new() {}
    }

