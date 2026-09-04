package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboBroadcastMessageParser implements IMessageParser
    {
        var _messageText:String = "";


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._messageText = k.readString();
            return true;
        }

        public var messageText(get,never):String;
function  get_messageText():String
        {
            return this._messageText;
        }

	public function new() {}
    }

