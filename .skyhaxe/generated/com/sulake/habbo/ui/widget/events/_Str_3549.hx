package com.sulake.habbo.ui.widget.events
;
     class _Str_3549 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWFRUE_SHOW_FRIEND_REQUEST= "RWFRUE_SHOW_FRIEND_REQUEST";
        public static inline final RWFRUE_HIDE_FRIEND_REQUEST= "RWFRUE_HIDE_FRIEND_REQUEST";

        var _requestId:Int = 0;
        var _userId:Int = 0;
        var _userName:String;

        public function new(k:String, _arg_2:Int, _arg_3:Int=0, _arg_4:String=null, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_5, _arg_6);
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

