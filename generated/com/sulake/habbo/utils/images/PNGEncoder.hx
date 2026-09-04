package com.sulake.habbo.utils.images
;
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.geom.*;

     class PNGEncoder 
    {
        static var _Str_982:Array<ASAny>;
        static var _Str_1151:Bool = false;


        public static function encode(k:BitmapData):com.sulake.core.utils.ByteArray
        {
            var _local_6:UInt;
            var _local_7:Int;
            var _local_2= new com.sulake.core.utils.ByteArray();
            _local_2.writeUnsignedInt(ASCompat.toUInt(2303741511));
            _local_2.writeUnsignedInt(218765834);
            var _local_3= new com.sulake.core.utils.ByteArray();
            _local_3.writeInt(k.width);
            _local_3.writeInt(k.height);
            _local_3.writeUnsignedInt(134610944);
            _local_3.writeByte(0);
            _Str_1503(_local_2, 1229472850, _local_3);
            var _local_4= new com.sulake.core.utils.ByteArray();
            var _local_5 = 0;
            while (_local_5 < k.height)
            {
                _local_4.writeByte(0);
                if (!k.transparent)
                {
                    _local_7 = 0;
                    while (_local_7 < k.width)
                    {
                        _local_6 = k.getPixel(_local_7, _local_5);
                        _local_4.writeUnsignedInt(ASCompat.toUInt((((_local_6 & 0xFFFFFF) << 8) | 0xFF)));
                        _local_7++;
                    }
                }
                else
                {
                    _local_7 = 0;
                    while (_local_7 < k.width)
                    {
                        _local_6 = k.getPixel32(_local_7, _local_5);
                        _local_4.writeUnsignedInt(ASCompat.toUInt((((_local_6 & 0xFFFFFF) << 8) | (_local_6 >>> 24))));
                        _local_7++;
                    }
                }
                _local_5++;
            }
            _local_4.compress();
            _Str_1503(_local_2, 1229209940, _local_4);
            _Str_1503(_local_2, 1229278788, null);
            return _local_2;
        }

        static function _Str_1503(k:com.sulake.core.utils.ByteArray, _arg_2:UInt, _arg_3:com.sulake.core.utils.ByteArray)
        {
            var _local_8:UInt;
            var _local_9:UInt;
            var _local_10:UInt;
            if (!_Str_1151)
            {
                _Str_1151 = true;
                _Str_982 = [];
                _local_9 = 0;
                while (_local_9 < 0x0100)
                {
                    _local_8 = _local_9;
                    _local_10 = 0;
                    while (_local_10 < 8)
                    {
                        if (((_local_8 & 0x01) != 0))
                        {
                            _local_8 = ASCompat.toUInt((ASCompat.toUInt(3988292384) ^ ASCompat.toUInt((_local_8 >>> 1))));
                        }
                        else
                        {
                            _local_8 = ASCompat.toUInt((_local_8 >>> 1));
                        }
                        _local_10++;
                    }
                    _Str_982[_local_9] = _local_8;
                    _local_9++;
                }
            }
            var _local_4:UInt = 0;
            if (_arg_3 != null)
            {
                _local_4 = _arg_3.length;
            }
            k.writeUnsignedInt(_local_4);
            var _local_5= k.position;
            k.writeUnsignedInt(_arg_2);
            if (_arg_3 != null)
            {
                k.writeBytes(_arg_3);
            }
            var _local_6= k.position;
            k.position = _local_5;
            _local_8 = 0xFFFFFFFF;
            var _local_7 = 0;
            while ((_local_7 : UInt) < (_local_6 - _local_5))
            {
                _local_8 = ASCompat.toUInt((ASCompat.toInt(_Str_982[((_local_8 ^ k.readUnsignedByte()) & ASCompat.toUInt(0xFF))]) ^ ASCompat.toUInt((_local_8 >>> 8))));
                _local_7++;
            }
            _local_8 = ASCompat.toUInt((_local_8 ^ ASCompat.toUInt(0xFFFFFFFF)));
            k.position = _local_6;
            k.writeUnsignedInt(_local_8);
        }

	public function new() {}
    }

