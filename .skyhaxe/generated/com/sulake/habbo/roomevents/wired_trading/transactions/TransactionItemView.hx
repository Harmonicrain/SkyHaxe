package com.sulake.habbo.roomevents.wired_trading.transactions
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.ChestItemTypeRenderableWrapper;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.FurniChestItemView;
    import com.sulake.habbo.window.widgets.IProductIconWidget;

    /** One pooled icon in July's deposit/withdrawal details grids. */
     final class TransactionItemView implements IDisposable
    {
        public static inline final TYPE_FURNI= 0;
        public static inline final TYPE_COINS= 1;
        public static inline final TYPE_INCOMPLETE= 2;

        var _window:IRegionWindow;
        var _amount:Int = 0;
        var _kind:Int = 0;
        var _hovered:Bool = false;
        var _disposed:Bool = false;

        public function new(template:IRegionWindow)
        {
            this._window = Std.downcast(template.clone() , IRegionWindow);
            this._window.addEventListener("WME_OVER", this.onOver);
            this._window.addEventListener("WME_OUT", this.onOut);
        }

        public function initialize(amount:Int, kind:Int, type:ChestItemType=null)
        {
            this._amount = Std.int(Math.max(0, amount));
            this._kind = kind;
            this._window.toolTipCaption = kind == TYPE_COINS
                ? "${wiredcontracts.element.type.0}"
                : kind == TYPE_INCOMPLETE
                    ? "${wiredchests.log_details.incomplete_data}" : "";
            this.furniIcon.visible = kind == TYPE_FURNI && type != null;
            if (this.furniIcon.visible)
            {
                Std.downcast(this.furniIcon.widget , IProductIconWidget).productInfo =
                    new ChestItemTypeRenderableWrapper(type);
            }
            this.coinsIcon.visible = kind == TYPE_COINS;
            this.incompleteText.visible = kind == TYPE_INCOMPLETE;
            this.limitedBackground.visible = false;
            this.limitedOverlay.visible = false;
            this.rarityOverlay.visible = false;
            this.updateUI();
            this.updateColoring();
        }

        function updateUI()
        {
            if (this._kind == TYPE_INCOMPLETE)
            {
                this.numberContainer.visible = false;
                this.incompleteText.fontSize = this._amount >= 1000 ? 12 : 16;
                this.incompleteText.text = "+" + Std.string(this._amount);
            }
            else
            {
                this.numberContainer.visible = this._amount > 1;
                if (this._amount > 1)
                {
                    this.quantity.text = Std.string(this._amount);
                }
            }
        }
        function onOver(event:WindowMouseEvent)
        {
            this._hovered = true; this.updateColoring();
        }
        function onOut(event:WindowMouseEvent)
        {
            this._hovered = false; this.updateColoring();
        }
        function updateColoring()
        {
            this.focus.visible = false;
            this.border.color = this._hovered
                ? FurniChestItemView.HOVERED_COLOR
                : FurniChestItemView.NOT_HOVERED_COLOR;
        }
        public function recycle()
        {
            this._hovered = false;
            this._amount = 0;
            this._kind = TYPE_FURNI;
        }
        public var window(get,never):IRegionWindow;
public function  get_window():IRegionWindow { return this._window; }
        var border(get,never):IBorderWindow;
function  get_border():IBorderWindow
        {
            return Std.downcast(this._window.findChildByName("border") , IBorderWindow);
        }
        var focus(get,never):IStaticBitmapWrapperWindow;
function  get_focus():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._window.findChildByName("outline_focus")
, IStaticBitmapWrapperWindow);
        }
        var coinsIcon(get,never):IStaticBitmapWrapperWindow;
function  get_coinsIcon():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._window.findChildByName("coins_icon")
, IStaticBitmapWrapperWindow);
        }
        var incompleteText(get,never):ITextWindow;
function  get_incompleteText():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("incomplete_text") , ITextWindow);
        }
        var furniIcon(get,never):IWidgetWindow;
function  get_furniIcon():IWidgetWindow
        {
            return Std.downcast(this._window.findChildByName("furni_icon") , IWidgetWindow);
        }
        var numberContainer(get,never):IWindowContainer;
function  get_numberContainer():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("number_container")
, IWindowContainer);
        }
        var quantity(get,never):ITextWindow;
function  get_quantity():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("furni_quantity") , ITextWindow);
        }
        var limitedBackground(get,never):IStaticBitmapWrapperWindow;
function  get_limitedBackground():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._window.findChildByName("unique_item_background_bitmap")
, IStaticBitmapWrapperWindow);
        }
        var limitedOverlay(get,never):IWidgetWindow;
function  get_limitedOverlay():IWidgetWindow
        {
            return Std.downcast(this._window.findChildByName("unique_item_overlay_container")
, IWidgetWindow);
        }
        var rarityOverlay(get,never):IWidgetWindow;
function  get_rarityOverlay():IWidgetWindow
        {
            return Std.downcast(this._window.findChildByName("rarity_item_overlay_container")
, IWidgetWindow);
        }
        public function dispose()
        {
            if (this._disposed) { return; }
            this._window.dispose();
            this._window = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

