package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectFloorHoleEvent extends RoomObjectEvent 
    {
        public static inline final ROFHO_ADD_HOLE= "ROFHO_ADD_HOLE";
        public static inline final ROFHO_REMOVE_HOLE= "ROFHO_REMOVE_HOLE";

        public function new(k:String, _arg_2:IRoomObject, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }
    }

