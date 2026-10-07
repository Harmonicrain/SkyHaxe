package org.openvideoads.util
;
     class StringUtils 
    {


        public static function _Str_26296(k:String, _arg_2:Float):String
        {
            if (k != null)
            {
                return k.substr(0, Std.int(_arg_2));
            }
            return k;
        }

        public static function _Str_26249(k:String, _arg_2:Int):Float
        {
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            var _local_5 = Math.NaN;
            var _local_6 = 0;
            if (k != null)
            {
                _local_3 = (cast k.split("."));
                _local_4 = 0;
                _local_5 = 0;
                _local_6 = (_local_3.length - 1);
                while (_local_6 >= 0)
                {
                    if (_local_5 == 0)
                    {
                        _local_4 = ASCompat.toInt(_local_3[_local_6]);
                        _local_5 = _arg_2;
                    }
                    else
                    {
                        _local_4 = ASCompat.toInt(_local_4 + (ASCompat.toNumber(_local_3[_local_6]) * _local_5));
                    }
                    _local_5 = (_local_5 * 10);
                    _local_6--;
                }
                return _local_4;
            }
            return 0;
        }

        public static function _Str_2810(k:ASAny):Bool
        {
            if (((!(k == null)) && (!(k == /*undefined*/null))))
            {
                if ((Std.is(k , String) || (ASCompat.typeOf(k) == "xml")))
                {
                    return k.toUpperCase() == "TRUE";
                }
                if (Std.is(k , Bool))
                {
                    return k;
                }
            }
            return false;
        }

        public static function _Str_24234(k:ASAny):Float
        {
            if (Std.is(k , Float))
            {
                return ASCompat.toNumber(k);
            }
            if (Std.is(k , String))
            {
                return ASCompat.toNumber(k);
            }
            return -1;
        }

        public static function _Str_22149(k:ASAny, _arg_2:String):Bool
        {
            var _local_3:ASObject = null;
            var _local_4:String = null;
            var _local_5:String = null;
            if (Std.is(k , Array))
            {
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_3  = _tmp_;
                    if (Std.is(_local_3 , String))
                    {
                        if (_Str_2576(ASCompat.asString(_local_3 ), _arg_2))
                        {
                            return true;
                        }
                    }
                }
            }
            else
            {
                if (Std.is(k , String))
                {
                    if ((StringUtils.isEmpty(k) || StringUtils.isEmpty(_arg_2)))
                    {
                        return false;
                    }
                    _local_4 = k.toUpperCase();
                    _local_5 = _arg_2.toUpperCase();
                    return _local_4.indexOf(_local_5) > -1;
                }
            }
            return false;
        }

        public static function _Str_2576(k:String, _arg_2:String):Bool
        {
            if (((k == null) && (_arg_2 == null)))
            {
                return true;
            }
            if ((((k == null) && (!(_arg_2 == null))) || ((!(k == null)) && (_arg_2 == null))))
            {
                return false;
            }
            return k.toUpperCase() == _arg_2.toUpperCase();
        }

        public static function trim(k:String):String
        {
            return ASCompat.stringAsBool(k) ? new compat.RegExp("^\\s+|\\s+$", "gs").replace(k, "") : "";
        }

        public static function isEmpty(k:String):Bool
        {
            if (k == null)
            {
                return true;
            }
            return StringUtils.trim(k).length == 0;
        }

        public static function _Str_21602(k:String):String
        {
            var _local_2:String = null;
            var _local_3:Array<ASAny> = null;
            if (k != null)
            {
                _local_2 = k;
                _local_2 = _local_2.split("\t").join(" ");
                _local_2 = _local_2.split("\r").join(" ");
                _local_2 = _local_2.split("\n").join(" ");
                return _local_2;
            }
            return k;
        }

        public static function _Str_26304(k:String):String
        {
            var _local_3:Array<ASAny> = null;
            var _local_2= k;
            _local_3 = (cast _local_2.split(" "));
            var _local_4:UInt = 0;
            while (_local_4 < (_local_3.length : UInt))
            {
                if (_local_3[ASCompat.toInt(_local_4)] == "")
                {
                    _local_3.splice(ASCompat.toInt(_local_4), 1);
                    _local_4--;
                }
                _local_4++;
            }
            _local_2 = _local_3.join(" ");
            return _local_2;
        }

        public static function _Str_26054(k:String, _arg_2:String, _arg_3:String):ASObject
        {
            var _local_6 = 0;
            var _local_7:Array<ASAny> = null;
            var _local_4:ASObject = new ASObject();
            var _local_5:Array<ASAny> = (cast k.split(_arg_2));
            if (_local_5.length > 0)
            {
                _local_6 = 0;
                while (_local_6 < _local_5.length)
                {
                    _local_7 = _local_5[_local_6].split(_arg_3);
                    if (_local_7.length == 2)
                    {
                        _local_4[_local_7[0]] = _local_7[1];
                    }
                    _local_6++;
                }
            }
            return _local_4;
        }

        public static function _Str_26335(k:String, _arg_2:String, _arg_3:String):String
        {
            if ((StringUtils._Str_17635(k, _arg_3) || StringUtils._Str_4861(_arg_2, _arg_3)))
            {
                return k + _arg_2;
            }
            return (k + _arg_3) + _arg_2;
        }

        public static function _Str_4861(k:String, _arg_2:String):Bool
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return false;
            }
            return StringUtils.trim(k).toUpperCase().indexOf(_arg_2.toUpperCase()) == 0;
        }

        public static function _Str_17635(k:String, _arg_2:String):Bool
        {
            if (k == null)
            {
                return false;
            }
            return k.lastIndexOf(_arg_2) == (k.length - _arg_2.length);
        }

        public static function _Str_20351(k:String, _arg_2:String):String
        {
            var _local_3= new compat.RegExp("{quote}", "g");
            return _local_3.replace(k, _arg_2);
        }

        public static function _Str_22866(k:String):String
        {
            return new compat.RegExp("\\n", "g").replace(k, "");
        }

        public static function _Str_22738(k:String):String
        {
            return new compat.RegExp("(['\\\\])", "g").replace(k, "\\$1");
        }

        public static function _Str_26006(k:String, _arg_2:String):Bool
        {
            if (k != null)
            {
                if (_arg_2 != null)
                {
                    if (((!StringUtils.isEmpty(k)) && (!StringUtils.isEmpty(_arg_2))))
                    {
                        return k == _arg_2;
                    }
                }
            }
            return false;
        }

        public static function _Str_26146(k:String, _arg_2:String):String
        {
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                if (_local_3 < _arg_2.length)
                {
                    if (k.charAt(_local_3) != _arg_2.charAt(_local_3))
                    {
                        return ((((("difference: " + Std.string(_local_3)) + ", (") + Std.string(k.charCodeAt(_local_3))) + ") != (") + Std.string(_arg_2.charCodeAt(_local_3))) + ")";
                    }
                }
                else
                {
                    return "difference: string1 longer";
                }
                _local_3++;
            }
            if (k.length < _arg_2.length)
            {
                return "difference: string2 is longer";
            }
            return "difference: identical";
        }

        public static function _Str_26338(k:String):String
        {
            var _local_2= new compat.RegExp("'", "g");
            return _local_2.replace(k, '"');
        }

        public static function _Str_25987(k:String):String
        {
            return new compat.RegExp("(['\\\\])", "g").replace(k, "\\$1");
        }

        public static function _Str_26323(k:String):String
        {
            var _local_2= "";
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                if (k.charAt(_local_3) == '"')
                {
                    _local_2 = (_local_2 + '"');
                }
                else
                {
                    _local_2 = (_local_2 + k.charAt(_local_3));
                }
                _local_3++;
            }
            return _local_2;
        }

	public function new() {}
    }

