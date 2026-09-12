package com.sulake.room.utils
;
     class RoomId 
    {
        static inline final PREVIEW_ROOM_ID_BASE= 0x7FFF0000;


        public static function makeRoomPreviewerId(k:Int):Int
        {
            return (k & 0xFFFF) + PREVIEW_ROOM_ID_BASE;
        }

        public static function isRoomPreviewerId(k:Int):Bool
        {
            return k >= PREVIEW_ROOM_ID_BASE;
        }

	public function new() {}
    }

