package com.sulake.habbo.inventory.events
;
    import flash.events.Event;

     class HabboInventoryHabboClubEvent extends Event 
    {
        public static inline final HIHCE_HABBO_CLUB_CHANGED= "HIHCE_HABBO_CLUB_CHANGED";

        public function new(k:Bool=false, _arg_2:Bool=false)
        {
            super(HIHCE_HABBO_CLUB_CHANGED, k, _arg_2);
        }
    }

