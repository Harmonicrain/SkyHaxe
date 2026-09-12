package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 1: pick effects randomly while avoiding recent selections. */
     class RandomEffectAddonElement extends DefaultElement
    {
        var _skips:SliderSection;
        var _picks:SliderSection;

        override public function  get_code():Int { return AddonCodes.RANDOM_EFFECT; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._skips = manager.createSliderSection("wiredfurni.params.skipactions", "skips",
                SliderSection.CONVERTER_ECHO, 0, 100, 1, false);
            this._picks = manager.createSliderSection("wiredfurni.params.pickamount", "picks",
                SliderSection.CONVERTER_ECHO, 1, 100, 1, false);
            builder.addElements([this._picks, this._skips]);
        }

        override public function onEditStart(definition:Triggerable)
        {
            this._skips.value = definition.intData.length > 0 ? ASCompat.toInt(definition.intData[0]) : 0;
            this._picks.value = definition.intData.length > 1 ? ASCompat.toInt(definition.intData[1]) : 1;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._skips.value, this._picks.value];
        }

	public function new() { super(); }
    }

