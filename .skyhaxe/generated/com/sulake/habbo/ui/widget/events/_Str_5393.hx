package com.sulake.habbo.ui.widget.events
;
     class _Str_5393 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWAIE_AVATAR_INFO= "RWAIE_AVATAR_INFO";

        var _userId:Int = 0;
        var _userName:String;
        var _userType:Int = 0;
        var _allowNameChange:Bool = false;
        var _roomIndex:Int = 0;

        public function new(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Bool, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(RWAIE_AVATAR_INFO, _arg_6, _arg_7);
            this._userId = k;
            this._userName = _arg_2;
            this._userType = _arg_3;
            this._roomIndex = _arg_4;
            this._allowNameChange = _arg_5;
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

        public var userType(get,never):Int;
public function  get_userType():Int
        {
            return this._userType;
        }

        public var roomIndex(get,never):Int;
public function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        public var allowNameChange(get,never):Bool;
public function  get_allowNameChange():Bool
        {
            return this._allowNameChange;
        }
    }

