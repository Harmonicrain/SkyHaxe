package com.sulake.habbo.ui.widget.events
;
     class _Str_3962 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWPPBE_CONFIRM_PET_BREEDING_RESULT= "RWPPBE_CONFIRM_PET_BREEDING_RESULT";
        public static inline final _Str_5196= 0;
        public static inline final _Str_16705= 1;
        public static inline final _Str_18855= 2;
        public static inline final INVALID_NAME= 3;

        var _Str_6143:Int = 0;
        var _result:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(RWPPBE_CONFIRM_PET_BREEDING_RESULT, _arg_3, _arg_4);
            this._Str_6143 = k;
            this._result = _arg_2;
        }

        public var breedingNestStuffId(get,never):Int;
public function  get_breedingNestStuffId():Int
        {
            return this._Str_6143;
        }

        public var result(get,never):Int;
public function  get_result():Int
        {
            return this._result;
        }
    }

