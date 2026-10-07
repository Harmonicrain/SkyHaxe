package com.sulake.habbo.ui.widget.events
;
     class _Str_9658 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWUE_DANCE= "RWUE_DANCE";

        var _style:Int = 0;

        public function new(k:Int, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(RWUE_DANCE, _arg_2, _arg_3);
            this._style = k;
        }

        public var style(get,never):Int;
public function  get_style():Int
        {
            return this._style;
        }
    }

