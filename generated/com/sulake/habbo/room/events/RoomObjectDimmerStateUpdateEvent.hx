package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectDimmerStateUpdateEvent extends RoomObjectEvent 
    {
        public static inline final DIMMER_STATE= "RODSUE_DIMMER_STATE";

        var _state:Int = 0;
        var _presetId:Int = 0;
        var _effectId:Int = 0;
        var _color:UInt = 0;
        var _brightness:Int = 0;

        public function new(k:IRoomObject, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:UInt, _arg_6:Int, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(DIMMER_STATE, k, _arg_7, _arg_8);
            this._state = _arg_2;
            this._presetId = _arg_3;
            this._effectId = _arg_4;
            this._color = _arg_5;
            this._brightness = _arg_6;
        }

        public var state(get,never):Int;
function  get_state():Int
        {
            return this._state;
        }

        public var _Str_14686(get,never):Int;
function  get__Str_14686():Int
        {
            return this._presetId;
        }

        public var effectId(get,never):Int;
function  get_effectId():Int
        {
            return this._effectId;
        }

        public var color(get,never):UInt;
function  get_color():UInt
        {
            return this._color;
        }

        public var brightness(get,never):UInt;
function  get_brightness():UInt
        {
            return this._brightness;
        }
    }

