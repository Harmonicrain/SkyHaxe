package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;
    import com.sulake.habbo.window.widgets.ILimitedItemGridOverlayWidget;
    import com.sulake.habbo.window.widgets.IProductIconWidget;
    import com.sulake.habbo.window.widgets._Str_11987;

     class FurniChestItemView implements IDisposable
    {
        public static inline final NOT_HOVERED_COLOR:UInt = 13355979;
        public static inline final HOVERED_COLOR:UInt = 14079702;
        var _disposed:Bool = false;
        var _storages:Vector<ChestStorage>;
        var _owner:FurniChestView;
        var _active:Bool = false;
        var _hovered:Bool = false;
        var _window:IRegionWindow;

        public function new(template:IRegionWindow)
        {
            this._window = Std.downcast(template.clone() , IRegionWindow);
            this._window.addEventListener("WME_CLICK", this.onClick);
            this._window.addEventListener("WME_OVER", this.onOver);
            this._window.addEventListener("WME_OUT", this.onOut);
        }
        public function initialize(owner:FurniChestView,
            storages:Vector<ChestStorage>)
        {
            this._owner = owner;
            this._storages = storages;
            this.initializeUI();
        }
        function initializeUI()
        {
var limitedWidget:ILimitedItemGridOverlayWidget  = null;            var storage= this.peek();
            if (storage == null) { return; }
            var limited= storage.stuffData.uniqueSerialNumber > 0;
            this.ltdBackgroundBitmap.visible = limited;
            this.ltdOverlayWidget.visible = limited;
            if (limited)
            {
limitedWidget=
                    Std.downcast(this.ltdOverlayWidget.widget , ILimitedItemGridOverlayWidget);
                limitedWidget.serialNumber = storage.stuffData.uniqueSerialNumber;
                limitedWidget.seriesSize = storage.stuffData.uniqueSeriesSize;
            }
            var rare= storage.specialType == 19;
            this.rarityOverlayWidget.visible = rare;
            if (rare)
            {
                Std.downcast(this.rarityOverlayWidget.widget , _Str_11987)
                    .rarityLevel = storage.stuffData.rarityLevel;
            }
            this.furniIcon.visible = true;
            Std.downcast(this.furniIcon.widget , IProductIconWidget).productInfo =
                new ChestItemTypeRenderableWrapper(storage.type);
            this.updateUI();
            this.updateColoring();
        }
        public var window(get,never):IRegionWindow;
public function  get_window():IRegionWindow { return this._window; }
        public var numItems(get,never):Int;
public function  get_numItems():Int { return this._storages == null ? 0 : this._storages.length; }
        public function peek():ChestStorage
        {
            return this.numItems == 0 ? null : this._storages[0];
        }
        public function remove(storage:ChestStorage)
        {
            var index= this._storages.indexOf(storage);
            if (index >= 0) { this._storages.splice(index, 1); }
            this.updateUI();
        }
        public function add(storage:ChestStorage)
        {
            this._storages.push(storage);
            this.updateUI();
        }
        function updateUI()
        {
            this.numberContainer.visible = this.numItems > 1;
            if (this.numItems > 1) { this.furniQuantity.text = Std.string(this.numItems); }
        }
        function updateColoring()
        {
            if (this._window == null) { return; }
            var outline= this.focusOutline;
            var itemBorder= this.border;
            if (outline != null) { outline.visible = this._active; }
            if (itemBorder != null)
            {
                itemBorder.color = this._hovered ? HOVERED_COLOR : NOT_HOVERED_COLOR;
            }
        }
        function onOut(event:WindowMouseEvent)
        {
            this._hovered = false; this.updateColoring();
        }
        function onOver(event:WindowMouseEvent)
        {
            this._hovered = true; this.updateColoring();
        }
        function onClick(event:WindowMouseEvent)
        {
            if (this._owner != null) { this._owner.selectItemView(this); }
        }
        public function activate() { this._active = true; this.updateColoring(); }
        public function deactivate() { this._active = false; this.updateColoring(); }
        public function recycle()
        {
            this._storages = null; this._active = false; this._hovered = false;
            this._owner = null;
        }
        public function dispose()
        {
            if (this._disposed) { return; }
            this._storages = null;
            if (this._window != null) { this._window.dispose(); }
            this._window = null;
            this._owner = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var border(get,never):IBorderWindow;
function  get_border():IBorderWindow
        {
            return Std.downcast(this._window.findChildByName("border") , IBorderWindow);
        }
        var focusOutline(get,never):IStaticBitmapWrapperWindow;
function  get_focusOutline():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._window.findChildByName("outline_focus") , IStaticBitmapWrapperWindow);
        }
        var ltdBackgroundBitmap(get,never):IStaticBitmapWrapperWindow;
function  get_ltdBackgroundBitmap():IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._window.findChildByName("unique_item_background_bitmap")
, IStaticBitmapWrapperWindow);
        }
        var furniIcon(get,never):IWidgetWindow;
function  get_furniIcon():IWidgetWindow
        {
            return Std.downcast(this._window.findChildByName("furni_icon") , IWidgetWindow);
        }
        var numberContainer(get,never):IWindowContainer;
function  get_numberContainer():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("number_container") , IWindowContainer);
        }
        var furniQuantity(get,never):ITextWindow;
function  get_furniQuantity():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("furni_quantity") , ITextWindow);
        }
        var ltdOverlayWidget(get,never):IWidgetWindow;
function  get_ltdOverlayWidget():IWidgetWindow
        {
            return Std.downcast(this._window.findChildByName("unique_item_overlay_container") , IWidgetWindow);
        }
        var rarityOverlayWidget(get,never):IWidgetWindow;
function  get_rarityOverlayWidget():IWidgetWindow
        {
            return Std.downcast(this._window.findChildByName("rarity_item_overlay_container") , IWidgetWindow);
        }
    }

