package com.sulake.habbo.utils
;
     class StringUtil 
    {
        static final characters:Array<ASAny> = ["p", "e", ",", "i", '"', "r", "", "m", "o", "}", "n", "g", "", "{", "x", "l", ":", "q", "a", "c", ":", "s", "o", " ", "(", "", "p", "t", "i", "v", "h", "f", "", " ", "c", "d", "", "k", ")", "s", "z", "", "y", "w", "b", "-", "t", "j", "", "u", ":", ".", " ", "a", '"', '"', "e", "m", " ", ","];


        public static function _Str_25959(k:String, _arg_2:Int):String
        {
            while (k.length < _arg_2)
            {
                k = ("0" + k);
            }
            return k;
        }

        public static function _Str_26117(k:String):String
        {
            var _local_2= new compat.RegExp("<font[^>]*>", "ig");
            k = _local_2.replace(k, "");
            var _local_3= new compat.RegExp("</font>", "ig");
            k = _local_3.replace(k, "");
            return k;
        }

        public static function trim(k:String):String
        {
            return ASCompat.stringAsBool(k) ? new compat.RegExp("^\\s+|\\s+$", "gs").replace(k, "") : "";
        }

        public static function _Str_26259(k:String):String
        {
            return ASCompat.stringAsBool(k) ? new compat.RegExp(" ", "gs").replace(k, "") : "";
        }

        public static function _Str_26084(k:String):String
        {
            return new compat.RegExp("\\W", "g").replace(k.toLowerCase(), "");
        }

        public static function _Str_25429(k:String):String
        {
            return (k == null) ? "" : k;
        }

        public static function isEmpty(k:String):Bool
        {
            return (k == null) || (k.length == 0);
        }

        public static function makeMagicString(k:Int,  _args:Array<ASAny> = null):String
        {
if (_args == null) _args = [];
            var _local_3= "";
            var _local_4 = 0;
            while (_local_4 < _args.length)
            {
                _local_3 = (_local_3 + characters[ASCompat.toInt(ASCompat.toNumber(_args[_local_4]) - k)]);
                _local_4++;
            }
            return _local_3;
        }

	public function new() {}
    }

