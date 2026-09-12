package com.sulake.habbo.ui.widget.chatinput.habbiconselector
;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.habbicons.HabbiconCollectionData;
    import com.sulake.habbo.catalog.habbicons.HabbiconController;
    import com.sulake.habbo.catalog.habbicons.HabbiconControllerEvent;
    import com.sulake.habbo.catalog.habbicons.HabbiconOwnedItem;
    import com.sulake.habbo.catalog.habbicons.HabbiconShopItem;
    import com.sulake.habbo.catalog.habbicons.HabbiconState;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.habbo.ui.widget.chatinput.RoomChatInputView;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;

     class HabbiconSelector
    {
        static inline final SCREEN_LEFT_BORDER= 92;
        static inline final CHAT_BAR_POPUP_OFFSET= 55;
        static inline final MENU_MIN_HEIGHT= 91;
        static inline final MENU_MAX_HEIGHT= 292;
        static inline final TOP_BAR_HEIGHT= 42;
        static inline final BOTTOM_PADDING= 6;
        static inline final GRID_COLUMNS= 5;
        static inline final SLOT_SIZE= 42;
        static inline final SLOT_SPACING= 2;
        static inline final SLOT_FILLED_COLOR:UInt = 0xFF1F1F1F;
        static inline final SLOT_EMPTY_COLOR:UInt = 0xFF343434;
        static inline final SLOT_FILLED_HOVER_COLOR:UInt = 0xFF2A2A2A;
        static inline final RECENT_LIMIT= 10;

        var _anchor:RoomChatInputView;
        var _button:IWindow;
        var _menuContainer:IWindowContainer;
        var _controller:HabbiconController;
        var _window:IWindowContainer;
        var _sectionList:IItemListWindow;
        var _sectionTemplate:IWindowContainer;
        var _searchInput:ITextFieldWindow;
        var _searchPlaceholder:ITextWindow;
        var _emptyView:IWindow;
        var _sections:Array<ASAny>;
        var _searchEntries:Array<ASAny>;
        var _entriesById:ASDictionary<ASAny,ASAny>;
        var _entryByWindow:ASDictionary<ASAny,ASAny>;
        var _disposed:Bool = false;
        var _sectionsDirty:Bool = true;
        var _layoutDirty:Bool = true;
        var _lastQuery:String = "";

        public function new(anchor:RoomChatInputView, button:IWindow, menuContainer:IWindowContainer, controller:HabbiconController)
        {
            this._anchor = anchor;
            this._button = button;
            this._menuContainer = menuContainer;
            this._controller = controller;
            this._sections = [];
            this._searchEntries = [];
            this._entriesById = new ASDictionary<ASAny,ASAny>();
            this._entryByWindow = new ASDictionary<ASAny,ASAny>(true);
            this.createWindow();
            if (this._controller != null)
            {
                this._controller.addEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onControllerDataUpdated);
                this._controller.addEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onControllerDataUpdated);
                this._controller.addEventListener(HabbiconControllerEvent.RECENT_HABBICONS_UPDATED, this.onControllerDataUpdated);
                this._controller.addEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onControllerDataUpdated);
                this._controller.getShopData(true);
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed || this._window == null;
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return this._window != null && this._window.visible;
        }

        public function toggle()
        {
            if (this._window == null)
            {
                if (this._controller != null)
                {
                    this._controller.openHabbiconHub();
                }
                return;
            }
            if (this._window.visible)
            {
                this.hide();
                return;
            }
            if (this._menuContainer != null)
            {
                this._menuContainer.visible = true;
            }
            this._window.visible = true;
            this.renderIfDirty();
            this.alignToAnchor();
            this._window.activate();
            if (this._searchInput != null)
            {
                this._searchInput.focus();
            }
        }

        public function hide(resetUnseen:Bool = true)
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
            if (this._menuContainer != null)
            {
                this._menuContainer.visible = false;
            }
            if (resetUnseen && this._controller != null)
            {
                this._controller.resetUnseenHabbicons();
                this.invalidateLayout();
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._controller != null)
            {
                this._controller.removeEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onControllerDataUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onControllerDataUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.RECENT_HABBICONS_UPDATED, this.onControllerDataUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onControllerDataUpdated);
            }
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onAssetsLoaded);
            this.clearSections();
            this._sectionTemplate = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._menuContainer != null)
            {
                this._menuContainer.visible = false;
            }
            this._anchor = null;
            this._button = null;
            this._menuContainer = null;
            this._controller = null;
            this._sectionList = null;
            this._searchInput = null;
            this._searchPlaceholder = null;
            this._emptyView = null;
            this._sections = null;
            this._searchEntries = null;
            this._entriesById = null;
            this._entryByWindow = null;
            this._disposed = true;
        }

        function createWindow()
        {
            var asset:XmlAsset = null;
            var close:IWindow = null;
            var openHub:IWindow = null;
            var clear:IWindow = null;
            if (this._anchor == null || this._anchor.widget == null)
            {
                return;
            }
            asset = Std.downcast(this._anchor.widget.assets.getAssetByName("habbiconselector_menu_xml") , XmlAsset);
            if (asset == null || asset.content == null)
            {
                return;
            }
            this._window = Std.downcast(this._anchor.widget.windowManager.buildFromXML((asset.content : com.sulake.core.utils.xml.XML) ) , IWindowContainer);
            if (this._window == null)
            {
                return;
            }
            this._window.visible = false;
            if (this._menuContainer != null)
            {
                this._menuContainer.visible = false;
                this._menuContainer.addChild(this._window);
            }
            this._sectionList = Std.downcast(this._window.findChildByName("habbicon_section_list") , IItemListWindow);
            if (this._sectionList != null)
            {
                this._sectionTemplate = Std.downcast(this._sectionList.removeListItem(this._sectionList.getListItemByName("habbicon_section_template")) , IWindowContainer);
            }
            this._searchInput = Std.downcast(this._window.findChildByName("habbicon_search_input") , ITextFieldWindow);
            this._searchPlaceholder = Std.downcast(this._window.findChildByName("habbicon_search_placeholder") , ITextWindow);
            clear = this._window.findChildByName("habbicon_search_clear_button");
            openHub = this._window.findChildByName("habbicon_open_hub_button");
            this._emptyView = this._window.findChildByName("empty_view");
            close = this._window.findChildByTag("close");
            if (this._searchInput != null)
            {
                this._searchInput.procedure = this.onSearch;
            }
            if (this._searchPlaceholder != null)
            {
                this._searchPlaceholder.text = this.localize("generic.search", "search");
                this._searchPlaceholder.procedure = this.onSearchPlaceholder;
            }
            if (clear != null)
            {
                clear.procedure = this.onSearchClear;
            }
            if (openHub != null)
            {
                openHub.procedure = this.onOpenHub;
            }
            if (close != null)
            {
                close.procedure = this.onClose;
            }
            this.setSearchState(false);
            HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onAssetsLoaded);
        }

        function onControllerDataUpdated(event:Event)
        {
            this.invalidateSections();
            if (this._window != null && this._window.visible)
            {
                this.renderIfDirty();
                this.alignToAnchor();
            }
        }

        function onAssetsLoaded(event:Event)
        {
            this.invalidateLayout();
            if (this._window != null && this._window.visible)
            {
                this.renderIfDirty();
            }
        }

        function invalidateSections()
        {
            this._sectionsDirty = true;
            this._layoutDirty = true;
        }

        function invalidateLayout()
        {
            this._layoutDirty = true;
        }

        function renderIfDirty()
        {
            var query= this.normalizedQuery();
            if (this._lastQuery != query)
            {
                this._layoutDirty = true;
            }
            if (this._sectionsDirty)
            {
                this.refreshSections();
                this._sectionsDirty = false;
            }
            if (this._layoutDirty)
            {
                this.refresh(query);
                this._lastQuery = query;
                this._layoutDirty = false;
            }
            this.setSearchState(query.length > 0);
        }

        function refreshSections()
        {
            var ownedEntries:Array<ASAny> = [];
            var favouriteEntries:Array<ASAny> = [];
            var recentEntries:Array<ASAny> = null;
            this._sections = [];
            this._searchEntries = [];
            this._entriesById = new ASDictionary<ASAny,ASAny>();
            if (this._controller == null)
            {
                return;
            }
            this.collectOwnedEntries(ownedEntries, favouriteEntries);
            this.sortEntries(ownedEntries);
            this.sortEntries(favouriteEntries);
            recentEntries = this.buildRecentEntries();
            if (favouriteEntries.length > 0)
            {
                this._sections.push(new HabbiconSelectorSection("favorites", "favorites", this.localize("habbicons.favourites.title", "Favorites"), favouriteEntries));
            }
            if (recentEntries.length > 0)
            {
                this._sections.push(new HabbiconSelectorSection("recent", "recent", this.localize("habbicon.recently.used", "Recently used"), recentEntries));
            }
            this.addOwnedSetSections();
            if (this._sections.length == 0 && ownedEntries.length > 0)
            {
                this._sections.push(new HabbiconSelectorSection("owned", "owned", this.localize("habbicons.owned", "Owned Habbicons"), ownedEntries));
            }
        }

        function collectOwnedEntries(ownedEntries:Array<ASAny>, favouriteEntries:Array<ASAny>)
        {
            var owned:HabbiconOwnedItem = null;
            var entry:HabbiconSelectorEntry = null;
            var collection:HabbiconCollectionData = null;
            var shopItem:HabbiconShopItem = null;
            final _iter_ = this._controller.ownedHabbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
owned  = _tmp_;
                if (owned != null && HabbiconState.isUsableState(owned.habbiconState))
                {
                    entry = this.getOrCreateEntry(owned.habbiconId, owned.habbiconState == HabbiconState.FAVOURITE);
                    ownedEntries.push(entry);
                    this._searchEntries.push(entry);
                    if (entry.favorite)
                    {
                        favouriteEntries.push(entry);
                    }
                }
            }
            final _iter_ = this._controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                if (collection != null && collection.habbicons != null)
                {
                    final _iter_ = collection.habbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
shopItem  = _tmp_;
                        if (shopItem != null && HabbiconState.isUsableState(shopItem.state) && this._entriesById[shopItem.habbiconId] == null)
                        {
                            entry = this.getOrCreateEntry(shopItem.habbiconId, shopItem.state == HabbiconState.FAVOURITE, shopItem.name);
                            ownedEntries.push(entry);
                            this._searchEntries.push(entry);
                            if (entry.favorite)
                            {
                                favouriteEntries.push(entry);
                            }
                        }
                    }
                }
            }
        }

        function addOwnedSetSections()
        {
            var collection:HabbiconCollectionData = null;
            var shopItem:HabbiconShopItem = null;
            var entries:Array<ASAny> = null;
            var entry:HabbiconSelectorEntry = null;
            if (this._controller == null || !this._controller.hasLoadedShopData)
            {
                return;
            }
            final _iter_ = this._controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                if (collection == null)
                {
                    continue;
                }
                entries = [];
                if (collection.habbicons != null)
                {
                    final _iter_ = collection.habbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
shopItem  = _tmp_;
                        if (shopItem != null)
                        {
                            entry = ASCompat.dynamicAs(this._entriesById[shopItem.habbiconId] , HabbiconSelectorEntry);
                            if (entry != null)
                            {
                                entries.push(entry);
                            }
                        }
                    }
                }
                if (collection.rewardHabbiconId > 0)
                {
                    entry = ASCompat.dynamicAs(this._entriesById[collection.rewardHabbiconId] , HabbiconSelectorEntry);
                    if (entry != null)
                    {
                        entries.push(entry);
                    }
                }
                if (entries.length > 0)
                {
                    this._sections.push(new HabbiconSelectorSection("collection", "collection:" + Std.string(collection.collectionId), this.resolveCollectionTitle(collection), entries));
                }
            }
        }

        function buildRecentEntries():Array<ASAny>
        {
            var id = 0;
            var entry:HabbiconSelectorEntry = null;
            var result:Array<ASAny> = [];
            if (this._controller == null)
            {
                return result;
            }
            final _iter_ = this._controller.recentHabbiconIds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
id  = ASCompat.toInt(_tmp_);
                entry = ASCompat.dynamicAs(this._entriesById[id] , HabbiconSelectorEntry);
                if (entry != null)
                {
                    result.push(entry);
                    if (result.length >= RECENT_LIMIT)
                    {
                        break;
                    }
                }
            }
            return result;
        }

        function refresh(query:String)
        {
            var section:HabbiconSelectorSection = null;
            var filtered:Array<ASAny> = null;
            var entry:HabbiconSelectorEntry = null;
            var count= 0;
            if (this._sectionList == null || this._sectionTemplate == null)
            {
                return;
            }
            this.clearSections();
            if (query.length > 0)
            {
                filtered = [];
                final _iter_ = this._searchEntries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
entry  = _tmp_;
                    if (entry.searchName.indexOf(query) >= 0)
                    {
                        filtered.push(entry);
                    }
                }
                if (filtered.length > 0)
                {
                    this.addSection(new HabbiconSelectorSection("search", "search", this.localize("habbicon.search.results", "Search results"), filtered));
                    count++;
                }
            }
            else
            {
                final _iter_ = this._sections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
section  = _tmp_;
                    if (section != null && section.entries != null && section.entries.length > 0)
                    {
                        this.addSection(section);
                        count++;
                    }
                }
            }
            if (this._emptyView != null)
            {
                this._emptyView.visible = count == 0;
            }
            this.setText(this._window, "empty_text", count == 0 ? this.localize("habbicons.selector.empty", "You do not own any Habbicons yet.") : "");
            this.updateHeight();
        }

        function clearSections()
        {
            var child:IWindow = null;
            this._entryByWindow = new ASDictionary<ASAny,ASAny>(true);
            if (this._sectionList == null)
            {
                return;
            }
            while (this._sectionList.numListItems > 0)
            {
                child = this._sectionList.removeListItemAt(0);
                if (child != null)
                {
                    child.dispose();
                }
            }
        }

        function addSection(section:HabbiconSelectorSection)
        {
            var sectionWindow= this.createSectionWindow(section);
            if (sectionWindow != null)
            {
                this._sectionList.addListItem(sectionWindow);
            }
        }

        function createSectionWindow(section:HabbiconSelectorSection):IWindowContainer
        {
var index = 0;            var sectionWindow= Std.downcast(this._sectionTemplate.clone() , IWindowContainer);
            var grid:IItemGridWindow = null;
            var template:IWindowContainer = null;
            var rows = 0;
            var totalSlots = 0;
            var index = 0;
            var entry:HabbiconSelectorEntry = null;
            var tile:IWindowContainer = null;
            if (sectionWindow == null)
            {
                return null;
            }
            sectionWindow.visible = true;
            this.setText(sectionWindow, "section_title", section.title);
            grid = Std.downcast(sectionWindow.findChildByName("habbicon_grid") , IItemGridWindow);
            if (grid == null)
            {
                return sectionWindow;
            }
            template = Std.downcast(grid.getGridItemAt(0) , IWindowContainer);
            grid.removeGridItems();
            if (template == null)
            {
                return sectionWindow;
            }
            rows = Std.int(Math.max(1, Math.fceil(section.entries.length / GRID_COLUMNS)));
            totalSlots = rows * GRID_COLUMNS;
            for (_tmp_ in 0...totalSlots)
            {
index= _tmp_;
                entry = index < section.entries.length ? ASCompat.dynamicAs(section.entries[index] , HabbiconSelectorEntry) : null;
                tile = this.createTile(entry, template);
                grid.addGridItem(tile);
            }
            grid.height = rows * SLOT_SIZE + (rows - 1) * SLOT_SPACING;
            sectionWindow.height = 20 + grid.height + 2;
            template.dispose();
            return sectionWindow;
        }

        function createTile(entry:HabbiconSelectorEntry, template:IWindowContainer):IWindowContainer
        {
            var tile= Std.downcast(template.clone() , IWindowContainer);
            var bg:IWindow = null;
            tile.visible = true;
            bg = tile.findChildByName("habbicon_item_bg");
            if (bg != null)
            {
                bg.color = entry != null ? SLOT_FILLED_COLOR : SLOT_EMPTY_COLOR;
            }
            if (entry != null)
            {
                tile.id = entry.habbiconId;
                tile.name = "habbicon_selector_item_" + Std.string(entry.habbiconId);
                if (Std.is(tile , IInteractiveWindow))
                {
                    cast(tile, IInteractiveWindow).toolTipCaption = entry.name;
                }
                tile.procedure = this.onTile;
                this.setTileBitmap(tile, entry);
                this._entryByWindow[tile] = entry;
            }
            else
            {
                tile.id = 0;
                this.setTileBitmap(tile, null);
            }
            return tile;
        }

        function setTileBitmap(tile:IWindowContainer, entry:HabbiconSelectorEntry)
        {
            var bitmapWindow= Std.downcast(tile.findChildByName("habbicon_icon") , IBitmapWrapperWindow);
            var bitmap:BitmapData = null;
            if (bitmapWindow == null)
            {
                return;
            }
            if (bitmapWindow.bitmap != null)
            {
                bitmapWindow.bitmap.dispose();
                bitmapWindow.bitmap = null;
            }
            if (entry == null)
            {
                bitmapWindow.visible = false;
                bitmapWindow.invalidate();
                return;
            }
            bitmap = this.createHabbiconBitmap(entry.habbiconId, entry.color);
            bitmapWindow.bitmap = new BitmapData(bitmapWindow.width, bitmapWindow.height, true, 0);
            bitmapWindow.bitmap.copyPixels(bitmap, bitmap.rect, new Point((bitmapWindow.width - bitmap.width) / 2, (bitmapWindow.height - bitmap.height) / 2), null, null, true);
            bitmap.dispose();
            bitmapWindow.visible = true;
            bitmapWindow.invalidate();
        }

        function updateHeight()
        {
            var contentHeight = 0;
            var listHeight = 0;
            if (this._window == null || this._sectionList == null)
            {
                return;
            }
            contentHeight = Std.int(this._sectionList.scrollableRegion.height);
            listHeight = Std.int(Math.max(46, contentHeight + 2));
            listHeight = Std.int(Math.min(listHeight, MENU_MAX_HEIGHT - TOP_BAR_HEIGHT - BOTTOM_PADDING));
            this._sectionList.height = listHeight;
            this._window.height = Std.int(Math.max(MENU_MIN_HEIGHT, TOP_BAR_HEIGHT + listHeight + BOTTOM_PADDING));
            this._window.invalidate();
        }

        function alignToAnchor()
        {
            var rect:Rectangle = null;
            var global:Point = null;
            if (this._window == null || this._button == null || this._menuContainer == null)
            {
                return;
            }
            rect = new Rectangle();
            this._button.getGlobalRectangle(rect);
            this._menuContainer.x = Std.int(rect.x);
            this._menuContainer.y = Std.int(rect.bottom - CHAT_BAR_POPUP_OFFSET - this._window.height);
            global = new Point();
            this._menuContainer.getGlobalPosition(global);
            if (global.x < SCREEN_LEFT_BORDER)
            {
                this._menuContainer.x += Std.int(SCREEN_LEFT_BORDER - global.x);
            }
            if (this._menuContainer.y < 0)
            {
                this._menuContainer.y = 0;
            }
        }

        function onTile(event:WindowEvent, window:IWindow)
        {
            var entry:HabbiconSelectorEntry = null;
            if (event.type != WindowMouseEvent.CLICK || window == null || this._controller == null)
            {
                return;
            }
            entry = ASCompat.dynamicAs(this._entryByWindow[window] , HabbiconSelectorEntry);
            if (entry == null)
            {
                return;
            }
            this._controller.useHabbiconInRoom(entry.habbiconId);
            if (!Std.is(event , WindowMouseEvent) || !cast(event, WindowMouseEvent).shiftKey)
            {
                this.hide(false);
            }
        }

        function onOpenHub(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK && this._anchor != null)
            {
                if (this._controller != null)
                {
                    this._controller.resetUnseenHabbicons();
                }
                this._anchor.widget._Str_13265.context.createLinkEvent("habbicons/open");
                this.hide(false);
            }
        }

        function onSearch(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowEvent.WINDOW_EVENT_CHANGE || (Std.is(event , WindowKeyboardEvent) && cast(event, WindowKeyboardEvent).keyCode == Keyboard.ENTER))
            {
                this.invalidateLayout();
                this.renderIfDirty();
                this.alignToAnchor();
            }
        }

        function onSearchPlaceholder(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.DOWN && this._searchInput != null)
            {
                this._searchInput.focus();
            }
        }

        function onSearchClear(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK && this._searchInput != null)
            {
                this._searchInput.text = "";
                this.invalidateLayout();
                this.renderIfDirty();
                this.alignToAnchor();
            }
        }

        function onClose(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this.hide();
            }
        }

        function normalizedQuery():String
        {
            var value= this._searchInput != null ? this._searchInput.text : "";
            return value != null ? value.toLowerCase() : "";
        }

        function setSearchState(active:Bool)
        {
            if (this._searchPlaceholder != null)
            {
                this._searchPlaceholder.visible = !active && (this._searchInput == null || this._searchInput.text.length == 0);
            }
        }

        function getOrCreateEntry(habbiconId:Int, favorite:Bool, fallbackName:String = null):HabbiconSelectorEntry
        {
            var entry= ASCompat.dynamicAs(this._entriesById[habbiconId] , HabbiconSelectorEntry);
            if (entry == null)
            {
                entry = new HabbiconSelectorEntry(habbiconId, this._controller.resolveHabbiconDisplayName(habbiconId, fallbackName), this.seededColor(habbiconId * 37), favorite);
                this._entriesById[habbiconId] = entry;
            }
            if (favorite)
            {
                entry.favorite = true;
            }
            return entry;
        }

        function sortEntries(entries:Array<ASAny>)
        {
            ASCompat.ASArray.sort(entries, function(a:HabbiconSelectorEntry, b:HabbiconSelectorEntry):Int
            {
                if (a.favorite != b.favorite)
                {
                    return a.favorite ? -1 : 1;
                }
                return a.habbiconId - b.habbiconId;
            });
        }

        function resolveCollectionTitle(collection:HabbiconCollectionData):String
        {
            if (collection.name != null && collection.name.length > 0)
            {
                return this.localize("habbicon_collection_" + collection.name.toLowerCase() + "_name", collection.name);
            }
            return this.localize("habbicons.collection", "Collection");
        }

        function localize(key:String, fallback:String):String
        {
            return this._controller != null ? this._controller.localize(key, fallback) : fallback;
        }

        function setText(container:IWindowContainer, name:String, text:String)
        {
            var field:ITextWindow = container != null ? Std.downcast(container.findChildByName(name) , ITextWindow) : null;
            if (field != null)
            {
                field.text = text;
            }
        }

        function createHabbiconBitmap(habbiconId:Int, color:UInt):BitmapData
        {
            var bitmap= HabbiconAssetManager.getPreviewBitmap(habbiconId, false);
            return bitmap != null ? bitmap.clone() : new BitmapData(40, 40, false, color);
        }

        function seededColor(seed:Int):UInt
        {
            switch (seed % 6)
            {
                case 0:
                    return 0x00F9C52F;
                case 1:
                    return 0x00F39D2F;
                case 2:
                    return 0x00EF7F2F;
                case 3:
                    return 0x008EDBFF;
                case 4:
                    return 0x004DC0E8;
                default:
                    return 0x00C384F5;
            }
        }
    }

