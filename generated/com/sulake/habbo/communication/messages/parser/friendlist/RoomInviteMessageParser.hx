package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomInviteMessageParser implements IMessageParser
    {
        var _senderId:Int = 0;
        var _messageText:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._senderId = k.readInteger();
            this._messageText = k.readString();
            return true;
        }

        public var senderId(get,never):Int;
function  get_senderId():Int
        {
            return this._senderId;
        }

        public var messageText(get,never):String;
function  get_messageText():String
        {
            return this._messageText;
        }

	public function new() {}
    }

