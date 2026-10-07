package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ConcurrentUsersGoalProgressParser implements IMessageParser 
    {
        var _state:Int = 0;
        var _userCount:Int = 0;
        var _Str_5422:Int = 0;


        public function flush():Bool
        {
            this._state = -1;
            this._userCount = -1;
            this._Str_5422 = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._state = k.readInteger();
            this._userCount = k.readInteger();
            this._Str_5422 = k.readInteger();
            return true;
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

        public var userCount(get,never):Int;
public function  get_userCount():Int
        {
            return this._userCount;
        }

        public var _Str_21827(get,never):Int;
public function  get__Str_21827():Int
        {
            return this._Str_5422;
        }

	public function new() {}
    }

