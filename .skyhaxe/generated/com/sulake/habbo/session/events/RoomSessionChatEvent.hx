package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionChatEvent extends RoomSessionEvent 
    {
        public static inline final RSCE_CHAT_EVENT= "RSCE_CHAT_EVENT";
        public static inline final RSCE_FLOOD_EVENT= "RSCE_FLOOD_EVENT";
        public static inline final CHAT_TYPE_SPEAK= 0;
        public static inline final CHAT_TYPE_WHISPER= 1;
        public static inline final CHAT_TYPE_SHOUT= 2;
        public static inline final CHAT_TYPE_RESPECT= 3;
        public static inline final CHAT_TYPE_PETRESPECT= 4;
        public static inline final CHAT_TYPE_HAND_ITEM_RECEIVED= 5;
        public static inline final CHAT_TYPE_PETTREAT= 6;
        public static inline final CHAT_TYPE_PETREVIVE= 7;
        public static inline final CHAT_TYPE_PET_REBREED_FERTILIZE= 8;
        public static inline final CHAT_TYPE_PET_SPEED_FERTILIZE= 9;
        public static inline final _Str_8909= 10;

        var _userId:Int = 0;
        var _text:String = "";
        var _chatType:Int = 0;
        var _links:Array<ASAny>;
        var _extraParam:Int = 0;
        var _style:Int = 0;

        public function new(k:String, _arg_2:IRoomSession, _arg_3:Int, _arg_4:String, _arg_5:Int=0, _arg_6:Int=0, _arg_7:Array<ASAny>=null, _arg_8:Int=-1)
        {
            super(k, _arg_2, false, false);
            this._userId = _arg_3;
            this._text = _arg_4;
            this._chatType = _arg_5;
            this._links = _arg_7;
            this._extraParam = _arg_8;
            this._style = _arg_6;
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

        public var links(get,never):Array<ASAny>;
public function  get_links():Array<ASAny>
        {
            return this._links;
        }

        public var extraParam(get,never):Int;
public function  get_extraParam():Int
        {
            return this._extraParam;
        }

        public var style(get,never):Int;
public function  get_style():Int
        {
            return this._style;
        }
    }

