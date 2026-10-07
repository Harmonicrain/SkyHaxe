package com.sulake.habbo.friendbar.events
;
    import flash.events.Event;

     class FriendBarSelectionEvent extends Event 
    {
        public static inline final FBVE_FRIEND_SELECTED= "FBVE_FRIEND_SELECTED";

        var _friendId:Int = 0;
        var _friendName:String;

        public function new(k:Int, _arg_2:String)
        {
            super(FBVE_FRIEND_SELECTED);
            this._friendId = k;
            this._friendName = _arg_2;
        }

        public var _Str_9566(get,never):Int;
public function  get__Str_9566():Int
        {
            return this._friendId;
        }

        public var _Str_24718(get,never):String;
public function  get__Str_24718():String
        {
            return this._friendName;
        }
    }

