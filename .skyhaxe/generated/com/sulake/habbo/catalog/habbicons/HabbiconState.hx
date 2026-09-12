package com.sulake.habbo.catalog.habbicons
;
     class HabbiconState
    {
        public static inline final NONE= 0;
        public static inline final CLAIMABLE= 1;
        public static inline final OWNED= 2;
        public static inline final FAVOURITE= 3;
        public static inline final LOCKED= 4;
        public static inline final REWARD_MARKER= 5;

        public static function isOwnedState(state:Int):Bool
        {
            return state == CLAIMABLE || state == OWNED || state == FAVOURITE;
        }

        public static function isUsableState(state:Int):Bool
        {
            return state == OWNED || state == FAVOURITE;
        }

	public function new() {}
    }

