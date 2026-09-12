package com.sulake.habbo.utils
;
     class BuildersClubTools 
    {
        static inline final BUILDERS_CLUB_FURNITURE_ID_BASE= 0x7FFF0000;


        public static function isBuildersClubFurniture(k:Int):Bool
        {
            return k >= BUILDERS_CLUB_FURNITURE_ID_BASE;
        }

	public function new() {}
    }

