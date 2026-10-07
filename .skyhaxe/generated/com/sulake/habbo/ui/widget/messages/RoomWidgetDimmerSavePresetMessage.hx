package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetDimmerSavePresetMessage extends RoomWidgetMessage 
    {
        public static inline final RWSDPM_SAVE_PRESET= "RWSDPM_SAVE_PRESET";

        var _presetNumber:Int = 0;
        var _effectTypeId:Int = 0;
        var _color:UInt = 0;
        var _brightness:Int = 0;
        var _apply:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:UInt, _arg_4:Int, _arg_5:Bool)
        {
            super(RWSDPM_SAVE_PRESET);
            this._presetNumber = k;
            this._effectTypeId = _arg_2;
            this._color = _arg_3;
            this._brightness = _arg_4;
            this._apply = _arg_5;
        }

        public var _Str_25037(get,never):Int;
public function  get__Str_25037():Int
        {
            return this._presetNumber;
        }

        public var _Str_24446(get,never):Int;
public function  get__Str_24446():Int
        {
            return this._effectTypeId;
        }

        public var color(get,never):UInt;
public function  get_color():UInt
        {
            return this._color;
        }

        public var brightness(get,never):Int;
public function  get_brightness():Int
        {
            return this._brightness;
        }

        public var apply(get,never):Bool;
public function  get_apply():Bool
        {
            return this._apply;
        }
    }

