package com.sulake.habbo.inventory.wired_trading.requirements.offerings
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.window.widgets.IProductIconWidget;

     class OfferingNodeView implements IDisposable
    {
        var _window:IItemListWindow;
        var _node:TradeRequirementNode;
        var _index:Int = 0;
        var _disposed:Bool = false;

        public function new(template:IItemListWindow)
        {
            this._window = Std.downcast(template.clone() , IItemListWindow);
        }

        public function initialize(node:TradeRequirementNode, index:Int)
        {
            this._node = node;
            this._index = index;
            this.furniIcon.visible =
                node.type == TradeRequirementNode.TYPE_FURNI;
            this.coinIcon.visible =
                node.type == TradeRequirementNode.TYPE_COIN;
            this.andText.visible = index > 0;
            this.amountText.visible = node.amount > 1;
            if (node.amount > 1)
            {
                this.amountText.text = Std.string(node.amount) + "x";
            }
            if (node.type == TradeRequirementNode.TYPE_FURNI
                && node.itemType != null)
            {
                Std.downcast(this.furniIcon.widget , IProductIconWidget).productInfo =
                    new ChestItemTypeRenderableWrapper(node.itemType);
            }
        }

        public var window(get,never):IItemListWindow;
public function  get_window():IItemListWindow { return this._window; }

        public function dispose()
        {
            if (this._disposed) { return; }
            this._window.dispose();
            this._window = null;
            this._node = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var andText(get,never):ITextWindow;
function  get_andText():ITextWindow
        { return Std.downcast(this._window.getListItemByName("and_text") , ITextWindow); }
        var amountText(get,never):ITextWindow;
function  get_amountText():ITextWindow
        { return Std.downcast(this._window.getListItemByName("amount_text") , ITextWindow); }
        var ruleIcon(get,never):IWindowContainer;
function  get_ruleIcon():IWindowContainer
        { return Std.downcast(this._window.getListItemByName("rule_icon") , IWindowContainer); }
        var furniIcon(get,never):IWidgetWindow;
function  get_furniIcon():IWidgetWindow
        { return Std.downcast(this.ruleIcon.findChildByName("furni_icon") , IWidgetWindow); }
        var coinIcon(get,never):IStaticBitmapWrapperWindow;
function  get_coinIcon():IStaticBitmapWrapperWindow
        { return Std.downcast(this.ruleIcon.findChildByName("coin_icon") , IStaticBitmapWrapperWindow); }
    }

