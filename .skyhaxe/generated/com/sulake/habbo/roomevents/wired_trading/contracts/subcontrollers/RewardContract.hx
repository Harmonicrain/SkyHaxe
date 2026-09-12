package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers
;
    import com.sulake.core.communication.util.Short;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRulesDefinition;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.TradeRuleEditorPreset;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.util.AbstractContract;

     class RewardContract extends AbstractContract
    {
        var _rule:TradeRuleEditorPreset;
        var _category:DropdownPreset;
        var _categorySection:SectionPreset;
        var _rewardText:TextAreaPreset;
        var _showByDefault:CheckboxGroupPreset;

        public function new(parent:WiredContractController,
            presetManager:PresetManager)
        {
            super(parent, presetManager);
            this._rule = presetManager.createRuleEditorPreset(
                "${wiredcontracts.reward_rule}",
                parent.addEditContractElement.onEdit,
                parent.addEditContractElement.onAdd, null,
                this.onRulesChange);
            var ruleSection= presetManager.createSection(
                "${wiredcontracts.reward_requirements}", this._rule);
            this._rewardText = presetManager.createTextArea(new TextAreaParam(
                52, -1, 3, -1, 200, "",
                "${wiredcontracts.reward_contract.reward_popup.text.tooltip}"));
            this._showByDefault = presetManager.createCheckboxGroup([
                new CheckboxOptionParam(
                    "${wiredcontracts.reward_contract.reward_popup.show_by_default}")
            ]);
            var popupContents=
                presetManager.createSimpleListView(true,
                    [this._rewardText, this._showByDefault]);
            var popupSection= presetManager.createSection(
                "${wiredcontracts.reward_contract.reward_popup}", popupContents);
            var options=
                Vector.ofArray([
                    new ExpandableDropdownOption(11,
                        "${wiredfurni.params.earnings_category.11}"),
                    new ExpandableDropdownOption(13,
                        "${wiredfurni.params.earnings_category.13}")
                ]);
            this._category = presetManager.createDropdown(new DropdownParam(
                "${wiredcontracts.reward_contract.earnings_category}", options));
            this._categorySection = presetManager.createSection(
                "${wiredcontracts.reward_contract.earnings_category}",
                this._category, SectionParam.COLLAPSED);
            this.framePreset = presetManager.createFramePreset(
                [ruleSection, popupSection, this._categorySection,
                    this.footerPreset], this.onCloseClicked);
            this.framePreset.resizeToWidth(262);
            this.framePreset.title = "${wiredcontracts.reward_contract.title}";
        }

        function onRulesChange()
        {
            this._categorySection.disabled = !this.hasCreditNode();
        }

        function hasCreditNode():Bool
        {
var node:TradeRequirementNode  = null;            var rule= this._rule.finalizeRule();
            final _iter_ = rule.nodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{node = _tmp_;
                if (node.type == TradeRequirementNode.TYPE_COIN) return true;
};
            return false;
        }

        override function createNewDefinitionFromUI():TradeRequirementRulesDefinition
        {
            return new TradeRequirementRulesDefinition(null, this._rule.finalizeRule());
        }

        override public function show(contents:ChestContractContentsMessageParser)
        {
            if (contents.contractType != this.contractType() ||
                contents.definition.youGetRule == null) return;
            super.show(contents);
            this._rule.rule = contents.definition.youGetRule;
            this._showByDefault.get(0).selected = contents.showDialog;
            this._category.selectedId = contents.rewardCategory;
            this._rewardText.text = contents.rewardText;
            this.onRulesChange();
            this._categorySection.updateDisabledState();
            this.showFrame();
        }

        override public function addContentsToComposer(data:Array<ASAny>)
        {
            super.addContentsToComposer(data);
            data.push(new Short(this._category.selectedId));
            data.push(this._showByDefault.get(0).selected);
            data.push(this._rewardText.text);
        }

        override public function contractType():Int { return 2; }

        override public function dispose()
        {
            if (disposed) return;
            this._rule = null;
            this._category = null;
            this._categorySection = null;
            this._rewardText = null;
            this._showByDefault = null;
            super.dispose();
        }
    }

