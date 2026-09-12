package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CanCreateRoomMessageParser implements IMessageParser
    {
        public static inline final _Str_21199= 0;
        public static inline final _Str_21069= 1;

        var _resultCode:Int = 0;
        var _Str_21340:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._resultCode = k.readInteger();
            this._Str_21340 = k.readInteger();
            return true;
        }

        public var resultCode(get,never):Int;
public function  get_resultCode():Int
        {
            return this._resultCode;
        }

        public var _Str_20396(get,never):Int;
public function  get__Str_20396():Int
        {
            return this._Str_21340;
        }

	public function new() {}
    }

