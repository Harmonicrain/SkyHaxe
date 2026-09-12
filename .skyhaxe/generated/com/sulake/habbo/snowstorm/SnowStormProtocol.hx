package com.sulake.habbo.snowstorm
;
    /** Frozen original-Shockwave SnowStorm v1 transport and validation limits. */
     final class SnowStormProtocol
    {
        public static inline final VERSION= 4;
        public static inline final MAX_LIVE_INSTANCES= 100;
        public static inline final MAX_FINISHED_ROWS= 15;
        public static final MAX_INSTANCE_ROWS:Int = MAX_LIVE_INSTANCES + MAX_FINISHED_ROWS;
        public static inline final MAX_PLAYERS= 12;
        public static inline final MAX_TEAMS= 4;
        public static inline final MAX_SPECTATORS= 20;
        public static inline final MAX_OBJECTS= 337;
        public static inline final MAX_EVENTS_PER_SUBTURN= 128;
        public static inline final MAX_EVENTS_PER_TURN= 512;
        public static inline final SUBTURNS_PER_TURN= 5;
        public static inline final MAX_HEALTH= 4;
        public static inline final MAX_AMMO= 5;
        public static inline final INVINCIBLE_SUBTURNS= 60;

        public static inline final STATE_LOBBY= 0;
        public static inline final STATE_COUNTDOWN= 1;
        public static inline final STATE_RUNNING= 2;
        public static inline final STATE_ENDING= 3;

        public static inline final OBJECT_AVATAR= 0;
        public static inline final OBJECT_SNOWBALL= 1;
        public static inline final OBJECT_MACHINE= 2;

        public static inline final ACTIVITY_NORMAL= 0;
        public static inline final ACTIVITY_CREATING= 1;
        public static inline final ACTIVITY_STUNNED= 2;
        public static inline final ACTIVITY_INVINCIBLE= 3;

        /** Checksum-critical projectile constants mirrored from the authoritative server. */
        public static inline final TRAJECTORY_QUICK= 0;
        public static inline final TRAJECTORY_SHORT_LOB= 1;
        public static inline final TRAJECTORY_LONG_LOB= 2;
        public static inline final PROJECTILE_VELOCITY= 2000;
        public static inline final PROJECTILE_DIRECTION_SCALE= 255;
        public static inline final PROJECTILE_QUICK_DESCENT_POINT= 3;
        public static inline final PROJECTILE_QUICK_MULTIPLIER= 4;
        public static inline final PROJECTILE_SHORT_LOB_MULTIPLIER= 10;
        public static inline final PROJECTILE_LONG_LOB_MULTIPLIER= 100;
        public static inline final PROJECTILE_QUICK_HEIGHT= 4000;
        public static inline final PROJECTILE_LOB_HEIGHT= 3000;

        public static inline final EVENT_SPAWN_OBJECT= 0;
        public static inline final EVENT_REMOVE_OBJECT= 1;
        public static inline final EVENT_AVATAR_MOVE= 2;
        public static inline final EVENT_AVATAR_THROW= 3;
        public static inline final EVENT_LAUNCH_SNOWBALL= 4;
        public static inline final EVENT_HIT= 5;
        public static inline final EVENT_STUN= 6;
        public static inline final EVENT_ACTIVITY_STATE= 7;
        public static inline final EVENT_SNOWBALL_COUNT= 8;
        public static inline final EVENT_MACHINE_RESTOCK= 9;
        public static inline final EVENT_MACHINE_TRANSFER= 10;
        public static inline final EVENT_PLAYER_SCORE= 11;
        public static inline final EVENT_SNOWBALL_MISS= 12;

        public static inline final LOUNGE_INFO= 7800;
        public static inline final INSTANCE_LIST= 7801;
        public static inline final GAME_INSTANCE= 7802;
        public static inline final INSTANCE_REMOVED= 7803;
        public static inline final JOIN_PARAMETERS= 7804;
        public static inline final OPERATION_FAILED= 7805;
        public static inline final GAME_LOCATION= 7806;
        public static inline final GAME_RESET= 7807;
        public static inline final GAME_START= 7808;
        public static inline final FULL_GAME_STATUS= 7809;
        public static inline final GAME_STATUS= 7810;
        public static inline final GAME_END= 7811;
        public static inline final PLAYER_REMOVED= 7812;
        public static inline final SPECTATOR_COUNT= 7813;
        public static inline final FINISHED_GAME= 7814;
        public static inline final SKILL_LEVEL_CHANGED= 7815;
        public static inline final IDLE_WARNING= 7816;

	public function new() {}
    }

