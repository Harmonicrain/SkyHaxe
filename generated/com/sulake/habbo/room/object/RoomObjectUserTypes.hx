package com.sulake.habbo.room.object
;

     class RoomObjectUserTypes 
    {
        public static inline final USER= "user";
        public static inline final PET= "pet";
        public static inline final BOT= "bot";
        public static inline final RENTABLE_BOT= "rentable_bot";
        public static inline final MONSTERPLANT= "monsterplant";
        static final _IDS:ASDictionary<ASAny,ASAny> = new ASDictionary();


        public static function _Str_19576(k:String):Int
        {
            return ASCompat.toInt(_IDS[k]);
        }

        public static function getName(k:Int):String
        {
            var _local_2:String;
            for (_tmp_ in _IDS.keys())
            {
var _local_2:String  = _tmp_;
                if (_IDS[_local_2] == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public static function getVisualizationType(k:String):String
        {
            switch (k)
            {
                case BOT
                   | RENTABLE_BOT:
                    return USER;
                default:
                    return k;
            }
        }

	public function new() {}

	static final ___init = {

        {
            _IDS[USER] = 1;
            _IDS[PET] = 2;
            _IDS[BOT] = 3;
            _IDS[RENTABLE_BOT] = 4;
        }

	null;
	};
    }

