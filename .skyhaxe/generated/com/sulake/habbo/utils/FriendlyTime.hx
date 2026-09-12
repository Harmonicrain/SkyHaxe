package com.sulake.habbo.utils
;
    import com.sulake.habbo.localization.IHabboLocalizationManager;

     class FriendlyTime 
    {
        static inline final MINUTE:UInt = 60;
        static final HOUR:UInt = (60 * MINUTE);//3600
        static final DAY:UInt = (24 * HOUR);//86400
        static final WEEK:UInt = (7 * DAY);//604800
        static final MONTH:UInt = (30 * DAY);//0x278D00
        static final YEAR:UInt = (365 * DAY);//31536000


        public static function format(localization:IHabboLocalizationManager, seconds:Float, key:String="", threshold:Int=3):String
        {
            if (seconds > (threshold * YEAR))
            {
                return getLocalization(localization, ("friendlytime.years" + key), Std.int(Math.fround((seconds / YEAR))));
            }
            if (seconds > (threshold * MONTH))
            {
                return getLocalization(localization, ("friendlytime.months" + key), Std.int(Math.fround((seconds / MONTH))));
            }
            if (seconds > (threshold * DAY))
            {
                return getLocalization(localization, ("friendlytime.days" + key), Std.int(Math.fround((seconds / DAY))));
            }
            if (seconds > (threshold * HOUR))
            {
                return getLocalization(localization, ("friendlytime.hours" + key), Std.int(Math.fround((seconds / HOUR))));
            }
            if (seconds > (threshold * MINUTE))
            {
                return getLocalization(localization, ("friendlytime.minutes" + key), Std.int(Math.fround((seconds / MINUTE))));
            }
            return getLocalization(localization, ("friendlytime.seconds" + key), Std.int(Math.fround(seconds)));
        }

        public static function shortFormat(k:IHabboLocalizationManager, _arg_2:Float, _arg_3:String="", _arg_4:Int=3):String
        {
            if (_arg_2 > (_arg_4 * YEAR))
            {
                return getLocalization(k, ("friendlytime.years.short" + _arg_3), Std.int(Math.fround((_arg_2 / YEAR))));
            }
            if (_arg_2 > (_arg_4 * MONTH))
            {
                return getLocalization(k, ("friendlytime.months.short" + _arg_3), Std.int(Math.fround((_arg_2 / MONTH))));
            }
            if (_arg_2 > (_arg_4 * DAY))
            {
                return getLocalization(k, ("friendlytime.days.short" + _arg_3), Std.int(Math.fround((_arg_2 / DAY))));
            }
            if (_arg_2 > (_arg_4 * HOUR))
            {
                return getLocalization(k, ("friendlytime.hours.short" + _arg_3), Std.int(Math.fround((_arg_2 / HOUR))));
            }
            if (_arg_2 > (_arg_4 * MINUTE))
            {
                return getLocalization(k, ("friendlytime.minutes.short" + _arg_3), Std.int(Math.fround((_arg_2 / MINUTE))));
            }
            return getLocalization(k, ("friendlytime.seconds.short" + _arg_3), Std.int(Math.fround(_arg_2)));
        }

        public static function getLocalization(k:IHabboLocalizationManager, _arg_2:String, _arg_3:Int):String
        {
            return k.getLocalizationWithParams(_arg_2, _arg_2, ["amount", Std.string(_arg_3)]);
        }

	public function new() {}
    }

