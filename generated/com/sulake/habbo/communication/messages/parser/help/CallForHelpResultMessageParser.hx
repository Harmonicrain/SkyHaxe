package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CallForHelpResultMessageParser implements IMessageParser
    {
        var _resultType:Int = 0;
        var _messageText:String;


        public var resultType(get,never):Int;
function  get_resultType():Int
        {
            return this._resultType;
        }

        public var messageText(get,never):String;
function  get_messageText():String
        {
            return this._messageText;
        }

        public function flush():Bool
        {
            this._resultType = -1;
            this._messageText = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._resultType = k.readInteger();
            this._messageText = k.readString();
            return true;
        }

	public function new() {}
    }

