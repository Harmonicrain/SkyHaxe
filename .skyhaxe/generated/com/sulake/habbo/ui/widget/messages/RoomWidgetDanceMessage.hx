package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetDanceMessage extends RoomWidgetMessage 
    {
        public static inline final RWCM_MESSAGE_DANCE= "RWCM_MESSAGE_DANCE";
        public static inline final _Str_13814= 0;
        public static final _Str_17699:Array<ASAny> = [2, 3, 4];

        var _style:Int = 0;

        public function new(k:Int)
        {
            super(RWCM_MESSAGE_DANCE);
            this._style = k;
        }

        public var style(get,never):Int;
public function  get_style():Int
        {
            return this._style;
        }
    }

