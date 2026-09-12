package com.sulake.habbo.ui.widget.events
;
    import flash.events.Event;

     class RoomWidgetUpdateEvent extends Event 
    {
        public static inline final EVENT_TEST= "RWUE_EVENT_TEST";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

