package com.sulake.habbo.window._enum
;
     class _Str_3142 
    {
        public static inline final _Str_14897= "up, left";
        public static inline final _Str_14331= "up, center";
        public static inline final _Str_13347= "up, right";
        public static inline final _Str_14284= "down, left";
        public static inline final _Str_16868= "down, center";
        public static inline final _Str_12741= "down, right";
        public static inline final _Str_12710= "left, top";
        public static inline final _Str_18275= "left, middle";
        public static inline final _Str_15111= "left, bottom";
        public static inline final _Str_13226= "right, top";
        public static inline final _Str_17619= "right, middle";
        public static inline final _Str_15859= "right, bottom";
        public static final ALL:Array<ASAny> = [_Str_14897, _Str_14331, _Str_13347, _Str_14284, _Str_16868, _Str_12741, _Str_12710, _Str_18275, _Str_15111, _Str_13226, _Str_17619, _Str_15859];
        public static inline final UP= "up";
        public static inline final DOWN= "down";
        public static inline final LEFT= "left";
        public static inline final RIGHT= "right";
        public static inline final MINIMUM= "minimum";
        public static inline final MIDDLE= "middle";
        public static inline final MAXIMUM= "maximum";


        public static function _Str_22659(k:String):String
        {
            return k.substr(0, k.indexOf(","));
        }

        public static function _Str_20849(k:String):String
        {
            switch (k)
            {
                case _Str_14897
                   | _Str_14284
                   | _Str_12710
                   | _Str_13226:
                    return MINIMUM;
                case _Str_13347
                   | _Str_12741
                   | _Str_15111
                   | _Str_15859:
                    return MAXIMUM;
                default:
                    return MIDDLE;
            }
        }

	public function new() {}
    }

