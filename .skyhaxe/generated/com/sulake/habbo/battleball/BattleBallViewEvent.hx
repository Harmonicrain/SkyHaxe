package com.sulake.habbo.battleball
;
    import flash.events.Event;

     final class BattleBallViewEvent extends Event
    {
        /** Ask the server for a fresh instance list. Rate limited server-side -- use sparingly. */
        public static inline final REFRESH= "BATTLEBALL_REFRESH";
        /** Re-render the current view from data already held. No packet. */
        public static inline final REDRAW= "BATTLEBALL_REDRAW";
        /** Open the shared Games Hall leaderboard filtered to BattleBall. */
        public static inline final HIGH_SCORES= "BATTLEBALL_HIGH_SCORES";
        /** Open the localized BattleBall rules alert. */
        public static inline final GAME_RULES= "BATTLEBALL_GAME_RULES";
        public static inline final CREATE= "BATTLEBALL_CREATE";
        public static inline final JOIN= "BATTLEBALL_JOIN";
        public static inline final JOIN_TEAM= "BATTLEBALL_JOIN_TEAM";
        public static inline final WATCH= "BATTLEBALL_WATCH";
        public static inline final START= "BATTLEBALL_START";
        public static inline final KICK= "BATTLEBALL_KICK";
        public static inline final ADD_BOT= "BATTLEBALL_ADD_BOT";
        public static inline final LEAVE= "BATTLEBALL_LEAVE";
        public static inline final CLOSE= "BATTLEBALL_CLOSE";
        public static inline final DELETE_GAME= "BATTLEBALL_DELETE";
        public static inline final REJOIN= "BATTLEBALL_REJOIN";
        public static inline final MOVE= "BATTLEBALL_MOVE";
        public static inline final ACTIVATE= "BATTLEBALL_ACTIVATE";
        public static inline final BUY_TICKETS= "BATTLEBALL_BUY_TICKETS";

        public var data:ASObject;
        public function new(type:String, data:ASObject=null) { super(type); this.data = data; }
    }

