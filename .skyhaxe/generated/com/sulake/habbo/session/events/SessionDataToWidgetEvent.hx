package com.sulake.habbo.session.events
;
    import flash.events.Event;

     class SessionDataToWidgetEvent extends Event
    {
        public static inline final PURCHASABLE_STYLES_UPDATED= "SDTWE_PURCHASABLE_STYLES_UPDATED";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

