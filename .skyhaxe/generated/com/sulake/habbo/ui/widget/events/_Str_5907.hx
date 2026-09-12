package com.sulake.habbo.ui.widget.events
;
     class _Str_5907 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWBIUE_HABBO_CLUB= "RWBIUE_HABBO_CLUB";

        var _Str_22208:Int = 0;
        var _Str_21908:Int = 0;
        var _Str_20357:Int = 0;
        var _Str_21522:Bool = false;
        var _clubLevel:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Bool, _arg_5:Int, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(RWBIUE_HABBO_CLUB, _arg_6, _arg_7);
            this._Str_22208 = k;
            this._Str_21908 = _arg_2;
            this._Str_20357 = _arg_3;
            this._Str_21522 = _arg_4;
            this._clubLevel = _arg_5;
        }

        public var _Str_19392(get,never):Int;
public function  get__Str_19392():Int
        {
            return this._Str_22208;
        }

        public var _Str_23037(get,never):Int;
public function  get__Str_23037():Int
        {
            return this._Str_21908;
        }

        public var _Str_24579(get,never):Int;
public function  get__Str_24579():Int
        {
            return this._Str_20357;
        }

        public var _Str_23338(get,never):Bool;
public function  get__Str_23338():Bool
        {
            return this._Str_21522;
        }

        public var clubLevel(get,never):Int;
public function  get_clubLevel():Int
        {
            return this._clubLevel;
        }
    }

