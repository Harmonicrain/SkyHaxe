package com.sulake.habbo.gamecenter
;
    import flash.events.Event;

     class GameCenterEvent extends Event 
    {
        public static inline final GAME_CONFIGURATIONS_INITIALIZED= "GAME_CONFIGURATIONS_INITIALIZED";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

