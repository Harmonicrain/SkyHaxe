package snowwar._str_254
;
     class Direction8 
    {
        public static var DIRECTIONS:Array<ASAny> = [];
        public static final N:Direction8 = new Direction8(0, "N", 0, -1);
        public static final NE:Direction8 = new Direction8(1, "NE", 1, -1);
        public static final E:Direction8 = new Direction8(2, "E", 1, 0);
        public static final SE:Direction8 = new Direction8(3, "SE", 1, 1);
        public static final S:Direction8 = new Direction8(4, "S", 0, 1);
        public static final SW:Direction8 = new Direction8(5, "SW", -1, 1);
        public static final W:Direction8 = new Direction8(6, "W", -1, 0);
        public static final NW:Direction8 = new Direction8(7, "NW", -1, -1);
        public static final _SafeStr_22057:Direction8 = S;
        public static final _SafeStr_22058:Direction8 = SW;
        static var _SafeStr_22059:Array<ASAny> = [0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 10, 11, 11, 11, 11, 12, 12, 12, 12, 12, 13, 13, 13, 13, 13, 14, 14, 14, 14, 15, 15, 15, 15, 15, 16, 16, 16, 16, 16, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 23, 23, 23, 23, 23, 24, 24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 26, 26, 26, 26, 26, 26, 27, 27, 27, 27, 27, 28, 28, 28, 28, 28, 28, 29, 29, 29, 29, 29, 29, 30, 30, 30, 30, 30, 30, 31, 31, 31, 31, 31, 31, 32, 32, 32, 32, 32, 32, 33, 33, 33, 33, 33, 33, 34, 34, 34, 34, 34, 34, 34, 35, 35, 35, 35, 35, 35, 36, 36, 36, 36, 36, 36, 36, 37, 37, 37, 37, 37, 37, 37, 38, 38, 38, 38, 38, 38, 38, 39, 39, 39, 39, 39, 39, 39, 39, 40, 40, 40, 40, 40, 40, 40, 41, 41, 41, 41, 41, 41, 41, 41, 42, 42, 42, 42, 42, 42, 42, 42, 43, 43, 43, 43, 43, 43, 43, 43, 44, 44, 44, 44, 44, 44, 44, 44, 44, 45, 45, 45, 45, 45];

        var _index:Int = 0;
        var _offsetX:Int = 0;
        var _offsetY:Int = 0;
        var _code:String;

        public function new(index:Int, code:String, offsetX:Int, offsetY:Int)
        {
            this._index = index;
            this._code = code;
            this._offsetX = offsetX;
            this._offsetY = offsetY;
            DIRECTIONS[index] = this;
        }

        public static function fromIndex(k:Int):Direction8 //_SafeStr_18744
        {
            if (((k < 0) || (k > 7)))
            {
                return null;
            }
            return DIRECTIONS[k];
        }

        public static function validateDirection8Value(k:Int):Int
        {
            return k & 0x07;
        }

        public static function directionFromPointToPoint(fromX:Int, fromY:Int, toX:Int, toY:Int):Direction8 //_SafeStr_22060
        {
            var dX= (toX - fromX);
            var dY= (toY - fromY);
            if (((dX == 0) && (dY < 0)))
            {
                return N;
            }
            if (((dX == 0) && (dY > 0)))
            {
                return S;
            }
            if (((dX > 0) && (dY < 0)))
            {
                return NE;
            }
            if (((dX > 0) && (dY == 0)))
            {
                return E;
            }
            if (((dX > 0) && (dY > 0)))
            {
                return SE;
            }
            if (((dX < 0) && (dY < 0)))
            {
                return NW;
            }
            if (((dX < 0) && (dY == 0)))
            {
                return W;
            }
            if (((dX < 0) && (dY > 0)))
            {
                return SW;
            }
            return null;
        }

        static function validateDirection360Value(k:Int):Int
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

        static function _SafeStr_18792(k:Int, _arg_2:Int):Int
        {
            var _local_3 = 0;
            if (Math.abs(k) <= Math.abs(_arg_2))
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


        public function index():Int //index
        {
            return this._index;
        }

        public function rotateDirection180Degrees():Direction8 //_SafeStr_18699
        {
            return this._SafeStr_18854(4);
        }

        public function rotateDirection45Degrees(k:Bool):Direction8
        {
            return this._SafeStr_18854((k ? 1 : -1));
        }

        public function rotateDirection90Degrees(k:Bool):Direction8
        {
            return this._SafeStr_18854((k ? 2 : -2));
        }

        public function _SafeStr_18701():Bool
        {
            return (this._index % 2) == 0;
        }

        public function _SafeStr_18790():Int //Maybe hashcode just like Location._SafeStr_18790
        {
            return this._index;
        }

        public function _SafeStr_18854(k:Int):Direction8
        {
            var _local_2= (this._index + k);
            _local_2 = validateDirection8Value(_local_2);
            return DIRECTIONS[_local_2];
        }

        public function toString():String
        {
            return ((this._code + "(") + Std.string(this._index)) + ")";
        }

        public function code():String //_SafeStr_22064
        {
            return this._code;
        }

        public function offsetX():Int //_SafeStr_18738
        {
            return this._offsetX;
        }

        public function offsetY():Int //_SafeStr_18739
        {
            return this._offsetY;
        }
    }

