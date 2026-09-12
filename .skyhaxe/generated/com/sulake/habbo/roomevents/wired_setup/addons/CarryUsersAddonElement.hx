package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 8: chooses which users are carried by moving furniture. */
     class CarryUsersAddonElement extends DefaultElement
    {
        var _mode:RadioGroupPreset;

        override public function  get_code():Int { return AddonCodes.CARRY_USERS; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(0, this.loc("wiredfurni.params.carry_mode.0")),
                new RadioButtonParam(1, this.loc("wiredfurni.params.carry_mode.1"))
            ]);
            builder.addElements([manager.createSection(this.loc("wiredfurni.params.carry_mode"), this._mode)]);
        }

        override public function onEditStart(definition:Triggerable)
        {
            this._mode.selected = definition.intData.length > 0 ? ASCompat.toInt(definition.intData[0]) : 0;
        }

        override public function readIntParamsFromForm():Array<ASAny> { return [this._mode.selected]; }

        override public function userSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.users.title.carry";
        }

        override public function advancedAlwaysVisible():Bool { return true; }

	public function new() { super(); }
    }

