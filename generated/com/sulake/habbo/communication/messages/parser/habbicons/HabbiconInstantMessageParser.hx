package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class HabbiconInstantMessageParser implements IMessageParser
    {
        var _chatId:Int = 0;
        var _content:HabbiconMessengerContent;
        var _secondsSinceSent:Int = 0;
        var _messageId:String;
        var _confirmationId:Int = 0;
        var _senderId:Int = 0;
        var _senderName:String;
        var _senderFigure:String;

        public function flush():Bool
        {
            this._chatId = 0;
            this._content = null;
            this._secondsSinceSent = 0;
            this._messageId = "";
            this._confirmationId = 0;
            this._senderId = 0;
            this._senderName = "";
            this._senderFigure = "";
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
            this._chatId = wrapper.readInteger();
            this._content = new HabbiconMessengerContent(wrapper);
            this._secondsSinceSent = wrapper.readInteger();
            this._messageId = wrapper.readString();
            this._confirmationId = wrapper.readInteger();
            this._senderId = wrapper.readInteger();
            this._senderName = wrapper.readString();
            this._senderFigure = wrapper.readString();
            return true;
        }

        public var chatId(get,never):Int;
function  get_chatId():Int
        {
            return this._chatId;
        }

        public var content(get,never):HabbiconMessengerContent;
function  get_content():HabbiconMessengerContent
        {
            return this._content;
        }

        public var secondsSinceSent(get,never):Int;
function  get_secondsSinceSent():Int
        {
            return this._secondsSinceSent;
        }

        public var messageId(get,never):String;
function  get_messageId():String
        {
            return this._messageId;
        }

        public var confirmationId(get,never):Int;
function  get_confirmationId():Int
        {
            return this._confirmationId;
        }

        public var senderId(get,never):Int;
function  get_senderId():Int
        {
            return this._senderId;
        }

        public var senderName(get,never):String;
function  get_senderName():String
        {
            return this._senderName;
        }

        public var senderFigure(get,never):String;
function  get_senderFigure():String
        {
            return this._senderFigure;
        }

	public function new() {}
    }

