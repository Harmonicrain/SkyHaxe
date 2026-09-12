package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR condition 43: compare a variable creation/update timestamp against a duration. */
     class VariableAgeConditionElement extends DefaultElement
    {
        var _selectionSection:SectionPreset;
        var _picker:VariablePickerPreset;
        var _comparison:RadioGroupPreset;
        var _timestampKind:RadioGroupPreset;
        var _duration:NamedNumberInputPreset;
        var _timeUnit:DropdownPreset;
        var _target:Int = 0;

        override public function  get_code():Int { return ConditionCodes.VARIABLE_AGE; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && (value.canReadCreationTime || value.canReadLastUpdateTime);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var values:Array<ASAny> = [this._target, this._comparison.selected, this._timestampKind.selected];
            Util.pushIntAsLong(values, this._duration.value);
            values.push(this._timeUnit.selectedId);
            return values;
        }

        override public function readVariableIdsFromForm():Array<ASAny> { return [this._picker.finalizeSelection]; }

        override public function onEditStart(definition:Triggerable)
        {
            var values= definition.intData;
            var variableId= definition.variableIds.length > 0 ? ASCompat.toString(definition.variableIds[0]) : null;
            this._target = values.length > 0 ? ASCompat.toInt(values[0]) : 0;
            var comparison= values.length > 1 ? ASCompat.toInt(values[1]) : 0;
            var timestampKind= values.length > 2 ? ASCompat.toInt(values[2]) : 0;
            var duration= values.length > 4 ? ASCompat.toInt(values[4]) : 0;
            var timeUnit= values.length > 5 ? ASCompat.toInt(values[5]) : 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
            this._comparison.selected = comparison;
            this._timestampKind.selected = timestampKind;
            this._duration.value = duration;
            this._timeUnit.selectedId = timeUnit;
            this.updateAgeOptions(this._picker.selected);
        }

        override public function onEditInitialized()
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
        }

        function updateAgeOptions(value:WiredVariable)
        {
            this._timestampKind.setOptionDisabled(0, false);
            this._timestampKind.setOptionDisabled(1, false);
            if (value == null) { return; }
            if (!value.canReadCreationTime)
            {
                this._timestampKind.setOptionDisabled(0, true);
            }
            else if (!value.canReadLastUpdateTime)
            {
                this._timestampKind.setOptionDisabled(1, true);
            }
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            var selector= new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter, this.updateAgeOptions);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), this._picker,
                new SectionParam(selector));
            this._timestampKind = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("variables.compare_value.0")),
                new RadioButtonParam(1, this.l("variables.compare_value.1"))
            ]);
            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("comparison.0")),
                new RadioButtonParam(2, this.l("comparison.2"))
            ]);
            this._duration = manager.createNamedNumberInput(
                new NumberInputParam(0, Std.int(-2147483648), 2147483647), this.l("variables.duration"));
            this._timeUnit = manager.createDropdown(new DropdownParam("",
                Vector.ofArray([
                    new ExpandableDropdownOption(0, this.l("variables.duration.0")),
                    new ExpandableDropdownOption(1, this.l("variables.duration.1")),
                    new ExpandableDropdownOption(2, this.l("variables.duration.2")),
                    new ExpandableDropdownOption(3, this.l("variables.duration.3")),
                    new ExpandableDropdownOption(4, this.l("variables.duration.4")),
                    new ExpandableDropdownOption(5, this.l("variables.duration.5")),
                    new ExpandableDropdownOption(6, this.l("variables.duration.6")),
                    new ExpandableDropdownOption(7, this.l("variables.duration.7"))
                ])));
            var durationList= manager.createSimpleListView(false,
                [this._duration, manager.createSpacing(false, 5), this._timeUnit], true);
            builder.addElements([this._selectionSection,
                manager.createSection(this.l("variables.compare_value"), this._timestampKind),
                manager.createSection(this.l("comparison_selection"), this._comparison),
                manager.createSection(this.l("variables.time_selection"), durationList)]);
        }

        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.variables";
        }
        override public function mergedSelections():Array<ASAny> { return [([0, 0] : Array<Dynamic>)]; }
        override public function setMergedType(index:Int, value:Int)
        {
            this._target = value;
            this._picker.variableTarget = value;
        }
        override public function getMergedType(index:Int):Int { return this._target; }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

