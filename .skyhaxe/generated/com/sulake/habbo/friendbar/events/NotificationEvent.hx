package com.sulake.habbo.friendbar.events
;
    import flash.events.Event;
    import com.sulake.habbo.friendbar.data.IFriendNotification;

     class NotificationEvent extends Event 
    {
        public static inline final FBE_NOTIFICATION_EVENT= "FBE_NOTIFICATION_EVENT";

        public var _Str_9566:Int = 0;
        public var notification:IFriendNotification;

        public function new(k:Int, _arg_2:IFriendNotification)
        {
            super(FBE_NOTIFICATION_EVENT);
            this._Str_9566 = k;
            this.notification = _arg_2;
        }
    }

