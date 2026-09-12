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

    /** July variable code 1: availability first, then value flag. */
     class UserVariableElement extends VariableElement
    {
        var _initialAvailability:Int = -1;
        var _variableName:VariableNameSection;
        var _availability:RadioGroupPreset;
        var _settings:CheckboxGroupPreset;

        override public function  get_code():Int { return VariableCodes.USER_VARIABLE; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.VARIABLES; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [
                this._availability.selected,
                this._settings.get(0).selected ? 1 : 0
            ];
        }

        override public function onEditStart(k:Triggerable)
        {
var candidate = 0;            super.onEditStart(k);
            var availability= VariableAvailabilityTypes.WHILE_USER_IN_ROOM;
            if (k != null && k.intData != null && k.intData.length > 0)
            {
candidate= ASCompat.toInt(k.intData[0]);
                if (candidate == VariableAvailabilityTypes.WHILE_USER_IN_ROOM ||
                    candidate == VariableAvailabilityTypes.PERMANENT ||
                    candidate == VariableAvailabilityTypes.PERMANENT_SHARED)
                {
                    availability = candidate;
                }
            }
            var hasValue= k != null && k.intData != null &&
                k.intData.length > 1 && ASCompat.toInt(k.intData[1]) != 0;
            this._initialAvailability = availability;
            this._availability.selected = availability;
            this._settings.get(0).selected = hasValue;
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
                new RadioButtonParam(VariableAvailabilityTypes.WHILE_USER_IN_ROOM,
                    l("variables.availability.0")),
                new RadioButtonParam(VariableAvailabilityTypes.PERMANENT,
                    l("variables.availability.10")),
                new RadioButtonParam(VariableAvailabilityTypes.PERMANENT_SHARED,
                    l("variables.availability.11"))
            ]);
            var availabilitySection= k.createSection(
                l("variables.availability"), this._availability);
            builder.addElements([this._variableName, settingsSection, availabilitySection]);
        }

        override public function  get_requireConfirmation():ASObject
        {
            if (VariableAvailabilityTypes.isStored(this._initialAvailability) &&
                !VariableAvailabilityTypes.isStored(this._availability.selected))
            {
                return {
                    "title":"${wiredfurni.variables.availability_change.title}",
                    "body":"${wiredfurni.variables.availability_change.body}"
                };
            }
            return null;
        }

        override public function variableType():Int { return VariableTargets.USER; }
        override function  get_variableNameSection():VariableNameSection
        {
            return this._variableName;
        }

	public function new() { super(); }
    }

