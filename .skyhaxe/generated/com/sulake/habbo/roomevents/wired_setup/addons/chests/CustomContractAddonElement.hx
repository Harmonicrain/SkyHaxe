package com.sulake.habbo.roomevents.wired_setup.addons.chests
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.addons.AddonCodes;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 20: override a contract's payment and reward requirements. */
     class CustomContractAddonElement extends DefaultElement
    {
        static inline final TYPE_FURNI= 1;

        var _paymentEnabled:CheckboxGroupPreset;
        var _paymentType:RadioGroupPreset;
        var _paymentAmount:ValueOrVariableSection;
        var _rewardEnabled:CheckboxGroupPreset;
        var _rewardType:RadioGroupPreset;
        var _rewardAmount:ValueOrVariableSection;

        override public function  get_code():Int { return AddonCodes.CUSTOM_CONTRACT; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.CHESTS |
                WiredCapabilityCodes.CHEST_WIRED | WiredCapabilityCodes.CONTRACTS |
                WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [
                this._paymentEnabled.get(0).selected ? 1 : 0,
                this._paymentType.selected,
                this._paymentAmount.option,
                this._paymentAmount.numberValue,
                this._paymentAmount.target,
                this._rewardEnabled.get(0).selected ? 1 : 0,
                this._rewardType.selected,
                this._rewardAmount.option,
                this._rewardAmount.numberValue,
                this._rewardAmount.target
            ];
        }

        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._paymentAmount.finalizeSelection, this._rewardAmount.finalizeSelection];
        }

        override public function onEditStart(definition:Triggerable)
        {
            this.initSide(definition, true);
            this.initSide(definition, false);
            this.onPaymentEnabled(0, this._paymentEnabled.get(0).selected);
            this.onRewardEnabled(0, this._rewardEnabled.get(0).selected);
        }

        function initSide(definition:Triggerable, payment:Bool)
        {
            var base= payment ? 0 : 5;
            var variableIndex= payment ? 0 : 1;
            var enabled= definition.intData.length > base &&
                ASCompat.toInt(definition.intData[base]) != 0;
            var type= definition.intData.length > base + 1 ?
                ASCompat.toInt(definition.intData[base + 1]) : 0;
            var option= definition.intData.length > base + 2 ?
                ASCompat.toInt(definition.intData[base + 2]) : 0;
            var amount= definition.intData.length > base + 3 ?
                ASCompat.toInt(definition.intData[base + 3]) : 1;
            var target= definition.intData.length > base + 4 ?
                ASCompat.toInt(definition.intData[base + 4]) : 0;
            var variableId= definition.variableIds.length > variableIndex ?
                ASCompat.toString(definition.variableIds[variableIndex]) : WiredVariable.NONE_ID;
            if (enabled)
            {
                if (option == 0) variableId = WiredVariable.NONE_ID;
                else amount = 1;
            }
            else
            {
                variableId = WiredVariable.NONE_ID;
                amount = 1;
            }
            var enabledGroup= payment ?
                this._paymentEnabled : this._rewardEnabled;
            var typeGroup= payment ? this._paymentType : this._rewardType;
            var valueSection= payment ?
                this._paymentAmount : this._rewardAmount;
            enabledGroup.get(0).selected = enabled;
            typeGroup.selected = type;
            valueSection.init(definition.wiredContext.roomVariablesList, variableId,
                target, option, amount);
        }

        override public function onEditInitialized()
        {
            this._paymentAmount.onEditInitialized();
            this._rewardAmount.onEditInitialized();
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._paymentType = this.createTypeGroup(manager, this.onPaymentType);
            this._paymentAmount = manager.createValueOrVariableSection(0,
                this.mergedSourceOptions(0),
                "${wiredfurni.params.custom_contract.amount_selection}", 1, 100000);
            var paymentList= manager.createSimpleListView(true, [
                manager.createSection("${wiredfurni.params.custom_contract.element_type_selection}",
                    this._paymentType),
                manager.createSpacer(style.sectionSpacing),
                this._paymentAmount
            ]);
            paymentList.spacing = 0;
            var paymentOption=
                new CheckboxOptionParam("${wiredfurni.params.custom_contract.enable_payment}");
            paymentOption.extra2 = paymentList;
            this._paymentEnabled = manager.createCheckboxGroup([paymentOption],
                this.onPaymentEnabled);

            this._rewardType = this.createTypeGroup(manager, this.onRewardType);
            this._rewardAmount = manager.createValueOrVariableSection(1,
                this.mergedSourceOptions(1),
                "${wiredfurni.params.custom_contract.amount_selection}", 1, 100000);
            var rewardList= manager.createSimpleListView(true, [
                manager.createSection("${wiredfurni.params.custom_contract.element_type_selection}",
                    this._rewardType),
                manager.createSpacer(style.sectionSpacing),
                this._rewardAmount
            ]);
            rewardList.spacing = 0;
            var rewardOption=
                new CheckboxOptionParam("${wiredfurni.params.custom_contract.enable_reward}");
            rewardOption.extra2 = rewardList;
            this._rewardEnabled = manager.createCheckboxGroup([rewardOption],
                this.onRewardEnabled);

            builder.addElements(
                [manager.createUsageInfoSection(
                    "${wiredfurni.params.custom_contract.usage_warning}", true),
                manager.createSection("${wiredfurni.params.custom_contract.payment}",
                    this._paymentEnabled, SectionParam.COLLAPSED),
                manager.createSection("${wiredfurni.params.custom_contract.reward}",
                    this._rewardEnabled, SectionParam.COLLAPSED),
                manager.createWrapperPreset(style.createSplitterView())]);
        }

        function createTypeGroup(manager:PresetManager, callback:ASFunction):RadioGroupPreset
        {
            return manager.createRadioGroup([
                new RadioButtonParam(0,
                    "${wiredfurni.params.custom_contract.element_type_selection.0}"),
                new RadioButtonParam(1,
                    "${wiredfurni.params.custom_contract.element_type_selection.1}")
            ], callback, 2);
        }

        function onPaymentEnabled(index:Int, selected:Bool)
        {
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.FURNI_SOURCE, 0);
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0);
        }
        function onRewardEnabled(index:Int, selected:Bool)
        {
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.FURNI_SOURCE, 1);
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 1);
        }
        function onPaymentType(value:Int)
        {
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.FURNI_SOURCE, 0);
        }
        function onRewardType(value:Int)
        {
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.FURNI_SOURCE, 1);
        }

        override public function isInputSourceDisabled(index:Int, sourceType:Int):Bool
        {
            if (sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 0)
                return !this._paymentEnabled.get(0).selected ||
                    this._paymentAmount.isSourcePickingDisabled();
            if (sourceType == WiredInputSourcePicker.MERGED_SOURCE && index == 1)
                return !this._rewardEnabled.get(0).selected ||
                    this._rewardAmount.isSourcePickingDisabled();
            if (sourceType == WiredInputSourcePicker.FURNI_SOURCE && index == 0)
                return !this._paymentEnabled.get(0).selected ||
                    this._paymentType.selected != TYPE_FURNI;
            if (sourceType == WiredInputSourcePicker.FURNI_SOURCE && index == 1)
                return !this._rewardEnabled.get(0).selected ||
                    this._rewardType.selected != TYPE_FURNI;
            return false;
        }

        override public function mergedSelectionTitle(index:Int):String
        {
            return index == 0 ?
                "wiredfurni.params.sources.merged.title.variables_reference_payment" :
                "wiredfurni.params.sources.merged.title.variables_reference_reward";
        }
        override public function furniSelectionTitle(index:Int):String
        {
            return index == 0 ? "wiredfurni.params.sources.furni.title.payment" :
                "wiredfurni.params.sources.furni.title.reward";
        }
        override public function mergedSelections():Array<ASAny> { return [([2, 0] : Array<Dynamic>), ([3, 1] : Array<Dynamic>)]; }
        override public function setMergedType(index:Int, value:Int)
        {
            if (index == 0) this._paymentAmount.target = value;
            else this._rewardAmount.target = value;
        }
        override public function getMergedType(index:Int):Int
        {
            return index == 0 ? this._paymentAmount.target : this._rewardAmount.target;
        }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }
        override public function  get_widthModifier():Float { return 1.2; }

	public function new() { super(); }
    }

