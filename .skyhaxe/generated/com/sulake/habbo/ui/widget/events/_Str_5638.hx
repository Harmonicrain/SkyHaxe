package com.sulake.habbo.ui.widget.events
;
     class _Str_5638 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWUEUE_UPDATE_EFFECTS= "RWUEUE_UPDATE_EFFECTS";

        var _effects:Array<ASAny>;

        public function new(k:Array<ASAny>=null, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(RWUEUE_UPDATE_EFFECTS, _arg_2, _arg_3);
            this._effects = k;
        }

        public var effects(get,never):Array<ASAny>;
public function  get_effects():Array<ASAny>
        {
            return this._effects;
        }
    }

