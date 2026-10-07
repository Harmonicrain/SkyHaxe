package com.sulake.habbo.communication.messages.parser.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FriendFurniStartConfirmationMessageParser implements IMessageParser 
    {
        var _stuffId:Int = 0;
        var _isOwner:Bool = false;


        public var stuffId(get,never):Int;
public function  get_stuffId():Int
        {
            return this._stuffId;
        }

        public var isOwner(get,never):Bool;
public function  get_isOwner():Bool
        {
            return this._isOwner;
        }

        public function flush():Bool
        {
            this._stuffId = -1;
            this._isOwner = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._stuffId = k.readInteger();
            this._isOwner = k.readBoolean();
            return true;
        }

	public function new() {}
    }

