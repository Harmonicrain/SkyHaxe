package com.sulake.core.runtime.events
;
    import flash.events.Event;

     class HotelViewReadyEvent extends Event 
    {
        public static inline final HOTEL_VIEW_READY= "HOTEL_VIEW_READY";

        public function new(type:String, bubbles:Bool=false, cancelable:Bool=false)
        {
            super(type, bubbles, cancelable);
        }
    }

