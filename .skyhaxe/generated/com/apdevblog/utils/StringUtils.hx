package com.apdevblog.utils
;
     class StringUtils 
    {
        public static var LEFT:Float = (1 << 1);
        public static var RIGHT:Float = (1 << 2);


        public static function objectToString(k:ASObject):String
        {
var _local_4:ASAny  = null;            var _local_4:ASAny = null;
            var _local_2= "";
            var _local_3 = false;
            _local_2 = (_local_2 + "{");
            if (checkNullIteratee(k)) for (_tmp_ in k.___keys())
            {
_local_4 = _tmp_;
                if (!_local_3)
                {
                    _local_3 = true;
                }
                if (Std.is(k[_local_4] , Array))
                {
                    _local_2 = (_local_2 + (((_local_4 + ": [") + k[_local_4]) + "], "));
                }
                else
                {
                    if ((k[_local_4] != null))
                    {
                        _local_2 = (_local_2 + (StringUtils.objectToString(k[_local_4]) + ", "));
                    }
                    else
                    {
                        if (Reflect.isFunction(k[_local_4] ))
                        {
                            _local_2 = (_local_2 + (_local_4 + ": (function), "));
                        }
                        else
                        {
                            _local_2 = (_local_2 + (((_local_4 + ": ") + k[_local_4]) + ", "));
                        }
                    }
                }
            }
            if (_local_3)
            {
                return _local_2.substring(0, -2) + "}";
            }
            return _local_2 + "}";
        }

        public static function _Str_22222(k:String, _arg_2:Float, _arg_3:String, _arg_4:Float=null):String
{
            if (_arg_4 == null) _arg_4 = Math.NaN;
            if (Math.isNaN(_arg_4))
            {
                _arg_4 = StringUtils.LEFT;
            }
            if (((k.length >= _arg_2) || (!(_arg_3.length == 1))))
            {
                return k;
            }
            var _local_5= "";
            var _local_6:Float = 0;
            while (_local_6 < (_arg_2 - k.length))
            {
                _local_5 = (_local_5 + _arg_3);
                _local_6++;
            }
            var _local_7= ((_arg_4 == StringUtils.LEFT) ? (_local_5 + k) : (k + _local_5));
            return _local_7;
        }

        public static function replace(k:String, _arg_2:String, _arg_3:String):String
        {
            return k.split(_arg_2).join(_arg_3);
        }

        public static function trim(k:String=null):String
        {
            if (k == null)
            {
                return "";
            }

            while (k.charAt(0) == " ")
            {
                k = k.substring(1);
            }
            while (k.charAt((k.length - 1)) == " ")
            {
                k = k.substring(0, (k.length - 1));
            }
            return k;
        }

        public static function _Str_25338(k:String):String
        {
            return k.substr(0, 1).toUpperCase() + k.substr(1).toLowerCase();
        }

        public static function _Str_26378(k:String):String
        {
            var _local_2= "";
            var _local_3:Array<ASAny> = (cast k.split(" "));
            var _local_4 = 0;
            while (_local_4 < _local_3.length)
            {
                _local_2 = (_local_2 + StringUtils._Str_25338(_local_3[_local_4]));
                if (_local_4 < (_local_3.length - 1))
                {
                    _local_2 = (_local_2 + " ");
                }
                _local_4++;
            }
            return _local_2;
        }

	public function new() {}
    }

