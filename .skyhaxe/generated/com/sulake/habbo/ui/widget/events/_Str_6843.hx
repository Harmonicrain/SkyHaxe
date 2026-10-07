package com.sulake.habbo.ui.widget.events
;
     class _Str_6843 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWCERE_CHANGE_EMAIL_RESULT= "rwcere_change_email_result";

        var _result:Int = 0;

        public function new(k:Int, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(RWCERE_CHANGE_EMAIL_RESULT, _arg_2, _arg_3);
            this._result = k;
        }

        public var result(get,never):Int;
public function  get_result():Int
        {
            return this._result;
        }
    }

