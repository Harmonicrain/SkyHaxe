package com.sulake.habbo.utils
;
    import flash.display.BitmapData;
    import flash.geom.Point;

     class Canvas extends BitmapData 
    {
        public function new(k:Int, _arg_2:Int, _arg_3:Bool=true, _arg_4:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        static function _Str_22323(k:Point, _arg_2:Point):Int
        {
            if (k.y > _arg_2.y)
            {
                return 1;
            }
            if (k.y < _arg_2.y)
            {
                return -1;
            }
            return 0;
        }

        static function _Str_23302(k:BitmapData, _arg_2:Point, _arg_3:Int, _arg_4:Int, _arg_5:UInt):UInt
        {
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = Math.NaN;
            var _local_9 = Math.NaN;
            var _local_10:UInt = 0;
            if (k != null)
            {
                _local_6 = Std.int(_arg_3 - _arg_2.x);
                _local_7 = Std.int(_arg_4 - _arg_2.y);
                _local_8 = (_local_6 % k.width);
                _local_9 = ((_local_7 + (_local_6 / 2)) % k.height);
                _local_10 = k.getPixel32(Std.int(_local_8), Std.int(_local_9));
                return colorize(_local_10, _arg_5);
            }
            return _arg_5;
        }

        static function _Str_24365(k:BitmapData, _arg_2:Point, _arg_3:Int, _arg_4:Int, _arg_5:UInt):UInt
        {
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = Math.NaN;
            var _local_9 = Math.NaN;
            var _local_10:UInt = 0;
            if (k != null)
            {
                _local_6 = Std.int(_arg_3 - _arg_2.x);
                _local_7 = Std.int(_arg_4 - _arg_2.y);
                _local_8 = (_local_6 % k.width);
                _local_9 = ((_local_7 - (_local_6 / 2)) % k.height);
                _local_10 = k.getPixel32(Std.int(_local_8), Std.int(_local_9));
                return colorize(_local_10, _arg_5);
            }
            return _arg_5;
        }

        static function _Str_25009(k:BitmapData, _arg_2:Point, _arg_3:Int, _arg_4:Int, _arg_5:UInt):UInt
        {
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = Math.NaN;
            var _local_9 = Math.NaN;
            var _local_10:UInt = 0;
            if (k != null)
            {
                _local_6 = Std.int(_arg_3 - _arg_2.x);
                _local_7 = Std.int(_arg_4 - _arg_2.y);
                _local_8 = ((_local_7 + (_local_6 / 2)) % k.width);
                _local_9 = ((_local_7 - (_local_6 / 2)) % k.height);
                _local_10 = k.getPixel32(Std.int(_local_8), Std.int(_local_9));
                return colorize(_local_10, _arg_5);
            }
            return _arg_5;
        }

        public static function colorize(k:UInt, _arg_2:UInt):UInt
        {
            if (_arg_2 == 0xFFFFFFFF)
            {
                return k;
            }
            var _local_3:UInt = ((ASCompat.toInt(_arg_2 )>> 16) & 0xFF);
            var _local_4:UInt = ((ASCompat.toInt(_arg_2 )>> 8) & 0xFF);
            var _local_5:UInt = (ASCompat.toInt(_arg_2 )& 0xFF);
            _local_3 = Std.int((((ASCompat.toInt(k )>> 16) & 0xFF) * _local_3) / 0xFF);
            _local_4 = Std.int((((ASCompat.toInt(k )>> 8) & 0xFF) * _local_4) / 0xFF);
            _local_5 = Std.int(((ASCompat.toInt(k )& 0xFF) * _local_5) / 0xFF);
            return (((ASCompat.toInt(k) & ASCompat.toInt(0xFF000000)) | (ASCompat.toInt(_local_3 )<< 16)) | (ASCompat.toInt(_local_4 )<< 8)) | ASCompat.toInt(_local_5);
        }

        public static function _Str_23439(k:BitmapData):UInt
        {
            var _local_7 = 0;
            var _local_8:UInt = 0;
            if (k == null)
            {
                return 0xFFFFFF;
            }
            var _local_2:Float = 0;
            var _local_3:Float = 0;
            var _local_4:Float = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            while (_local_6 < k.width)
            {
                _local_7 = 0;
                while (_local_7 < k.height)
                {
                    _local_8 = k.getPixel32(_local_6, _local_7);
                    if (((ASCompat.toInt(_local_8 )>> 24) & 0xFF) > 0)
                    {
                        _local_2 = (_local_2 + ((ASCompat.toInt(_local_8 )>> 16) & 0xFF));
                        _local_3 = (_local_3 + ((ASCompat.toInt(_local_8 )>> 8) & 0xFF));
                        _local_4 = (_local_4 + (ASCompat.toInt(_local_8 )& 0xFF));
                        _local_5++;
                    }
                    _local_7++;
                }
                _local_6++;
            }
            if (_local_5 == 0)
            {
                return 0xFFFFFF;
            }
            _local_2 = (_local_2 / _local_5);
            _local_3 = (_local_3 / _local_5);
            _local_4 = (_local_4 / _local_5);
            return ((Std.int(_local_2 )<< 16) | (Std.int(_local_3 )<< 8)) | Std.int(_local_4);
        }


        public function _Str_25929(k:Vector<Point>, _arg_2:BitmapData, _arg_3:UInt=0xFFFFFFFF)
        {
            var _local_4:Point = null;
            var _local_5:ASFunction = null;
            if (k.length != 4)
            {
                return;
            }
            if (k[1].x == k[3].x)
            {
                _local_4 = k[3];
                if (k[0].y < k[1].y)
                {
                    _local_5 = _Str_23302;
                }
                else
                {
                    _local_5 = _Str_24365;
                }
            }
            else
            {
                _local_4 = k[3];
                _local_5 = _Str_25009;
            }
            this._Str_20595(k.slice(0, 3), _arg_2, _local_4, _local_5, _arg_3);
            this._Str_20595(k.slice(1, 4), _arg_2, _local_4, _local_5, _arg_3);
        }

        public function _Str_20595(k:Vector<Point>, _arg_2:BitmapData, _arg_3:Point, _arg_4:ASFunction, _arg_5:UInt)
        {
            if (k.length != 3)
            {
                return;
            }
            var _local_6= k.concat();
            ASCompat.ASVector.sort(_local_6, _Str_22323);
            var _local_7= new Point((_local_6[1].x - _local_6[0].x), (_local_6[1].y - _local_6[0].y));
            var _local_8= new Point((_local_6[2].x - _local_6[0].x), (_local_6[2].y - _local_6[0].y));
            var _local_9= new Point((_local_6[2].x - _local_6[1].x), (_local_6[2].y - _local_6[1].y));
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = 0;
            if (((!(_local_7.y == 0)) && (!(_local_8.y == 0))))
            {
                _local_10 = 0;
                while (_local_10 < _local_7.y)
                {
                    _local_11 = Std.int(_local_6[0].x + ((_local_7.x / _local_7.y) * _local_10));
                    _local_12 = Std.int(_local_6[0].x + ((_local_8.x / _local_8.y) * _local_10));
                    this._Str_19454(_local_11, _local_12, Std.int(_local_6[0].y + _local_10), _arg_2, _arg_3, _arg_4, _arg_5);
                    _local_10++;
                }
            }
            if (((!(_local_8.y == 0)) && (!(_local_9.y == 0))))
            {
                _local_10 = 0;
                while (_local_10 < _local_9.y)
                {
                    _local_11 = Std.int(_local_6[1].x + ((_local_9.x / _local_9.y) * _local_10));
                    _local_12 = Std.int(_local_6[0].x + ((_local_8.x / _local_8.y) * (_local_7.y + _local_10)));
                    this._Str_19454(_local_11, _local_12, Std.int(_local_6[1].y + _local_10), _arg_2, _arg_3, _arg_4, _arg_5);
                    _local_10++;
                }
            }
        }

        function _Str_19454(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:BitmapData, _arg_5:Point, _arg_6:ASFunction, _arg_7:UInt)
        {
            var _local_8 = 0;
            if (k < _arg_2)
            {
                _local_8 = k;
                while (_local_8 < _arg_2)
                {
                    setPixel(_local_8, _arg_3, ASCompat.toUInt(_arg_6(_arg_4, _arg_5, _local_8, _arg_3, _arg_7)));
                    _local_8++;
                }
            }
            else
            {
                _local_8 = _arg_2;
                while (_local_8 < k)
                {
                    setPixel(_local_8, _arg_3, ASCompat.toUInt(_arg_6(_arg_4, _arg_5, _local_8, _arg_3, _arg_7)));
                    _local_8++;
                }
            }
        }
    }

