package com.sulake.room.utils
;
     class XMLValidator 
    {
        public static function checkRequiredAttributes(k:ASObject, _arg_2:Array<ASAny>):Bool
        {
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:com.sulake.core.utils.xml.XMLList;
            if (((k == null) || (_arg_2 == null)))
            {
                return false;
            }
            var _local_3:Int;
            if (ASCompat.isXML(k ))
            {
                _local_4 = ((k : com.sulake.core.utils.xml.XML) );
                _local_3 = 0;
                while (_local_3 < _arg_2.length)
                {
                    if (_local_4.attribute(ASCompat.toString(_arg_2[_local_3])).length() == 0)
                    {
                        return false;
                    }
                    _local_3++;
                }
            }
            else
            {
                if (Std.is(k , com.sulake.core.utils.xml.XMLList))
                {
                    _local_5 = ((k : com.sulake.core.utils.xml.XMLList) );
                    _local_3 = 0;
                    while (_local_3 < _arg_2.length)
                    {
                        if (_local_4.attribute(ASCompat.toString(_arg_2[_local_3])).length() == 0)
                        {
                            return false;
                        }
                        _local_3++;
                    }
                }
                else
                {
                    return false;
                }
            }
            return true;
        }

	public function new() {}
    }

