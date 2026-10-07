package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetOpenProfileMessage extends RoomWidgetMessage 
    {
        public static inline final RWOPEM_OPEN_USER_PROFILE= "RWOPEM_OPEN_USER_PROFILE";

        var _userId:Int = 0;
        var _trackingLocation:String;

        public function new(k:String, _arg_2:Int, _arg_3:String)
        {
            super(k);
            this._userId = _arg_2;
            this._trackingLocation = _arg_3;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var trackingLocation(get,never):String;
public function  get_trackingLocation():String
        {
            return this._trackingLocation;
        }
    }

