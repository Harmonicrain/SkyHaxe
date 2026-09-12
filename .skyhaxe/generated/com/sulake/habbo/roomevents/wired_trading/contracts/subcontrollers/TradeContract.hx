package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRulesDefinition;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.TradeRuleEditorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.TradeRuleListEditorPreset;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.util.AbstractContract;

     class TradeContract extends AbstractContract
    {
        var _giveRules:TradeRuleListEditorPreset;
        var _getRule:TradeRuleEditorPreset;

        public function new(parent:WiredContractController,
            presetManager:PresetManager)
        {
            super(parent, presetManager);
            this._giveRules = presetManager.createRuleListEditorPreset(
                parent.addEditContractElement.onEdit,
                parent.addEditContractElement.onAdd);
            var giveSection= presetManager.createSection(
                "${wiredcontracts.payment_requirements}", this._giveRules);
            this._getRule = presetManager.createRuleEditorPreset(
                "${wiredcontracts.reward_rule}",
                parent.addEditContractElement.onEdit,
                parent.addEditContractElement.onAdd);
            var getSection= presetManager.createSection(
                "${wiredcontracts.reward_requirements}", this._getRule);
            this.framePreset = presetManager.createFramePreset(
                [giveSection, getSection, this.footerPreset],
                this.onCloseClicked);
            this.framePreset.resizeToWidth(262);
            this.framePreset.title = "${wiredcontracts.trade_contract.title}";
        }

        override function createNewDefinitionFromUI():TradeRequirementRulesDefinition
        {
            return new TradeRequirementRulesDefinition(
                this._giveRules.finalizeRules(), this._getRule.finalizeRule());
        }

        override public function show(contents:ChestContractContentsMessageParser)
        {
            if (contents.contractType != this.contractType() ||
                contents.definition.youGiveRule == null ||
                contents.definition.youGetRule == null) return;
            super.show(contents);
            this._giveRules.rules = contents.definition.youGiveRule;
            this._getRule.rule = contents.definition.youGetRule;
            this.showFrame();
        }

        override public function contractType():Int { return 1; }

        override public function dispose()
        {
            if (disposed) return;
            this._giveRules = null;
            this._getRule = null;
            super.dispose();
        }
    }

