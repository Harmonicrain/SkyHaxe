package com.sulake.habbo.roomevents.wired_trading.reward_notification
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.WiredTransactionSuccessContents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.HtmlTextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.HtmlPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.NodeOverviewPreset;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;

     class RewardNotificationView extends AbstractUbuntuWiredUI
    {
        var _parent:RewardNotificationController;
        var _contents:WiredTransactionSuccessContents;
        var _description:TextPreset;
        var _overview:NodeOverviewPreset;
        var _earnings:HtmlPreset;
        var _okButton:ButtonPreset;
        var _viewIndex:Int = 0;

        public function new(
            parent:RewardNotificationController, presetManager:PresetManager)
        {
            super(parent.roomEvents, presetManager);
            this._parent = parent;
            this._description = presetManager.createText("", TextParam.DEFAULT);
            this._overview = presetManager.createNodeOverviewPreset(
                "${wiredrewards.title}", this.onClickNode);
            this._earnings = presetManager.createHtml(
                this.localization.getLocalization("wiredrewards.earnings"),
                HtmlTextParam.DEFAULT);
            this._okButton = presetManager.createButton(
                "${wiredrewards.ok}", this.onClickButton);
            var contents=
                presetManager.createSimpleListView(true,
                    [this._description, this._overview,
                        this._earnings, this._okButton]);
            var padded=
                presetManager.createPaddedContainerPreset(
                    contents, 7, 7, 7, 7);
            this.framePreset = presetManager.createFramePreset(
                [padded], this.onCloseClicked);
            this.framePreset.resizeToWidth(276);
            this.framePreset.title = "${wiredrewards.title}";
        }

        static function hasCreditNode(rule:TradeRequirementRule):Bool
        {
var node:TradeRequirementNode  = null;            final _iter_ = rule.nodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{node = _tmp_;
                if (node.type == TradeRequirementNode.TYPE_COIN) return true;
};
            return false;
        }

        function onClickNode(node:TradeRequirementNode)
        {
            this._parent.openLink(node.type == TradeRequirementNode.TYPE_COIN
                ? "habboUI/open/vault" : "inventory/open");
        }

        function onClickButton() { this.onCloseClicked(); }

        override function hideFrame()
        {
            super.hideFrame();
            this._parent.closeRewardView(this);
        }

        override function  get_isBoundToParentRect():Bool { return true; }

        public function show(contents:WiredTransactionSuccessContents,
            xOffset:Int, yOffset:Int, viewIndex:Int)
        {
            this._contents = contents;
            this._description.text = contents.rewardText.length == 0
                ? "${wiredrewards.desc_default}" : contents.rewardText;
            this._overview.rule = contents.rewardContents;
            this._earnings.visible = hasCreditNode(contents.rewardContents);
            this.showFrame();
            this.window.x += xOffset;
            this.window.y += yOffset;
            this._viewIndex = viewIndex;
        }

        public var viewIndex(get,never):Int;
public function  get_viewIndex():Int { return this._viewIndex; }
        public var contents(get,never):WiredTransactionSuccessContents;
public function  get_contents():WiredTransactionSuccessContents
        {
            return this._contents;
        }

        override public function dispose()
        {
            if (disposed) return;
            if (isShowing()) hide();
            this._okButton = null;
            this._overview = null;
            this._description = null;
            this._earnings = null;
            this._contents = null;
            this._parent = null;
            super.dispose();
        }
    }

