package com.sulake.habbo.catalog.purse
;
    import com.sulake.core.runtime.IHabboConfigurationManager;

     class ActivityPointTypeEnum 
    {
        public static inline final DUCKET= 0;
        public static inline final SUBSCRIPTION_GIFT_POINTS= 3;
        public static inline final LOYALTY= 5;
        public static inline final SEASONAL_1= 101;
        public static inline final SEASONAL_2= 102;
        public static inline final SEASONAL_3= 103;
        public static inline final SEASONAL_4= 104;
        public static inline final SEASONAL_5= 105;
        public static inline final NO_OP_1= 1;
        public static inline final NO_OP_2= 2;
        public static inline final NO_OP_4= 4;


        public static function values():Array<ASAny>
        {
            return [DUCKET, SEASONAL_1, SEASONAL_2, SEASONAL_3, SEASONAL_4, SEASONAL_5, NO_OP_1, NO_OP_2, NO_OP_4];
        }

        public static function getIconStyleFor(k:Int, _arg_2:IHabboConfigurationManager, _arg_3:Bool, _arg_4:Bool=false):Int
        {
            var _local_5:String = null;
            if (k == -1)
            {
                return _arg_3 ? 34 : 35;
            }
            if (k == DUCKET)
            {
                return _arg_3 ? 32 : 33;
            }
            if (k == SUBSCRIPTION_GIFT_POINTS)
            {
                return _arg_3 ? 36 : 37;
            }
            if (k == LOYALTY)
            {
                if (_arg_2.getBoolean("diamonds.enabled"))
                {
                    return _arg_3 ? 41 : 42;
                }
                return _arg_3 ? 53 : 54;
            }
            _local_5 = (((("currencyiconstyle." + (_arg_3 ? "big" : "small")) + ".") + Std.string(k)) + (_arg_4 ? ".combo" : ""));
            return _arg_2.getInteger(_local_5, 0);
        }

        public static function isVisible(k:Int):Bool
        {
            if (([NO_OP_1, NO_OP_2, NO_OP_4] : Array<Dynamic>).indexOf(k) != 1)
            {
                return false;
            }
            return true;
        }

	public function new() {}
    }

