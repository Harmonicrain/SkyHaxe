package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR action 41: mutate a numeric variable using a selected operation. */
     class ChangeVariableActionElement extends DefaultElement
    {
        var _picker:VariablePickerPreset;
        var _operator:DropdownPreset;
        var _selectionSection:SectionPreset;
        var _operationSection:SectionPreset;
        var _operandSection:ValueOrVariableSection;
        var _target:Int = 0;

        override public function  get_code():Int { return ActionTypeCodes.CHANGE_VARIABLE; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        function operatorOptions():Vector<ExpandableDropdownOption>
        {
var id = 0;            var options= new Vector<ExpandableDropdownOption>();
            var id = 0;
            for (_tmp_ in 0...7)
            {
id= _tmp_;
                options.push(new ExpandableDropdownOption(id,
                    this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation." + Std.string(id)), false));
            }
            options.push(new ExpandableDropdownOption(40,
                this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation.40"), true));
            options.push(new ExpandableDropdownOption(41,
                this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation.41"), true));
            options.push(new ExpandableDropdownOption(50,
                this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation.50"), true));
            options.push(new ExpandableDropdownOption(60,
                this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation.60"), true));
            for (_tmp_ in 100...106)
            {
id = _tmp_;
                options.push(new ExpandableDropdownOption(id,
                    this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation." + Std.string(id)), true));
            }
            for (_tmp_ in 110...119)
            {
id = _tmp_;
                options.push(new ExpandableDropdownOption(id,
                    this.roomEvents.localization.getLocalization("wiredfurni.params.variables.operation." + Std.string(id)), true));
            }
            return options;
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && value.canWriteValue;
        }

        function requiresOperand():Bool
        {
            return this._operator.selectedId != 103 && this._operator.selectedId != 60 &&
                this._operator.selectedId != 110;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var values:Array<ASAny> = [this._target, this._operator.selectedId,
                this.requiresOperand() ? this._operandSection.option : 0];
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
            var operandVariableId= definition.variableIds.length > 1 ? ASCompat.toString(definition.variableIds[1]) : null;
            this._target = values.length > 0 ? ASCompat.toInt(values[0]) : 0;
            var operation= values.length > 1 ? ASCompat.toInt(values[1]) : 0;
            var operandOption= values.length > 2 ? ASCompat.toInt(values[2]) : 0;
            var operandValue= values.length > 4 ? ASCompat.toInt(values[4]) : 0;
            var operandTarget= values.length > 5 ? ASCompat.toInt(values[5]) : 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
            if (operandOption == 0)
            {
                operandVariableId = null;
            }
            else
            {
                operandValue = 0;
            }
            this._operandSection.init(definition.wiredContext.roomVariablesList, operandVariableId,
                operandTarget, operandOption, operandValue);
            this._operator.selectedId = operation;
        }

        override public function onEditInitialized()
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
            this._operandSection.onEditInitialized();
        }

        function onChangeOperator(value:ExpandableDropdownOption)
        {
            this._operandSection.disabled = !this.requiresOperand();
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 1);
        }

        override public function isInputSourceDisabled(sourceType:Int, index:Int):Bool
        {
            return index == 1 && sourceType == WiredInputSourcePicker.MERGED_SOURCE &&
                (this._operandSection.isSourcePickingDisabled() || !this.requiresOperand());
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            var selector= new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), this._picker,
                new SectionParam(selector));
            this._operator = manager.createDropdown(new DropdownParam(this.l("variables.operation.tooltip"),
                this.operatorOptions(), this.onChangeOperator, this.l("variables.operation.advanced")));
            this._operationSection = manager.createSection(this.l("variables.operation"), this._operator);
            this._operandSection = manager.createValueOrVariableSection(1, this.mergedSourceOptions(1),
                this.l("variables.reference_value"), Std.int(-2147483648), 2147483647);
            builder.addElements([this._selectionSection, this._operationSection, this._operandSection]);
        }

        override public function mergedSelectionTitle(index:Int):String
        {
            return index == 0
                ? "wiredfurni.params.sources.merged.title.variables_destination"
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

