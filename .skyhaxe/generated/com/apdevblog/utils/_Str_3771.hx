package com.apdevblog.utils
;
    import flash.display.Shape;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.display.GradientType;
    import flash.display.SpreadMethod;
    import flash.display.InterpolationMethod;

     class _Str_3771 
    {
        public static var _Str_1761:Int = 1;
        public static var _Str_2059:Int = 2;
        public static final _Str_5603:Float = (Math.PI / 180);//0.0174532925199433


        public static function _Str_25985(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:BitmapData, _arg_5:Float=1):Shape
        {
            var _local_6= new Shape();
            _local_6.graphics.beginBitmapFill(_arg_4);
            _local_6.graphics.moveTo((k + _arg_3), _arg_2);
            _local_6.graphics.curveTo((_arg_3 + k), ((Math.tan((Math.PI / 8)) * _arg_3) + _arg_2), ((Math.sin((Math.PI / 4)) * _arg_3) + k), ((Math.sin((Math.PI / 4)) * _arg_3) + _arg_2));
            _local_6.graphics.curveTo(((Math.tan((Math.PI / 8)) * _arg_3) + k), (_arg_3 + _arg_2), k, (_arg_3 + _arg_2));
            _local_6.graphics.curveTo(((-Math.tan((Math.PI / 8)) * _arg_3) + k), (_arg_3 + _arg_2), ((-Math.sin((Math.PI / 4)) * _arg_3) + k), ((Math.sin((Math.PI / 4)) * _arg_3) + _arg_2));
            _local_6.graphics.curveTo((-_arg_3 + k), ((Math.tan((Math.PI / 8)) * _arg_3) + _arg_2), (-_arg_3 + k), _arg_2);
            _local_6.graphics.curveTo((-_arg_3 + k), ((-Math.tan((Math.PI / 8)) * _arg_3) + _arg_2), ((-Math.sin((Math.PI / 4)) * _arg_3) + k), ((-Math.sin((Math.PI / 4)) * _arg_3) + _arg_2));
            _local_6.graphics.curveTo(((-Math.tan((Math.PI / 8)) * _arg_3) + k), (-_arg_3 + _arg_2), k, (-_arg_3 + _arg_2));
            _local_6.graphics.curveTo(((Math.tan((Math.PI / 8)) * _arg_3) + k), (-_arg_3 + _arg_2), ((Math.sin((Math.PI / 4)) * _arg_3) + k), ((-Math.sin((Math.PI / 4)) * _arg_3) + _arg_2));
            _local_6.graphics.curveTo((_arg_3 + k), ((-Math.tan((Math.PI / 8)) * _arg_3) + _arg_2), (_arg_3 + k), _arg_2);
            _local_6.graphics.endFill();
            _local_6.alpha = _arg_5;
            return _local_6;
        }

        public static function _Str_26095(k:Int, _arg_2:Int, _arg_3:BitmapData, _arg_4:Float):Shape
        {
            var _local_5= new Shape();
            _local_5.graphics.beginBitmapFill(_arg_3);
            _local_5.graphics.drawRect(0, 0, k, _arg_2);
            _local_5.graphics.endFill();
            _local_5.alpha = _arg_4;
            return _local_5;
        }

        public static function _Str_26445(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:BitmapData, _arg_5:Float):Shape
        {
            var _local_6= new Shape();
            var _local_7= _local_6.graphics;
            _local_7.beginBitmapFill(_arg_4);
            _local_7.moveTo(_arg_3, 0);
            _local_7.curveTo((k - _arg_3), 0, (k - _arg_3), 0);
            _local_7.curveTo(k, 0, k, _arg_3);
            _local_7.curveTo(k, (_arg_2 - _arg_3), k, (_arg_2 - _arg_3));
            _local_7.curveTo(k, _arg_2, (k - _arg_3), _arg_2);
            _local_7.curveTo(_arg_3, _arg_2, _arg_3, _arg_2);
            _local_7.curveTo(0, _arg_2, 0, (_arg_2 - _arg_3));
            _local_7.curveTo(0, _arg_3, 0, _arg_3);
            _local_7.curveTo(0, 0, _arg_3, 0);
            _local_7.endFill();
            _local_6.alpha = _arg_5;
            return _local_6;
        }

        public static function _Str_26172(k:Int, _arg_2:Int, _arg_3:UInt, _arg_4:UInt, _arg_5:Float=1):Shape
        {
            var _local_6= new Shape();
            var _local_7= _local_6.graphics;
            var _local_8= new BitmapData(2, 2, true);
            _local_8.lock();
            _local_8.setPixel32(0, 0, _arg_3);
            _local_8.setPixel32(1, 0, _arg_4);
            _local_8.setPixel32(0, 1, _arg_4);
            _local_8.setPixel32(1, 1, _arg_3);
            _local_8.unlock();
            _local_7.clear();
            _local_7.beginBitmapFill(_local_8);
            _local_7.drawRect(0, 0, k, _arg_2);
            _local_7.endFill();
            _local_6.alpha = _arg_5;
            return _local_6;
        }

        public static function _Str_26227(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:Float=1):Shape
        {
            var _local_6= new Shape();
            _local_6.graphics.beginFill(Std.int(_arg_4), 1);
            _local_6.graphics.moveTo((k + _arg_3), _arg_2);
            _local_6.graphics.curveTo((_arg_3 + k), ((Math.tan((Math.PI / 8)) * _arg_3) + _arg_2), ((Math.sin((Math.PI / 4)) * _arg_3) + k), ((Math.sin((Math.PI / 4)) * _arg_3) + _arg_2));
            _local_6.graphics.curveTo(((Math.tan((Math.PI / 8)) * _arg_3) + k), (_arg_3 + _arg_2), k, (_arg_3 + _arg_2));
            _local_6.graphics.curveTo(((-Math.tan((Math.PI / 8)) * _arg_3) + k), (_arg_3 + _arg_2), ((-Math.sin((Math.PI / 4)) * _arg_3) + k), ((Math.sin((Math.PI / 4)) * _arg_3) + _arg_2));
            _local_6.graphics.curveTo((-_arg_3 + k), ((Math.tan((Math.PI / 8)) * _arg_3) + _arg_2), (-_arg_3 + k), _arg_2);
            _local_6.graphics.curveTo((-_arg_3 + k), ((-Math.tan((Math.PI / 8)) * _arg_3) + _arg_2), ((-Math.sin((Math.PI / 4)) * _arg_3) + k), ((-Math.sin((Math.PI / 4)) * _arg_3) + _arg_2));
            _local_6.graphics.curveTo(((-Math.tan((Math.PI / 8)) * _arg_3) + k), (-_arg_3 + _arg_2), k, (-_arg_3 + _arg_2));
            _local_6.graphics.curveTo(((Math.tan((Math.PI / 8)) * _arg_3) + k), (-_arg_3 + _arg_2), ((Math.sin((Math.PI / 4)) * _arg_3) + k), ((-Math.sin((Math.PI / 4)) * _arg_3) + _arg_2));
            _local_6.graphics.curveTo((_arg_3 + k), ((-Math.tan((Math.PI / 8)) * _arg_3) + _arg_2), (_arg_3 + k), _arg_2);
            _local_6.graphics.endFill();
            _local_6.alpha = _arg_5;
            return _local_6;
        }

        public static function _Str_1645(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Float=1, _arg_5:Int=2):Shape
        {
            var _local_6= new Shape();
            var _local_7= _local_6.graphics;
            _local_7.lineStyle(_arg_5, _arg_3);
            _local_7.lineTo(k, _arg_2);
            _local_7.moveTo(0, _arg_2);
            _local_7.lineTo(k, 0);
            _local_7.endFill();
            _local_6.alpha = _arg_4;
            return _local_6;
        }

        public static function _Str_25390(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Int, _arg_5:Float):Shape
        {
            var _local_9 = Math.NaN;
            var _local_10 = Math.NaN;
            var _local_11 = Math.NaN;
            var _local_12 = Math.NaN;
            var _local_13 = Math.NaN;
            var _local_6= new Shape();
            var _local_7= _local_6.graphics;
            _local_7.beginFill(_arg_4, 1);
            _local_7.moveTo(0, 0);
            _local_7.lineTo(k, 0);
            var _local_8= Math.tan(((1 * Math.PI) * 180));
            _local_9 = 0;
            while (_local_9 < _arg_3)
            {
                _local_10 = (k * Math.cos(((_local_9 + 1) * _Str_5603)));
                _local_11 = (k * Math.sin(((_local_9 + 1) * _Str_5603)));
                _local_12 = (_local_10 + ((k * _local_8) * Math.cos((((_local_9 + 1) - 90) * _Str_5603))));
                _local_13 = (_local_11 + ((k * _local_8) * Math.sin((((_local_9 + 1) - 90) * _Str_5603))));
                _local_7.curveTo(_local_12, _local_13, _local_10, _local_11);
                _local_9++;
            }
            _local_7.moveTo(0, 0);
            _local_7.lineTo(_arg_2, 0);
            _local_9 = 0;
            while (_local_9 < _arg_3)
            {
                _local_10 = (_arg_2 * Math.cos(((_local_9 + 1) * _Str_5603)));
                _local_11 = (_arg_2 * Math.sin(((_local_9 + 1) * _Str_5603)));
                _local_12 = (_local_10 + ((_arg_2 * _local_8) * Math.cos((((_local_9 + 1) - 90) * _Str_5603))));
                _local_13 = (_local_11 + ((_arg_2 * _local_8) * Math.sin((((_local_9 + 1) - 90) * _Str_5603))));
                _local_7.curveTo(_local_12, _local_13, _local_10, _local_11);
                _local_9++;
            }
            _local_6.alpha = _arg_5;
            return _local_6;
        }

        public static function _Str_25926(k:Int, _arg_2:Int, _arg_3:UInt, _arg_4:UInt, _arg_5:Int=1, _arg_6:Int=1, _arg_7:Float=1):Shape
        {
            var _local_8= new Shape();
            var _local_9= _local_8.graphics;
            var _local_10= ((_arg_2 == _Str_2059) ? k : 1);
            var _local_11= ((_arg_2 == _Str_2059) ? 1 : k);
            var _local_12= new BitmapData((_arg_5 + _arg_6), 1, true);
            _local_12.lock();
            var _local_13 = 0;
            while (_local_13 < _arg_5)
            {
                _local_12.setPixel32(_local_13, 0, _arg_3);
                _local_13++;
            }
            while (_local_13 < (_arg_5 + _arg_6))
            {
                _local_12.setPixel32(_local_13, 0, _arg_4);
                _local_13++;
            }
            _local_12.unlock();
            var _local_14= new Matrix();
            if (_arg_2 == _Str_1761)
            {
                _local_14.rotate(((90 * Math.PI) / 180));
            }
            _local_9.clear();
            _local_9.beginBitmapFill(_local_12, _local_14);
            _local_9.drawRect(0, 0, _local_10, _local_11);
            _local_9.endFill();
            _local_8.alpha = _arg_7;
            return _local_8;
        }

        public static function _Str_13333(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:Float, _arg_6:Float=1, _arg_7:Float=1):Shape
        {
            var _local_8= new Shape();
            var _local_9= _local_8.graphics;
            var _local_10:Array<ASAny> = [_arg_4, _arg_5];
            var _local_11= GradientType.LINEAR;
            var _local_12:Array<ASAny> = [_arg_6, _arg_7];
            var _local_13:Array<ASAny> = [0, 0xFF];
            var _local_14= SpreadMethod.PAD;
            var _local_15= InterpolationMethod.RGB;
            var _local_16= new Matrix();
            _local_16.createGradientBox(k, _arg_2, ((_arg_3 * Math.PI) / 180), 0, 0);
            _local_9.beginGradientFill(_local_11, (cast _local_10), (cast _local_12), (cast _local_13), _local_16, _local_14, _local_15);
            _local_9.drawRect(0, 0, k, _arg_2);
            return _local_8;
        }

        public static function rect(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float=1, _arg_5:Float=0, _arg_6:Float=0):Shape
        {
            var _local_7= new Shape();
            _local_7.graphics.beginFill(Std.int(_arg_3), 1);
            _local_7.graphics.moveTo(0, 0);
            _local_7.graphics.lineTo(k, 0);
            _local_7.graphics.lineTo(k, _arg_2);
            _local_7.graphics.lineTo(0, _arg_2);
            _local_7.graphics.lineTo(0, 0);
            _local_7.graphics.endFill();
            _local_7.alpha = _arg_4;
            _local_7.x = _arg_5;
            _local_7.y = _arg_6;
            return _local_7;
        }

        public static function _Str_25924(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:Float, _arg_6:Float, _arg_7:Float):Shape
        {
            var _local_8= new Shape();
            var _local_9= _local_8.graphics;
            _local_9.beginFill(Std.int(_arg_6), 1);
            _local_9.moveTo((k + _arg_5), _arg_2);
            _local_9.curveTo(((k + _arg_3) - _arg_5), _arg_2, ((k + _arg_3) - _arg_5), _arg_2);
            _local_9.curveTo((k + _arg_3), _arg_2, (k + _arg_3), (_arg_2 + _arg_5));
            _local_9.curveTo((k + _arg_3), ((_arg_2 + _arg_4) - _arg_5), (k + _arg_3), ((_arg_2 + _arg_4) - _arg_5));
            _local_9.curveTo((k + _arg_3), (_arg_2 + _arg_4), ((k + _arg_3) - _arg_5), (_arg_2 + _arg_4));
            _local_9.curveTo((k + _arg_5), (_arg_2 + _arg_4), (k + _arg_5), (_arg_2 + _arg_4));
            _local_9.curveTo(k, (_arg_2 + _arg_4), k, ((_arg_2 + _arg_4) - _arg_5));
            _local_9.curveTo(k, (_arg_2 + _arg_5), k, (_arg_2 + _arg_5));
            _local_9.curveTo(k, _arg_2, (k + _arg_5), _arg_2);
            _local_9.endFill();
            _local_8.alpha = _arg_7;
            return _local_8;
        }

        public static function outline(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Float):Shape
        {
            var _local_5= new Shape();
            var _local_6= _local_5.graphics;
            _local_6.beginFill(_arg_3, 1);
            _local_6.drawRect(0, 0, k, 1);
            _local_6.drawRect(0, 1, 1, (_arg_2 - 1));
            _local_6.drawRect((k - 1), 1, 1, (_arg_2 - 1));
            _local_6.drawRect(1, (_arg_2 - 1), (k - 2), 1);
            _local_6.endFill();
            _local_5.alpha = _arg_4;
            return _local_5;
        }

	public function new() {}
    }

