package com.sulake.habbo.inventory.wired_trading.requirements
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IBubbleWindow;
    import com.sulake.core.window.components.IHTMLTextWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementTypes;
    import com.sulake.habbo.inventory.wired_trading.WiredTradingModel;
    import com.sulake.habbo.inventory.wired_trading.requirements.offerings.OfferingRequirementsView;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

     class WiredTradeRequirementsView implements IDisposable
    {
        static inline final MIN_BORDER_HEIGHT= 80;
        static inline final BORDER_TOP_BOTTOM_OFFSET= 18;
        static inline final MINIMAL_WIDTH= 122;
        static inline final NORMAL_WIDTH= 180;

        var _model:WiredTradeRequirementsModel;
        var _bubble:IBubbleWindow;
        var _offeringTemplate:IWindowContainer;
        var _requirement:TradeRequirement;
        var _give:OfferingRequirementsView;
        var _receive:OfferingRequirementsView;
        var _offeringBorderMargins:Int = 0;
        var _highlightTimer:Timer;
        var _disposed:Bool = false;

        public function new(
            model:WiredTradeRequirementsModel)
        {
            this._model = model;
            this._bubble = Std.downcast(model.tradingModel.getWindowContainer()
                .findChildByName("trade_requirements_bubble") , IBubbleWindow);
            this._bubble.visible = false;
            this.requirementsButton.addEventListener(
                WindowMouseEvent.CLICK, this.onRequirementsClicked);
            this._offeringTemplate = Std.downcast(this.youGiveContainer.getChildByName(
                "offering_requirements_template") , IWindowContainer);
            this._offeringBorderMargins = this._offeringTemplate.height
                - this._offeringTemplate.findChildByName(
                    "requirements_definition").height;
            this.youGiveContainer.removeChild(this._offeringTemplate);
            this.recenter();
        }

        function onRequirementsClicked(event:WindowMouseEvent)
        {
            this._bubble.visible = !this._bubble.visible;
        }

        public function requirementsUpdated(
            requirement:TradeRequirement, showImmediate:Bool)
        {
var receiveRules:Vector<TradeRequirementRule>  = null;            this.clear();
            this._requirement = requirement;
            var paymentOnly= requirement.isPaymentOnly();
            this.bubbleTitle.text =
                this.tradingModel.localization.getLocalizationWithParams(
                    "inventory.wired_trading.requirements.title", "",
                    ["type", this.tradingModel.tradeTypeLocalization]);

            var showReceive= !paymentOnly
                || (requirement.youGetText != null
                    && requirement.youGetText.length > 0);
            this.offeringContainersSeparator.visible = showReceive;
            this.youGetContainer.visible = showReceive;

            this._give = new OfferingRequirementsView(
                this._offeringTemplate);
            this._give.initialize(
                this._model,
                requirement.type,
                requirement.rules == null
                    ? null : requirement.rules.youGiveRule,
                null,
                OfferingRequirementsView.TYPE_GIVE);
            this.youGiveContainer.addChild(this._give.window);
            this.stretchToParent(this._give.window);

            if (showReceive)
            {
receiveRules=
                    new Vector<TradeRequirementRule>();
                if (requirement.rules != null
                    && requirement.rules.youGetRule != null)
                {
                    receiveRules.push(requirement.rules.youGetRule);
                }
                this._receive = new OfferingRequirementsView(
                    this._offeringTemplate);
                this._receive.initialize(
                    this._model,
                    requirement.type,
                    receiveRules,
                    requirement.youGetText,
                    OfferingRequirementsView.TYPE_RECEIVE);
                this.youGetContainer.addChild(this._receive.window);
                this.stretchToParent(this._receive.window);
            }

            this.requirementsStateUpdated();
            this.disclaimerText.visible = paymentOnly && showReceive;
            if (this.disclaimerText.visible)
            {
                this.disclaimerText.text =
                    this.tradingModel.localization.getLocalizationWithParams(
                        "inventory.wired_trading.requirements.receive_text_disclaimer",
                        "",
                        ["you_get_name",
                        this.tradingModel.localization.getLocalization(
                            "inventory.wired_trading.requirements.receiving")]);
                this.resizeHtml(this.disclaimerText);
            }
            this._bubble.visible = showImmediate;
        }

        public function requirementsStateUpdated()
        {
var key:String  = null;            if (this._requirement == null || this._give == null)
            {
                return;
            }
            var met= this.tradingModel.canAccept;
            var amount= this.tradingModel.extra;
            if (this._requirement.rules != null
                && this._requirement.rules.type
                    == TradeRequirementTypes.FIXED_MULTIPLIER)
            {
                this.requirementsMetText.text =
                    this.tradingModel.localization.getLocalizationWithParams(
                        "inventory.wired_trading.requirements.indicator.multi",
                        "",
                        ["times", this._requirement.rules.multiplier,
                        "amount", amount]);
            }
            else if (met)
            {
                if (this._requirement.rules != null
                    && this._requirement.rules.type
                        == TradeRequirementTypes.AUTO_MULTIPLIER
                    && amount > 1)
                {
                    this.requirementsMetText.text =
                        this.tradingModel.localization.getLocalizationWithParams(
                            "inventory.wired_trading.requirements.indicator.met_numbered",
                            "", ["amount", amount]);
                }
                else
                {
                    this.requirementsMetText.text =
                        this.tradingModel.localization.getLocalization(
                            "inventory.wired_trading.requirements.indicator.met");
                }
            }
            else
            {
                this.requirementsMetText.text =
                    this.tradingModel.localization.getLocalization(
                        "inventory.wired_trading.requirements.indicator.not_met");
            }
            this.resizeHtml(this.requirementsMetText);
            this.requirementsMetIcon.assetUri =
                met ? "common_check_mark" : "common_cross_mark";

            this.additionalText.visible = false;
            if (this._requirement.rules != null
                && this._requirement.rules.type
                    == TradeRequirementTypes.AUTO_MULTIPLIER)
            {
                this.additionalText.visible = true;
key= this._requirement.isPaymentOnly()
                    ? "inventory.wired_trading.requirements.auto_mode_hint_payment"
                    : "inventory.wired_trading.requirements.auto_mode_hint_trade";
                this.additionalText.text =
                    this.tradingModel.localization.getLocalizationWithParams(
                        key, "",
                        ["amount", this._requirement.rules.autoMultiplierMax]);
                this.resizeHtml(this.additionalText);
            }
            this.resizeRequirementContainers();
            this.recenter();
        }

        function resizeRequirementContainers()
        {
            var width= NORMAL_WIDTH;
            if (this.youGetContainer.visible && this._receive != null
                && this._give.canMinimalizeWidth
                && this._receive.canMinimalizeWidth)
            {
                width = MINIMAL_WIDTH;
            }
            this.youGiveContainer.width = width;
            this.youGetContainer.width = width;

            var borderHeight= this._give.minBorderHeight;
            if (this._receive != null)
            {
                borderHeight = Std.int(Math.max(
                    borderHeight, this._receive.minBorderHeight));
            }
            borderHeight = Std.int(Math.max(
                MIN_BORDER_HEIGHT,
                borderHeight + 2 * BORDER_TOP_BOTTOM_OFFSET));
            this.offeringContainersSeparator.height = borderHeight;
            var containerHeight=
                borderHeight + this._offeringBorderMargins;
            this.youGiveContainer.height = containerHeight;
            this.youGetContainer.height = containerHeight;
            this._give.centerActiveElement();
            if (this._receive != null)
            {
                this._receive.centerActiveElement();
            }
        }

        function stretchToParent(window:IWindowContainer)
        {
            window.width = window.parent.width;
            window.height = window.parent.height;
            window.setParamFlag(128, true);
            window.setParamFlag(2048, true);
        }

        function resizeHtml(window:IHTMLTextWindow)
        {
            window.height = window.numLines * 15 + 2;
        }

        function recenter()
        {
            this._bubble.x = this.requirementsButton.x
                + this.requirementsButton.width + 4;
            this._bubble.y = Std.int(this.requirementsButton.y
                + this.requirementsButton.height / 2
                - this._bubble.height / 2);
        }

        public function highlightRefresh()
        {
            if (this._highlightTimer != null)
            {
                this._highlightTimer.stop();
                this._highlightTimer.reset();
            }
            this.highlightBorder.visible = true;
            this.highlightBorder.blend = 0.35;
            this._highlightTimer = new Timer(500, 1);
            this._highlightTimer.addEventListener(
                TimerEvent.TIMER_COMPLETE, (this.onHighlightComplete : ASAny));
            this._highlightTimer.start();
        }

        function onHighlightComplete(event:TimerEvent)
        {
            this.highlightBorder.visible = false;
        }

        function clear()
        {
            if (this._give != null)
            {
                if (this._give.window.parent != null)
                {
                    this.youGiveContainer.removeChild(this._give.window);
                }
                this._give.dispose();
                this._give = null;
            }
            if (this._receive != null)
            {
                if (this._receive.window.parent != null)
                {
                    this.youGetContainer.removeChild(this._receive.window);
                }
                this._receive.dispose();
                this._receive = null;
            }
            this._requirement = null;
        }

        public function dispose()
        {
            if (this._disposed) { return; }
            this.clear();
            this.requirementsButton.removeEventListener(
                WindowMouseEvent.CLICK, this.onRequirementsClicked);
            if (this._highlightTimer != null)
            {
                this._highlightTimer.stop();
                this._highlightTimer.removeEventListener(
                    TimerEvent.TIMER_COMPLETE, (this.onHighlightComplete : ASAny));
                this._highlightTimer = null;
            }
            this.youGiveContainer.addChild(this._offeringTemplate);
            this._offeringTemplate = null;
            this._bubble = null;
            this._model = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var tradingModel(get,never):WiredTradingModel;
function  get_tradingModel():WiredTradingModel
        { return this._model.tradingModel; }
        var requirementsButton(get,never):IRegionWindow;
function  get_requirementsButton():IRegionWindow
        { return this.tradingModel.tradingView.requirementsButton; }
        var bubbleTitle(get,never):ITextWindow;
function  get_bubbleTitle():ITextWindow
        { return Std.downcast(this._bubble.findChildByName("bubble_title") , ITextWindow); }
        var highlightBorder(get,never):IBorderWindow;
function  get_highlightBorder():IBorderWindow
        { return Std.downcast(this._bubble.findChildByName("highlight_border") , IBorderWindow); }
        var youGiveContainer(get,never):IWindowContainer;
function  get_youGiveContainer():IWindowContainer
        { return Std.downcast(this._bubble.findChildByName("you_give_container") , IWindowContainer); }
        var youGetContainer(get,never):IWindowContainer;
function  get_youGetContainer():IWindowContainer
        { return Std.downcast(this._bubble.findChildByName("you_get_container") , IWindowContainer); }
        var offeringContainersSeparator(get,never):IWidgetWindow;
function  get_offeringContainersSeparator():IWidgetWindow
        { return Std.downcast(this._bubble.findChildByName("offering_containers_separator") , IWidgetWindow); }
        var requirementsMetText(get,never):IHTMLTextWindow;
function  get_requirementsMetText():IHTMLTextWindow
        { return Std.downcast(this._bubble.findChildByName("req_met_text") , IHTMLTextWindow); }
        var requirementsMetIcon(get,never):IStaticBitmapWrapperWindow;
function  get_requirementsMetIcon():IStaticBitmapWrapperWindow
        { return Std.downcast(this._bubble.findChildByName("req_met_icon") , IStaticBitmapWrapperWindow); }
        var additionalText(get,never):IHTMLTextWindow;
function  get_additionalText():IHTMLTextWindow
        { return Std.downcast(this._bubble.findChildByName("additional_text") , IHTMLTextWindow); }
        var disclaimerText(get,never):IHTMLTextWindow;
function  get_disclaimerText():IHTMLTextWindow
        { return Std.downcast(this._bubble.findChildByName("disclaimer_text") , IHTMLTextWindow); }
    }

