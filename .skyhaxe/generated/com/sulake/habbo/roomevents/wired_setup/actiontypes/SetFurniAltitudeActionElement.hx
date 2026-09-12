package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueHundredth;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class SetFurniAltitudeActionElement extends DefaultElement
    {
        var _code:Int = 0;
        var _height:SliderSection;
        var _operator:RadioGroupPreset;

        public function new(_arg_1:Int = -1)
        {
            super();
            this._code = (_arg_1 == -1) ? ActionTypeCodes.SET_FURNI_ALTITUDE : _arg_1;
        }

        override public function  get_code():Int { return this._code; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiresFurniSelection():Bool { return true; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._operator = _arg_1.createRadioGroup([new RadioButtonParam(0, l("operator.0")), new RadioButtonParam(1, l("operator.1")), new RadioButtonParam(2, l("operator.2"))]);
            this._height = _arg_1.createSliderSection("wiredfurni.params.setaltitude", "altitude", new SliderValueHundredth(), 0, 8000, 1);
            _arg_3.addElements([_arg_1.createSection(l("choose_type"), this._operator), this._height]);
        }

        override public function readIntParamsFromForm():Array<ASAny> { return [this._height.value, this._operator.selected]; }
        override public function onEditStart(_arg_1:Triggerable)
        {
            this._height.value = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0);
            this._operator.selected = ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): 0);
        }
    }

