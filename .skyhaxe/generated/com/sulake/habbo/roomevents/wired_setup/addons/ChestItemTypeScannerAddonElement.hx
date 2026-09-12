package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ChooseVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 18: write an opened chest's item type into a context variable. */
     class ChestItemTypeScannerAddonElement extends DefaultElement
    {
        var _variable:ChooseVariableSection;
        var _mode:RadioGroupPreset;

        override public function  get_code():Int { return AddonCodes.CHEST_ITEM_TYPE_SCANNER; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.CHESTS |
                WiredCapabilityCodes.CHEST_WIRED | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && value.hasValue && value.canCreateAndDelete && value.canWriteValue;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._variable = manager.createChooseVariableSection(0, null,
                this.variableSelectionFilter, null);
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("chest_item_type_scanner.0")),
                new RadioButtonParam(1, this.l("chest_item_type_scanner.1"))
            ]);
            builder.addElements([manager.createUsageInfoSection(this.l("chest_item_type_scanner.info")),
                this._variable, manager.createSection(this.l("chest_item_type_scanner"), this._mode)]);
        }

        override public function onEditStart(definition:Triggerable)
        {
            var variableId= definition.variableIds.length > 0 ? ASCompat.toString(definition.variableIds[0]) : null;
            this._variable.init(definition.wiredContext.roomVariablesList, variableId,
                VariableExtraSourceTypes.CONTEXT_SOURCE);
            this._mode.selected = definition.intData.length > 0 ? ASCompat.toInt(definition.intData[0]) : 0;
        }

        override public function onEditInitialized() { this._variable.onEditInitialized(); }
        override public function readVariableIdsFromForm():Array<ASAny> { return [this._variable.finalizeSelection]; }
        override public function readIntParamsFromForm():Array<ASAny> { return [this._mode.selected]; }
        override public function furniSelectionTitle(index:Int):String
        {
            return index == 0 ? "wiredfurni.params.sources.furni.title.item_types" :
                "wiredfurni.params.sources.furni.title.chests";
        }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }

	public function new() { super(); }
    }

