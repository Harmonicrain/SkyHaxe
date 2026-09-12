package com.sulake.habbo.friendbar.data
;
     class FriendNotification implements IFriendNotification 
    {
        public static inline final TYPE_MESSENGER= -1;
        public static inline final TYPE_ROOM_EVENT= 0;
        public static inline final TYPE_ACHIEVEMENT= 1;
        public static inline final TYPE_QUEST= 2;
        public static inline final TYPE_PLAYING_GAME= 3;
        public static inline final TYPE_FINISHED_GAME= 4;
        public static inline final TYPE_GAME_INVITE= 5;

        var _typeCode:Int = -1;
        var _message:String;
        var _viewOnce:Bool = false;

        public function new(k:Int, _arg_2:String, _arg_3:Bool)
        {
            this._typeCode = k;
            this._message = _arg_2;
            this._viewOnce = _arg_3;
        }

        public static function typeCodeToString(k:Int):String
        {
            switch (k)
            {
                case TYPE_MESSENGER:
                    return "instant_message";
                case TYPE_ROOM_EVENT:
                    return "room_event";
                case TYPE_ACHIEVEMENT:
                    return "achievement";
                case TYPE_QUEST:
                    return "quest";
                case TYPE_PLAYING_GAME:
                    return "playing_game";
                case TYPE_FINISHED_GAME:
                    return "finished_game";
                case TYPE_GAME_INVITE:
                    return "game_invite";
            }
            return "unknown";
        }


        
        public var typeCode(get,set):Int;
public function  get_typeCode():Int
        {
            return this._typeCode;
        }
public function  set_typeCode(k:Int):Int        {
            return this._typeCode = k;
        }

        
        public var message(get,set):String;
public function  get_message():String
        {
            return this._message;
        }
public function  set_message(k:String):String        {
            return this._message = k;
        }

        
        public var viewOnce(get,set):Bool;
public function  get_viewOnce():Bool
        {
            return this._viewOnce;
        }
public function  set_viewOnce(k:Bool):Bool        {
            return this._viewOnce = k;
        }
    }

