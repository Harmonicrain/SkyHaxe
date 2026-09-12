package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RespectNotificationMessageParser implements IMessageParser
    {
        var _userId:Int = 0;
        var _respectTotal:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._userId = k.readInteger();
            this._respectTotal = k.readInteger();
            return true;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var respectTotal(get,never):Int;
public function  get_respectTotal():Int
        {
            return this._respectTotal;
        }

	public function new() {}
    }

