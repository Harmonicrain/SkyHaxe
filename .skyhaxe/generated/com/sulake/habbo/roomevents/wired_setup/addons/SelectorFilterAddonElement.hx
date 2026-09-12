package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Shared July editor for addons 10 and 11. */
     class SelectorFilterAddonElement extends DefaultElement
    {
        var _filterAmount:ValueOrVariableSection;

        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._filterAmount = manager.createValueOrVariableSection(0, this.mergedSourceOptions(0),
                this.l("setfilter"), 1, 1000);
            builder.addElements([this._filterAmount]);
        }

        override public function onEditStart(definition:Triggerable)
        {
            var values= definition.intData;
            var variableId= definition.variableIds.length > 0 ? ASCompat.toString(definition.variableIds[0]) : null;
            var amount= values.length > 0 ? ASCompat.toInt(values[0]) : 1;
            var option= values.length > 1 ? ASCompat.toInt(values[1]) : 0;
            var target= values.length > 2 ? ASCompat.toInt(values[2]) : 0;
            if (option == 0)
            {
                variableId = WiredVariable.NONE_ID;
            }
            else
            {
                amount = 1;
            }
            this._filterAmount.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, amount);
        }

        override public function onEditInitialized() { this._filterAmount.onEditInitialized(); }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._filterAmount.numberValue, this._filterAmount.option,
                this._filterAmount.target];
        }

        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._filterAmount.finalizeSelection];
        }

        override public function isInputSourceDisabled(sourceType:Int, index:Int):Bool
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE &&
                this._filterAmount.isSourcePickingDisabled();
        }

        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function mergedSelections():Array<ASAny> { return [([0, 0] : Array<Dynamic>)]; }
        override public function setMergedType(index:Int, value:Int) { this._filterAmount.target = value; }
        override public function getMergedType(index:Int):Int { return this._filterAmount.target; }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

