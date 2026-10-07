package org.openvideoads.util
;
    import org.openvideoads.base.Debuggable;

     class Timestamp extends Debuggable 
    {


        public static function validate(k:String):Bool
        {
            if (k == null)
            {
                return false;
            }
            var _local_2:Array<ASAny> = (cast k.split(":"));
            return _local_2.length == 3;
        }

        public static function _Str_16820(k:String):String
        {
            if (k == null)
            {
                return "00:00:00";
            }
            return _Str_4110(ASCompat.toInt(k));
        }

        public static function _Str_25945(k:Int):String
        {
            if (k < 10)
            {
                return "0" + Std.string(k);
            }
            return "" + Std.string(k);
        }

        public static function _Str_24782(k:String, _arg_2:Float):String
        {
            var _local_3 = 0;
            if (_arg_2 > 0)
            {
                _local_3 = timestampToSeconds(k);
                return _Str_4110((_local_3 + _arg_2));
            }
            return k;
        }

        public static function _Str_4110(k:Float):String
        {
            var _local_2 = Math.NaN;
            var _local_3 = Math.NaN;
            var _local_4 = Math.NaN;
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_7:String = null;
            if (k > 0)
            {
                _local_2 = (k % 60);
                _local_3 = Math.ffloor(((k % 3600) / 60));
                _local_4 = Math.ffloor((k / (60 * 60)));
                _local_5 = (((_local_4 == 0) ? "00" : _Str_8262(Std.int(_local_4))) + ":");
                _local_6 = (_Str_8262(Std.int(_local_3)) + ":");
                _local_7 = _Str_8262(Std.int(_local_2));
                return (_local_5 + _local_6) + _local_7;
            }
            return "00:00:00";
        }

        static function _Str_8262(k:UInt):String
        {
            if (k < 10)
            {
                return "0" + Std.string(k);
            }
            return Std.string(k);
        }

        public static function timestampToSeconds(k:String):Int
        {
            var _local_2:Array<ASAny> = null;
            if (k != null)
            {
                _local_2 = (cast k.split(":"));
                if (_local_2.length == 3)
                {
                    return ((ASCompat.parseInt(_local_2[0]) * 3600) + (ASCompat.parseInt(_local_2[1]) * 60)) + ASCompat.parseInt(_local_2[2]);
                }
                return ASCompat.parseInt(k);
            }
            return 0;
        }

        public static function _Str_3314(k:String):String
        {
            return Std.string(Timestamp.timestampToSeconds(k));
        }

	public function new() { super(); }
    }

