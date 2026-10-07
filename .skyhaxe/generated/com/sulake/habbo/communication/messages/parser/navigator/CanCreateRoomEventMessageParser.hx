package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CanCreateRoomEventMessageParser implements IMessageParser
    {
        var _Str_20547:Bool = false;
        var _errorCode:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_20547 = k.readBoolean();
            this._errorCode = k.readInteger();
            return true;
        }

        public var _Str_13420(get,never):Bool;
public function  get__Str_13420():Bool
        {
            return this._Str_20547;
        }

        public var errorCode(get,never):Int;
public function  get_errorCode():Int
        {
            return this._errorCode;
        }

	public function new() {}
    }

