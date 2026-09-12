package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

     class FurnisHaveAvatarsConditionElement extends DefaultElement
    {
        var _quantifier:RadioGroupPreset;

        override public function  get_code():Int
        {
            return ConditionCodes.FURNIS_HAVE_AVATARS;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.FURNI_NOT_HAVE_HABBO;
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
            this._quantifier = _arg_1.createRadioGroup([new RadioButtonParam(0, l("requireall.0")), new RadioButtonParam(1, l("requireall.1"))]);
            _arg_3.addElements([_arg_1.createSection(l("requireall"), this._quantifier)]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._quantifier.selected];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._quantifier.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0);
        }

	public function new() { super(); }
    }

