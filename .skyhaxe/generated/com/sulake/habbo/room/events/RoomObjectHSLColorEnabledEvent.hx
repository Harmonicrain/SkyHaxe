package com.sulake.habbo.room.events
;
     class RoomObjectHSLColorEnabledEvent extends RoomEngineEvent 
    {
        public static inline final ROOM_BACKGROUND_COLOR= "ROHSLCEE_ROOM_BACKGROUND_COLOR";

        var _enable:Bool = false;
        var _hue:Int = 0;
        var _saturation:Int = 0;
        var _lightness:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Bool, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_2, _arg_7, _arg_8);
            this._enable = _arg_3;
            this._hue = _arg_4;
            this._saturation = _arg_5;
            this._lightness = _arg_6;
        }

        public var enable(get,never):Bool;
public function  get_enable():Bool
        {
            return this._enable;
        }

        public var hue(get,never):Int;
public function  get_hue():Int
        {
            return this._hue;
        }

        public var saturation(get,never):Int;
public function  get_saturation():Int
        {
            return this._saturation;
        }

        public var lightness(get,never):Int;
public function  get_lightness():Int
        {
            return this._lightness;
        }
    }

