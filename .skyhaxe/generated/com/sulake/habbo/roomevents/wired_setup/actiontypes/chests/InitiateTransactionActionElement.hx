package com.sulake.habbo.roomevents.wired_setup.actiontypes.chests
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July action 47: initiate a contract transaction. */
     class InitiateTransactionActionElement extends DefaultElement
    {
        static inline final MODE_NO_MULTIPLIER= 0;
        static inline final MODE_ALTERNATE_LABEL= 2;

        var _mode:RadioGroupPreset;
        var _multiplier:ValueOrVariableSection;
        var _timeoutEnabled:CheckboxGroupPreset;
        var _timeout:NamedNumberInputPreset;

        override public function  get_code():Int { return ActionTypeCodes.INITIATE_TRANSACTION; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.CHESTS | WiredCapabilityCodes.CHEST_WIRED |
                WiredCapabilityCodes.CONTRACTS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._mode.selected, this._multiplier.numberValue, this._multiplier.option,
                this._multiplier.target, this._timeoutEnabled.get(0).selected ? 1 : 0,
                this._timeout.value];
        }

        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._multiplier.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable)
        {
            var values= definition.intData;
            var variableId= definition.variableIds.length > 0 ?
                ASCompat.toString(definition.variableIds[0]) : WiredVariable.NONE_ID;
            var mode= values.length > 0 ? ASCompat.toInt(values[0]) : 0;
            var amount= values.length > 1 ? ASCompat.toInt(values[1]) : 1;
            var option= values.length > 2 ? ASCompat.toInt(values[2]) : 0;
            var target= values.length > 3 ? ASCompat.toInt(values[3]) : 0;
            if (option == 0) variableId = WiredVariable.NONE_ID;
            else amount = 1;
            this._mode.selected = mode;
            this._multiplier.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, amount);
            this._timeoutEnabled.get(0).selected = values.length > 4 && ASCompat.toInt(values[4]) != 0;
            this._timeout.value = values.length > 5 ? ASCompat.toInt(values[5]) : 300;
            this.onModeChange(mode);
        }

        override public function onEditInitialized() { this._multiplier.onEditInitialized(); }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(0, "${wiredfurni.params.contract.mode.0}"),
                new RadioButtonParam(1, "${wiredfurni.params.contract.mode.1}"),
                new RadioButtonParam(2, "${wiredfurni.params.contract.mode.2}")
            ], this.onModeChange);
            this._multiplier = manager.createValueOrVariableSection(0,
                this.mergedSourceOptions(0), "${wiredfurni.params.contract.multiplier_selection}",
                1, 500);
            this._timeout = manager.createNamedNumberInput(
                new NumberInputParam(300, 30, 3600),
                "${wiredfurni.params.contract.timeout.selection}");
            var timeoutOption=
                new CheckboxOptionParam("${wiredfurni.params.contract.timeout.desc}");
            timeoutOption.extra2 = this._timeout;
            this._timeoutEnabled = manager.createCheckboxGroup([timeoutOption]);
            builder.addElements(
                [manager.createSection("${wiredfurni.params.contract.mode}", this._mode),
                this._multiplier,
                manager.createSection("${wiredfurni.params.contract.timeout}",
                    this._timeoutEnabled)]);
        }

        function onModeChange(value:Int)
        {
            this._multiplier.sectionTitle = value == MODE_ALTERNATE_LABEL
                ? "${wiredfurni.params.contract.multiplier_selection2}"
                : "${wiredfurni.params.contract.multiplier_selection}";
            this._multiplier.disabled = value == MODE_NO_MULTIPLIER;
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0);
        }

        override public function isInputSourceDisabled(index:Int, sourceType:Int):Bool
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 0 &&
                (this._multiplier.disabled || this._multiplier.isSourcePickingDisabled());
        }
        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function furniSelectionTitle(index:Int):String
        {
            return index == 0 ? "wiredfurni.params.sources.furni.title.chests" :
                "wiredfurni.params.sources.furni.title.contracts";
        }
        override public function mergedSelections():Array<ASAny> { return [([2, 1] : Array<Dynamic>)]; }
        override public function setMergedType(index:Int, value:Int) { this._multiplier.target = value; }
        override public function getMergedType(index:Int):Int { return this._multiplier.target; }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

