package com.sulake.habbo.ui.widget.events
;
     class _Str_6300 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWFCE_FLOOD_CONTROL= "RWFCE_FLOOD_CONTROL";

        var _seconds:Int = 0;

        public function new(k:Int)
        {
            super(RWFCE_FLOOD_CONTROL, false, false);
            this._seconds = k;
        }

        public var seconds(get,never):Int;
public function  get_seconds():Int
        {
            return this._seconds;
        }
    }

