package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FollowFriendFailedMessageParser implements IMessageParser
    {
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
public function  get_errorCode():Int
        {
            return this._errorCode;
        }

	public function new() {}
    }

