package com.sulake.habbo.roomevents.wired_setup.actiontypes.chests
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Shared July editor contract for actions 45 and 46. */
     class GiveFromChestActionElement extends DefaultElement
    {
        static inline final MODE_AMOUNT= 0;
        static inline final MODE_ALL= 1;

        var _modeSection:SectionPreset;
        var _amount:ValueOrVariableSection;
        var _popupSection:SectionPreset;
        var _mode:RadioGroupPreset;
        var _popupText:TextAreaPreset;
        var _showPopup:CheckboxGroupPreset;

        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.CHESTS | WiredCapabilityCodes.CHEST_WIRED |
                WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._mode.selected, this._amount.numberValue, this._amount.option,
                this._amount.target, this._showPopup.get(0).selected ? 1 : 0];
        }

        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._amount.finalizeSelection];
        }

        override public function readStringParamFromForm():String { return this._popupText.text; }

        override public function onEditStart(definition:Triggerable)
        {
            var values= definition.intData;
            var variableId= definition.variableIds.length > 0 ?
                ASCompat.toString(definition.variableIds[0]) : WiredVariable.NONE_ID;
            var mode= values.length > 0 ? ASCompat.toInt(values[0]) : MODE_AMOUNT;
            var amount= values.length > 1 ? ASCompat.toInt(values[1]) : 1;
            var option= values.length > 2 ? ASCompat.toInt(values[2]) : 0;
            var target= values.length > 3 ? ASCompat.toInt(values[3]) : 0;
            if (mode == MODE_AMOUNT)
            {
                if (option == 0) variableId = WiredVariable.NONE_ID;
                else amount = 1;
            }
            else
            {
                variableId = WiredVariable.NONE_ID;
                amount = 1;
            }
            this._mode.selected = mode;
            this._amount.disabled = mode == MODE_ALL;
            this._amount.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, amount);
            this._showPopup.get(0).selected = values.length > 4 && ASCompat.toInt(values[4]) != 0;
            this._popupText.text = definition.stringData;
        }

        override public function onEditInitialized() { this._amount.onEditInitialized(); }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(MODE_AMOUNT, this.l("rewarding_mode.0")),
                new RadioButtonParam(MODE_ALL, this.l("rewarding_mode.1"))
            ], this.onModeChange);
            this._modeSection = manager.createSection(this.l("rewarding_mode"), this._mode);
            this._amount = manager.createValueOrVariableSection(0, this.mergedSourceOptions(0),
                this.l("amount_to_give"), 1, 2147483647);
            this._popupText = manager.createTextArea(new TextAreaParam(45, -1, 3, -1, 200,
                "", "${wiredfurni.reward_contract.reward_popup.text.tooltip}"));
            this._showPopup = manager.createCheckboxGroup([new CheckboxOptionParam(
                "${wiredfurni.reward_contract.reward_popup.show_by_default}")]);
            var list= manager.createSimpleListView(true,
                [this._popupText, this._showPopup]);
            this._popupSection = manager.createSection(
                "${wiredfurni.reward_contract.reward_popup}", list);
            this.finalizeBuilding(builder);
        }

        function finalizeBuilding(builder:WiredUIBuilder)
        {
            builder.addElements([this._modeSection, this._amount, this._popupSection]);
        }

        var rewardingMode(get,never):Int;
function  get_rewardingMode():Int { return this._mode.selected; }

        function onModeChange(value:Int)
        {
            this._amount.disabled = value == MODE_ALL;
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0);
        }

        override public function isInputSourceDisabled(index:Int, sourceType:Int):Bool
        {
            return sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 0 &&
                (this._amount.isSourcePickingDisabled() || this._amount.disabled);
        }

        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function furniSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.furni.title.chests";
        }
        override public function userSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.users.title.reward_user";
        }
        override public function mergedSelections():Array<ASAny> { return [([1, 1] : Array<Dynamic>)]; }
        override public function setMergedType(index:Int, value:Int) { this._amount.target = value; }
        override public function getMergedType(index:Int):Int { return this._amount.target; }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

