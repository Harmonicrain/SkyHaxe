package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValuePulses;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 5: cap executions within a pulse-based time window. */
     class ExecutionLimitAddonElement extends DefaultElement
    {
        var _executions:SliderSection;
        var _timeWindow:SliderSection;

        override public function  get_code():Int { return AddonCodes.EXECUTION_LIMIT; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._executions = manager.createSliderSection("wiredfurni.params.setexecutions", "amount",
                SliderSection.CONVERTER_ECHO, 1, 100, 1, false);
            this._timeWindow = manager.createSliderSection("wiredfurni.params.settimewindow", "timewindow",
                new SliderValuePulses(), 1, 20, 1, false);
            builder.addElements([this._executions, this._timeWindow]);
        }

        override public function onEditStart(definition:Triggerable)
        {
            this._executions.value = definition.intData.length > 0 ? ASCompat.toInt(definition.intData[0]) : 1;
            this._timeWindow.value = definition.intData.length > 1 ? ASCompat.toInt(definition.intData[1]) : 1;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._executions.value, this._timeWindow.value];
        }

	public function new() { super(); }
    }

