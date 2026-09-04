package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CallForHelpReplyMessageParser implements IMessageParser
    {
        var _message:String;


        public var message(get,never):String;
function  get_message():String
        {
            return this._message;
        }

        public function flush():Bool
        {
            this._message = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._message = k.readString();
            return true;
        }

	public function new() {}
    }

