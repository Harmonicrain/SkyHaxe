package com.sulake.habbo.friendbar.events
;
    import flash.events.Event;

     class ActiveConversationsCountEvent extends Event 
    {
        public static inline final AMC_EVENT= "AMC_EVENT";

        var _activeConversationsCount:Int = 0;

        public function new(k:Int=-1)
        {
            this._activeConversationsCount = k;
            super(AMC_EVENT);
        }

        public var _Str_18689(get,never):Int;
public function  get__Str_18689():Int
        {
            return this._activeConversationsCount;
        }
    }

