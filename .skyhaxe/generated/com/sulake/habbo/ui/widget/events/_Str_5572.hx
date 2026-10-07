package com.sulake.habbo.ui.widget.events
;
     class _Str_5572 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWDSUE_DIMMER_STATE= "RWDSUE_DIMMER_STATE";

        var _state:Int = 0;
        var _Str_6356:Int = 0;
        var _effectId:Int = 0;
        var _color:UInt = 0;
        var _Str_3486:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:UInt, _arg_5:UInt, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(RWDSUE_DIMMER_STATE, _arg_6, _arg_7);
            this._state = k;
            this._Str_6356 = _arg_2;
            this._effectId = _arg_3;
            this._color = _arg_4;
            this._Str_3486 = ASCompat.toInt(_arg_5);
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

        public var _Str_14686(get,never):Int;
public function  get__Str_14686():Int
        {
            return this._Str_6356;
        }

        public var effectId(get,never):Int;
public function  get_effectId():Int
        {
            return this._effectId;
        }

        public var color(get,never):UInt;
public function  get_color():UInt
        {
            return this._color;
        }

        public var brightness(get,never):UInt;
public function  get_brightness():UInt
        {
            return this._Str_3486;
        }
    }

