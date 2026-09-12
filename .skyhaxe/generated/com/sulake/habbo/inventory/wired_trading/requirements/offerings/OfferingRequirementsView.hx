package com.sulake.habbo.inventory.wired_trading.requirements.offerings
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.inventory.wired_trading.requirements.WiredTradeRequirementsModel;

     class OfferingRequirementsView implements IDisposable
    {
        public static inline final TYPE_GIVE= 0;
        public static inline final TYPE_RECEIVE= 1;

        var _model:WiredTradeRequirementsModel;
        var _window:IWindowContainer;
        var _ruleTemplate:IWindowContainer;
        var _rules:Vector<OfferingRuleView>;
        var _active:IWindow;
        var _canMinimalizeWidth:Bool = false;
        var _disposed:Bool = false;

        public function new(template:IWindowContainer)
        {
            this._window = Std.downcast(template.clone() , IWindowContainer);
            this._ruleTemplate =
                Std.downcast(this.rulesList.removeListItemAt(0) , IWindowContainer);
        }

        public function initialize(
            model:WiredTradeRequirementsModel,
            type:Int,
            rules:Vector<TradeRequirementRule>,
            customTextValue:String,
            side:Int)
        {
var index = 0, rule:TradeRequirementRule  = null, ruleView:OfferingRuleView  = null;            this.clearRules();
            this._model = model;
            this._rules = new Vector<OfferingRuleView>();
            this.rulesList.visible = false;
            this.customText.visible = false;
            this.anyAllText.visible = false;
            this.anyCoinsText.visible = false;
            this.anyFurniText.visible = false;
            this._active = null;
            this._canMinimalizeWidth = false;

            if (type != TradeRequirement.TYPE_RULES && side == TYPE_GIVE)
            {
                if (type == TradeRequirement.TYPE_CREDIT_FURNI)
                {
                    this.anyCoinsText.visible = true;
                    this._active = this.anyCoinsText;
                }
                else if (type == TradeRequirement.TYPE_NORMAL_FURNI)
                {
                    this.anyFurniText.visible = true;
                    this._active = this.anyFurniText;
                }
                else if (type == TradeRequirement.TYPE_ANY_FURNI)
                {
                    this.anyAllText.visible = true;
                    this._active = this.anyAllText;
                }
            }
            else
            {
                if (rules != null && rules.length > 0)
                {
                    this.rulesList.visible = true;
                    this._active = this.rulesList;
                    this._canMinimalizeWidth = true;
index= 0;
                    if (checkNullIteratee(rules)) for (_tmp_ in rules)
                    {
rule = _tmp_;
ruleView=
                            new OfferingRuleView(this._ruleTemplate);
                        ruleView.initialize(rule, index++);
                        this._rules.push(ruleView);
                        this.rulesList.addListItem(ruleView.window);
                        if (rule.nodes.length != 1)
                        {
                            this._canMinimalizeWidth = false;
                        }
                    }
                }
                if (!this.rulesList.visible && customTextValue != null
                    && customTextValue.length > 0)
                {
                    this.customText.visible = true;
                    this.customText.text = customTextValue;
                    this._active = this.customText;
                    this._canMinimalizeWidth =
                        this.customText.textWidth <= 100;
                }
            }
            this.title.text = model.tradingModel.localization.getLocalization(
                side == TYPE_GIVE
                    ? "inventory.wired_trading.requirements.offering"
                    : "inventory.wired_trading.requirements.receiving");
            this.centerActiveElement();
        }

        public function centerActiveElement()
        {
            if (this._active == null)
            {
                return;
            }
            this._active.y = Std.int(this.requirementsBorder.height / 2
                - this._active.height / 2);
            if (this._rules != null && this._rules.length == 1)
            {
                this._rules[0].center(
                    this.requirementsBorder.width - this.rulesList.x * 2);
            }
        }

        function clearRules()
        {
var rule:OfferingRuleView  = null;            this.rulesList.removeListItems();
            if (this._rules != null)
            {
                final _iter_ = this._rules; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
rule = _tmp_;
                    rule.dispose();
                }
            }
            this._rules = null;
        }

        public var canMinimalizeWidth(get,never):Bool;
public function  get_canMinimalizeWidth():Bool
        { return this._canMinimalizeWidth; }
        public var minBorderHeight(get,never):Int;
public function  get_minBorderHeight():Int
        { return this._active == null ? 0 : this._active.height; }
        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer { return this._window; }

        public function dispose()
        {
            if (this._disposed) { return; }
            this.clearRules();
            this._ruleTemplate.dispose();
            this._ruleTemplate = null;
            this._window.dispose();
            this._window = null;
            this._model = null;
            this._active = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var title(get,never):ITextWindow;
function  get_title():ITextWindow
        { return Std.downcast(this._window.findChildByName("offerings_title") , ITextWindow); }
        var requirementsBorder(get,never):IBorderWindow;
function  get_requirementsBorder():IBorderWindow
        { return Std.downcast(this._window.findChildByName("requirements_definition") , IBorderWindow); }
        var rulesList(get,never):IItemListWindow;
function  get_rulesList():IItemListWindow
        { return Std.downcast(this._window.findChildByName("rules_list") , IItemListWindow); }
        var customText(get,never):ITextWindow;
function  get_customText():ITextWindow
        { return Std.downcast(this._window.findChildByName("custom_text") , ITextWindow); }
        var anyFurniText(get,never):ITextWindow;
function  get_anyFurniText():ITextWindow
        { return Std.downcast(this._window.findChildByName("any_furni_text") , ITextWindow); }
        var anyCoinsText(get,never):ITextWindow;
function  get_anyCoinsText():ITextWindow
        { return Std.downcast(this._window.findChildByName("any_coins_text") , ITextWindow); }
        var anyAllText(get,never):ITextWindow;
function  get_anyAllText():ITextWindow
        { return Std.downcast(this._window.findChildByName("any_all_text") , ITextWindow); }
    }

