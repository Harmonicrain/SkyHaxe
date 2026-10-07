package snowwar._str_254
;
     class _SafeStr_4669 
    {
        public static function _SafeStr_18715(k:Int):Int
        {
            var _local_2 = 0;
            if (k == 0)
            {
                k = -1;
            }
            _local_2 = (k << 13);
            k = (k ^ _local_2);
            _local_2 = (k >> 17);
            k = (k ^ _local_2);
            _local_2 = (k << 5);
            k = (k ^ _local_2);
            return k;
        }

        public static function _SafeStr_22068(k:Int, _arg_2:Int):Int
        {
            if (_arg_2 == 0)
            {
                return 0;
            }
            return ((k < 0) ? (k * -1) : k) % _arg_2;
        }

        static function _SafeStr_22069(k:Int):String
        {
            var _local_2= "";
            var _local_3= 31;
            while (_local_3 >= 0)
            {
                _local_2 = (_local_2 + (((k & (1 << _local_3)) > 0) ? "1" : "0"));
                _local_3--;
            }
            return _local_2;
        }

	public function new() {}
    }

