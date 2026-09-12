package com.sulake.habbo.ui.widget.events
;
     class _Str_4656 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWPUE_CREDIT_BALANCE= "RWPUE_CREDIT_BALANCE";
        public static inline final RWPUE_PIXEL_BALANCE= "RWPUE_PIXEL_BALANCE";
        public static inline final RWPUE_SHELL_BALANCE= "RWPUE_SHELL_BALANCE";

        var _balance:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._balance = _arg_2;
        }

        public var balance(get,never):Int;
public function  get_balance():Int
        {
            return this._balance;
        }
    }

