package com.sulake.habbo.room.events
;
     class RoomEngineDragWidgetMouseEvent extends RoomEngineEvent 
    {
        public static inline final DRAG_START= "REDWME_DRAG_START";
        public static inline final DRAG_END= "REDWME_DRAG_END";

        public function new(k:String, _arg_2:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }
    }

