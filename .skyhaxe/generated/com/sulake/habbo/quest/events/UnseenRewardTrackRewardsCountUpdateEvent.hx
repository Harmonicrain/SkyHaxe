package com.sulake.habbo.quest.events
;
    import flash.events.Event;

     class UnseenRewardTrackRewardsCountUpdateEvent extends Event
    {
        public static inline final UNSEEN_REWARD_TRACK_REWARDS_COUNT_UPDATE= "qe_urtrcue";

        var _count:Int = 0;

        public function new(count:Int)
        {
            super(UNSEEN_REWARD_TRACK_REWARDS_COUNT_UPDATE);
            this._count = count;
        }

        public var count(get,never):Int;
public function  get_count():Int
        {
            return this._count;
        }
    }

