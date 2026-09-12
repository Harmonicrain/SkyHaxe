package com.sulake.habbo.communication.messages.parser.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FriendFurniOtherLockConfirmedMessageParser implements IMessageParser
    {
        var _stuffId:Int = 0;


        public var stuffId(get,never):Int;
public function  get_stuffId():Int
        {
            return this._stuffId;
        }

        public function flush():Bool
        {
            this._stuffId = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._stuffId = k.readInteger();
            return true;
        }

	public function new() {}
    }

