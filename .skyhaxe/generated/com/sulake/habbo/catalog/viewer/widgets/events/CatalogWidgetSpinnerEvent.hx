package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetSpinnerEvent extends Event 
    {
        public static inline final CWSE_VALUE_CHANGED= "CWSE_VALUE_CHANGED";
        public static inline final CWSE_RESET= "CWSE_RESET";
        public static inline final CWSE_SHOW= "CWSE_SHOW";
        public static inline final CWSE_HIDE= "CWSE_HIDE";
        public static inline final CWSE_SET_MAX= "CWSE_SET_MAX";
        public static inline final CWSE_SET_MIN= "CWSE_SET_MIN";

        var _value:Int = 0;
        var _skipSteps:Array<ASAny>;

        public function new(k:String, _arg_2:Int=1, _arg_3:Array<ASAny>=null)
        {
            super(k);
            this._value = _arg_2;
            this._skipSteps = _arg_3;
        }

        public var value(get,never):Int;
public function  get_value():Int
        {
            return this._value;
        }

        public var _Str_21173(get,never):Array<ASAny>;
public function  get__Str_21173():Array<ASAny>
        {
            return this._skipSteps;
        }
    }

