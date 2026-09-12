package com.sulake.habbo.session._enum
;
     class RoomTradingLevelEnum 
    {
        public static inline final NO_TRADING= 0;
        public static inline final ROOM_CONTROLLER_REQUIRED= 1;
        public static inline final FREE_TRADING= 2;


        public static function _Str_22614(k:Int):String
        {
            switch (k)
            {
                case FREE_TRADING:
                    return "${trading.mode.free}";
                case ROOM_CONTROLLER_REQUIRED:
                    return "${trading.mode.controller}";
                case NO_TRADING:
                    return "${trading.mode.not.allowed}";
            }
            return "";
        }

	public function new() {}
    }

