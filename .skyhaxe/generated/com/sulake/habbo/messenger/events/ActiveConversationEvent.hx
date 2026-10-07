package com.sulake.habbo.messenger.events
;
    import flash.events.Event;

     class ActiveConversationEvent extends Event 
    {
        public static inline final ACCE_CHANGED= "ACCE_changed";

        var _activeConversationsCount:Int = 0;

        public function new(k:String, _arg_2:Int=-1)
        {
            super(k);
            this._activeConversationsCount = _arg_2;
        }

        public var _Str_18689(get,never):Int;
public function  get__Str_18689():Int
        {
            return this._activeConversationsCount;
        }
    }

