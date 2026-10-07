package com.sulake.habbo.toolbar.events
;
    import flash.events.Event;

     class ExtensionViewEvent extends Event 
    {
        public static inline final EVE_EXTENSION_VIEW_RESIZED= "EVE_EXTENSION_VIEW_RESIZED";

        public function new(type:String, bubbles:Bool=false, cancelable:Bool=false)
        {
            super(type, bubbles, cancelable);
        }
    }

