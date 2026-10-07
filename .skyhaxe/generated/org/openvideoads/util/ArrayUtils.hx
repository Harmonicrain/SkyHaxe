package org.openvideoads.util
;
    import adobe.serialization.json.JSON;

     class ArrayUtils 
    {


        public static function _Str_8734(k:ASObject):Array<ASAny>
        {
            var _local_2:ASAny = null;
            if (Std.is(k , Array))
            {
                return ASCompat.dynamicAs(k , Array);
            }
            if (Std.is(k , String))
            {
                _local_2 = adobe.serialization.json.JSON.decode(ASCompat.asString(k ));
                if (Std.is(_local_2 , Array))
                {
                    return _local_2;
                }
                if (Std.is(_local_2 , String))
                {
                    return _local_2.split(",");
                }
            }
            return new Array<ASAny>();
        }

        public static function toUpperCase(k:Array<ASAny>):Array<ASAny>
        {
            var _local_3 = 0;
            var _local_2= new Array<ASAny>();
            if (k != null)
            {
                _local_3 = 0;
                while (_local_3 < k.length)
                {
                    if (Std.is(k[_local_3] , String))
                    {
                        _local_2.push(k[_local_3].toUpperCase());
                    }
                    else
                    {
                        _local_2.push(k[_local_3].toJSObject());
                    }
                    _local_3++;
                }
            }
            return _local_2;
        }

        public static function _Str_6975(k:Array<ASAny>):Array<ASAny>
        {
            var _local_3 = 0;
            var _local_2= new Array<ASAny>();
            if (k != null)
            {
                _local_3 = 0;
                while (_local_3 < k.length)
                {
                    _local_2.push(k[_local_3].toJSObject());
                    _local_3++;
                }
            }
            return _local_2;
        }

	public function new() {}
    }

