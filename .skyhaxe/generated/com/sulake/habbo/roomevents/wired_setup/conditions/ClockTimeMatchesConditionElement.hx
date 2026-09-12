package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValuePulses;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueSeconds5;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

     class ClockTimeMatchesConditionElement extends DefaultElement
    {
        var _seconds:SliderSection;
        var _minutes:SliderSection;
        var _operator:RadioGroupPreset;

        override public function  get_code():Int { return ConditionCodes.CLOCK_TIME_MATCHES; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._operator = _arg_1.createRadioGroup([new RadioButtonParam(0, l("comparison.0")), new RadioButtonParam(1, l("comparison.1")), new RadioButtonParam(2, l("comparison.2"))]);
            this._minutes = _arg_1.createSliderSection("wiredfurni.params.clock_minutes_elapsed", "minutes", new SliderValueSeconds5(), 0, 99, 1, false);
            this._seconds = _arg_1.createSliderSection("wiredfurni.params.clock_seconds_elapsed", "seconds", new SliderValuePulses(), 0, 119, 1, false);
            _arg_3.addElements([_arg_1.createSection(l("comparison_selection"), this._operator), this._minutes, this._seconds]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var _local_1= this._seconds.value;
            return [Math.ffloor(_local_1 / 2), this._minutes.value, _local_1 % 2, this._operator.selected];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            var _local_2= ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0);
            var _local_3= ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): 0);
            var _local_4= ASCompat.toInt((_arg_1.intData.length > 2) ? ASCompat.toInt(_arg_1.intData[2] ): 0);
            this._seconds.value = (_local_2 * 2) + _local_4;
            this._minutes.value = _local_3;
            this._operator.selected = ASCompat.toInt((_arg_1.intData.length > 3) ? ASCompat.toInt(_arg_1.intData[3] ): 0);
        }

	public function new() { super(); }
    }

