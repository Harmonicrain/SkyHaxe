package com.sulake.habbo.ui.widget.events
;
    import flash.display.BitmapData;

     class RoomWidgetChatUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWCUE_EVENT_CHAT= "RWCUE_EVENT_CHAT";
        public static inline final CHAT_TYPE_SPEAK= 0;
        public static inline final CHAT_TYPE_WHISPER= 1;
        public static inline final CHAT_TYPE_SHOUT= 2;
        public static inline final CHAT_TYPE_RESPECT= 3;
        public static inline final CHAT_TYPE_PETRESPECT= 4;
        public static inline final CHAT_TYPE_NOTIFY= 5;
        public static inline final CHAT_TYPE_PETTREAT= 6;
        public static inline final CHAT_TYPE_PETREVIVE= 7;
        public static inline final CHAT_TYPE_PET_REBREED_FERTILIZE= 8;
        public static inline final CHAT_TYPE_PET_SPEED_FERTILIZE= 9;
        public static inline final CHAT_TYPE_BOT_SPEAK= 10;
        public static inline final CHAT_TYPE_BOT_SHOUT= 11;
        public static inline final CHAT_TYPE_BOT_WHISPER= 12;

        var _userId:Int = 0;
        var _text:String = "";
        var _chatType:Int = 0;
        var _userName:String;
        var _links:Array<ASAny>;
        var _Str_19459:Float = Math.NaN;
        var _Str_22119:Float = Math.NaN;
        var _Str_20012:BitmapData;
        var _Str_22210:UInt = 0;
        var _roomId:Int = 0;
        var _Str_22055:Int = 0;
        var _userType:Int = 0;
        var _Str_6689:Int = 0;
        var _styleId:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:Int, _arg_6:Int, _arg_7:Int, _arg_8:Float, _arg_9:Float, _arg_10:BitmapData, _arg_11:UInt, _arg_12:Int, _arg_13:Int=0, _arg_14:Int=0, _arg_15:Array<ASAny>=null, _arg_16:Bool=false, _arg_17:Bool=false)
        {
            super(k, _arg_16, _arg_17);
            this._userId = _arg_2;
            this._text = _arg_3;
            this._chatType = _arg_13;
            this._userName = _arg_4;
            this._Str_22055 = _arg_5;
            this._userType = _arg_6;
            this._Str_6689 = _arg_7;
            this._links = _arg_15;
            this._Str_19459 = _arg_8;
            this._Str_22119 = _arg_9;
            this._Str_20012 = _arg_10;
            this._Str_22210 = _arg_11;
            this._roomId = _arg_12;
            this._styleId = _arg_14;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }

        public var chatType(get,never):Int;
public function  get_chatType():Int
        {
            return this._chatType;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public var _Str_23083(get,never):Int;
public function  get__Str_23083():Int
        {
            return this._Str_22055;
        }

        public var userType(get,never):Int;
public function  get_userType():Int
        {
            return this._userType;
        }

        public var _Str_4355(get,never):Int;
public function  get__Str_4355():Int
        {
            return this._Str_6689;
        }

        public var links(get,never):Array<ASAny>;
public function  get_links():Array<ASAny>
        {
            return this._links;
        }

        public var _Str_24184(get,never):Float;
public function  get__Str_24184():Float
        {
            return this._Str_19459;
        }

        public var _Str_26168(get,never):Float;
public function  get__Str_26168():Float
        {
            return this._Str_22119;
        }

        public var _Str_23069(get,never):BitmapData;
public function  get__Str_23069():BitmapData
        {
            return this._Str_20012;
        }

        public var _Str_24330(get,never):UInt;
public function  get__Str_24330():UInt
        {
            return this._Str_22210;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var styleId(get,never):Int;
public function  get_styleId():Int
        {
            return this._styleId;
        }
    }

