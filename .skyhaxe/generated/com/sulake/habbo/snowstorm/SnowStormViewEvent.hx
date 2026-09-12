package com.sulake.habbo.snowstorm
;
    import flash.events.Event;

     final class SnowStormViewEvent extends Event
    {
        public static inline final REFRESH= "SNOWSTORM_REFRESH";
        public static inline final REDRAW= "SNOWSTORM_REDRAW";
        public static inline final HIGH_SCORES= "SNOWSTORM_HIGH_SCORES";
        public static inline final GAME_RULES= "SNOWSTORM_GAME_RULES";
        public static inline final SHOW_CREATE= "SNOWSTORM_SHOW_CREATE";
        public static inline final CREATE= "SNOWSTORM_CREATE";
        public static inline final SELECT= "SNOWSTORM_SELECT";
        public static inline final JOIN= "SNOWSTORM_JOIN";
        public static inline final JOIN_TEAM= "SNOWSTORM_JOIN_TEAM";
        public static inline final WATCH= "SNOWSTORM_WATCH";
        public static inline final START= "SNOWSTORM_START";
        public static inline final KICK= "SNOWSTORM_KICK";
        public static inline final ADD_BOT= "SNOWSTORM_ADD_BOT";
        public static inline final REMOVE_BOT= "SNOWSTORM_REMOVE_BOT";
        public static inline final LEAVE= "SNOWSTORM_LEAVE";
        public static inline final CLOSE= "SNOWSTORM_CLOSE";
        public static inline final DELETE_GAME= "SNOWSTORM_DELETE";
        public static inline final FINISHED_SCORES= "SNOWSTORM_FINISHED_SCORES";
        public static inline final REJOIN= "SNOWSTORM_REJOIN";
        public static inline final WALK= "SNOWSTORM_WALK";
        public static inline final THROW_PLAYER= "SNOWSTORM_THROW_PLAYER";
        public static inline final THROW_LOCATION= "SNOWSTORM_THROW_LOCATION";
        public static inline final MAKE_SNOWBALL= "SNOWSTORM_MAKE_SNOWBALL";
        public static inline final CANCEL_MAKE= "SNOWSTORM_CANCEL_MAKE";
        public static inline final BUY_TICKETS= "SNOWSTORM_BUY_TICKETS";

        public var data:ASObject;
        public function new(type:String, data:ASObject = null)
        { super(type); this.data = data; }
    }

