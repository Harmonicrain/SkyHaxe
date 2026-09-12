package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValuePulses;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July action 38: adjust a counter by minutes and half-second pulses. */
     class AdjustClockActionElement extends DefaultElement
    {
        var _seconds:SliderSection;
        var _minutes:SliderSection;
        var _operator:RadioGroupPreset;

        override public function  get_code():Int { return ActionTypeCodes.ADJUST_CLOCK; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._seconds = manager.createSliderSection(
                "wiredfurni.params.clock_seconds", "seconds",
                new SliderValuePulses(), 0, 119, 1, false);
            this._minutes = manager.createSliderSection(
                "wiredfurni.params.clock_minutes", "minutes",
                new SliderValueEcho(), 0, 99, 1, false);
            this._operator = manager.createRadioGroup([
                new RadioButtonParam(0, l("operator.0")),
                new RadioButtonParam(1, l("operator.1")),
                new RadioButtonParam(2, l("operator.2"))
            ]);
            builder.addElements(
                [manager.createSection(l("choose_type"), this._operator),
                this._minutes, this._seconds]);
        }

        override public function onEditStart(data:Triggerable)
        {
            var halfSeconds= data.intData.length > 0 ? ASCompat.toInt(data.intData[0]) : 0;
            var minutes= data.intData.length > 1 ? ASCompat.toInt(data.intData[1]) : 0;
            var remainder= data.intData.length > 2 ? ASCompat.toInt(data.intData[2]) : 0;
            this._seconds.value = halfSeconds * 2 + remainder;
            this._minutes.value = minutes;
            this._operator.selected = data.intData.length > 3 ? ASCompat.toInt(data.intData[3]) : 0;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var seconds= this._seconds.value;
            return [Math.ffloor(seconds / 2), this._minutes.value, seconds % 2,
                this._operator.selected];
        }

	public function new() { super(); }
    }

