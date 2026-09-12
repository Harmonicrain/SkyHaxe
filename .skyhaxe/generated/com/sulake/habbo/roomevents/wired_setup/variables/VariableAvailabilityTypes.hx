package com.sulake.habbo.roomevents.wired_setup.variables
;
    /** Availability values used by the July Furni/User/Global variable editors. */
     class VariableAvailabilityTypes
    {
        public static inline final WHILE_USER_IN_ROOM= 0;
        public static inline final WHILE_ROOM_ACTIVE= 1;
        public static inline final PERMANENT= 10;
        public static inline final PERMANENT_SHARED= 11;
        public static inline final SHARED= 20;
        public static inline final SHARED_DYNAMIC= 21;
        public static inline final INTERNAL= 999;

        public static function isStored(k:Int):Bool
        {
            return k == PERMANENT || k == PERMANENT_SHARED;
        }

	public function new() {}
    }

