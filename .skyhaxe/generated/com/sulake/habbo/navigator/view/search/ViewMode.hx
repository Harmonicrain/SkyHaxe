package com.sulake.habbo.navigator.view.search
;
     class ViewMode 
    {
        public static inline final MYWORLD_VIEW= "myworld_view";
        public static inline final HOTEL_VIEW= "hotel_view";
        public static inline final OFFICIAL_VIEW= "official_view";
        public static inline final ROOMADS_VIEW= "roomads_view";
        public static inline final NEW_ADS= "new_ads";
        public static inline final EVENTCATEGORY__= "eventcategory__";
        public static inline final _Str_16624= 0;
        public static inline final _Str_17823= 1;
        public static inline final _Str_17120= 2;
        public static inline final _Str_12908= 3;
        public static inline final _Str_12044= 4;


        public static function _Str_20005(k:String):Int
        {
            if (k == OFFICIAL_VIEW)
            {
                return _Str_16624;
            }
            if (k == MYWORLD_VIEW)
            {
                return _Str_17823;
            }
            if (k == ROOMADS_VIEW)
            {
                return _Str_12908;
            }
            if (k == NEW_ADS)
            {
                return _Str_12044;
            }
            if (k.indexOf(EVENTCATEGORY__) == 0)
            {
                return _Str_12044;
            }
            return _Str_17120;
        }

        public static function _Str_25096(k:Int):Bool
        {
            return (k == _Str_12908) || (k == _Str_12044);
        }

	public function new() {}
    }

