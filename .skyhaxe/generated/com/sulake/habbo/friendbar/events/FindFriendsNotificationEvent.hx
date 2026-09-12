package com.sulake.habbo.friendbar.events
;
    import flash.events.Event;

     class FindFriendsNotificationEvent extends Event 
    {
        public static inline final FIND_FRIENDS_RESULT= "FIND_FRIENDS_RESULT";

        var _success:Bool = false;

        public function new(k:Bool)
        {
            this._success = k;
            super(FIND_FRIENDS_RESULT);
        }

        public var success(get,never):Bool;
public function  get_success():Bool
        {
            return this._success;
        }
    }

