package com.sulake.habbo.session.events
;
    import flash.events.Event;

     class PerksUpdatedEvent extends Event 
    {
        public static inline final PERKS_UPDATED= "PUE_perks_updated";

        public function new()
        {
            super(PERKS_UPDATED);
        }
    }

