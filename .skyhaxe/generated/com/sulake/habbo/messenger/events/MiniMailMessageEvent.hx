package com.sulake.habbo.messenger.events
;
    import flash.events.Event;

     class MiniMailMessageEvent extends Event 
    {
        public static inline final MMME_NEW= "MMME_new";
        public static inline final MMME_UNREAD= "MMME_unread";

        var _unreadCount:Int = 0;

        public function new(k:String, _arg_2:Int=-1)
        {
            super(k);
            this._unreadCount = _arg_2;
        }

        public var unreadCount(get,never):Int;
public function  get_unreadCount():Int
        {
            return this._unreadCount;
        }
    }

