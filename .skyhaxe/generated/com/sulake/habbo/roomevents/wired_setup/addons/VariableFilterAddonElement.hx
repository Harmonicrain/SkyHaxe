package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Shared July editor for addons 12 and 13. */
     class VariableFilterAddonElement extends DefaultElement
    {
        var _variableSection:SectionPreset;
        var _variablePicker:VariablePickerPreset;
        var _sortSection:SectionPreset;
        var _sort:DropdownPreset;
        var _filterAmount:ValueOrVariableSection;

        var variableTarget(get,never):Int;
function  get_variableTarget():Int { return WiredInputSourcePicker.FURNI_SOURCE; }

        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && (value.hasValue || value.canReadCreationTime || value.canReadLastUpdateTime);
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._variablePicker = manager.createVariablePicker(this.variableSelectionFilter,
                this.initSortingDropdown);
            this._variableSection = manager.createSection(this.loc("wiredfurni.params.variables.variable_selection"),
                this._variablePicker);
            this._sort = manager.createDropdown(new DropdownParam(this.l("variables.sort_by.caption"),
                new Vector<ExpandableDropdownOption>()));
            this._sortSection = manager.createSection(this.l("variables.sort_by"), this._sort);
            this._filterAmount = manager.createValueOrVariableSection(0, this.mergedSourceOptions(0),
                this.l("setfilter"), 1, 1000);
            builder.addElements([this._variableSection, this._sortSection, this._filterAmount]);
        }

        override public function onEditStart(definition:Triggerable)
        {
            var values= definition.intData;
            var primaryId= definition.variableIds.length > 0 ? ASCompat.toString(definition.variableIds[0]) : null;
            var referenceId= definition.variableIds.length > 1 ? ASCompat.toString(definition.variableIds[1]) : null;
            var amount= values.length > 0 ? ASCompat.toInt(values[0]) : 1;
            var sort= values.length > 1 ? ASCompat.toInt(values[1]) : 0;
            var option= values.length > 2 ? ASCompat.toInt(values[2]) : 0;
            var target= values.length > 3 ? ASCompat.toInt(values[3]) : 0;
            this._variablePicker.init(definition.wiredContext.roomVariablesList, primaryId, this.variableTarget);
            if (option == 0)
            {
                referenceId = WiredVariable.NONE_ID;
            }
            else
            {
                amount = 1;
            }
            this._filterAmount.init(definition.wiredContext.roomVariablesList, referenceId,
                target, option, amount);
            this.initSortingDropdown(this._variablePicker.selected, sort);
        }

        override public function onEditInitialized() { this._filterAmount.onEditInitialized(); }

        function initSortingDropdown(variable:WiredVariable, selectedId:Int = -1)
        {
            if (selectedId == -1) { selectedId = this._sort.selectedId; }
            var options= new Vector<ExpandableDropdownOption>();
            var prefix= "variables.sort_by.";
            if (variable == null || variable.hasValue)
            {
                options.push(new ExpandableDropdownOption(0, this.l(prefix + "0")));
                options.push(new ExpandableDropdownOption(1, this.l(prefix + "1")));
            }
            if (variable == null || variable.canReadCreationTime)
            {
                options.push(new ExpandableDropdownOption(2, this.l(prefix + "2")));
                options.push(new ExpandableDropdownOption(3, this.l(prefix + "3")));
            }
            if (variable == null || variable.canReadLastUpdateTime)
            {
                options.push(new ExpandableDropdownOption(4, this.l(prefix + "4")));
                options.push(new ExpandableDropdownOption(5, this.l(prefix + "5")));
            }
            this._sort.reinit(options, selectedId);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._filterAmount.numberValue, this._sort.selectedId,
                this._filterAmount.option, this._filterAmount.target];
        }
        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._variablePicker.finalizeSelection, this._filterAmount.finalizeSelection];
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

