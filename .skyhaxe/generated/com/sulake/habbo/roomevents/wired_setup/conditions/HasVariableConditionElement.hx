package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR conditions 40/41: selected variable exists/does not exist. */
     class HasVariableConditionElement extends DefaultElement
    {
        var _picker:VariablePickerPreset;
        var _selectionSection:SectionPreset;
        var _target:Int = 0;

        override public function  get_code():Int { return ConditionCodes.HAS_VARIABLE; }
        override public function  get_negativeCode():Int { return ConditionCodes.NOT_HAS_VARIABLE; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && !value.alwaysAvailable;
        }

        override public function readIntParamsFromForm():Array<ASAny> { return [this._target]; }
        override public function readVariableIdsFromForm():Array<ASAny> { return [this._picker.finalizeSelection]; }

        override public function onEditStart(definition:Triggerable)
        {
            var variableId= definition.variableIds.length > 0 ? ASCompat.toString(definition.variableIds[0]) : null;
            this._target = definition.intData.length > 0 ? ASCompat.toInt(definition.intData[0]) : 0;
            this._picker.init(definition.wiredContext.roomVariablesList, variableId, this._target);
        }

        override public function onEditInitialized()
        {
            this._selectionSection.getSourceTypeSelector().select(this._target);
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            var selector= new SourceTypeSelectorParam(
                this.mergedSourceOptions(0), this.createSourceTypeListener(0));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter);
            this._selectionSection = manager.createSection(this.l("variables.variable_selection"), this._picker,
                new SectionParam(selector));
            builder.addElements([this._selectionSection]);
        }

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
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

