package com.sulake.habbo.utils
;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

     class _Str_988 
    {


        public static function normalize(k:Float, _arg_2:Float, _arg_3:Float):Float
        {
            return (k - _arg_2) / (_arg_3 - _arg_2);
        }

        public static function _Str_1028(k:Float, _arg_2:Float, _arg_3:Float):Float
        {
            return (k * (_arg_3 - _arg_2)) + _arg_2;
        }

        public static function _Str_2040(k:Float, _arg_2:Float=0, _arg_3:Float=1):Float
        {
            return Math.max(_arg_2, Math.min(_arg_3, k));
        }

        public static function _Str_1452(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:Float):Float
        {
            return _Str_1028(normalize(k, _arg_2, _arg_3), _arg_4, _arg_5);
        }

        public static function _Str_2065(k:Rectangle, _arg_2:Rectangle):Matrix
        {
            var _local_3= new Matrix();
            _local_3.a = (_arg_2.width / k.width);
            _local_3.d = (_arg_2.height / k.height);
            _local_3.tx = (_arg_2.x - (k.x * _local_3.a));
            _local_3.ty = (_arg_2.y - (k.y * _local_3.d));
            return _local_3;
        }

	public function new() {}
    }

