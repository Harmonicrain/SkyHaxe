package com.sulake.habbo.sound.events
;
    import flash.events.Event;

     class PlayListStatusEvent extends Event 
    {
        public static inline final PLUE_PLAY_LIST_UPDATED= "PLUE_PLAY_LIST_UPDATED";
        public static inline final PLUE_PLAY_LIST_FULL= "PLUE_PLAY_LIST_FULL";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

