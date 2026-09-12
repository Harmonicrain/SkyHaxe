package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxOptionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * July AIR variable-comparison selector shared by selector 17 (furni) and
     * selector 18 (users). Its payload is:
     * [comparison, valueFilterMode, valueSign, valueInt, referenceScope],
     * with [targetVariableId, referenceVariableId] in variableIds.
     */
     class VariableSelectorElement extends DefaultElement
    {
        var _variableSection:SectionPreset;
        var _picker:VariablePickerPreset;
        var _valueEnabledSection:SectionPreset;
        var _valueEnabled:CheckboxOptionPreset;
        var _comparisonSection:SectionPreset;
        var _comparison:RadioGroupPreset;
        var _referenceSection:ValueOrVariableSection;

        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return true;
        }

        /** The target scope is fixed by the concrete selector: furni or user. */
        var variableSource(get,never):Int;
function  get_variableSource():Int { return WiredInputSourcePicker.FURNI_SOURCE; }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var values:Array<ASAny> = [this._comparison.selected,
                this._valueEnabled.selected ? this._referenceSection.option + 1 : 0];
            Util.pushIntAsLong(values, this._referenceSection.numberValue);
            values.push(this._referenceSection.target);
            return values;
        }

        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._picker.finalizeSelection, this._referenceSection.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable)
        {
            var values= definition.intData;
            var variableIds= definition.variableIds;
            var targetVariableId= variableIds != null && variableIds.length > 0
                ? ASCompat.toString(variableIds[0]) : null;
            var referenceVariableId= variableIds != null && variableIds.length > 1
                ? ASCompat.toString(variableIds[1]) : null;
            var comparison= values.length > 0 ? ASCompat.toInt(values[0]) : 1;
            var valueFilterMode= values.length > 1 ? ASCompat.toInt(values[1]) : 0;
            // index 2 is the signed-long high word. The NumberInput stores index 3.
            var valueInt= values.length > 3 ? ASCompat.toInt(values[3]) : 0;
            var referenceScope= values.length > 4 ? ASCompat.toInt(values[4]) : 0;

            this._picker.init(definition.wiredContext.roomVariablesList, targetVariableId, this.variableSource);
            this._comparison.selected = comparison;

            if (valueFilterMode == 0 || this._picker.selected == null || !this._picker.selected.hasValue)
            {
                referenceVariableId = null;
                valueInt = 0;
                valueFilterMode = 0;
                this._valueEnabled.selected = false;
            }
            else if (valueFilterMode == 1)
            {
                referenceVariableId = null;
                this._valueEnabled.selected = true;
            }
            else
            {
                valueInt = 0;
                this._valueEnabled.selected = true;
            }

            this._referenceSection.init(definition.wiredContext.roomVariablesList,
                referenceVariableId, referenceScope, valueFilterMode - 1, valueInt);
            this.setValueSelectionVisibility(this._picker.selected != null && this._picker.selected.hasValue
                && valueFilterMode > 0);
            this.onVariableSelected(this._picker.selected);
        }

        override public function onEditInitialized()
        {
            // Source slot 0 owns the reference variable's furni/user scope.
            this._referenceSection.onEditInitialized();
        }

        override public function isInputSourceDisabled(sourceType:Int, index:Int):Bool
        {
            return index == 0 && sourceType == WiredInputSourcePicker.MERGED_SOURCE
                && (this._valueEnabledSection.disabled || !this._valueEnabled.selected
                    || this._referenceSection.isSourcePickingDisabled());
        }

        function onVariableSelected(value:WiredVariable)
        {
            var hasValue= value != null && value.hasValue;
            this._valueEnabledSection.disabled = !hasValue;
            this.setValueSelectionVisibility(hasValue && this._valueEnabled.selected);
        }

        function setValueSelectionVisibility(visible:Bool)
        {
            this._comparisonSection.disabled = !visible;
            this._referenceSection.disabled = !visible;
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0);
        }

        function onSelectByValueChange(id:Int, selected:Bool)
        {
            this.setValueSelectionVisibility(selected);
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._picker = manager.createVariablePicker(this.variableSelectionFilter, this.onVariableSelected);
            this._variableSection = manager.createSection(this.l("variables.variable_selection"), this._picker);

            var valueToggle= manager.createCheckboxGroup([
                new CheckboxOptionParam(this.l("variables.value_settings.select_by_value"))
            ], this.onSelectByValueChange);
            this._valueEnabled = valueToggle.get(0);
            this._valueEnabledSection = manager.createSection(this.l("choose_type"), this._valueEnabled);

            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(2, ">"),
                new RadioButtonParam(5, "≥"),
                new RadioButtonParam(1, "="),
                new RadioButtonParam(3, "≤"),
                new RadioButtonParam(0, "<"),
                new RadioButtonParam(4, "≠")
            ], null, 6);
            this._comparisonSection = manager.createSection(this.l("comparison_selection"), this._comparison);
            this._referenceSection = manager.createValueOrVariableSection(0, this.mergedSourceOptions(0),
                this.l("variables.reference_value"), Std.int(-2147483648), 2147483647);
            builder.addElements([this._variableSection, this._valueEnabledSection,
                this._comparisonSection, this._referenceSection]);
        }

        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }

        override public function mergedSelections():Array<ASAny> { return [([0, 0] : Array<Dynamic>)]; }
        override public function setMergedType(index:Int, value:Int) { this._referenceSection.target = value; }
        override public function getMergedType(index:Int):Int { return this._referenceSection.target; }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

