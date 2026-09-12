package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabbiconMessengerHistoryEntry
    {
        var _senderId:Int = 0;
        var _senderName:String;
        var _senderFigure:String;
        var _content:HabbiconMessengerContent;
        var _secondsSinceSent:Int = 0;
        var _messageId:String;

        public function new(wrapper:IMessageDataWrapper)
        {
            this._senderId = wrapper.readInteger();
            this._senderName = wrapper.readString();
            this._senderFigure = wrapper.readString();
            this._content = new HabbiconMessengerContent(wrapper);
            this._secondsSinceSent = wrapper.readInteger();
            this._messageId = wrapper.readString();
        }

        public var senderId(get,never):Int;
public function  get_senderId():Int
        {
            return this._senderId;
        }

        public var senderName(get,never):String;
public function  get_senderName():String
        {
            return this._senderName;
        }

        public var senderFigure(get,never):String;
public function  get_senderFigure():String
        {
            return this._senderFigure;
        }

        public var content(get,never):HabbiconMessengerContent;
public function  get_content():HabbiconMessengerContent
        {
            return this._content;
        }

        public var secondsSinceSent(get,never):Int;
public function  get_secondsSinceSent():Int
        {
            return this._secondsSinceSent;
        }

        public var messageId(get,never):String;
public function  get_messageId():String
        {
            return this._messageId;
        }
    }

