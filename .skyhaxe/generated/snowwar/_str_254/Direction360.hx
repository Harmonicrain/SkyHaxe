package snowwar._str_254
;
	import com.sulake.core.runtime.IDisposable;

     class Direction360 implements IDisposable 
    {
        static inline final _SafeStr_22076:Float = 1;
        public static inline final N= 0;
        public static inline final NE= 45;
        public static inline final E= 90;
        public static inline final SE= 135;
        public static inline final S= 180;
        public static inline final SW= 225;
        public static inline final W= 270;
        public static inline final NW= 315;
        static var _SafeStr_22077:Array<ASAny> = [([0, 4, 8, 13, 17, 22, 26, 31, 35, 40, 44, 48, 53, 57, 61, 66, 70, 74, 79, 83, 87, 91, 95, 100, 104, 108, 112, 116, 120, 124, 127, 131, 135, 139, 143, 146, 150, 154, 157, 161, 164, 167, 171, 174, 177, 181, 184, 187, 190, 193, 196, 198, 201, 204, 207, 209, 212, 214, 217, 219, 221, 223, 226, 228, 230, 232, 233, 235, 237, 238, 240, 242, 243, 244, 246, 247, 248, 249, 250, 251, 252, 252, 253, 254, 254, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0100, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 254, 254, 253, 252, 252, 251, 250, 249, 248, 247, 246, 244, 243, 242, 240, 238, 237, 235, 233, 232, 230, 228, 226, 223, 221, 219, 217, 214, 212, 209, 207, 204, 201, 198, 196, 193, 190, 187, 184, 181, 177, 174, 171, 167, 164, 161, 157, 154, 150, 146, 143, 139, 135, 131, 127, 124, 120, 116, 112, 108, 104, 100, 95, 91, 87, 83, 79, 74, 70, 66, 61, 57, 53, 48, 44, 40, 35, 31, 26, 22, 17, 13, 8, 4, 0, -4, -8, -13, -17, -22, -26, -31, -35, -40, -44, -48, -53, -57, -61, -66, -70, -74, -79, -83, -87, -91, -95, -100, -104, -108, -112, -116, -120, -124, -128, -131, -135, -139, -143, -146, -150, -154, -157, -161, -164, -167, -171, -174, -177, -181, -184, -187, -190, -193, -196, -198, -201, -204, -207, -209, -212, -214, -217, -219, -221, -223, -226, -228, -230, -232, -233, -235, -237, -238, -240, -242, -243, -244, -246, -247, -248, -249, -250, -251, -252, -252, -253, -254, -254, -255, -255, -255, -255, -255, -256, -255, -255, -255, -255, -255, -254, -254, -253, -252, -252, -251, -250, -249, -248, -247, -246, -244, -243, -242, -240, -238, -237, -235, -233, -232, -230, -228, -226, -223, -221, -219, -217, -214, -212, -209, -207, -204, -201, -198, -196, -193, -190, -187, -184, -181, -177, -174, -171, -167, -164, -161, -157, -154, -150, -146, -143, -139, -135, -131, -128, -124, -120, -116, -112, -108, -104, -100, -95, -91, -87, -83, -79, -74, -70, -66, -61, -57, -53, -48, -44, -40, -35, -31, -26, -22, -17, -13, -8, -4] : Array<Dynamic>), ([-256, -255, -255, -255, -255, -255, -254, -254, -253, -252, -252, -251, -250, -249, -248, -247, -246, -244, -243, -242, -240, -238, -237, -235, -233, -232, -230, -228, -226, -223, -221, -219, -217, -214, -212, -209, -207, -204, -201, -198, -196, -193, -190, -187, -184, -181, -177, -174, -171, -167, -164, -161, -157, -154, -150, -146, -143, -139, -135, -131, -128, -124, -120, -116, -112, -108, -104, -100, -95, -91, -87, -83, -79, -74, -70, -66, -61, -57, -53, -48, -44, -40, -35, -31, -26, -22, -17, -13, -8, -4, 0, 4, 8, 13, 17, 22, 26, 31, 35, 40, 44, 48, 53, 57, 61, 66, 70, 74, 79, 83, 87, 91, 95, 100, 104, 108, 112, 116, 120, 124, 127, 131, 135, 139, 143, 146, 150, 154, 157, 161, 164, 167, 171, 174, 177, 181, 184, 187, 190, 193, 196, 198, 201, 204, 207, 209, 212, 214, 217, 219, 221, 223, 226, 228, 230, 232, 233, 235, 237, 238, 240, 242, 243, 244, 246, 247, 248, 249, 250, 251, 252, 252, 253, 254, 254, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0100, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 254, 254, 253, 252, 252, 251, 250, 249, 248, 247, 246, 244, 243, 242, 240, 238, 237, 235, 233, 232, 230, 228, 226, 223, 221, 219, 217, 214, 212, 209, 207, 204, 201, 198, 196, 193, 190, 187, 184, 181, 177, 174, 171, 167, 164, 161, 157, 154, 150, 146, 143, 139, 135, 131, 128, 124, 120, 116, 112, 108, 104, 100, 95, 91, 87, 83, 79, 74, 70, 66, 61, 57, 53, 48, 44, 40, 35, 31, 26, 22, 17, 13, 8, 4, 0, -4, -8, -13, -17, -22, -26, -31, -35, -40, -44, -48, -53, -57, -61, -66, -70, -74, -79, -83, -87, -91, -95, -100, -104, -108, -112, -116, -120, -124, -128, -131, -135, -139, -143, -146, -150, -154, -157, -161, -164, -167, -171, -174, -177, -181, -184, -187, -190, -193, -196, -198, -201, -204, -207, -209, -212, -214, -217, -219, -221, -223, -226, -228, -230, -232, -233, -235, -237, -238, -240, -242, -243, -244, -246, -247, -248, -249, -250, -251, -252, -252, -253, -254, -254, -255, -255, -255, -255, -255] : Array<Dynamic>)];
        static var _SafeStr_22059:Array<ASAny> = [0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 10, 11, 11, 11, 11, 12, 12, 12, 12, 12, 13, 13, 13, 13, 13, 14, 14, 14, 14, 15, 15, 15, 15, 15, 16, 16, 16, 16, 16, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 23, 23, 23, 23, 23, 24, 24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 26, 26, 26, 26, 26, 26, 27, 27, 27, 27, 27, 28, 28, 28, 28, 28, 28, 29, 29, 29, 29, 29, 29, 30, 30, 30, 30, 30, 30, 31, 31, 31, 31, 31, 31, 32, 32, 32, 32, 32, 32, 33, 33, 33, 33, 33, 33, 34, 34, 34, 34, 34, 34, 34, 35, 35, 35, 35, 35, 35, 36, 36, 36, 36, 36, 36, 36, 37, 37, 37, 37, 37, 37, 37, 38, 38, 38, 38, 38, 38, 38, 39, 39, 39, 39, 39, 39, 39, 39, 40, 40, 40, 40, 40, 40, 40, 41, 41, 41, 41, 41, 41, 41, 41, 42, 42, 42, 42, 42, 42, 42, 42, 43, 43, 43, 43, 43, 43, 43, 43, 44, 44, 44, 44, 44, 44, 44, 44, 44, 45, 45, 45, 45, 45];

        var _SafeStr_22080:Int = 0;
        var _SafeStr_5041:Bool = false;

        public function new(k:Int)
        {
            this._SafeStr_22080 = k;
        }

        public static function validateDirection360Value(k:Int):Int
        {
            if (k > 359)
            {
                k = (k % 360);
            }
            else
            {
                if (k < 0)
                {
                    k = (360 + (k % 360));
                }
            }
            return k;
        }

        public static function direction360ValueToDirection8(k:Int):Direction8
        {
            return Direction8.fromIndex(Direction8.validateDirection8Value((_SafeStr_4667._SafeStr_18698((validateDirection360Value((k - 22)) / 45)) + 1)));
        }

        public static function direction8ToDirection360Value(k:Direction8):Int
        {
            switch (k.index())
            {
                case 0:
                    return Direction360.N;
                case 1:
                    return Direction360.NE;
                case 2:
                    return Direction360.E;
                case 3:
                    return Direction360.SE;
                case 4:
                    return Direction360.S;
                case 5:
                    return Direction360.SW;
                case 6:
                    return Direction360.W;
                case 7:
                    return Direction360.NW;
            }
            return -1;
        }

        public static function __as3_static__SafeStr_19045(k:Int):Int
        {
            k = validateDirection360Value(k);
            return ASCompat.toInt(_SafeStr_22077[0][k]);
        }

        public static function __as3_static__SafeStr_19046(k:Int):Int
        {
            k = validateDirection360Value(k);
            return ASCompat.toInt(_SafeStr_22077[1][k]);
        }

        public static function _SafeStr_18792(k:Int, _arg_2:Int):Int
        {
            var _local_3 = 0;
            if (_SafeStr_22078(k) <= _SafeStr_22078(_arg_2))
            {
                if (_arg_2 == 0)
                {
                    _arg_2 = 1;
                }
                k = (k * 0x0100);
                _local_3 = _SafeStr_4667._SafeStr_18698((k / _arg_2));
                if (_local_3 < 0)
                {
                    _local_3 = -_local_3;
                }
                if (_local_3 > 0xFF)
                {
                    _local_3 = 0xFF;
                }
                if (_arg_2 < 0)
                {
                    if (k > 0)
                    {
                        return ASCompat.toInt(_SafeStr_22059[_local_3]);
                    }
                    return ASCompat.toInt(360 - ASCompat.toNumber(_SafeStr_22059[_local_3]));
                }
                if (k > 0)
                {
                    return ASCompat.toInt(180 - ASCompat.toNumber(_SafeStr_22059[_local_3]));
                }
                return ASCompat.toInt(180 + _SafeStr_22059[_local_3]);
            }
            if (k == 0)
            {
                k = 1;
            }
            _arg_2 = (_arg_2 * 0x0100);
            _local_3 = _SafeStr_4667._SafeStr_18698((_arg_2 / k));
            if (_local_3 < 0)
            {
                _local_3 = -_local_3;
            }
            if (_local_3 > 0xFF)
            {
                _local_3 = 0xFF;
            }
            if (_arg_2 < 0)
            {
                if (k > 0)
                {
                    return ASCompat.toInt(90 - ASCompat.toNumber(_SafeStr_22059[_local_3]));
                }
                return ASCompat.toInt(270 + _SafeStr_22059[_local_3]);
            }
            if (k > 0)
            {
                return ASCompat.toInt(90 + _SafeStr_22059[_local_3]);
            }
            return ASCompat.toInt(270 - ASCompat.toNumber(_SafeStr_22059[_local_3]));
        }

        public static function _SafeStr_22078(k:Int):Int
        {
            if (k < 0)
            {
                return -k;
            }
            return k;
        }

        static function _SafeStr_22079(k:Int, _arg_2:Int):Int
        {
            return Std.int(Math.atan2(k, ((_arg_2 * 57.295) + 0.5)));
        }


        public function dispose()
        {
            this._SafeStr_5041 = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._SafeStr_5041;
        }

        public function index():Int
        {
            return this._SafeStr_22080;
        }

        public function _SafeStr_19043(k:Int)
        {
            this._SafeStr_22080 = validateDirection360Value(k);
        }

        public function _SafeStr_18854(k:Int)
        {
            this._SafeStr_22080 = (this._SafeStr_22080 + k);
            this._SafeStr_22080 = validateDirection360Value(this._SafeStr_22080);
        }

        public function toString():String
        {
            return ("[" + Std.string(this._SafeStr_22080)) + "]";
        }

        public function direction8Value():Direction8
        {
            return direction360ValueToDirection8(this._SafeStr_22080);
        }

        public function _SafeStr_19045():Int
        {
            return ASCompat.toInt(_SafeStr_22077[0][this._SafeStr_22080]);
        }

        public function _SafeStr_19046():Int
        {
            return ASCompat.toInt(_SafeStr_22077[1][this._SafeStr_22080]);
        }
    }

