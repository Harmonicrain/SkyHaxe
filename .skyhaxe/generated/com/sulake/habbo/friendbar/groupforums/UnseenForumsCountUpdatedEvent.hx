package com.sulake.habbo.friendbar.groupforums
;
    import flash.events.Event;

     class UnseenForumsCountUpdatedEvent extends Event 
    {
        public static inline final UNSEEN_FORUMS_COUNT= "UNSEEN_FORUMS_COUNT";

        var _unseenForumsCount:Int = 0;

        public function new(k:String, _arg_2:Int)
        {
            super(k);
            this._unseenForumsCount = _arg_2;
        }

        public var _Str_9691(get,never):Int;
public function  get__Str_9691():Int
        {
            return this._unseenForumsCount;
        }
    }

