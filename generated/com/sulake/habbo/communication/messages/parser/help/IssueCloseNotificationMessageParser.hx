package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IssueCloseNotificationMessageParser implements IMessageParser
    {
        var _Str_19723:Int = 0;
        var _messageText:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_19723 = k.readInteger();
            this._messageText = k.readString();
            return true;
        }

        public var _Str_25784(get,never):Int;
function  get__Str_25784():Int
        {
            return this._Str_19723;
        }

        public var messageText(get,never):String;
function  get_messageText():String
        {
            return this._messageText;
        }

	public function new() {}
    }

