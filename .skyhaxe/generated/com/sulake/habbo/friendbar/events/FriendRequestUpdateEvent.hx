package com.sulake.habbo.friendbar.events
;
    import flash.events.Event;

     class FriendRequestUpdateEvent extends Event 
    {
        public static inline final FBE_REQUESTS= "FBE_REQUESTS";

        public function new()
        {
            super(FBE_REQUESTS, false, false);
        }
    }

