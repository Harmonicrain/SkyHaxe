package deng.utils
;
    import flash.utils.ByteArray;

     class ChecksumUtil 
    {
        static var _Str_982:Array<ASAny> = _Str_1021();


        static function _Str_1021():Array<ASAny>
        {
            var _local_2:UInt = 0;
            var _local_3:UInt = 0;
            var _local_4:UInt = 0;
            var k:Array<ASAny> = [];
            _local_2 = 0;
            while (_local_2 < 0x0100)
            {
                _local_4 = _local_2;
                _local_3 = 0;
                while (_local_3 < 8)
                {
                    if (((ASCompat.toInt(_local_4 )& 0x01) != 0))
                    {
                        _local_4 = (ASCompat.toInt(3988292384 )^ (ASCompat.toInt(_local_4 )>>> 1));
                    }
                    else
                    {
                        _local_4 = (ASCompat.toInt(_local_4 )>>> 1);
                    }
                    _local_3++;
                }
                k.push(_local_4);
                _local_2++;
            }
            return k;
        }

        public static function _Str_1999(k:com.sulake.core.utils.ByteArray, _arg_2:UInt=0, _arg_3:UInt=0):UInt
        {
            var _local_4:UInt = 0;
            if (_arg_2 >= k.length)
            {
                _arg_2 = k.length;
            }
            if (_arg_3 == 0)
            {
                _arg_3 = (k.length - _arg_2);
            }
            if ((_arg_3 + _arg_2) > k.length)
            {
                _arg_3 = (k.length - _arg_2);
            }
            var _local_5:UInt = 0xFFFFFFFF;
            _local_4 = _arg_2;
            while (_local_4 < _arg_3)
            {
                _local_5 = (ASCompat.toInt(ASCompat.toUInt(_Str_982[((ASCompat.toInt(_local_5 )^ ASCompat.toInt(k[_local_4])) & 0xFF)]) )^ (ASCompat.toInt(_local_5 )>>> 8));
                _local_4++;
            }
            return ASCompat.toInt(_local_5 )^ ASCompat.toInt(0xFFFFFFFF);
        }

        public static function _Str_1386(k:com.sulake.core.utils.ByteArray, _arg_2:UInt=0, _arg_3:UInt=0):UInt
        {
            if (_arg_2 >= k.length)
            {
                _arg_2 = k.length;
            }
            if (_arg_3 == 0)
            {
                _arg_3 = (k.length - _arg_2);
            }
            if ((_arg_3 + _arg_2) > k.length)
            {
                _arg_3 = (k.length - _arg_2);
            }
            var _local_4= _arg_2;
            var _local_5:UInt = 1;
            var _local_6:UInt = 0;
            while (_local_4 < (_arg_2 + _arg_3))
            {
                _local_5 = ((_local_5 + k[_local_4]) % 65521);
                _local_6 = ((_local_5 + _local_6) % 65521);
                _local_4++;
            }
            return (ASCompat.toInt(_local_6 )<< 16) | ASCompat.toInt(_local_5);
        }

	public function new() {}
    }

