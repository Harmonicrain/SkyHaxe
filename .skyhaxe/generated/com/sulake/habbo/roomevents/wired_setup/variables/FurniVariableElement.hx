package com.sulake.habbo.roomevents.wired_setup.variables
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July variable code 0: value flag first, then availability. */
     class FurniVariableElement extends VariableElement
    {
        var _variableName:VariableNameSection;
        var _availability:RadioGroupPreset;
        var _settings:CheckboxGroupPreset;

        override public function  get_code():Int { return VariableCodes.FURNI_VARIABLE; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.VARIABLES; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [
                this._settings.get(0).selected ? 1 : 0,
                this._availability.selected
            ];
        }

        override public function onEditStart(k:Triggerable)
        {
var candidate = 0;            super.onEditStart(k);
            var hasValue= k != null && k.intData != null &&
                k.intData.length > 0 && ASCompat.toInt(k.intData[0]) != 0;
            var availability= VariableAvailabilityTypes.WHILE_ROOM_ACTIVE;
            if (k != null && k.intData != null && k.intData.length > 1)
            {
candidate= ASCompat.toInt(k.intData[1]);
                if (candidate == VariableAvailabilityTypes.WHILE_ROOM_ACTIVE ||
                    candidate == VariableAvailabilityTypes.PERMANENT)
                {
                    availability = candidate;
                }
            }
            this._settings.get(0).selected = hasValue;
            this._availability.selected = availability;
            this.initialVariableName = k != null ? k.stringData : "";
        }

        override public function readStringParamFromForm():String
        {
            return this._variableName.variableName;
        }

        override public function buildInputs(k:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._variableName = k.createVariableNameSection();
            this._settings = k.createCheckboxGroup([
                new CheckboxOptionParam(l("variables.settings.has_value"))
            ]);
            var settingsSection= k.createSection(
                l("variables.settings"), this._settings);
            this._availability = k.createRadioGroup([
                new RadioButtonParam(VariableAvailabilityTypes.WHILE_ROOM_ACTIVE,
                    l("variables.availability.1")),
                new RadioButtonParam(VariableAvailabilityTypes.PERMANENT,
                    l("variables.availability.10"))
            ]);
            var availabilitySection= k.createSection(
                l("variables.availability"), this._availability);
            builder.addElements([this._variableName, settingsSection, availabilitySection]);
        }

        override public function variableType():Int { return VariableTargets.FURNI; }
        override function  get_variableNameSection():VariableNameSection
        {
            return this._variableName;
        }

	public function new() { super(); }
    }

