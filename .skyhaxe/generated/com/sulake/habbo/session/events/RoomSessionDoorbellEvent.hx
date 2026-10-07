package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionDoorbellEvent extends RoomSessionEvent 
    {
        public static inline final RSDE_DOORBELL= "RSDE_DOORBELL";
        public static inline final REJECTED= "RSDE_REJECTED";
        public static inline final RSDE_ACCEPTED= "RSDE_ACCEPTED";

        var _userName:String = "";

        public function new(k:String, _arg_2:IRoomSession, _arg_3:String, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_2, _arg_4, _arg_5);
            this._userName = _arg_3;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }
    }

