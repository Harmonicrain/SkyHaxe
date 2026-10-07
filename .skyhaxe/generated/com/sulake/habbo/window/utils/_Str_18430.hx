package com.sulake.habbo.window.utils
;
     class _Str_18430 
    {


        public static function _Str_25426(k:Int, _arg_2:Int):UInt
        {
            var _local_3= Std.int(100 * (k / _arg_2));
            if (_local_3 >= 92)
            {
                return 0xFFC2332C;
            }
            if (_local_3 >= 80)
            {
                return 0xFFFFB11B;
            }
            if (_local_3 >= 50)
            {
                return 0xFFFFB11B;
            }
            if (k > 0)
            {
                return 0xFF63B162;
            }
            return 0xFFCBCAC1;
        }

	public function new() {}
    }

