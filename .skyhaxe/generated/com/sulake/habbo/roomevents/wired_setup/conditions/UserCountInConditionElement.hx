package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

     class UserCountInConditionElement extends DefaultElement
    {
        var _min:SliderSection;
        var _max:SliderSection;

        public function new()
        {
            super();
        }

        override public function  get_code():Int
        {
            return ConditionCodes.USER_COUNT_IN;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_USER_COUNT_IN;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._min = _arg_1.createSliderSection("wiredfurni.params.usercountmin", "value", new SliderValueEcho(), 0, 125, 1, false);
            this._max = _arg_1.createSliderSection("wiredfurni.params.usercountmax", "value", new SliderValueEcho(), 0, 125, 1, false);
            _arg_3.addElements([this._min, this._max]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._min.value, this._max.value];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._min.value = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 1);
            this._max.value = ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): 1);
        }
    }

