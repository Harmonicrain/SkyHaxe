package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPropertyUpdateEvent extends RoomSessionEvent 
    {
        public static inline final RSDUE_ALLOW_PETS= "RSDUE_ALLOW_PETS";

        public function new(k:String, _arg_2:IRoomSession, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }
    }

