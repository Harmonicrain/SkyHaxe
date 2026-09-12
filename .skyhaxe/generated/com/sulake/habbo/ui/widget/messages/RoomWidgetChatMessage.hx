package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetChatMessage extends RoomWidgetMessage 
    {
        public static inline final RWCM_MESSAGE_CHAT= "RWCM_MESSAGE_CHAT";
        public static inline final CHAT_TYPE_SPEAK= 0;
        public static inline final CHAT_TYPE_WHISPER= 1;
        public static inline final CHAT_TYPE_SHOUT= 2;

        var _chatType:Int = 0;
        var _text:String = "";
        var _recipientName:String = "";
        var _styleId:Int = 0;

        public function new(k:String, _arg_2:String, _arg_3:Int=0, _arg_4:String="", _arg_5:Int=0)
        {
            super(k);
            this._text = _arg_2;
            this._chatType = _arg_3;
            this._recipientName = _arg_4;
            this._styleId = _arg_5;
        }

        public var chatType(get,never):Int;
public function  get_chatType():Int
        {
            return this._chatType;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }

        public var _Str_23716(get,never):String;
public function  get__Str_23716():String
        {
            return this._recipientName;
        }

        public var styleId(get,never):Int;
public function  get_styleId():Int
        {
            return this._styleId;
        }
    }

