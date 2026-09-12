package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
;
     class SliderValueCountOrUnlimited implements ISliderValueConverter
    {
        var _unlimitedValue:Int = 0;

        public function new(_arg_1:Int)
        {
            this._unlimitedValue = _arg_1;
        }

        public function toIntParam(_arg_1:String):Int
        {
            return Std.int(ASCompat.toNumber(_arg_1));
        }

        public function toString(_arg_1:Int):String
        {
            if (_arg_1 == this._unlimitedValue)
            {
                return "∞";
            }
            return "" + Std.string(_arg_1);
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

