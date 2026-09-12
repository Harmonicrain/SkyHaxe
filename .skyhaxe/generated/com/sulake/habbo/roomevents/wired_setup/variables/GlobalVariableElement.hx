package com.sulake.habbo.roomevents.wired_setup.variables
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.VariableInfoAndValue;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredContext;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July variable code 2: one global/room value with configurable persistence. */
     class GlobalVariableElement extends VariableElement
    {
        static inline final AVAILABILITY_WHILE_ROOM_ACTIVE= 1;
        static inline final AVAILABILITY_PERMANENT= 10;
        static inline final AVAILABILITY_PERMANENT_SHARED= 11;

        var _variableName:VariableNameSection;
        var _availability:RadioGroupPreset;
        var _currentValue:TextPreset;

        override public function  get_code():Int
        {
            return VariableCodes.GLOBAL_VARIABLE;
        }

        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.VARIABLES;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._availability != null ? this._availability.selected : AVAILABILITY_WHILE_ROOM_ACTIVE];
        }

        override public function onEditStart(data:Triggerable)
        {
var candidate = 0;            super.onEditStart(data);

            var availability= AVAILABILITY_WHILE_ROOM_ACTIVE;
            if (data != null && data.intData != null && data.intData.length > 0)
            {
candidate= ASCompat.toInt(data.intData[0]);
                if (isSupportedAvailability(candidate))
                {
                    availability = candidate;
                }
            }
            if (this._availability != null)
            {
                this._availability.selected = availability;
            }

            this.initialVariableName = data != null ? data.stringData : "";

            var value= 0;
            var context:WiredContext = data != null ? data.wiredContext : null;
            var info:VariableInfoAndValue = context != null ? context.globalVariableInfo : null;
            if (info != null)
            {
                value = info.value;
            }
            if (this.roomEvents != null && this.roomEvents.localization != null)
            {
                this.roomEvents.localization.registerParameter(
                    "wiredfurni.params.variables.inspection.current_value", "value", Std.string(value));
            }
        }

        static function isSupportedAvailability(value:Int):Bool
        {
            return value == AVAILABILITY_WHILE_ROOM_ACTIVE ||
                value == AVAILABILITY_PERMANENT ||
                value == AVAILABILITY_PERMANENT_SHARED;
        }

        override public function readStringParamFromForm():String
        {
            return this._variableName != null ? this._variableName.variableName : "";
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(presetManager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._variableName = presetManager.createVariableNameSection();
            this._currentValue = presetManager.createText(l("variables.inspection.current_value"));
            var inspectionSection= presetManager.createSection(
                l("variables.inspection"), this._currentValue);

            this._availability = presetManager.createRadioGroup([
                new RadioButtonParam(AVAILABILITY_WHILE_ROOM_ACTIVE, l("variables.availability.1")),
                new RadioButtonParam(AVAILABILITY_PERMANENT, l("variables.availability.10")),
                new RadioButtonParam(AVAILABILITY_PERMANENT_SHARED, l("variables.availability.11"))
            ]);
            var availabilitySection= presetManager.createSection(
                l("variables.availability"), this._availability);
            builder.addElements([this._variableName, inspectionSection, availabilitySection]);
        }

        override public function variableType():Int
        {
            return VariableTargets.GLOBAL;
        }

        override function  get_variableNameSection():VariableNameSection
        {
            return this._variableName;
        }

	public function new() { super(); }
    }

