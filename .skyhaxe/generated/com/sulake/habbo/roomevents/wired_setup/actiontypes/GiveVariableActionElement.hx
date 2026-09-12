package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxOptionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR action 39: create a variable, optionally overriding its value. */
     class GiveVariableActionElement extends DefaultElement
    {
        var _picker:VariablePickerPreset;
        var _overrideExisting:CheckboxOptionPreset;
        var _initialValue:NamedNumberInputPreset;
        var _selectionSection:SectionPreset;
        var _valueSection:SectionPreset;
        var _target:Int = 0;

        override public function  get_code():Int { return ActionTypeCodes.GIVE_VARIABLE; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && value.canCreateAndDelete;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var values:Array<ASAny> = [this._target];
            Util.pushIntAsLong(values, this._initialValue.value);
            values.push(this._overrideExisting.selected ? 1 : 0);
            return values;
        }

        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._picker.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable)
        {
            var variableId= definition.variableIds.length > 0 ? ASCompat.toString(definition.variableIds[0]) : null;
            var values= definition.intData;
            this._target = values.length > 0 ? ASCompat.toInt(values[0]) : 0;
            var initialValue= values.length > 2 ? ASCompat.toInt(values[2]) : 0;
            var overrideExisting= values.length > 3 && ASCompat.toInt(values[3]) != 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
            var selected= this._picker.selected;
            if (selected == null || !selected.canWriteValue)
            {
                initialValue = 0;
            }
            this.onVariableSelected(selected);
            this._overrideExisting.selected = overrideExisting;
            this._initialValue.value = initialValue;
        }

        override public function onEditInitialized()
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
        }

        function onVariableSelected(value:WiredVariable)
        {
            this._valueSection.disabled = value == null || !value.hasValue;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            var selector= new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter, this.onVariableSelected);
            this._overrideExisting = manager.createCheckboxOption(
                new CheckboxOptionParam(this.l("variables.value_settings.override_existing")));
            var list= manager.createSimpleListView(true,
                [this._picker, this._overrideExisting]);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), list,
                new SectionParam(selector));
            this._initialValue = manager.createNamedNumberInput(
                new NumberInputParam(0, Std.int(-2147483648), 2147483647),
                this.l("variables.value_settings.initial_value"));
            this._valueSection = manager.createSection(this.l("variables.value_settings"), this._initialValue);
            builder.addElements([this._selectionSection, this._valueSection]);
        }

        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_destination";
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
            return [VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

