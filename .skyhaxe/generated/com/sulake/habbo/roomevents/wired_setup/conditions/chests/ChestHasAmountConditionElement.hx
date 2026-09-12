package com.sulake.habbo.roomevents.wired_setup.conditions.chests
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July condition 45: compare chest content amount to a literal or variable. */
     class ChestHasAmountConditionElement extends DefaultElement
    {
        var amount:ValueOrVariableSection;
        var _comparison:RadioGroupPreset;

        override public function  get_code():Int { return ConditionCodes.CHEST_HAS_ITEMS; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.CHESTS | WiredCapabilityCodes.CHEST_WIRED |
                WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }
        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this.amount.numberValue, this.amount.option, this.amount.target,
                this._comparison.selected];
        }
        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this.amount.finalizeSelection];
        }
        override public function onEditStart(definition:Triggerable)
        {
            var values= definition.intData;
            var variableId= definition.variableIds.length > 0 ?
                ASCompat.toString(definition.variableIds[0]) : WiredVariable.NONE_ID;
            var value= values.length > 0 ? ASCompat.toInt(values[0]) : 0;
            var option= values.length > 1 ? ASCompat.toInt(values[1]) : 0;
            var target= values.length > 2 ? ASCompat.toInt(values[2]) : 0;
            if (option == 0) variableId = WiredVariable.NONE_ID;
            else value = 1;
            this.amount.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, value);
            this._comparison.selected = values.length > 3 ? ASCompat.toInt(values[3]) : 1;
        }
        override public function onEditInitialized() { this.amount.onEditInitialized(); }
        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._comparison = manager.createRadioGroup([
                new RadioButtonParam(2, ">"), new RadioButtonParam(5, "≥"),
                new RadioButtonParam(1, "="), new RadioButtonParam(3, "≤"),
                new RadioButtonParam(0, "<"), new RadioButtonParam(4, "≠")
            ], null, 6);
            this.amount = manager.createValueOrVariableSection(0, this.mergedSourceOptions(0),
                this.l("chest_compare_amount"), 0, 1000000);
            builder.addElements(
                [manager.createSection(this.l("comparison_selection"), this._comparison),
                this.amount]);
        }
        override public function isInputSourceDisabled(index:Int, sourceType:Int):Bool
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 0 &&
                this.amount.isSourcePickingDisabled();
        }
        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function furniSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.furni.title.chests";
        }
        override public function mergedSelections():Array<ASAny> { return [([1, 0] : Array<Dynamic>)]; }
        override public function setMergedType(index:Int, value:Int) { this.amount.target = value; }
        override public function getMergedType(index:Int):Int { return this.amount.target; }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

