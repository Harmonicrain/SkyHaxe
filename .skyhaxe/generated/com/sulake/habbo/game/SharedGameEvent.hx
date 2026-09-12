package com.sulake.habbo.game
;
    import flash.events.Event;

     class SharedGameEvent extends Event 
    {
        public static inline final API_VERSION= 1;
        public static inline final EVENT_TYPE_TO_HABBO= "HabboGameAPIEventToHabbo";
        public static inline final EVENT_TYPE_TO_GAME= "HabboGameAPIEventToGame";

        public var api:Int = 0;
        public var name:String;
        public var content:ASAny;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:ASAny=null)
        {
            super(k);
            this.api = _arg_2;
            this.name = _arg_3;
            this.content = _arg_4;
        }

        public static function createToHabbo(k:String, _arg_2:ASAny=null):SharedGameEvent
        {
            return new SharedGameEvent(EVENT_TYPE_TO_HABBO, API_VERSION, k, _arg_2);
        }

        public static function createToGame(k:String, _arg_2:ASAny=null):SharedGameEvent
        {
            return new SharedGameEvent(EVENT_TYPE_TO_GAME, API_VERSION, k, _arg_2);
        }
    }

