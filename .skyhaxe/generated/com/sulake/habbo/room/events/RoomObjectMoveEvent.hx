package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectMoveEvent extends RoomObjectEvent 
    {
        public static inline final ROME_SLIDE_ANIMATION= "ROME_SLIDE_ANIMATION";
        public static inline final ROME_POSITION_CHANGED= "ROME_POSITION_CHANGED";
        public static inline final ROME_OBJECT_REMOVED= "ROME_OBJECT_REMOVED";

        public function new(k:String, _arg_2:IRoomObject, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }
    }

