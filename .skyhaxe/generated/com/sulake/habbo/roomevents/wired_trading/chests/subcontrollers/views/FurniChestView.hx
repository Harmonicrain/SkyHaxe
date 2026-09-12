package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IScrollableGridWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.FurniChestSubController;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.window.widgets.ProductImageWidget;

     class FurniChestView implements IDisposable
    {
        static inline final SEARCH_THRESHOLD= 31;
        static inline final SEARCH_OFFSET= 28;
        var _disposed:Bool = false;
        var _controller:FurniChestSubController;
        var _container:IWindowContainer;
        var _itemTemplate:IRegionWindow;
        var _groupedViews:Map;
        var _storageViews:Map;
        var _selected:FurniChestItemView;
        var _views:Vector<FurniChestItemView>;
        var _search:String = "";

        public function new(controller:FurniChestSubController)
        {
            this._controller = controller;
            this._container = Std.downcast(this.roomEvents.getXmlWindow("furni_chest_contents")
, IWindowContainer);
            if (this._container != null && this._container.parent != null)
            {
                this._container.parent = null;
            }
            this._itemTemplate = Std.downcast(this.itemGrid.removeGridItemAt(0) , IRegionWindow);
            this._groupedViews = new Map();
            this._storageViews = new Map();
            this._views = new Vector<FurniChestItemView>();
            this.withdrawInput.restrict = "0-9";
            this.withdrawButton.addEventListener("WME_CLICK", this.onWithdrawClick);
            this.viewLogsButton.addEventListener("WME_CLICK", this.onViewLogsClick);
            this.searchInput.addEventListener("WE_CHANGE", this.onSearchChanged);
            this.searchInput.addEventListener("WKE_KEY_DOWN", this.onSearchKeyDown);
            this.searchClearButton.addEventListener("WME_CLICK", this.onClearSearch);
        }
        public static function itemTypeKey(type:ChestItemType):String
        {
            return (type.isWallItem ? "1" : "0") + "-" + Std.string(type.typeId) + "-"
                + type.legacyPosterId;
        }
        public static function getStorageName(storage:ChestStorage,
            localization:IHabboLocalizationManager, session:ISessionDataManager):String
        {
            var data:IFurnitureData = null;
            if (storage.type.isWallItem)
            {
                if (storage.specialType == 6 && storage.type.legacyPosterId != "")
                {
                    return localization.getLocalization("poster_"
                        + storage.type.legacyPosterId + "_name");
                }
                data = session.getWallItemData(storage.type.typeId);
            }
            else
            {
                data = session.getFloorItemData(storage.type.typeId);
            }
            return data == null ? "(missing item name)" : data.localizedName;
        }
        function onWithdrawClick(event:WindowMouseEvent)
        {
            var amount:Float = ASCompat.parseInt(this.withdrawInput.text);
            if (!Math.isNaN(amount) && amount > 0 && this._selected != null
                && this._selected.peek() != null)
            {
                this._controller.withdrawItemsWithType(this._selected.peek().type, Std.int(amount));
            }
        }
        function onViewLogsClick(event:WindowMouseEvent)
        {
            if (this._selected != null && this._selected.peek() != null)
            {
                this._controller.viewLogsWithType(this._selected.peek().type);
            }
        }
        function onSearchChanged(event:WindowEvent)
        {
            this.searchPlaceholder.visible = this.searchInput.text.length == 0;
            this.searchClearButton.visible = this.searchInput.text.length > 0;
        }
        function onSearchKeyDown(event:WindowKeyboardEvent)
        {
            if (event.keyCode == 13)
            {
                this._search = this.searchInput.text;
                this.updateGrid();
            }
            else if (event.keyCode == 27)
            {
                this.clearSearch();
                this.updateGrid();
            }
        }
        function onClearSearch(event:WindowMouseEvent)
        {
            this.clearSearch();
            this.updateGrid();
        }
        function clearSearch()
        {
            this.searchInput.text = "";
            this.searchClearButton.visible = false;
            this.searchPlaceholder.visible = true;
            this._search = "";
        }
        public function itemsInitialize(storages:Vector<ChestStorage>)
        {
var storage:ChestStorage  = null;            this.clear();
            if (checkNullIteratee(storages)) for (_tmp_ in storages) { storage = _tmp_;
this.addStorage(storage); }
            this.updateGrid();
            this.selectFirstIfNeeded();
        }
        public function itemsUpdated(removed:Vector<ChestStorage>,
            added:Vector<ChestStorage>)
        {
var oldStorage:ChestStorage  = null, newStorage:ChestStorage  = null;            if (checkNullIteratee(removed)) for (_tmp_ in removed)
            {
oldStorage = _tmp_;
                this.removeStorage(oldStorage);
            }
            if (checkNullIteratee(added)) for (_tmp_ in added) { newStorage = _tmp_;
this.addStorage(newStorage); }
            this.updateGrid();
            this.selectFirstIfNeeded();
            this._controller.wrapperView.updateUI();
        }
        function addStorage(storage:ChestStorage)
        {
var group:Vector<ChestStorage>  = null;            var groupKey= itemTypeKey(storage.type);
            if (storage.stuffData.uniqueSerialNumber > 0)
            {
                groupKey += "-limited-" + Std.string(storage.inventoryId);
            }
            else if (storage.specialType == 19)
            {
                groupKey += "-rarity-" + Std.string(storage.stuffData.rarityLevel);
            }
            var view:FurniChestItemView = this._groupedViews.getValue(groupKey);
            if (view == null)
            {
group= new Vector<ChestStorage>();
                group.push(storage);
                view = new FurniChestItemView(this._itemTemplate);
                view.initialize(this, group);
                this._groupedViews.add(groupKey, view);
                this._views.push(view);
            }
            else
            {
                view.add(storage);
            }
            this._storageViews.add(storage.inventoryId, view);
        }
        function removeStorage(storage:ChestStorage)
        {
var index = 0, keys:Array<ASAny>  = null, key:ASObject  = null;            var view= ASCompat.dynamicAs(this._storageViews.remove(storage.inventoryId)
, FurniChestItemView);
            if (view == null) { return; }
            view.remove(storage);
            if (view.numItems == 0)
            {
                if (this._selected == view) { this.selectItemView(null); }
index= this._views.indexOf(view);
                if (index >= 0) { this._views.splice(index, 1); }
keys= this._groupedViews.getKeys();
                if (checkNullIteratee(keys)) for (_tmp_ in keys)
                {
key = _tmp_;
                    if (this._groupedViews.getValue(key) == view)
                    {
                        this._groupedViews.remove(key);
                        break;
                    }
                }
                view.dispose();
            }
        }
        public function clear()
        {
var view:FurniChestItemView  = null;            // Clear selection while its view is still alive. Deactivating a
            // disposed view dereferences its null window during chunk refresh.
            this.selectItemView(null);
            this.itemGrid.removeGridItems();
            final _iter_ = this._views; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) { view = _tmp_;
view.dispose(); }
            this._views = new Vector<FurniChestItemView>();
            this._groupedViews.reset();
            this._storageViews.reset();
            this.updatePreviewUI();
        }
        public function updateGrid()
        {
var view:FurniChestItemView  = null, name:String  = null, matches = false, word:String  = null;            this.updateSearchVisibility();
            this.itemGrid.removeGridItems();
            var words:Array<ASAny> = this._search.length > 0
                ? (cast this._search.toLowerCase().split(" ")) : null;
            final _iter_ = this._views; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
view = _tmp_;
                if (words != null)
                {
name= this.getChestStorageName(view.peek()).toLowerCase();
matches= true;
                    if (checkNullIteratee(words)) for (_tmp_ in words)
                    {
word = _tmp_;
                        if (name.indexOf(word) < 0) { matches = false; break; }
                    }
                    if (!matches) { continue; }
                }
                this.itemGrid.addGridItem(view.window);
            }
            this.noItemsText.visible = this.itemGrid.numGridItems == 0;
        }
        function updateSearchVisibility()
        {
            if (!this.searchBorder.visible && this._views.length >= SEARCH_THRESHOLD)
            {
                this.searchBorder.visible = true;
                this.clearSearch();
                this.itemGrid.y += SEARCH_OFFSET;
                this.itemGrid.height -= SEARCH_OFFSET;
            }
            else if (this.searchBorder.visible && this._views.length < SEARCH_THRESHOLD)
            {
                this.searchBorder.visible = false;
                this.clearSearch();
                this.itemGrid.y -= SEARCH_OFFSET;
                this.itemGrid.height += SEARCH_OFFSET;
            }
        }
        public function selectItemView(view:FurniChestItemView)
        {
            if (this._selected != null && !this._selected.disposed)
            {
                this._selected.deactivate();
            }
            this._selected = view;
            if (this._selected != null && !this._selected.disposed)
            {
                this._selected.activate();
            }
            else if (this._selected != null)
            {
                this._selected = null;
            }
            this.updatePreviewUI();
        }
        function selectFirstIfNeeded()
        {
            if (this._selected == null && this._views.length > 0)
            {
                this.selectItemView(this._views[0]);
            }
        }
        public function updatePreviewUI()
        {
            var widget= Std.downcast(this.previewWidget.widget , ProductImageWidget);
            if (this._selected == null || this._selected.peek() == null)
            {
                this.previewFurniName.text = "";
                if (widget != null) { widget.clearPreviewer(); }
                this.viewLogsButton.disable();
                this.withdrawButton.disable();
                this.placeholderPreviewImage.visible = true;
                return;
            }
            var storage= this._selected.peek();
            this.placeholderPreviewImage.visible = false;
            Util.disableSection(this.viewLogsButton, !this._controller.canRead);
            Util.disableSection(this.withdrawButton, !this._controller.canWithdraw);
            this.previewFurniName.text = this.getChestStorageName(storage);
            if (widget != null)
            {
                widget.productInfo = new ChestItemTypeRenderableWrapper(storage.type);
            }
        }
        public function getChestStorageName(storage:ChestStorage):String
        {
            return getStorageName(storage, this._controller.localization,
                this._controller.parentController.sessionDataManager);
        }
        public function updateUI() { this.updatePreviewUI(); }
        public var container(get,never):IWindowContainer;
public function  get_container():IWindowContainer { return this._container; }
        var roomEvents(get,never):HabboUserDefinedRoomEvents;
function  get_roomEvents():HabboUserDefinedRoomEvents { return this._controller.roomEvents; }
        public function dispose()
        {
            if (this._disposed) { return; }
            this.clear();
            this._container.dispose();
            this._container = null;
            this._itemTemplate.dispose();
            this._itemTemplate = null;
            this._groupedViews.dispose();
            this._storageViews.dispose();
            this._groupedViews = null;
            this._storageViews = null;
            this._controller = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var itemGrid(get,never):IScrollableGridWindow;
function  get_itemGrid():IScrollableGridWindow
        { return Std.downcast(this._container.findChildByName("grid_items") , IScrollableGridWindow); }
        var searchBorder(get,never):IBorderWindow;
function  get_searchBorder():IBorderWindow
        { return Std.downcast(this._container.findChildByName("search_border") , IBorderWindow); }
        var searchPlaceholder(get,never):ITextWindow;
function  get_searchPlaceholder():ITextWindow
        { return Std.downcast(this._container.findChildByName("search_placeholder") , ITextWindow); }
        var searchInput(get,never):ITextFieldWindow;
function  get_searchInput():ITextFieldWindow
        { return Std.downcast(this._container.findChildByName("search_input") , ITextFieldWindow); }
        var searchClearButton(get,never):IRegionWindow;
function  get_searchClearButton():IRegionWindow
        { return Std.downcast(this._container.findChildByName("clear_search_button") , IRegionWindow); }
        var noItemsText(get,never):ITextWindow;
function  get_noItemsText():ITextWindow
        { return Std.downcast(this._container.findChildByName("no_items_text") , ITextWindow); }
        var previewFurniName(get,never):ITextWindow;
function  get_previewFurniName():ITextWindow
        { return Std.downcast(this._container.findChildByName("furni_name") , ITextWindow); }
        var previewWidget(get,never):IWidgetWindow;
function  get_previewWidget():IWidgetWindow
        { return Std.downcast(this._container.findChildByName("preview_image") , IWidgetWindow); }
        var placeholderPreviewImage(get,never):IStaticBitmapWrapperWindow;
function  get_placeholderPreviewImage():IStaticBitmapWrapperWindow
        { return Std.downcast(this._container.findChildByName("placeholder_preview_image") , IStaticBitmapWrapperWindow); }
        var withdrawInput(get,never):ITextFieldWindow;
function  get_withdrawInput():ITextFieldWindow
        { return Std.downcast(this._container.findChildByName("withdraw_input") , ITextFieldWindow); }
        var withdrawButton(get,never):IButtonWindow;
function  get_withdrawButton():IButtonWindow
        { return Std.downcast(this._container.findChildByName("withdraw_btn") , IButtonWindow); }
        var viewLogsButton(get,never):IButtonWindow;
function  get_viewLogsButton():IButtonWindow
        { return Std.downcast(this._container.findChildByName("view_logs_by_furni_btn") , IButtonWindow); }
    }

