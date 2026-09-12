package com.sulake.habbo.freeflowchat.data
;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;

     class ChatItem 
    {
        var _timestamp:Int = 0;
        var _userId:Int = 0;
        var _roomId:Int = 0;
        var _text:String = "";
        var _chatType:Int = 0;
        var _links:Array<ASAny>;
        var _style:Int = 0;
        var _userLocation:IVector3d;
        var _forcedColor:ASAny;
        var _forcedScreenLocation:ASAny;
        var _forcedFigure:String;
        var _forcedUserName:String;
        var _extraParam:Int = 0;

        public function new(k:RoomSessionChatEvent, _arg_2:Int, _arg_3:IVector3d=null, _arg_4:Int=0, _arg_5:ASAny=null, _arg_6:ASAny=null, _arg_7:String=null, _arg_8:String=null)
        {
            this._chatType = RoomSessionChatEvent.CHAT_TYPE_SPEAK;
            this._timestamp = _arg_2;
            this._userLocation = _arg_3;
            this._userId = k.userId;
            if (k.session != null)
            {
                this._roomId = k.session.roomId;
            }
            else
            {
                this._roomId = 1;
            }
            this._text = k.text;
            this._chatType = k.chatType;
            this._style = k.style;
            this._links = [k.links];
            this._forcedColor = _arg_6;
            this._forcedScreenLocation = _arg_5;
            this._forcedFigure = _arg_7;
            this._forcedUserName = _arg_8;
            this._extraParam = _arg_4;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        
        public var text(get,set):String;
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

        public var style(get,never):Int;
public function  get_style():Int
        {
            return this._style;
        }

        public var timeStamp(get,never):UInt;
public function  get_timeStamp():UInt
        {
            return this._timestamp;
        }

        public var _Str_20712(get,never):IVector3d;
public function  get__Str_20712():IVector3d
        {
            return this._userLocation;
        }

        public var _Str_15133(get,never):ASAny;
public function  get__Str_15133():ASAny
        {
            return this._forcedColor;
        }

        public var _Str_12917(get,never):ASAny;
public function  get__Str_12917():ASAny
        {
            return this._forcedScreenLocation;
        }

        public var _Str_15251(get,never):String;
public function  get__Str_15251():String
        {
            return this._forcedFigure;
        }

        public var _Str_14270(get,never):String;
public function  get__Str_14270():String
        {
            return this._forcedUserName;
        }

        public var extraParam(get,never):Int;
public function  get_extraParam():Int
        {
            return this._extraParam;
        }
public function  set_text(k:String):String        {
            return this._text = k;
        }
    }

