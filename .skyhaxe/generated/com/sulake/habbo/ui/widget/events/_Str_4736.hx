package com.sulake.habbo.ui.widget.events
;
     class _Str_4736 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWPBRE_PET_BREEDING_RESULT= "RWPBRE_PET_BREEDING_RESULT";

        var _Str_3111:_Str_3801;
        var _resultData2:_Str_3801;

        public function new(k:_Str_3801, _arg_2:_Str_3801, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(RWPBRE_PET_BREEDING_RESULT, _arg_3, _arg_4);
            this._Str_3111 = k;
            this._resultData2 = _arg_2;
        }

        public var _Str_3713(get,never):_Str_3801;
public function  get__Str_3713():_Str_3801
        {
            return this._Str_3111;
        }

        public var resultData2(get,never):_Str_3801;
public function  get_resultData2():_Str_3801
        {
            return this._resultData2;
        }
    }

