package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionFriendRequestEvent extends RoomSessionEvent 
    {
        public static inline final RSFRE_FRIEND_REQUEST= "RSFRE_FRIEND_REQUEST";

        var _requestId:Int = 0;
        var _userId:Int = 0;
        var _userName:String;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(RSFRE_FRIEND_REQUEST, k, _arg_5, _arg_6);
            this._requestId = _arg_2;
            this._userId = _arg_3;
            this._userName = _arg_4;
        }

        public var requestId(get,never):Int;
public function  get_requestId():Int
        {
            return this._requestId;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }
    }

