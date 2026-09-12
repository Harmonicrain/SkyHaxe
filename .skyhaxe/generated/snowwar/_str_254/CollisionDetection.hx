package snowwar._str_254
;
     class CollisionDetection 
    {
        public static inline final _SafeStr_22164= 0;
        public static inline final _SafeStr_22165= 1;
        public static inline final _SafeStr_18853= 2;
        public static inline final _SafeStr_22166= 3;
        public static inline final _SafeStr_22167= 4;
        public static inline final _SafeStr_22168= 0;
        public static inline final _SafeStr_22169= 1;
        public static inline final _SafeStr_22170= 2;
        public static inline final _SafeStr_22171= 3;
        public static inline final _SafeStr_22172= 4;
        public static inline final _SafeStr_22173= 5;

        public static function _SafeStr_18806(k:_SafeStr_4030, _arg_2:_SafeStr_4030):Bool
        {
            if (_arg_2 == k)
            {
                return false;
            }
            switch (_arg_2.boundingType)
            {
                case _SafeStr_22164:
                    
                case _SafeStr_22165:
                    
                case _SafeStr_18853:
                    switch (k.boundingType)
                    {
                        case _SafeStr_22165:
                            if (_SafeStr_22174(k, _arg_2))
                            {
                                return true;
                            }
                            
                        case _SafeStr_18853:
                            if (_SafeStr_22175(k, _arg_2))
                            {
                                return true;
                            }
                            
                        case _SafeStr_22167:
                            if (_SafeStr_22176(_arg_2, k))
                            {
                                return true;
                            }
                            
                    }
                    
                case _SafeStr_22167:
                    switch (k.boundingType)
                    {
                        case _SafeStr_22165:
                            if (_SafeStr_22177(k, _arg_2))
                            {
                                return true;
                            }
                            
                        case _SafeStr_18853:
                            if (_SafeStr_22176(k, _arg_2))
                            {
                                return true;
                            }
                            
                        case _SafeStr_22167:
                            if (_SafeStr_22178(k, _arg_2))
                            {
                                return true;
                            }
                            
                    }
                    
                case _SafeStr_22166:
                    if (k.boundingType == _SafeStr_22165)
                    {
                        if (_SafeStr_22179(k, _arg_2))
                        {
                            return true;
                        }
                    }
                    
            }
            return false;
        }

        static function _SafeStr_22174(k:_SafeStr_4030, _arg_2:_SafeStr_4030):Bool
        {
            return k.location3D._SafeStr_18791(_arg_2.location3D, ASCompat.toInt(_arg_2.boundingData[0]));
        }

        static function _SafeStr_22179(k:_SafeStr_4030, _arg_2:_SafeStr_4030):Bool
        {
            var _local_3= _arg_2.boundingData;
            if (((((k.location3D.x > (_arg_2.location3D.x + _local_3[0])) && (k.location3D.x < (_arg_2.location3D.x + _local_3[2]))) && (k.location3D.y > (_arg_2.location3D.y + _local_3[1]))) && (k.location3D.y < (_arg_2.location3D.y + _local_3[3]))))
            {
                return true;
            }
            return false;
        }

        static function _SafeStr_22175(k:_SafeStr_4030, _arg_2:_SafeStr_4030):Bool
        {
            return k.location3D._SafeStr_18791(_arg_2.location3D, ASCompat.toInt(k.boundingData[0] + _arg_2.boundingData[0]));
        }

        static function _SafeStr_22177(k:_SafeStr_4030, _arg_2:_SafeStr_4030):Bool
        {
            var _local_3= _SafeStr_22078((_arg_2.location3D.x - k.location3D.x));
            if (_local_3 > _arg_2.boundingData[5])
            {
                return false;
            }
            var _local_4= _SafeStr_22078((_arg_2.location3D.y - k.location3D.y));
            if (_local_4 > _arg_2.boundingData[5])
            {
                return false;
            }
            var _local_5= (_arg_2.location3D.x + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19045(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[3])) / 0x0100)));
            var _local_6= (_arg_2.location3D.y + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19046(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[3])) / 0x0100)));
            if (Location._SafeStr_18786(_local_5, _local_6, k.location3D.x, k.location3D.y, ASCompat.toInt(_arg_2.boundingData[0])))
            {
                return true;
            }
            if (Location._SafeStr_18786(_arg_2.location3D.x, _arg_2.location3D.y, k.location3D.x, k.location3D.y, ASCompat.toInt(_arg_2.boundingData[1])))
            {
                return true;
            }
            var _local_7= (_arg_2.location3D.x + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19045(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[4])) / 0x0100)));
            var _local_8= (_arg_2.location3D.y + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19046(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[4])) / 0x0100)));
            if (Location._SafeStr_18786(_local_7, _local_8, k.location3D.x, k.location3D.y, ASCompat.toInt(_arg_2.boundingData[2])))
            {
                return true;
            }
            return false;
        }

        static function _SafeStr_22176(k:_SafeStr_4030, _arg_2:_SafeStr_4030):Bool
        {
            var _local_3= _SafeStr_22078((_arg_2.location3D.x - k.location3D.x));
            if (_local_3 > (k.boundingData[0] + _arg_2.boundingData[5]))
            {
                return false;
            }
            var _local_4= _SafeStr_22078((_arg_2.location3D.y - k.location3D.y));
            if (_local_4 > (k.boundingData[0] + _arg_2.boundingData[5]))
            {
                return false;
            }
            var _local_5= (_arg_2.location3D.x + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19045(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[3])) / 0x0100)));
            var _local_6= (_arg_2.location3D.y + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19046(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[3])) / 0x0100)));
            if (Location._SafeStr_18786(_local_5, _local_6, k.location3D.x, k.location3D.y, ASCompat.toInt(_arg_2.boundingData[0] + k.boundingData[0])))
            {
                return true;
            }
            if (Location._SafeStr_18786(_arg_2.location3D.x, _arg_2.location3D.y, k.location3D.x, k.location3D.y, ASCompat.toInt(_arg_2.boundingData[1] + k.boundingData[0])))
            {
                return true;
            }
            var _local_7= (_arg_2.location3D.x + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19045(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[4])) / 0x0100)));
            var _local_8= (_arg_2.location3D.y + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19046(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[4])) / 0x0100)));
            if (Location._SafeStr_18786(_local_7, _local_8, k.location3D.x, k.location3D.y, ASCompat.toInt(_arg_2.boundingData[2] + k.boundingData[0])))
            {
                return true;
            }
            return false;
        }

        static function _SafeStr_22178(k:_SafeStr_4030, _arg_2:_SafeStr_4030):Bool
        {
            var _local_3= _SafeStr_22078((_arg_2.location3D.x - k.location3D.x));
            if (_local_3 > (k.boundingData[_SafeStr_22173] + _arg_2.boundingData[_SafeStr_22173]))
            {
                return false;
            }
            var _local_4= _SafeStr_22078((_arg_2.location3D.y - k.location3D.y));
            if (_local_4 > (k.boundingData[_SafeStr_22173] + _arg_2.boundingData[_SafeStr_22173]))
            {
                return false;
            }
            var _local_5= (k.location3D.x + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19045(k.direction360.index()) * ASCompat.toNumber(k.boundingData[_SafeStr_22171])) / 0x0100)));
            var _local_6= (k.location3D.y + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19046(k.direction360.index()) * ASCompat.toNumber(k.boundingData[_SafeStr_22171])) / 0x0100)));
            var _local_7= (_arg_2.location3D.x + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19045(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[_SafeStr_22171])) / 0x0100)));
            var _local_8= (_arg_2.location3D.y + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19046(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[_SafeStr_22171])) / 0x0100)));
            if (Location._SafeStr_18786(_local_5, _local_6, _local_7, _local_8, ASCompat.toInt(k.boundingData[_SafeStr_22168] + _arg_2.boundingData[_SafeStr_22168])))
            {
                return true;
            }
            if (Location._SafeStr_18786(_local_5, _local_6, _arg_2.location3D.x, _arg_2.location3D.y, ASCompat.toInt(k.boundingData[_SafeStr_22168] + _arg_2.boundingData[_SafeStr_22169])))
            {
                return true;
            }
            var _local_9= (_arg_2.location3D.x + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19045(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[_SafeStr_22172])) / 0x0100)));
            var _local_10= (_arg_2.location3D.y + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19046(_arg_2.direction360.index()) * ASCompat.toNumber(_arg_2.boundingData[_SafeStr_22172])) / 0x0100)));
            if (Location._SafeStr_18786(_local_5, _local_6, _local_9, _local_10, ASCompat.toInt(k.boundingData[_SafeStr_22168] + _arg_2.boundingData[_SafeStr_22170])))
            {
                return true;
            }
            if (Location._SafeStr_18786(k.location3D.x, k.location3D.y, _local_7, _local_8, ASCompat.toInt(k.boundingData[_SafeStr_22169] + _arg_2.boundingData[_SafeStr_22168])))
            {
                return true;
            }
            if (Location._SafeStr_18786(k.location3D.x, k.location3D.y, _arg_2.location3D.x, _arg_2.location3D.y, ASCompat.toInt(k.boundingData[_SafeStr_22169] + _arg_2.boundingData[_SafeStr_22169])))
            {
                return true;
            }
            if (Location._SafeStr_18786(k.location3D.x, k.location3D.y, _local_9, _local_10, ASCompat.toInt(k.boundingData[_SafeStr_22169] + _arg_2.boundingData[_SafeStr_22170])))
            {
                return true;
            }
            var _local_11= (k.location3D.x + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19045(k.direction360.index()) * ASCompat.toNumber(k.boundingData[_SafeStr_22172])) / 0x0100)));
            var _local_12= (k.location3D.y + _SafeStr_4667._SafeStr_18698((ASCompat.toNumber(Direction360.__as3_static__SafeStr_19046(k.direction360.index()) * ASCompat.toNumber(k.boundingData[_SafeStr_22172])) / 0x0100)));
            if (Location._SafeStr_18786(_local_11, _local_12, _local_7, _local_8, ASCompat.toInt(k.boundingData[_SafeStr_22170] + _arg_2.boundingData[_SafeStr_22168])))
            {
                return true;
            }
            if (Location._SafeStr_18786(_local_11, _local_12, _arg_2.location3D.x, _arg_2.location3D.y, ASCompat.toInt(k.boundingData[_SafeStr_22170] + _arg_2.boundingData[_SafeStr_22169])))
            {
                return true;
            }
            if (Location._SafeStr_18786(_local_11, _local_12, _local_9, _local_10, ASCompat.toInt(k.boundingData[_SafeStr_22170] + _arg_2.boundingData[_SafeStr_22170])))
            {
                return true;
            }
            return false;
        }

        static function _SafeStr_22078(k:Int):Int
        {
            if (k < 0)
            {
                return -k;
            }
            return k;
        }

	public function new() {}
    }

