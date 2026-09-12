package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
;
    /**
     * Identity converter (May §_-6Y§, CONVERTER_ECHO): displayed value == stored int.
     */
     class SliderValueEcho implements ISliderValueConverter
    {
        public function new()
        {
        }

        public function toIntParam(_arg_1:String):Int
        {
            return ASCompat.toInt(_arg_1);
        }

        public function toString(_arg_1:Int):String
        {
            return Std.string(_arg_1);
        }

        public var precision(get,never):Int;
public function  get_precision():Int
        {
            return 0;
        }

        public var endsWithFive(get,never):Bool;
public function  get_endsWithFive():Bool
        {
            return false;
        }
    }

