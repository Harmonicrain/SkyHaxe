package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FriendNotificationMessageParser implements IMessageParser
    {
        var _typeCode:Int = -1;
        var _avatarId:String;
        var _message:String;


        public var typeCode(get,never):Int;
function  get_typeCode():Int
        {
            return this._typeCode;
        }

        public var avatarId(get,never):String;
function  get_avatarId():String
        {
            return this._avatarId;
        }

        public var message(get,never):String;
function  get_message():String
        {
            return this._message;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._avatarId = k.readString();
            this._typeCode = k.readInteger();
            this._message = k.readString();
            return true;
        }

	public function new() {}
    }

