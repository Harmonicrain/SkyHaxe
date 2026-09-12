package com.sulake.habbo.configuration._enum
;
     class HabboComponentFlags 
    {
        public static inline final ROOM_VIEWER_MODE= 1;


        public static function isRoomViewerMode(k:Int):Bool
        {
            return !((k & ROOM_VIEWER_MODE) == 0);
        }

	public function new() {}
    }

