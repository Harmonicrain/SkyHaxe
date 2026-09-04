package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HandItemReceivedMessageParser implements IMessageParser
    {
        var _giverUserId:Int = -1;
        var _handItemType:Int = 0;


        public var giverUserId(get,never):Int;
function  get_giverUserId():Int
        {
            return this._giverUserId;
        }

        public var handItemType(get,never):Int;
function  get_handItemType():Int
        {
            return this._handItemType;
        }

        public function flush():Bool
        {
            this._giverUserId = -1;
            this._handItemType = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._giverUserId = k.readInteger();
            this._handItemType = k.readInteger();
            return true;
        }

	public function new() {}
    }

