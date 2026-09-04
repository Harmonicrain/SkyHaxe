package com.sulake.habbo.communication.messages.parser.game.directory
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2JoiningGameFailedMessageParser implements IMessageParser
    {
        public static inline final _Str_20087= 1;
        public static inline final DUPLICATE_MACHINEID= 2;
        public static inline final _Str_20332= 3;
        public static inline final _Str_20127= 4;
        public static inline final _Str_20854= 5;
        public static inline final _Str_19299= 6;
        public static inline final _Str_20717= 7;
        public static inline final _Str_20576= 8;

        var _reason:Int = 0;


        public var reason(get,never):Int;
function  get_reason():Int
        {
            return this._reason;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._reason = k.readInteger();
            return true;
        }

	public function new() {}
    }

