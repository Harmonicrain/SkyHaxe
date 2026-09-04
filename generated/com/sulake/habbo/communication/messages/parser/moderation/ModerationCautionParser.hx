package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ModerationCautionParser implements IMessageParser
    {
        var _message:String;
        var _url:String;


        public var message(get,never):String;
function  get_message():String
        {
            return this._message;
        }

        public var url(get,never):String;
function  get_url():String
        {
            return this._url;
        }

        public function flush():Bool
        {
            this._message = "";
            this._url = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._message = k.readString();
            this._url = k.readString();
            return true;
        }

	public function new() {}
    }

