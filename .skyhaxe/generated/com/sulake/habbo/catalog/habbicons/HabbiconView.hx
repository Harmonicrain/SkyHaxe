package com.sulake.habbo.catalog.habbicons
;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class HabbiconView
    {
        static inline final TAB_ALL= 0;
        static inline final TAB_OWNED= 1;
        static inline final TAB_FAVOURITED= 2;
        static inline final EMPTY_TILE_COUNT= 20;
        static final HABBICON_LOCKED_TRANSFORM:ColorTransform = new ColorTransform(0.35, 0.35, 0.35, 0.65, 90, 85, 80, 0);
        static inline final PROGRESS_INCOMPLETE_COLOR:UInt = 0xFF54A8E8;
        static inline final PROGRESS_COMPLETE_COLOR:UInt = 0xFF78C95C;

        var _controller:HabbiconController;
        var _window:IWindowContainer;
        var _setRowTemplate:IWindowContainer;
        var _tileTemplate:IWindowContainer;
        var _emptyTileTemplate:IWindowContainer;
        var _trayGroupTemplate:IWindowContainer;
        var _trayTileTemplate:IWindowContainer;
        var _selectedCollectionId:Int = 0;
        var _selectedHabbiconId:Int = 0;
        var _activeTile:IWindowContainer;
        var _activeTab:Int = 0;
        var _disposed:Bool = false;

        public function new(controller:HabbiconController)
        {
            this._controller = controller;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function show()
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            if (this._window == null)
            {
                return;
            }
            this.refresh();
            this._window.visible = true;
            this._window.center();
            this._window.activate();
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._controller != null)
            {
                this._controller.removeEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onControllerUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onControllerUpdated);
                this._controller.removeEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onControllerUpdated);
            }
            this._setRowTemplate = null;
            this._tileTemplate = null;
            this._emptyTileTemplate = null;
            this._trayGroupTemplate = null;
            this._trayTileTemplate = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._controller = null;
            this._disposed = true;
        }

        function createWindow()
        {
            var asset= Std.downcast(this._controller.assets.getAssetByName("habbicon_view_xml") , XmlAsset);
            if (asset == null || asset.content == null)
            {
                return;
            }
            this._window = Std.downcast(this._controller.windowManager.buildFromXML((asset.content : com.sulake.core.utils.xml.XML) , 1) , IWindowContainer);
            if (this._window == null)
            {
                return;
            }
            this._window.name = "habbicon_hub";
            this.extractTemplates();
            this.wireStaticControls();
            this.clearSetPage();
            this.hidePopup();
            this._controller.addEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onControllerUpdated);
            this._controller.addEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onControllerUpdated);
            this._controller.addEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onControllerUpdated);
        }

        function extractTemplates()
        {
            var trayGrid:IItemGridWindow = null;
            this._setRowTemplate = this.extractTemplate("set_row_template");
            if (this._setRowTemplate != null)
            {
                this._setRowTemplate.visible = false;
            }
            this._tileTemplate = this.extractTemplate("tile_template");
            this._emptyTileTemplate = this.extractTemplate("empty_tile_template");
            if (this._tileTemplate != null)
            {
                this._tileTemplate.visible = false;
            }
            if (this._emptyTileTemplate != null)
            {
                this._emptyTileTemplate.visible = false;
            }
            this._trayGroupTemplate = this.extractTemplate("tray_group_template");
            if (this._trayGroupTemplate != null)
            {
                this._trayGroupTemplate.visible = false;
                trayGrid = Std.downcast(this._trayGroupTemplate.findChildByName("tray_group_grid") , IItemGridWindow);
                if (trayGrid != null)
                {
                    this._trayTileTemplate = this.extractTemplateFromParent(this._trayGroupTemplate, "tray_tile_template");
                    if (this._trayTileTemplate != null)
                    {
                        this._trayTileTemplate.visible = false;
                    }
                }
            }
        }

        function extractTemplate(name:String):IWindowContainer
        {
            return this.extractTemplateFromParent(this._window, name);
        }

        function extractTemplateFromParent(parent:IWindowContainer, name:String):IWindowContainer
        {
            var template:IWindowContainer = parent == null ? null : Std.downcast(parent.findChildByName(name) , IWindowContainer);
            var templateParent:IWindowContainer = null;
            if (template == null)
            {
                return null;
            }
            templateParent = Std.downcast(template.parent , IWindowContainer);
            if (templateParent != null)
            {
                templateParent.removeChild(template);
            }
            template.visible = false;
            return template;
        }

        function wireStaticControls()
        {
            this.setProcedureByTag("close", this.onClose);
            this.setProcedure("tab_all_sets", this.onTabAll);
            this.setProcedure("tab_owned", this.onTabOwned);
            this.setProcedure("tab_favourited", this.onTabFavourited);
            this.setProcedure("reward_action_button", this.onRewardAction);
            this.setProcedure("reward_buy_button", this.onBuyCollection);
            this.setProcedure("habbicon_popup_action_button", this.onPopupAction);
            this.setProcedure("habbicon_popup_buy_button", this.onPopupBuy);
        }

        function refresh()
        {
            if (this._window == null)
            {
                return;
            }
            this.ensureSelectedCollection();
            this.setText("album_title", this._controller.localize("habbicons.hub.title", "Habbicons"));
            this.setText("album_subtitle", this._controller.localize("habbicons.hub.subtitle", "Collect sets, unlock animated Habbicons, and use them inside rooms!"));
            this.setText("owned_habbicons_label", this._controller.localize("habbicons.owned", "Owned habbicons"));
            this.setText("sets_completed_label", this._controller.localize("habbicons.sets", "Sets completed"));
            this.setText("owned_habbicons_value", Std.string(this.countOwned()));
            this.setText("sets_completed_value", Std.string(this.countCompletedSets()));
            this.updateOverallProgress();
            this.updateTabs();
            if (this._activeTab == TAB_ALL)
            {
                this.populateSetRail();
                if (this.getSelectedCollection() != null)
                {
                    this.populateSetPage(this.getSelectedCollection());
                }
                else
                {
                    this.clearSetPage();
                }
            }
            else
            {
                this.populateTray();
            }
            this.hidePopup();
        }

        function updateTabs()
        {
            var allSets= this._window.findChildByName("all_sets_container");
            var tray= this._window.findChildByName("tray_container");
            if (allSets != null)
            {
                allSets.visible = this._activeTab == TAB_ALL;
            }
            if (tray != null)
            {
                tray.visible = this._activeTab != TAB_ALL;
            }
            this.setText("tray_title", this._activeTab == TAB_OWNED ? this._controller.localize("habbicons.tab.owned", "Owned") : this._controller.localize("habbicons.tab.favourited", "Favorited"));
            this.setText("tray_summary", this._activeTab == TAB_OWNED ? this._controller.localize("habbicons.tray.owned.summary", "All Habbicons you own.") : this._controller.localize("habbicons.tray.favourited.summary", "Your favourite Habbicons."));
        }

        function populateSetRail()
        {
            var list= Std.downcast(this._window.findChildByName("set_rail_list") , IItemListWindow);
            var collection:HabbiconCollectionData = null;
            if (list == null || this._setRowTemplate == null)
            {
                return;
            }
            list.removeListItems();
            final _iter_ = this._controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                list.addListItem(this.createSetRow(collection));
            }
        }

        function createSetRow(collection:HabbiconCollectionData):IWindowContainer
        {
            var row= Std.downcast(this._setRowTemplate.clone() , IWindowContainer);
            var progress:ASObject = this.getCollectionProgress(collection);
            row.visible = true;
            row.id = collection.collectionId;
            row.name = "set_row_" + Std.string(collection.collectionId);
            row.procedure = this.onSetRowEvent;
            this.setChildText(row, "set_row_title", this.collectionName(collection));
            this.setChildBitmap(row, "set_icon", this.getCollectionRailIcon(collection));
            this.setChildProgress(row, "set_row_progress_bar", ASCompat.toInt(progress.owned), ASCompat.toInt(progress.total));
            this.setChildText(row, "set_row_progress_text", progress.owned + "/" + progress.total);
            this.tintRow(row, collection.collectionId == this._selectedCollectionId);
            return row;
        }

        function populateSetPage(collection:HabbiconCollectionData)
        {
var empty:IWindowContainer  = null;            var grid= Std.downcast(this._window.findChildByName("set_grid") , IItemGridWindow);
            var item:HabbiconShopItem = null;
            var reward:HabbiconShopItem = null;
            var progress:ASObject = null;
            var count = 0;
            if (collection == null || grid == null || this._tileTemplate == null)
            {
                this.clearSetPage();
                return;
            }
            progress = this.getCollectionProgress(collection);
            grid.removeGridItems();
            this.setText("set_title", this.collectionName(collection));
            this.setText("set_description", this.collectionDescription(collection));
            this.setProgress("set_progress_bar", ASCompat.toInt(progress.owned), ASCompat.toInt(progress.total));
            this.setText("set_progress_text", progress.owned + " / " + progress.total);
            final _iter_ = collection.habbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
                if (item == null || item.state == HabbiconState.REWARD_MARKER)
                {
                    reward = item;
                    continue;
                }
                grid.addGridItem(this.createTile(item, false));
                count++;
            }
            while (count < EMPTY_TILE_COUNT && this._emptyTileTemplate != null)
            {
empty= Std.downcast(this._emptyTileTemplate.clone() , IWindowContainer);
                empty.visible = true;
                grid.addGridItem(empty);
                count++;
            }
            this.populateRewardPanel(collection, reward);
            this.populateBuyPanel(collection, progress);
        }

        function populateRewardPanel(collection:HabbiconCollectionData, reward:HabbiconShopItem)
        {
            var panel= this._window.findChildByName("reward_panel");
            var rewardId = 0;
            var rewardState = 0;
            var button:IWindow = null;
            if (panel == null)
            {
                return;
            }
            rewardId = reward != null ? reward.habbiconId : collection.rewardHabbiconId;
            rewardState = reward != null ? reward.state : collection.rewardState;
            panel.visible = rewardId > 0;
            if (!panel.visible)
            {
                return;
            }
            this.setText("reward_title", this._controller.localize("habbicons.reward.title", "Set reward"));
            if (HabbiconState.isUsableState(rewardState))
            {
                this.setText("reward_description", this._controller.localize("habbicon_book.reward.claimed", "Reward claimed."));
            }
            else if (rewardState == HabbiconState.CLAIMABLE)
            {
                this.setText("reward_description", this._controller.localize("habbicon_book.reward.claimable", "Reward ready to claim."));
            }
            else
            {
                this.setText("reward_description", this._controller.localize("habbicons.reward.description", "Complete this set to unlock the reward."));
            }
            this.setBitmap("reward_habbicon", HabbiconAssetManager.getPreviewBitmap(rewardId, false));
            button = this._window.findChildByName("reward_action_button");
            if (button != null)
            {
                button.id = rewardId;
                button.visible = rewardState == HabbiconState.CLAIMABLE || HabbiconState.isUsableState(rewardState);
                button.enable();
                button.caption = rewardState == HabbiconState.CLAIMABLE ? this._controller.localize("habbicon_reward.claim", "Claim") : this._controller.localize("habbicon_reward.claimed", "Claimed");
                if (rewardState != HabbiconState.CLAIMABLE)
                {
                    button.disable();
                }
            }
        }

        function clearSetPage()
        {
            var grid:IItemGridWindow = this._window == null ? null : Std.downcast(this._window.findChildByName("set_grid") , IItemGridWindow);
            var panel:IWindow = this._window == null ? null : this._window.findChildByName("reward_panel");
            var buyPanel:IWindow = this._window == null ? null : this._window.findChildByName("reward_buy_container");
            if (grid != null)
            {
                grid.removeGridItems();
            }
            this.setText("set_title", "");
            this.setText("set_description", "");
            this.setProgress("set_progress_bar", 0, 0);
            this.setText("set_progress_text", "0 / 0");
            if (panel != null)
            {
                panel.visible = false;
            }
            if (buyPanel != null)
            {
                buyPanel.visible = false;
            }
        }

        function populateBuyPanel(collection:HabbiconCollectionData, progress:ASObject)
        {
            var panel= this._window.findChildByName("reward_buy_container");
            var button:IWindow = null;
            if (panel == null)
            {
                return;
            }
            panel.visible = progress.owned < progress.total && (collection.priceCredits > 0 || collection.priceActivityPoints > 0);
            if (!panel.visible)
            {
                return;
            }
            this.setText("reward_buy_description", this._controller.localize("habbicons.buy_set", "Buy the full set"));
            this.setText("reward_buy_price", this.formatPrice(collection.priceCredits, collection.priceActivityPoints));
            button = this._window.findChildByName("reward_buy_button");
            if (button != null)
            {
                button.id = collection.collectionId;
            }
        }

        function populateTray()
        {
            var list= Std.downcast(this._window.findChildByName("tray_group_list") , IItemListWindow);
            var collection:HabbiconCollectionData = null;
            var group:IWindowContainer = null;
            if (list == null || this._trayGroupTemplate == null || this._trayTileTemplate == null)
            {
                return;
            }
            list.removeListItems();
            final _iter_ = this._controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                group = this.createTrayGroup(collection);
                if (group != null)
                {
                    list.addListItem(group);
                }
            }
        }

        function createTrayGroup(collection:HabbiconCollectionData):IWindowContainer
        {
            var group= Std.downcast(this._trayGroupTemplate.clone() , IWindowContainer);
            var grid= Std.downcast(group.findChildByName("tray_group_grid") , IItemGridWindow);
            var item:HabbiconShopItem = null;
            var count = 0;
            if (grid == null)
            {
                return null;
            }
            grid.removeGridItems();
            final _iter_ = collection.habbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
                if (item == null || !HabbiconState.isUsableState(item.state))
                {
                    continue;
                }
                if (this._activeTab == TAB_FAVOURITED && item.state != HabbiconState.FAVOURITE)
                {
                    continue;
                }
                grid.addGridItem(this.createTile(item, true));
                count++;
            }
            if (count == 0)
            {
                group.dispose();
                return null;
            }
            group.visible = true;
            this.setChildText(group, "tray_group_title", this.collectionName(collection));
            return group;
        }

        function createTile(item:HabbiconShopItem, tray:Bool):IWindowContainer
        {
            var template= tray ? this._trayTileTemplate : this._tileTemplate;
            var tile= Std.downcast(template.clone() , IWindowContainer);
            tile.visible = true;
            tile.id = item.habbiconId;
            tile.name = "habbicon_tile_" + Std.string(item.habbiconId);
            tile.procedure = this.onTileEvent;
            this.setChildBitmap(tile, "bitmap", HabbiconAssetManager.getPreviewBitmap(item.habbiconId, false), this.isUnownedTileState(item.state) ? HABBICON_LOCKED_TRANSFORM : null);
            this.setChildVisible(tile, "favorite_icon", item.state == HabbiconState.FAVOURITE);
            this.setChildVisible(tile, "claimable_icon", item.state == HabbiconState.CLAIMABLE);
            this.setChildVisible(tile, "locked_overlay", this.isUnownedTileState(item.state) || item.state == HabbiconState.REWARD_MARKER);
            this.tintTile(tile, HabbiconState.isUsableState(item.state), false);
            return tile;
        }

        function onTileEvent(event:WindowEvent, window:IWindow)
        {
            var item:HabbiconShopItem = null;
            var tile= Std.downcast(window , IWindowContainer);
            if (window == null || tile == null)
            {
                return;
            }
            item = this._controller.tryGetShopItem(window.id);
            if (event.type == WindowMouseEvent.OVER)
            {
                if (tile != this._activeTile)
                {
                    this.tintTile(tile, item != null && HabbiconState.isUsableState(item.state), true);
                }
                return;
            }
            if (event.type == WindowMouseEvent.OUT)
            {
                if (tile != this._activeTile)
                {
                    this.tintTile(tile, item != null && HabbiconState.isUsableState(item.state), false);
                }
                return;
            }
            if (event.type == WindowMouseEvent.CLICK)
            {
                this._selectedHabbiconId = window.id;
                this.showPopup(window, item);
            }
        }

        function showPopup(anchor:IWindow, item:HabbiconShopItem)
        {
            var popup= this._window.findChildByName("habbicon_item_popup");
            var popupRoot= Std.downcast(this._window.findChildByName("habbicon_popup_layer") , IWindowContainer);
            var anchorRect:Rectangle = null;
            var rootRect:Rectangle = null;
            var maxX = 0;
            var maxY = 0;
            var action= this._window.findChildByName("habbicon_popup_action_button");
            var buy= this._window.findChildByName("habbicon_popup_buy_button");
            var bottom= this._window.findChildByName("habbicon_popup_bottom_bar");
            if (popup == null || item == null)
            {
                return;
            }
            if (popupRoot == null)
            {
                popupRoot = this._window;
            }
            this.setActiveTile(Std.downcast(anchor , IWindowContainer), item);
            popup.visible = true;
            anchorRect = new Rectangle();
            rootRect = new Rectangle();
            anchor.getGlobalRectangle(anchorRect);
            popupRoot.getGlobalRectangle(rootRect);
            maxX = Std.int(Math.max(4, popupRoot.width - popup.width - 4));
            maxY = Std.int(Math.max(0, popupRoot.height - popup.height));
            popup.x = Std.int(Math.max(4, Math.min(maxX, anchorRect.x - rootRect.x + Std.int((anchorRect.width - popup.width) * 0.5))));
            popup.y = Std.int(Math.max(0, Math.min(maxY, anchorRect.y - rootRect.y - popup.height + 2)));
            this.setText("habbicon_popup_title", this._controller.resolveHabbiconDisplayName(item.habbiconId, item.name));
            if (HabbiconState.isUsableState(item.state))
            {
                this.setText("habbicon_popup_description", this._controller.localize("habbicons.popup.owned", "Use this Habbicon in the room, or mark it as a favourite."));
                if (action != null)
                {
                    action.visible = true;
                    action.id = item.habbiconId;
                    action.caption = item.state == HabbiconState.FAVOURITE ? this._controller.localize("habbicons.unfavorite", "Unfavorite") : this._controller.localize("habbicons.favorite", "Favorite");
                }
                if (bottom != null)
                {
                    bottom.visible = false;
                }
            }
            else if (item.state == HabbiconState.CLAIMABLE)
            {
                this.setText("habbicon_popup_description", this._controller.localize("habbicons.popup.claimable", "Claim this set reward."));
                if (action != null)
                {
                    action.visible = true;
                    action.id = item.habbiconId;
                    action.caption = this._controller.localize("habbicons.claim", "Claim");
                }
                if (bottom != null)
                {
                    bottom.visible = false;
                }
            }
            else
            {
                this.setText("habbicon_popup_description", this._controller.localize("habbicons.popup.not_owned", "Not owned"));
                if (action != null)
                {
                    action.visible = false;
                }
                if (bottom != null)
                {
                    bottom.visible = item.priceCredits > 0 || item.priceActivityPoints > 0;
                }
                if (buy != null)
                {
                    buy.id = item.habbiconId;
                }
                this.setText("habbicon_popup_price", this.formatPrice(item.priceCredits, item.priceActivityPoints));
            }
        }

        function hidePopup()
        {
            var popup:IWindow = this._window == null ? null : this._window.findChildByName("habbicon_item_popup");
            if (popup != null)
            {
                popup.visible = false;
            }
            this.clearActiveTile();
        }

        function setActiveTile(tile:IWindowContainer, item:HabbiconShopItem)
        {
            this.clearActiveTile();
            this._activeTile = tile;
            if (this._activeTile != null && item != null)
            {
                this.tintTile(this._activeTile, HabbiconState.isUsableState(item.state), true);
            }
        }

        function clearActiveTile()
        {
            var item:HabbiconShopItem = null;
            if (this._activeTile == null)
            {
                return;
            }
            item = this._controller == null ? null : this._controller.tryGetShopItem(this._activeTile.id);
            this.tintTile(this._activeTile, item != null && HabbiconState.isUsableState(item.state), false);
            this._activeTile = null;
        }

        function onPopupAction(event:WindowEvent, window:IWindow)
        {
            var item:HabbiconShopItem = null;
            if (event.type != WindowMouseEvent.CLICK || window == null)
            {
                return;
            }
            item = this._controller.tryGetShopItem(window.id);
            if (item == null)
            {
                return;
            }
            if (item.state == HabbiconState.CLAIMABLE)
            {
                this._controller.claimHabbicon(item.habbiconId);
            }
            else if (item.state == HabbiconState.FAVOURITE)
            {
                this._controller.unfavoriteHabbicon(item.habbiconId);
            }
            else if (item.state == HabbiconState.OWNED)
            {
                this._controller.favoriteHabbicon(item.habbiconId);
            }
        }

        function onPopupBuy(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK && window != null)
            {
                this._controller.buyHabbicon(window.id);
            }
        }

        function onRewardAction(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK && window != null && window.id > 0)
            {
                this._controller.claimHabbicon(window.id);
            }
        }

        function onBuyCollection(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK && window != null && window.id > 0)
            {
                this._controller.buyHabbiconCollection(window.id);
            }
        }

        function onSetRowEvent(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK && window != null)
            {
                this._selectedCollectionId = window.id;
                this.refresh();
            }
        }

        function onTabAll(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this._activeTab = TAB_ALL;
                this.refresh();
            }
        }

        function onTabOwned(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this._activeTab = TAB_OWNED;
                this.refresh();
            }
        }

        function onTabFavourited(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this._activeTab = TAB_FAVOURITED;
                this.refresh();
            }
        }

        function ensureSelectedCollection()
        {
            var collection:HabbiconCollectionData = null;
            if (this._selectedCollectionId > 0 && this.getSelectedCollection() != null)
            {
                return;
            }
            final _iter_ = this._controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                this._selectedCollectionId = collection.collectionId;
                return;
            }
        }

        function getSelectedCollection():HabbiconCollectionData
        {
            var collection:HabbiconCollectionData = null;
            final _iter_ = this._controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                if (collection.collectionId == this._selectedCollectionId)
                {
                    return collection;
                }
            }
            return null;
        }

        function getCollectionProgress(collection:HabbiconCollectionData):ASObject
        {
            var total = 0;
            var owned = 0;
            var item:HabbiconShopItem = null;
            if (collection == null || collection.habbicons == null)
            {
                return {owned:0, total:0};
            }
            final _iter_ = collection.habbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
                if (item == null || item.state == HabbiconState.REWARD_MARKER || item.habbiconId == collection.rewardHabbiconId)
                {
                    continue;
                }
                total++;
                if (HabbiconState.isUsableState(item.state))
                {
                    owned++;
                }
            }
            return {owned:owned, total:total};
        }

        function countOwned():Int
        {
            var count = 0;
            var item:HabbiconOwnedItem = null;
            final _iter_ = this._controller.ownedHabbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
                if (HabbiconState.isUsableState(item.habbiconState))
                {
                    count++;
                }
            }
            return count;
        }

        function countTotal():Int
        {
            var total = 0;
            var collection:HabbiconCollectionData = null;
            var item:HabbiconShopItem = null;
            final _iter_ = this._controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                final _iter_ = collection.habbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
item  = _tmp_;
                    if (item != null && item.state != HabbiconState.REWARD_MARKER && item.habbiconId != collection.rewardHabbiconId)
                    {
                        total++;
                    }
                }
            }
            return total;
        }

        function countCompletedSets():Int
        {
            var count = 0;
            var collection:HabbiconCollectionData = null;
            var progress:ASObject = null;
            final _iter_ = this._controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                progress = this.getCollectionProgress(collection);
                if (progress.total > 0 && progress.owned >= progress.total)
                {
                    count++;
                }
            }
            return count;
        }

        function updateOverallProgress()
        {
            var owned= this.countOwned();
            var total= this.countTotal();
            this.setProgress("album_progress_bar", owned, total);
            this.setText("album_progress_text", Std.string(owned) + " / " + Std.string(total));
        }

        function setProgress(name:String, value:Int, total:Int)
        {
            var container= Std.downcast(this._window.findChildByName(name) , IWindowContainer);
            this.renderProgress(container, value, total);
        }

        function setChildProgress(parent:IWindowContainer, name:String, value:Int, total:Int)
        {
            var container= Std.downcast(parent.findChildByName(name) , IWindowContainer);
            this.renderProgress(container, value, total);
        }

        function renderProgress(container:IWindowContainer, value:Int, total:Int)
        {
            var progress:IWindow = null;
            var fill:IWindow = null;
            var highlight:IWindow = null;
            var progressWidth = 0;
            var cappedWidth = 0;
            if (container == null)
            {
                return;
            }
            progress = container.findChildByName("progress");
            if (progress != null)
            {
                progressWidth = Std.int(total <= 0 ? 0 : Std.int(Math.max(0, Math.min(container.width, Math.fround(container.width * value / total)))));
                cappedWidth = progressWidth >= container.width - 4 ? container.width : progressWidth + 4;
                progress.width = progressWidth;
                progress.visible = progressWidth > 0;
                fill = Std.downcast(progress , IWindowContainer).findChildByName("fill");
                if (fill != null)
                {
                    fill.width = Std.int(Math.max(0, cappedWidth));
                    fill.color = total > 0 && value >= total ? PROGRESS_COMPLETE_COLOR : PROGRESS_INCOMPLETE_COLOR;
                }
                highlight = Std.downcast(progress , IWindowContainer).findChildByName("highlight");
                if (highlight != null)
                {
                    highlight.width = Std.int(Math.max(0, cappedWidth - 2));
                }
                container.invalidate();
            }
        }

        function setText(name:String, text:String)
        {
            var field= Std.downcast(this._window.findChildByName(name) , ITextWindow);
            if (field != null)
            {
                field.text = text;
            }
        }

        function setChildText(parent:IWindowContainer, name:String, text:String)
        {
            var field= Std.downcast(parent.findChildByName(name) , ITextWindow);
            if (field != null)
            {
                field.text = text;
            }
        }

        function setBitmap(name:String, bitmap:BitmapData)
        {
            var bitmapWindow= Std.downcast(this._window.findChildByName(name) , IBitmapWrapperWindow);
            this.applyBitmap(bitmapWindow, bitmap);
        }

        function setChildBitmap(parent:IWindowContainer, name:String, bitmap:BitmapData, colorTransform:ColorTransform = null)
        {
            var bitmapWindow= Std.downcast(parent.findChildByName(name) , IBitmapWrapperWindow);
            this.applyBitmap(bitmapWindow, bitmap, colorTransform);
        }

        function applyBitmap(bitmapWindow:IBitmapWrapperWindow, bitmap:BitmapData, colorTransform:ColorTransform = null)
        {
            var copy:BitmapData = null;
            if (bitmapWindow == null)
            {
                return;
            }
            if (bitmap == null)
            {
                bitmapWindow.bitmap = new BitmapData(Std.int(Math.max(1, bitmapWindow.width)), Std.int(Math.max(1, bitmapWindow.height)), true, 0);
                bitmapWindow.invalidate();
                HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onAssetsLoaded);
                return;
            }
            bitmapWindow.bitmap = new BitmapData(bitmapWindow.width, bitmapWindow.height, true, 0);
            copy = bitmap;
            if (colorTransform != null)
            {
                copy = bitmap.clone();
                copy.colorTransform(copy.rect, colorTransform);
            }
            bitmapWindow.bitmap.copyPixels(copy, copy.rect, new Point((bitmapWindow.width - copy.width) / 2, (bitmapWindow.height - copy.height) / 2), null, null, true);
            if (copy != bitmap)
            {
                copy.dispose();
            }
            bitmapWindow.invalidate();
        }

        function setChildVisible(parent:IWindowContainer, name:String, visible:Bool)
        {
            var child= parent.findChildByName(name);
            if (child != null)
            {
                child.visible = visible;
            }
        }

        function setProcedure(name:String, callback:ASFunction)
        {
            var window= this._window.findChildByName(name);
            if (window != null)
            {
                window.procedure = callback;
            }
        }

        function setProcedureByTag(tag:String, callback:ASFunction)
        {
            var window= this._window.findChildByTag(tag);
            if (window != null)
            {
                window.procedure = callback;
            }
        }

        function tintRow(row:IWindowContainer, active:Bool)
        {
            var background= row.findChildByName("set_row_background");
            row.color = active ? 0xFFFFFFFF : 0xFFF2ECD5;
            if (background != null)
            {
                background.color = active ? 0xFFF0CF86 : 0xFFF8EBD6;
            }
        }

        function tintTile(tile:IWindowContainer, owned:Bool, active:Bool)
        {
            var background= tile.findChildByName("tile_background");
            var border= tile.findChildByName("tile_border");
            if (background != null)
            {
                background.color = owned ? (active ? 0xFFD4E4B9 : 0xFFC3D3A7) : (active ? 0xFFEBDFCB : 0xFFE0D6C2);
            }
            if (border != null)
            {
                border.color = owned ? (active ? 0xFFD3E8BD : 0xFF99C176) : (active ? 0xFFEADFCD : 0xFFD4C6AD);
            }
        }

        function getCollectionRailIcon(collection:HabbiconCollectionData):BitmapData
        {
            var item:HabbiconShopItem = null;
            if (collection != null)
            {
                final _iter_ = collection.habbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
item  = _tmp_;
                    if (item != null && item.state != HabbiconState.REWARD_MARKER && item.habbiconId != collection.rewardHabbiconId)
                    {
                        return HabbiconAssetManager.getPreviewBitmap(item.habbiconId, false);
                    }
                }
            }
            return HabbiconAssetManager.getCollectionIconBitmap(collection == null ? 0 : collection.collectionId);
        }

        function isUnownedTileState(state:Int):Bool
        {
            return state == HabbiconState.NONE || state == HabbiconState.LOCKED;
        }

        function collectionName(collection:HabbiconCollectionData):String
        {
            var key= "habbicon_collection_" + collection.name.toLowerCase().split(" ").join("_") + "_name";
            return this._controller.localize(key, collection.name);
        }

        function collectionDescription(collection:HabbiconCollectionData):String
        {
            var key= "habbicon_collection_" + collection.name.toLowerCase().split(" ").join("_") + "_description";
            return this._controller.localize(key, "");
        }

        function formatPrice(credits:Int, points:Int):String
        {
            if (credits > 0 && points > 0)
            {
                return Std.string(credits) + " + " + Std.string(points);
            }
            if (credits > 0)
            {
                return Std.string(credits);
            }
            return Std.string(points);
        }

        function onControllerUpdated(event:HabbiconControllerEvent)
        {
            this.refresh();
        }

        function onAssetsLoaded(event:Event)
        {
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onAssetsLoaded);
            this.refresh();
        }

        function onClose(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK && this._window != null)
            {
                this._window.visible = false;
            }
        }
    }

