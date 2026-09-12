package com.sulake.habbo.messenger
;

     class ChatEntry 
    {
        public static inline final TYPE_OWN_CHAT= 1;
        public static inline final TYPE_OTHER_CHAT= 2;
        public static inline final TYPE_NOTIFICATION= 3;
        public static inline final TYPE_INFO= 4;
        public static inline final TYPE_INVITATION= 5;
        public static inline final CONTENT_TEXT= 0;
        public static inline final CONTENT_HABBICON= 1;

        var _type:Int = 0;
        var _senderId:Int = 0;
        var _message:String;
        var _secondsSinceSent:Int = 0;
        var _clientReceiveTime:Int = 0;
        var _extraData:String;
        var _contentType:Int = 0;
        var _habbiconId:Int = 0;
        var _messageId:String;
        var _confirmationId:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:String=null, _arg_6:Int=0, _arg_7:Int=0, _arg_8:String=null, _arg_9:Int=0)
        {
            this._type = k;
            this._senderId = _arg_2;
            this._message = _arg_3;
            this._secondsSinceSent = _arg_4;
            this._clientReceiveTime = flash.Lib.getTimer();
            this._extraData = _arg_5;
            this._contentType = _arg_6;
            this._habbiconId = _arg_7;
            this._messageId = _arg_8;
            this._confirmationId = _arg_9;
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var senderId(get,never):Int;
public function  get_senderId():Int
        {
            return this._senderId;
        }

        public var message(get,never):String;
public function  get_message():String
        {
            return this._message;
        }

        public var extraData(get,never):String;
public function  get_extraData():String
        {
            return this._extraData;
        }

        public var contentType(get,never):Int;
public function  get_contentType():Int
        {
            return this._contentType;
        }

        public var habbiconId(get,never):Int;
public function  get_habbiconId():Int
        {
            return this._habbiconId;
        }

        public var messageId(get,never):String;
public function  get_messageId():String
        {
            return this._messageId;
        }

        public var confirmationId(get,never):Int;
public function  get_confirmationId():Int
        {
            return this._confirmationId;
        }

        public var isTextMessage(get,never):Bool;
public function  get_isTextMessage():Bool
        {
            return this._contentType == CONTENT_TEXT;
        }

        public var _Str_17201(get,never):Int;
public function  get__Str_17201():Int
        {
            var k= Std.int((flash.Lib.getTimer() - this._clientReceiveTime) / 1000);
            return this._secondsSinceSent + k;
        }

        public function _Str_22172():Float
        {
            return Date.now().getTime() - (this._Str_17201 * 1000);
        }
    }

