package com.sulake.habbo.friendbar.events
;
    import flash.events.Event;

     class FriendBarResizeEvent extends Event 
    {
        public static inline final FBE_BAR_RESIZE_EVENT= "FBE_BAR_RESIZE_EVENT";

        public function new()
        {
            super(FBE_BAR_RESIZE_EVENT);
        }
    }

