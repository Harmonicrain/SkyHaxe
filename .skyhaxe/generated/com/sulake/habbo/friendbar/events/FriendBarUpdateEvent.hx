package com.sulake.habbo.friendbar.events
;
    import flash.events.Event;

     class FriendBarUpdateEvent extends Event 
    {
        public static inline final FBE_UPDATED= "FBE_UPDATED";

        public function new()
        {
            super(FBE_UPDATED, false, false);
        }
    }

