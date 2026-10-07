package com.sulake.habbo.quest.events
;
    import flash.events.Event;

     class UnseenAchievementsCountUpdateEvent extends Event 
    {
        public static inline final QE_UACUE= "qe_uacue";

        var _count:Int = 0;

        public function new(k:Int, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(QE_UACUE, _arg_2, _arg_3);
            this._count = k;
        }

        public var count(get,never):Int;
public function  get_count():Int
        {
            return this._count;
        }
    }

