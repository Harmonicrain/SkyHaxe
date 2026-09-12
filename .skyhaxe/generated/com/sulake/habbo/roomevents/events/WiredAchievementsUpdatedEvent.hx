package com.sulake.habbo.roomevents.events
;
    import flash.events.Event;

     class WiredAchievementsUpdatedEvent extends Event
    {
        public static inline final WIRED_ACHIEVEMENTS_UPDATED= "WIRED_ACHIEVEMENTS_UPDATED";

        var _achievements:Vector<String>;

        public function new(type:String, achievements:Vector<String>,
                                                       bubbles:Bool = false, cancelable:Bool = false)
        {
            super(type, bubbles, cancelable);
            this._achievements = achievements != null
                ? achievements.concat()
                : new Vector<String>();
        }

        public var achievements(get,never):Vector<String>;
public function  get_achievements():Vector<String>
        {
            return this._achievements.concat();
        }

        override public function clone():Event
        {
            return new WiredAchievementsUpdatedEvent(
                type, this._achievements, bubbles, cancelable);
        }
    }

