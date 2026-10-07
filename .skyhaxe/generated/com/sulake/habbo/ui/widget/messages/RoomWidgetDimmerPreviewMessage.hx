package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetDimmerPreviewMessage extends RoomWidgetMessage 
    {
        public static inline final RWDPM_PREVIEW_DIMMER_PRESET= "RWDPM_PREVIEW_DIMMER_PRESET";

        var _color:UInt = 0;
        var _brightness:Int = 0;
        var _bgOnly:Bool = false;

        public function new(k:UInt, _arg_2:Int, _arg_3:Bool)
        {
            super(RWDPM_PREVIEW_DIMMER_PRESET);
            this._color = k;
            this._brightness = _arg_2;
            this._bgOnly = _arg_3;
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

        public var bgOnly(get,never):Bool;
public function  get_bgOnly():Bool
        {
            return this._bgOnly;
        }
    }

