package org.openvideoads.util
;
    import flash.system.Capabilities;

     class ObjectUtils 
    {
        static var counter:Float = 0;


        public static function _Str_22043():String
        {
            var k= Date.now();
            var _local_2= k.getTime();
            var _local_3= (Math.random() * ASCompat.MAX_FLOAT);
            var _local_4= Capabilities.serverString;
            var _local_5= _Str_21958((((Std.string(_local_2) + _local_4) + Std.string(_local_3)) + Std.string(counter++))).toUpperCase();
            var _local_6= ((((((((_local_5.substring(0, 8) + "-") + _local_5.substring(8, 12)) + "-") + _local_5.substring(12, 16)) + "-") + _local_5.substring(16, 20)) + "-") + _local_5.substring(20, 32));
            return _local_6;
        }

        static function _Str_21958(k:String):String
        {
            return _Str_20760(k);
        }

        static function _Str_20760(k:String):String
        {
            return _Str_20761(_Str_19782(_Str_20253(k), (k.length * 8)));
        }

        static function _Str_19782(k:Array<ASAny>, _arg_2:Float):Array<ASAny>
        {
            var _local_10 = Math.NaN;
            var _local_11 = Math.NaN;
            var _local_12 = Math.NaN;
            var _local_13 = Math.NaN;
            var _local_14 = Math.NaN;
            var _local_15 = Math.NaN;
            var _local_16 = Math.NaN;
            k[(Std.int(_arg_2 )>> 5)] = (ASCompat.toInt(k[(Std.int(_arg_2 )>> 5)] )| (128 << Std.int(24 - (_arg_2 % 32))));
            k[(((Std.int(_arg_2 + 64) >> 9) << 4) + 15)] = _arg_2;
            var _local_3= ASCompat.allocArray(80);
            var _local_4:Float = 1732584193;
            var _local_5:Float = -271733879;
            var _local_6:Float = -1732584194;
            var _local_7:Float = 271733878;
            var _local_8:Float = -1009589776;
            var _local_9:Float = 0;
            while (_local_9 < k.length)
            {
                _local_10 = _local_4;
                _local_11 = _local_5;
                _local_12 = _local_6;
                _local_13 = _local_7;
                _local_14 = _local_8;
                _local_15 = 0;
                while (_local_15 < 80)
                {
                    if (_local_15 < 16)
                    {
                        _local_3[Std.int(_local_15)] = k[Std.int(_local_9 + _local_15)];
                    }
                    else
                    {
                        _local_3[Std.int(_local_15)] = _Str_6749((((ASCompat.toInt(_local_3[Std.int(_local_15 - 3)] )^ ASCompat.toInt(_local_3[Std.int(_local_15 - 8)])) ^ ASCompat.toInt(_local_3[Std.int(_local_15 - 14)])) ^ ASCompat.toInt(_local_3[Std.int(_local_15 - 16)])), 1);
                    }
                    _local_16 = _Str_3687(_Str_3687(_Str_6749(_local_4, 5), sha1_ft(_local_15, _local_5, _local_6, _local_7)), _Str_3687(_Str_3687(_local_8, ASCompat.toNumber(_local_3[Std.int(_local_15)])), sha1_kt(_local_15)));
                    _local_8 = _local_7;
                    _local_7 = _local_6;
                    _local_6 = _Str_6749(_local_5, 30);
                    _local_5 = _local_4;
                    _local_4 = _local_16;
                    _local_15++;
                }
                _local_4 = _Str_3687(_local_4, _local_10);
                _local_5 = _Str_3687(_local_5, _local_11);
                _local_6 = _Str_3687(_local_6, _local_12);
                _local_7 = _Str_3687(_local_7, _local_13);
                _local_8 = _Str_3687(_local_8, _local_14);
                _local_9 = (_local_9 + 16);
            }
            return [_local_4, _local_5, _local_6, _local_7, _local_8];
        }

        static function sha1_ft(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float):Float
        {
            if (k < 20)
            {
                return (Std.int(_arg_2 )& Std.int(_arg_3)) | ((~Std.int(_arg_2)) & Std.int(_arg_4));
            }
            if (k < 40)
            {
                return (Std.int(_arg_2 )^ Std.int(_arg_3)) ^ Std.int(_arg_4);
            }
            if (k < 60)
            {
                return ((Std.int(_arg_2 )& Std.int(_arg_3)) | (Std.int(_arg_2 )& Std.int(_arg_4))) | (Std.int(_arg_3 )& Std.int(_arg_4));
            }
            return (Std.int(_arg_2 )^ Std.int(_arg_3)) ^ Std.int(_arg_4);
        }

        static function sha1_kt(k:Float):Float
        {
            return (k < 20) ? 1518500249 : ((k < 40) ? 1859775393 : ((k < 60) ? -1894007588 : -899497514));
        }

        static function _Str_3687(k:Float, _arg_2:Float):Float
        {
            var _local_3:Float = ((Std.int(k )& 0xFFFF) + (Std.int(_arg_2 )& 0xFFFF));
            var _local_4:Float = (((Std.int(k )>> 16) + (Std.int(_arg_2 )>> 16)) + (Std.int(_local_3 )>> 16));
            return (Std.int(_local_4 )<< 16) | (Std.int(_local_3 )& 0xFFFF);
        }

        static function _Str_6749(k:Float, _arg_2:Float):Float
        {
            return (Std.int(k )<< Std.int(_arg_2)) | (Std.int(k )>>> Std.int(32 - _arg_2));
        }

        static function _Str_20253(k:String):Array<ASAny>
        {
            var _local_2= new Array<ASAny>();
            var _local_3:Float = ((1 << 8) - 1);
            var _local_4:Float = 0;
            while (_local_4 < (k.length * 8))
            {
                _local_2[(Std.int(_local_4 )>> 5)] = (ASCompat.toInt(_local_2[(Std.int(_local_4 )>> 5)] )| ((k.charCodeAt(Std.int(_local_4 / 8)) & Std.int(_local_3)) << Std.int(24 - (_local_4 % 32))));
                _local_4 = (_local_4 + 8);
            }
            return _local_2;
        }

        static function _Str_20761(k:Array<ASAny>):String
        {
            var _local_2= "";
            var _local_3= "0123456789abcdef";
            var _local_4:Float = 0;
            while (_local_4 < (k.length * 4))
            {
                _local_2 = (_local_2 + (_local_3.charAt(((ASCompat.toInt(k[(Std.int(_local_4 )>> 2)] )>> Std.int(((3 - (_local_4 % 4)) * 8) + 4)) & 0x0F)) + _local_3.charAt(((ASCompat.toInt(k[(Std.int(_local_4 )>> 2)] )>> Std.int((3 - (_local_4 % 4)) * 8)) & 0x0F))));
                _local_4++;
            }
            return _local_2;
        }

	public function new() {}
    }

