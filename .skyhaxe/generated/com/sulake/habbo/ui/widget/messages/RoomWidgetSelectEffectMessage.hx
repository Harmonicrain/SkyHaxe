package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetSelectEffectMessage extends RoomWidgetMessage 
    {
        public static inline final RWCM_MESSAGE_SELECT_EFFECT= "RWCM_MESSAGE_SELECT_EFFECT";
        public static inline final RWCM_MESSAGE_UNSELECT_EFFECT= "RWCM_MESSAGE_UNSELECT_EFFECT";
        public static inline final RWCM_MESSAGE_UNSELECT_ALL_EFFECTS= "RWCM_MESSAGE_UNSELECT_ALL_EFFECTS";

        var _effectType:Int = 0;

        public function new(k:String, _arg_2:Int=-1)
        {
            super(k);
            this._effectType = _arg_2;
        }

        public var effectType(get,never):Int;
public function  get_effectType():Int
        {
            return this._effectType;
        }
    }

