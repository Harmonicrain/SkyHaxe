package com.sulake.habbo.roomevents.events
;
    import flash.events.Event;

     class WiredUserClickHandledEvent extends Event
    {
        public static inline final WIRED_USER_CLICK_HANDLED= "WIRED_USER_CLICK_HANDLED";

        var _index:Int = 0;
        var _openMenu:Bool = false;

        public function new(type:String, index:Int, openMenu:Bool, bubbles:Bool = false, cancelable:Bool = false)
        {
            super(type, bubbles, cancelable);
            this._index = index;
            this._openMenu = openMenu;
        }

        public var index(get,never):Int;
public function  get_index():Int
        {
            return this._index;
        }

        public var openMenu(get,never):Bool;
public function  get_openMenu():Bool
        {
            return this._openMenu;
        }
    }

