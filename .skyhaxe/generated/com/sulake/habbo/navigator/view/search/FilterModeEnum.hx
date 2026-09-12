package com.sulake.habbo.navigator.view.search
;
     class FilterModeEnum 
    {
        public static inline final DEFAULT= 0;
        public static inline final _Str_19005= 1;
        public static inline final _Str_17720= 2;
        public static inline final _Str_17241= 3;
        public static inline final _Str_3783= 4;
        public static inline final _Str_17193= 5;
        public static final _Str_7872:Array<ASAny> = ["", "owner:", "roomname:", "tag:", "group:", ""];


        public static function _Str_25167(k:String):Int
        {
            var _local_2= 1;
            while (_local_2 < _Str_7872.length)
            {
                if (k.indexOf(_Str_7872[_local_2]) == 0)
                {
                    return _local_2;
                }
                _local_2++;
            }
            return DEFAULT;
        }

	public function new() {}
    }

