package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetDoorbellEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWDE_RINGING= "RWDE_RINGING";
        public static inline final REJECTED= "RWDE_REJECTED";
        public static inline final RWDE_ACCEPTED= "RWDE_ACCEPTED";

        var _userName:String = "";

        public function new(k:String, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._userName = _arg_2;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }
    }

