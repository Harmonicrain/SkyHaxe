package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
;
     class SliderValueSeconds5 implements ISliderValueConverter
    {
        public function new()
        {
        }

        public function toIntParam(_arg_1:String):Int
        {
            return Std.int(Math.fround(ASCompat.toNumber(_arg_1) / 5));
        }

        public function toString(_arg_1:Int):String
        {
            return Std.string(_arg_1 * 5);
        }

        public var precision(get,never):Int;
public function  get_precision():Int
        {
            return 0;
        }

        public var endsWithFive(get,never):Bool;
public function  get_endsWithFive():Bool
        {
            return true;
        }
    }

