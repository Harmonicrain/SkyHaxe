package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
;
     class SliderValuePulses implements ISliderValueConverter
    {
        public function new()
        {
        }

        public function toIntParam(_arg_1:String):Int
        {
            return Std.int(Math.fround(ASCompat.toNumber(_arg_1) * 2));
        }

        public function toString(_arg_1:Int):String
        {
            var _local_2= Std.int(Math.ffloor(_arg_1 / 2));
            if (_arg_1 % 2 == 0)
            {
                return "" + Std.string(_local_2);
            }
            return Std.string(_local_2) + ".5";
        }

        public var precision(get,never):Int;
public function  get_precision():Int
        {
            return 1;
        }

        public var endsWithFive(get,never):Bool;
public function  get_endsWithFive():Bool
        {
            return true;
        }
    }

