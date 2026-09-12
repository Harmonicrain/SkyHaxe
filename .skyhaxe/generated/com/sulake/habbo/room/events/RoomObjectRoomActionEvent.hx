package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectRoomActionEvent extends RoomObjectEvent
    {
        public static inline final RORAE_LEAVE_ROOM= "RORAE_LEAVE_ROOM";
        public static inline final RORAE_CHANGE_ROOM= "RORAE_CHANGE_ROOM";
        public static inline final RORAE_TRY_BUS= "RORAE_TRY_BUS";

        public function new(k:String, _arg_2:IRoomObject, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }
    }

