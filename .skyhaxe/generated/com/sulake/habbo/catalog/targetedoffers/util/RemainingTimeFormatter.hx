package com.sulake.habbo.catalog.targetedoffers.util
;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.habbo.localization.IHabboLocalizationManager;

     class RemainingTimeFormatter 
    {


        public static function _Str_25649(k:IHabboLocalizationManager, _arg_2:UInt):String
        {
            var _local_3= Std.int(Math.ffloor(((_arg_2 / 60) / 60)));
            if (_local_3 > 24)
            {
                return FriendlyTime.format(k, _arg_2, "", 1);
            }
            if (_local_3 > 0)
            {
                return FriendlyTime.getLocalization(k, "friendlytime.hours.short", _local_3);
            }
            return _Str_9437(ASCompat.toInt(_arg_2));
        }

        public static function _Str_9437(k:Int):String
        {
            var _local_2= Std.int(Math.ffloor(((k / 60) / 60)));
            var _local_3= Std.int(Math.ffloor(((k - ((_local_2 * 60) * 60)) / 60)));
            var _local_4= ((k - ((_local_2 * 60) * 60)) - (_local_3 * 60));
            var _local_5= "";
            if (_local_2 > 0)
            {
                _local_5 = (Std.string(_local_2) + ":");
            }
            _local_5 = ((_local_3 < 10) ? ((_local_5 + "0") + Std.string(_local_3)) : (_local_5 + Std.string(_local_3)));
            if (_local_2 == 0)
            {
                _local_5 = (_local_5 + ":");
                _local_5 = ((_local_4 < 10) ? ((_local_5 + "0") + Std.string(_local_4)) : (_local_5 + Std.string(_local_4)));
            }
            return _local_5;
        }

	public function new() {}
    }

