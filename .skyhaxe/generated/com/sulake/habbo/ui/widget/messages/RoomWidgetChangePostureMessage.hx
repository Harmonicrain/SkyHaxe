package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetChangePostureMessage extends RoomWidgetMessage 
    {
        public static inline final RWCPM_MESSAGE_CHANGE_POSTURE= "RWCPM_MESSAGE_CHANGE_POSTURE";
        public static inline final _Str_1553= 0;
        public static inline final _Str_2016= 1;

        var _posture:Int = 0;

        public function new(k:Int)
        {
            super(RWCPM_MESSAGE_CHANGE_POSTURE);
            this._posture = k;
        }

        public var posture(get,never):Int;
public function  get_posture():Int
        {
            return this._posture;
        }
    }

