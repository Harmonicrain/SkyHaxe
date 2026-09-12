package org.openvideoads.util
;
     class StyleUtils 
    {


        public static function _Str_12804(k:String):UInt
        {
            if (!ASCompat.stringAsBool(k))
            {
                return 0xFFFFFF;
            }
            return ASCompat.parseInt(("0x" + k.substr(1)));
        }

        public static function _Str_11604(k:String):Array<ASAny>
        {
            return (cast k.split(" "));
        }

        public static function _Str_26127(k:String, _arg_2:String):String
        {
            var _local_3= _Str_11604(k);
            var _local_4:Float = 0;
            while (_local_4 < _local_3.length)
            {
                if ((Std.is(_local_3[Std.int(_local_4)] , String) && (ASCompat.toString(_local_3[Std.int(_local_4)]).indexOf(_arg_2) == 0)))
                {
                    return ASCompat.asString(_local_3[Std.int(_local_4)] );
                }
                _local_4++;
            }
            return null;
        }

	public function new() {}
    }

