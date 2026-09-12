package com.sulake.habbo.ui.widget.infostand
;
     class TimeFormatUtil 
    {
        public static function _Str_22740(k:Float):String
        {
            var _local_2:UInt = Std.int(Math.ffloor(k));
            var _local_3:UInt = Std.int(Math.ffloor((_local_2 / 3600)));
            var _local_4= ASCompat.toInt(_local_3 * 3600);
            var _local_5:UInt = Std.int((_local_2 - _local_4) / 60);
            var _local_6= ((_local_2 - _local_4) - (_local_5 * 60));
            var _local_7:ASAny = (Std.string(_local_3) + ":");
            var _local_8:ASAny = ((((_local_5 < 10) ? "0" : "") + Std.string(_local_5)) + ":");
            var _local_9= (((_local_6 < 10) ? "0" : "") + Std.string(_local_6));
            return (_local_7 + _local_8) + _local_9;
        }

	public function new() {}
    }

