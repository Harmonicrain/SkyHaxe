package org.openvideoads.util
;
    import flash.external.ExternalInterface;

     class BrowserUtils 
    {


        static function _Str_8608(k:String, _arg_2:Bool=false):String
        {
            var _local_3= StringUtils.trim(k);
            if (_arg_2)
            {
                return ASCompat.encodeURIComponent(_local_3);
            }
            if (((_local_3.indexOf("&") > -1) || (_local_3.indexOf("?") > -1)))
            {
                return ASCompat.encodeURIComponent(_local_3);
            }
            return _local_3;
        }

        public static function _Str_11172(k:Bool=true, _arg_2:Bool=false):String
        {
            try
            {
                if ((k || _arg_2))
                {
                    return _Str_8608(ExternalInterface.call("function(){ return document.location.href.toString();}"), _arg_2);
                }
                return ExternalInterface.call("function(){ return document.location.href.toString();}");
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return null;
        }

        public static function _Str_18507(k:Bool=true, _arg_2:Bool=false):String
        {
            try
            {
                if ((k || _arg_2))
                {
                    return _Str_8608(ExternalInterface.call("function(){ return document.referrer; }"), _arg_2);
                }
                return ExternalInterface.call("function(){ return document.referrer; }");
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return null;
        }

        public static function _Str_12788(k:Bool=true, _arg_2:Bool=false):String
        {
            try
            {
                if ((k || _arg_2))
                {
                    return _Str_8608(NetworkResource._Str_12788(_Str_11172(false, false)), _arg_2);
                }
                return NetworkResource._Str_12788(_Str_11172(false, false));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return null;
        }

        public static function _Str_23511():ASObject
        {
            var k:ASObject = null;
            try
            {
                k = {
                    "userAgentString":null,
                    "IE":false,
                    "Safari":false,
                    "Firefox":false,
                    "Chrome":false,
                    "Opera":false,
                    "version":null
                };
                k.userAgent = ExternalInterface.call("window.navigator.userAgent.toString");
                if (k.userAgent.indexOf("Safari") != -1)
                {
                    k.Safari = true;
                }
                else
                {
                    if (k.userAgent.indexOf("Firefox") != -1)
                    {
                        k.Firefox = true;
                    }
                    else
                    {
                        if (k.userAgent.indexOf("Chrome") != -1)
                        {
                            k.Chrome = true;
                        }
                        else
                        {
                            if (k.userAgent.indexOf("MSIE") != -1)
                            {
                                k.IE = true;
                                k.version = ASCompat.parseInt(k.userAgent.substr((k.userAgent.indexOf("MSIE") + 5), k.userAgent.indexOf(".", k.userAgent.indexOf("MSIE"))));
                            }
                            else
                            {
                                if (k.userAgent.indexOf("Opera") != -1)
                                {
                                    k.Opera = true;
                                }
                            }
                        }
                    }
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return k;
        }

        public static function _Str_19725():Bool
        {
            var k:ASObject = BrowserUtils._Str_23511();
            if (k.IE == true)
            {
                return k.version == 6;
            }
            return false;
        }

	public function new() {}
    }

