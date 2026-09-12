package com.sulake.habbo.friendlist
;
     class RelationshipStatusEnum 
    {
        public static inline final NONE= 0;
        public static inline final _Str_9205= 1;
        public static inline final _Str_8388= 2;
        public static inline final _Str_8824= 3;
        static final _Str_17215:Array<ASAny> = ["none", "heart", "smile", "bobba"];
		static final relationshipColors:Array<ASAny> = [0x6e6b67, 0xFA61A5, 0xEBEB3F, 0xA1A1A1];


        public static function _Str_7401(k:Int):String
        {
            return _Str_17215[k];
        }
		
		public static function relationshipColor(k:Int):Int
		{
			return ASCompat.toInt(relationshipColors[k]);
		}

        public static var _Str_15184(get,never):Array<ASAny>;
public static function  get__Str_15184():Array<ASAny>
        {
            return [_Str_9205, _Str_8388, _Str_8824];
        }

        public static function _Str_25054(k:String):Int
        {
            var _local_2 = 0;
            final _iter_ = _Str_15184; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toInt(_tmp_);
                if (_Str_7401(_local_2) == k)
                {
                    return _local_2;
                }
            }
            return NONE;
        }

	public function new() {}
    }

