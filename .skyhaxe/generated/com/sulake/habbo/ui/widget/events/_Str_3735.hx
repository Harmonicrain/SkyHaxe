package com.sulake.habbo.ui.widget.events
;
     class _Str_3735 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWONE_TYPE= "RWONE_TYPE";

        var _userId:Int = 0;
        var _category:Int = 0;
        var _userName:String;
        var _userType:Int = 0;
        var _roomIndex:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int)
        {
            this._userId = k;
            this._category = _arg_2;
            this._userName = _arg_3;
            this._userType = _arg_4;
            this._roomIndex = _arg_5;
            super(RWONE_TYPE, false, false);
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
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
    }

