package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
;
     class SliderValueHundredth implements ISliderValueConverter
    {
        public function new()
        {
        }

        public function toIntParam(_arg_1:String):Int
        {
            return Std.int(Math.fround(ASCompat.toNumber(_arg_1) * 100));
        }

        public function toString(_arg_1:Int):String
        {
            return ASCompat.toFixed((_arg_1 / 100), 2);
        }

        public var precision(get,never):Int;
public function  get_precision():Int
        {
            return 2;
        }

        public var endsWithFive(get,never):Bool;
public function  get_endsWithFive():Bool
        {
            return false;
        }
    }

