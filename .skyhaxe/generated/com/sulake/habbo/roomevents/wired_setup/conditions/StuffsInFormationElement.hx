package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

     class StuffsInFormationElement extends DefaultElement
    {
        var _size:SliderSection;
        var _formation:RadioGroupPreset;

        public function new()
        {
            super();
        }

        override public function  get_code():Int
        {
            return ConditionCodes.STUFFS_IN_FORMATION;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_STUFFS_IN_FORMATION;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function  get_requiresFurniSelection():Bool
        {
            return true;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._size = _arg_1.createSliderSection("wiredfurni.params.requiredformationsize", "furnis", new SliderValueEcho(), 2, 10, 3);
            this._formation = _arg_1.createRadioGroup([new RadioButtonParam(0, l("formation.0")), new RadioButtonParam(1, l("formation.1"))], null, 2);
            _arg_3.addElements([this._size, _arg_1.createSection(l("formation"), this._formation)]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._size.value, this._formation.selected];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._size.value = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 3);
            this._formation.selected = ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): 0);
        }
    }

