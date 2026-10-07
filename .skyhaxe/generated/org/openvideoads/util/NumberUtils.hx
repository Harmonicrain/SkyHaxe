package org.openvideoads.util
;
     class NumberUtils 
    {


        static function _Str_4080(k:String, _arg_2:String):Float
        {
            if (_arg_2.indexOf(k) <= 0)
            {
                return Math.NaN;
            }
            return ASCompat.toNumber(_arg_2.substring(0, _arg_2.indexOf(k)));
        }

        public static function _Str_5288(k:ASAny):Float
        {
            if (Std.is(k , Float))
            {
                return Math.fround(ASCompat.toNumber(k));
            }
            if (k.indexOf("px") < 0)
            {
                k = (k + "px");
            }
            var _local_2= _Str_4080("px", k);
            if (Math.isNaN(_local_2))
            {
                return ASCompat.asNumber(k.substr(0) );
            }
            return Math.fround(_local_2);
        }

        public static function _Str_26058(k:ASAny):Float
        {
            if (Std.is(k , Float))
            {
                return ASCompat.toNumber(k);
            }
            if (k.indexOf("pct") > -1)
            {
                return _Str_4080("pct", k);
            }
            return _Str_4080("%", k);
        }

	public function new() {}
    }

