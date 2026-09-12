package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR condition 42: compare a variable value with a literal or variable. */
     class VariableValueConditionElement extends DefaultElement
    {
        var _picker:VariablePickerPreset;
        var _comparison:RadioGroupPreset;
        var _selectionSection:SectionPreset;
        var _operandSection:ValueOrVariableSection;
        var _target:Int = 0;

        override public function  get_code():Int { return ConditionCodes.VARIABLE_VALUE; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && value.hasValue;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var values:Array<ASAny> = [this._target, this._comparison.selected, this._operandSection.option];
            Util.pushIntAsLong(values, this._operandSection.numberValue);
            values.push(this._operandSection.target);
            return values;
        }

        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._picker.finalizeSelection, this._operandSection.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable)
        {
            var values= definition.intData;
            var variableId= definition.variableIds.length > 0 ? ASCompat.toString(definition.variableIds[0]) : null;
            var referenceVariableId= definition.variableIds.length > 1 ? ASCompat.toString(definition.variableIds[1]) : null;
            this._target = values.length > 0 ? ASCompat.toInt(values[0]) : 0;
            var comparison= values.length > 1 ? ASCompat.toInt(values[1]) : 0;
            var referenceMode= values.length > 2 ? ASCompat.toInt(values[2]) : 0;
            var referenceValue= values.length > 4 ? ASCompat.toInt(values[4]) : 0;
            var referenceTarget= values.length > 5 ? ASCompat.toInt(values[5]) : 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
            if (referenceMode == 0)
            {
                referenceVariableId = WiredVariable.NONE_ID;
            }
            else
            {
                referenceValue = 0;
            }
            this._comparison.selected = comparison;
            this._operandSection.init(definition.wiredContext.roomVariablesList, referenceVariableId,
                referenceTarget, referenceMode, referenceValue);
        }

        override public function onEditInitialized()
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
            this._operandSection.onEditInitialized();
        }

        override public function isInputSourceDisabled(sourceType:Int, index:Int):Bool
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 1 &&
                this._operandSection.isSourcePickingDisabled();
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            var selector= new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), this._picker,
                new SectionParam(selector));
            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(2, ">"), new RadioButtonParam(5, "≥"),
                new RadioButtonParam(1, "="), new RadioButtonParam(3, "≤"),
                new RadioButtonParam(0, "<"), new RadioButtonParam(4, "≠")
            ], null, 6);
            this._operandSection = manager.createValueOrVariableSection(1, this.mergedSourceOptions(1),
                this.l("variables.reference_value"), Std.int(-2147483648), 2147483647);
            builder.addElements([this._selectionSection,
                manager.createSection(this.l("comparison_selection"), this._comparison), this._operandSection]);
        }

        override public function mergedSelectionTitle(index:Int):String
        {
            return index == 0
                ? "wiredfurni.params.sources.merged.title.variables"
                : "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function mergedSelections():Array<ASAny> { return [([0, 0] : Array<Dynamic>), ([1, 1] : Array<Dynamic>)]; }
        override public function setMergedType(index:Int, value:Int)
        {
            if (index == 0)
            {
                this._target = value;
                this._picker.variableTarget = value;
            }
            else
            {
                this._operandSection.target = value;
            }
        }
        override public function getMergedType(index:Int):Int
        {
            return index == 0 ? this._target : this._operandSection.target;
        }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

