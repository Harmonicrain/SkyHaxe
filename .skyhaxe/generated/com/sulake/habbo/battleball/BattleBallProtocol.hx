package com.sulake.habbo.battleball
;
    /**
     * Incoming headers, as the controller's dispatch switch reads them.
     *
     * Outgoing headers are not listed here: composers are registered by id in HabboMessages.as, which
     * is the client's one canonical packet table. A second copy of those numbers could only ever drift
     * out of step with it.
     */
     final class BattleBallProtocol
    {
        /** Status packet layout the parser expects; the server sends the same value. */
        public static inline final STATUS_VERSION= 2;

        public static inline final LOUNGE_INFO= 7600;
        public static inline final INSTANCE_LIST= 7601;
        public static inline final GAME_INSTANCE= 7602;
        public static inline final INSTANCE_NOT_AVAILABLE= 7603;
        public static inline final CREATE_FAILED= 7605;
        public static inline final GAME_DELETED= 7606;
        public static inline final JOIN_PARAMETERS= 7607;
        public static inline final JOIN_FAILED= 7608;
        public static inline final WATCH_FAILED= 7609;
        public static inline final GAME_LOCATION= 7610;
        public static inline final START_FAILED= 7611;
        public static inline final FULL_STATUS= 7612;
        public static inline final STATUS= 7613;
        public static inline final PLAYER_REMOVED= 7614;
        public static inline final GAME_START= 7615;
        public static inline final GAME_END= 7616;
        public static inline final SPECTATOR_COUNT= 7617;
        public static inline final IDLE_WARNING= 7619;
        public static inline final SKILL_LEVEL_CHANGED= 7620;

	public function new() {}
    }

