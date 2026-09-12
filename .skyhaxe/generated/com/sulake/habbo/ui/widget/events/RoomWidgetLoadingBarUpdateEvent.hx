package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetLoadingBarUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWLBUE_SHOW_LOADING_BAR= "RWLBUE_SHOW_LOADING_BAR";
        public static inline final RWLBUW_HIDE_LOADING_BAR= "RWLBUW_HIDE_LOADING_BAR";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

