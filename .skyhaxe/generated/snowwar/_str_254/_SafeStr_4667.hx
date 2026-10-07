package snowwar._str_254
;
     class _SafeStr_4667 
    {
        public static function _SafeStr_18698(k:Float):Int
        {
            if (k >= 0)
            {
                return Std.int(Math.ffloor(k));
            }
            return Std.int(Math.fceil(k));
        }

	public function new() {}
    }

