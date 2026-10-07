package com.sulake.habbo.room.events
;
     class RoomEngineRoomAdEvent extends RoomEngineObjectEvent 
    {
        public static inline final FURNI_CLICK= "RERAE_FURNI_CLICK";
        public static inline final FURNI_DOUBLE_CLICK= "RERAE_FURNI_DOUBLE_CLICK";
        public static inline final TOOLTIP_SHOW= "RERAE_TOOLTIP_SHOW";
        public static inline final TOOLTIP_HIDE= "RERAE_TOOLTIP_HIDE";

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }
    }

