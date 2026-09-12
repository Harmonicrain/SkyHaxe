package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ChooseVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderTypeSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariablePlaceholderModeSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 15: variable placeholder definition. */
     class VariablePlaceholderAddonElement extends DefaultElement
    {
        var _name:PlaceholderNameSection;
        var _variable:ChooseVariableSection;
        var _displayMode:VariablePlaceholderModeSection;
        var _type:PlaceholderTypeSection;
        var _lastVariable:WiredVariable;

        override public function  get_code():Int { return AddonCodes.VARIABLE_PLACEHOLDER; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && value.hasValue;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._name = manager.createPlaceholderNameSection(this.l("texts.placeholder_name"), "$");
            this._variable = manager.createChooseVariableSection(0, this.mergedSourceOptions(0),
                this.variableSelectionFilter, this.onChangeVariable);
            this._displayMode = manager.createVariablePlaceholderModeSection(this.l("texts.variable_display_type"));
            this._type = manager.createPlaceholderTypeSection();
            builder.addElements([this._name, this._variable, this._displayMode, this._type]);
        }

        override public function onEditStart(definition:Triggerable)
        {
            var text:Array<ASAny> = (cast definition.stringData.split("\t"));
            var variableId= definition.variableIds.length > 0 ? ASCompat.toString(definition.variableIds[0]) : null;
            var target= definition.intData.length > 1 ? ASCompat.toInt(definition.intData[1]) : 0;
            this._name.placeholderName = text.length > 0 ? ASCompat.toString(text[0]) : "";
            this._type.isShowMultiple = definition.intData.length > 0 && ASCompat.toInt(definition.intData[0]) == 1;
            this._type.delimiter = text.length > 1 ? ASCompat.toString(text[1]) : "";
            this._displayMode.isTextMode = definition.intData.length > 2 && ASCompat.toInt(definition.intData[2]) == 1;
            this._variable.init(definition.wiredContext.roomVariablesList, variableId, target);
            this._lastVariable = this._variable.selected;
            this.onChangeVariable(this._lastVariable);
            this.updateMultipleOptionVisibility();
        }

        override public function onEditInitialized() { this._variable.onEditInitialized(); }
        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._type.isShowMultiple ? 1 : 0, this._variable.target,
                this._displayMode.isTextMode ? 1 : 0];
        }
        override public function readStringParamFromForm():String
        {
            return this._type.isShowMultiple
                ? this._name.placeholderName + "\t" + this._type.delimiter : this._name.placeholderName;
        }
        override public function readVariableIdsFromForm():Array<ASAny> { return [this._variable.finalizeSelection]; }

        function onChangeVariable(value:WiredVariable)
        {
            var textUnavailable= value == null || !value.hasTextConnector;
            this._displayMode.get(1).disabled = textUnavailable;
            if (textUnavailable) { this._displayMode.isTextMode = false; }
            if (this._name.placeholderName == "" || (this._lastVariable != null &&
                this.prettifiedName(this._lastVariable) == this._name.placeholderName))
            {
                this._name.placeholderName = this.prettifiedName(value);
            }
            this._lastVariable = value;
        }

        function prettifiedName(value:WiredVariable):String
        {
            return value == null ? "" : new compat.RegExp("\\.", "g").replace(ASCompat.stringReplace(ASCompat.stringReplace(value.variableName, "@", ""), "~", ""), "_");
        }

        function updateMultipleOptionVisibility()
        {
            var customTarget= this._variable.target == VariableExtraSourceTypes.CONTEXT_SOURCE ||
                this._variable.target == VariableExtraSourceTypes.GLOBAL_SOURCE;
            this._type.get(1).disabled = customTarget;
            if (customTarget) { this._type.isShowMultiple = false; }
        }

        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.variables";
        }
        override public function mergedSelections():Array<ASAny> { return [([0, 0] : Array<Dynamic>)]; }
        override public function setMergedType(index:Int, value:Int)
        {
            this._variable.target = value;
            this.updateMultipleOptionVisibility();
        }
        override public function getMergedType(index:Int):Int { return this._variable.target; }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

