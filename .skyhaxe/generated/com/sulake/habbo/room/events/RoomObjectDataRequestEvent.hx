package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectDataRequestEvent extends RoomObjectEvent 
    {
        public static inline final RODRE_CURRENT_USER_ID= "RODRE_CURRENT_USER_ID";
        public static inline final RODRE_URL_PREFIX= "RODRE_URL_PREFIX";

        public function new(k:String, _arg_2:IRoomObject, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }
    }

