package com.sulake.habbo.roomevents.wired_setup.common.slider_converter
;
    /**
     * Slider value converter contract (May §_-113§). Converts between the displayed
     * slider string and the stored wired int param.
     */
     interface ISliderValueConverter
    {
        function toIntParam(_arg_1:String):Int;
        function toString(_arg_1:Int):String;
        var precision(get,never):Int;
        var endsWithFive(get,never):Bool;
    }

