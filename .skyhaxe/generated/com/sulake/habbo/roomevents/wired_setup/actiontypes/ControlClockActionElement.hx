package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class ControlClockActionElement extends DefaultElement
    {
        var _mode:RadioGroupPreset;

        override public function  get_code():Int { return ActionTypeCodes.CONTROL_CLOCK; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._mode = _arg_1.createRadioGroup([
                new RadioButtonParam(0, l("clock_control.0")),
                new RadioButtonParam(1, l("clock_control.1")),
                new RadioButtonParam(2, l("clock_control.2")),
                new RadioButtonParam(3, l("clock_control.3")),
                new RadioButtonParam(4, l("clock_control.4"))
            ]);
            _arg_3.addElements([_arg_1.createSection(l("clock_control"), this._mode)]);
        }

        override public function readIntParamsFromForm():Array<ASAny> { return [this._mode.selected]; }
        override public function onEditStart(_arg_1:Triggerable) { this._mode.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0); }

	public function new() { super(); }
    }

