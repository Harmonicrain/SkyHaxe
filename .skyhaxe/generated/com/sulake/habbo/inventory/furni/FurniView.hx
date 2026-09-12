package com.sulake.habbo.inventory.furni
;
    import com.sulake.habbo.inventory.IInventoryView;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.inventory.marketplace.MarketplaceModel;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.window.widgets.ILimitedItemPreviewOverlayWidget;
    import com.sulake.habbo.window.widgets._Str_4520;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.room.preview.RoomPreviewer;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.room.utils.Vector3d;
    import flash.filters.GlowFilter;
    import com.sulake.habbo.room.object.data.MapStuffData;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.window.widgets.IRoomPreviewerWidget;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.habbo.inventory.items.IFurnitureItem;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.habbo.inventory._enum.InventorySubCategory;

     class FurniView implements IInventoryView implements  IUpdateReceiver 
    {
        static inline final _Str_12512= 0;
        static inline final _Str_4299= 1;
        static inline final _Str_5391= 2;
        static inline final _Str_4660= 3;
        static inline final _Str_12387= 4;

        var _lastCategory:String = "";
        var _windowManager:IHabboWindowManager;
        var _assetLibrary:IAssetLibrary;
        var _view:IWindowContainer;
        var _grid:FurniGridView;
        var _model:FurniModel;
        var _marketplace:MarketplaceModel;
        var _roomEngine:IRoomEngine;
        var _disposed:Bool = false;
        var _currentState:Int = 0;
        var _limitedItemOverlay:ILimitedItemPreviewOverlayWidget;
        var _rarityItemOverlay:_Str_4520;
        var _buttonList:IItemListWindow;
        var _placeInRoomButton:IButtonWindow;
        var _gotoRoomButton:IButtonWindow;
        var _sellInMarketplaceButton:IButtonWindow;
        var _offerInTradingButton:IButtonWindow;
        var _offerInTradingCountButton:ITextFieldWindow;
        var _useFurnitureButton:IButtonWindow;
        var _extendRentPeriodButton:IButtonWindow;
        var _buyRentedItemButton:IButtonWindow;
        var _isInitialized:Bool = false;
        var _roomPreviewer:RoomPreviewer;
        var _rentablesPlacementSelection:Int = 0;

        public function new(k:FurniModel, _arg_2:MarketplaceModel, _arg_3:IHabboWindowManager, _arg_4:IAssetLibrary, _arg_5:IRoomEngine)
        {
            this._model = k;
            this._marketplace = _arg_2;
            this._assetLibrary = _arg_4;
            this._windowManager = _arg_3;
            this._roomEngine = _arg_5;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var isVisible(get,never):Bool;
public function  get_isVisible():Bool
        {
            return ((this._view != null) && (!(this._view.parent == null))) && this._view.visible;
        }

        public var isInitialized(get,never):Bool;
public function  get_isInitialized():Bool
        {
            return this._isInitialized;
        }

        public var _Str_12561(get,never):Vector<GroupItem>;
public function  get__Str_12561():Vector<GroupItem>
        {
            return (this._grid != null) ? this._grid._Str_12561 : null;
        }

        public var grid(get,never):FurniGridView;
public function  get_grid():FurniGridView
        {
            return this._grid;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (((this._model != null) && (this._model.controller != null)))
                {
                    this._model.controller.removeUpdateReceiver(this);
                }
                this._model = null;
                this._marketplace = null;
                this._assetLibrary = null;
                this._windowManager = null;
                this._roomEngine = null;
                if (this._limitedItemOverlay != null)
                {
                    this._limitedItemOverlay.dispose();
                    this._limitedItemOverlay = null;
                }
                if (this._rarityItemOverlay != null)
                {
                    this._rarityItemOverlay.dispose();
                    this._rarityItemOverlay = null;
                }
                if (this._view != null)
                {
                    this._view.dispose();
                    this._view = null;
                }
                this._disposed = true;
            }
        }

        public function getWindowContainer():IWindowContainer
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            if (this._view == null)
            {
                return null;
            }
            if (this._view.disposed)
            {
                return null;
            }
            this.updateActionButtons(false);
            return this._view;
        }

        public function _Str_7636()
        {
            var k = 0;
            if (!this._model._Str_21873())
            {
                k = _Str_4299;
            }
            else
            {
                if (((!(this._model.furniData != null)) || (this._model.furniData.length == 0)))
                {
                    k = _Str_5391;
                }
                else
                {
                    k = _Str_4660;
                }
            }
            if (this._currentState == k)
            {
                return;
            }
            this._currentState = k;
            this.updateContainerVisibility();
        }

        public function _Str_22617()
        {
            this._Str_2944();
        }

        public function _Str_15980():IWindowContainer
        {
            return (this._grid != null) ? this._grid._Str_15980() : null;
        }

        public function _Str_2944()
        {
            var _local_2:FurnitureItem = null;
            var _local_3:IStaticBitmapWrapperWindow = null;
            var _local_4:ITextWindow = null;
            var _local_5:IRegionWindow = null;
            var _local_9:String = null;
            var _local_10:String = null;
            var _local_11:String = null;
            var _local_12:String = null;
            var _local_13 = 0;
            var _local_14:IWidgetWindow = null;
            var _local_15:IWidgetWindow = null;
            var _local_16:String = null;
            var _local_17:String = null;
            var _local_18:String = null;
            var _local_19:IFurnitureData = null;
            var _local_20:String = null;
            if (this._view == null)
            {
                return;
            }
            if (this._view.disposed)
            {
                return;
            }
            this.updateContainerVisibility();
            var k = false;
            var _local_6= this._model._Str_3968();
            if (((!(_local_6 == null)) && (!(_local_6._Str_3205() == null))))
            {
                if (_local_6._Str_4405 >= 0)
                {
                    _local_2 = _local_6._Str_5087(_local_6._Str_4405);
                    if (_local_2 == null)
                    {
                        _local_2 = _local_6._Str_3205();
                    }
                }
                else
                {
                    _local_2 = _local_6._Str_3205();
                }
                k = true;
                _local_9 = this._roomEngine.getWallItemType(_local_2.type);
                this._view.findChildByName("nextItemButton").visible = (this._view.findChildByName("viewItemButton").visible = (ASCompat.stringAsBool(_local_9) && (!(_local_9.indexOf("external_image_wallitem") == -1))));
                this._view.findChildByName("furni_preview_widget").visible = true;
                _local_10 = this._roomEngine.getRoomStringValue(this._roomEngine.activeRoomId, RoomObjectVariableEnum.ROOM_WALL_TYPE);
                _local_11 = this._roomEngine.getRoomStringValue(this._roomEngine.activeRoomId, RoomObjectVariableEnum.ROOM_FLOOR_TYPE);
                _local_12 = this._roomEngine.getRoomStringValue(this._roomEngine.activeRoomId, RoomObjectVariableEnum.ROOM_LANDSCAPE_TYPE);
                _local_10 = ((ASCompat.stringAsBool(_local_10) && (_local_10.length > 0)) ? _local_10 : "101");
                _local_11 = ((ASCompat.stringAsBool(_local_11) && (_local_11.length > 0)) ? _local_11 : "101");
                _local_12 = ((ASCompat.stringAsBool(_local_12) && (_local_12.length > 0)) ? _local_12 : "1.1");
                this._roomPreviewer.reset(false);
                this._roomPreviewer.updateObjectRoom(_local_11, _local_10, _local_12);
                if ((((_local_2.category == FurniCategory.WALL_PAPER) || (_local_2.category == FurniCategory.FLOOR)) || (_local_2.category == FurniCategory.LANDSCAPE)))
                {
                    this._roomPreviewer.updateRoomWallsAndFloorVisibility(true, true);
                    _local_16 = ((_local_2.category == FurniCategory.FLOOR) ? _local_6.stuffData.getLegacyString() : _local_11);
                    _local_17 = ((_local_2.category == FurniCategory.WALL_PAPER) ? _local_6.stuffData.getLegacyString() : _local_10);
                    _local_18 = ((_local_2.category == FurniCategory.LANDSCAPE) ? _local_6.stuffData.getLegacyString() : _local_12);
                    this._roomPreviewer.updateObjectRoom(_local_16, _local_17, _local_18);
                    if (_local_2.category == FurniCategory.LANDSCAPE)
                    {
                        _local_19 = this._model.controller.getFurnitureDataByName("ads_twi_windw", ProductTypeEnum.WALL);
                        this._roomPreviewer.addWallItemIntoRoom(_local_19.id, new Vector3d(90, 0, 0), _local_19.customParams);
                    }
                }
                else
                {
                    if (_local_6.isWallItem)
                    {
                        this._roomPreviewer.updateRoomWallsAndFloorVisibility(true, true);
                        this._roomPreviewer.addWallItemIntoRoom(_local_6.type, new Vector3d(90, 0, 0), _local_2.stuffData.getLegacyString());
                    }
                    else
                    {
                        this._roomPreviewer.updateRoomWallsAndFloorVisibility(false, true);
                        this._roomPreviewer.addFurnitureIntoRoom(_local_6.type, new Vector3d(90, 0, 0), _local_6.stuffData, Std.string(_local_6.extra));
                    }
                }
                _local_3 = Std.downcast(this._view.findChildByName("tradeable_icon") , IStaticBitmapWrapperWindow);
                _local_4 = Std.downcast(this._view.findChildByName("tradeable_number") , ITextWindow);
                _local_5 = Std.downcast(this._view.findChildByName("tradeable_info_region") , IRegionWindow);
                if ((((!(_local_3 == null)) && (!(_local_4 == null))) && (!(_local_5 == null))))
                {
                    _local_13 = _local_6._Str_24914();
                    if (_local_13 == 0)
                    {
                        _local_3.assetUri = "inventory_furni_no_trade_icon";
                        _local_4.visible = false;
                        _local_5.toolTipCaption = "${inventory.furni.preview.not_tradeable}";
                        _local_4.filters = [];
                    }
                    else
                    {
                        _local_3.assetUri = "inventory_furni_trade_icon";
                        _local_4.visible = true;
                        _local_4.text = Std.string(_local_13);
                        _local_5.toolTipCaption = "${inventory.furni.preview.tradeable_amount}";
                        _local_4.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 300)];
                    }
                }
                _local_3 = Std.downcast(this._view.findChildByName("recyclable_icon") , IStaticBitmapWrapperWindow);
                _local_4 = Std.downcast(this._view.findChildByName("recyclable_number") , ITextWindow);
                _local_5 = Std.downcast(this._view.findChildByName("recyclable_info_region") , IRegionWindow);
                if ((((!(_local_3 == null)) && (!(_local_4 == null))) && (!(_local_5 == null))))
                {
                    _local_13 = _local_6._Str_22135();
                    if (_local_13 == 0)
                    {
                        _local_3.assetUri = "inventory_furni_no_recycle_icon";
                        _local_4.visible = false;
                        _local_5.toolTipCaption = "${inventory.furni.preview.not_recyclable}";
                        _local_4.filters = [];
                    }
                    else
                    {
                        _local_3.assetUri = "inventory_furni_recycle_icon";
                        _local_4.visible = true;
                        _local_4.text = Std.string(_local_13);
                        _local_5.toolTipCaption = "${inventory.furni.preview.recyclable_amount}";
                        _local_4.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 300)];
                    }
                }
                _local_14 = cast(this._view.findChildByName("unique_limited_item_overlay_widget"), IWidgetWindow);
                if (((_local_2.stuffData != null) && (_local_2.stuffData.uniqueSerialNumber > 0)))
                {
                    if (this._limitedItemOverlay == null)
                    {
                        this._limitedItemOverlay = cast(_local_14.widget, ILimitedItemPreviewOverlayWidget);
                    }
                    this._limitedItemOverlay.serialNumber = _local_2.stuffData.uniqueSerialNumber;
                    this._limitedItemOverlay.seriesSize = _local_2.stuffData.uniqueSeriesSize;
                    _local_14.visible = true;
                }
                else
                {
                    _local_14.visible = false;
                }
                _local_15 = cast(this._view.findChildByName("rarity_item_overlay_widget"), IWidgetWindow);
                if (((_local_2.stuffData != null) && (_local_2.stuffData.rarityLevel >= 0)))
                {
                    if (this._rarityItemOverlay == null)
                    {
                        this._rarityItemOverlay = cast(_local_15.widget, _Str_4520);
                    }
                    this._rarityItemOverlay.rarityLevel = _local_2.stuffData.rarityLevel;
                    _local_15.visible = true;
                }
                else
                {
                    _local_15.visible = false;
                }
            }
            else
            {
                this._view.findChildByName("furni_preview_widget").visible = (this._view.findChildByName("nextItemButton").visible = (this._view.findChildByName("viewItemButton").visible = false));
                _local_3 = Std.downcast(this._view.findChildByName("tradeable_icon") , IStaticBitmapWrapperWindow);
                _local_4 = Std.downcast(this._view.findChildByName("tradeable_number") , ITextWindow);
                _local_5 = Std.downcast(this._view.findChildByName("tradeable_info_region") , IRegionWindow);
                if ((((_local_3 != null) && (_local_4 != null)) && (_local_5 != null)))
                {
                    _local_3.assetUri = "";
                    _local_4.visible = false;
                }
                _local_3 = Std.downcast(this._view.findChildByName("recyclable_icon") , IStaticBitmapWrapperWindow);
                _local_4 = Std.downcast(this._view.findChildByName("recyclable_number") , ITextWindow);
                _local_5 = Std.downcast(this._view.findChildByName("recyclable_info_region") , IRegionWindow);
                if ((((_local_3 != null) && (_local_4 != null)) && (_local_5 != null)))
                {
                    _local_3.assetUri = "";
                    _local_4.visible = false;
                }
            }
            var _local_7= this._model._Str_7553;
            this.updateActionButtons(k);
            if (((_local_6 != null) && (_local_2 != null)))
            {
                this._view.findChildByName("furni_name").caption = _local_6.name;
                if (((_local_2 != null) && (this._roomEngine.getWallItemType(_local_2.type) == "external_image_wallitem")))
                {
                    this._view.findChildByName("furni_description").caption = _local_2.stuffData.getJSONValue("m");
                }
                else
                {
                    this._view.findChildByName("furni_description").caption = _local_6.description;
                }
            }
            else
            {
                this._view.findChildByName("furni_name").caption = "";
                this._view.findChildByName("furni_description").caption = "";
            }
            var _local_8= Std.downcast(this._view.findChildByName("furni_extra") , ITextWindow);
            if (_local_8 != null)
            {
                if ((((!(_local_2 == null)) && (!(_local_2.stuffData == null))) && (_local_2.stuffData.rarityLevel >= 0)))
                {
                    _local_20 = Std.downcast(_local_2.stuffData , MapStuffData).getValue("rarity");
                    if (_local_20 != null)
                    {
                        this._windowManager.registerLocalizationParameter("inventory.rarity", "rarity", Std.string(_local_2.stuffData.rarityLevel));
                        _local_8.text = this._model.localization.getLocalization("inventory.rarity");
                        _local_8.visible = true;
                    }
                }
                else
                {
                    _local_8.text = "";
                }
            }
            this.updateRentedItem();
        }

        public function _Str_12834(k:GroupItem)
        {
            if (this._view == null)
            {
                return;
            }
            if (this._view.disposed)
            {
                return;
            }
            var _local_2= k._Str_3205();
            if (_local_2.isWallItem)
            {
                this._roomPreviewer.addWallItemIntoRoom(_local_2.type, new Vector3d(90, 0, 0), _local_2.stuffData.getLegacyString());
            }
            else
            {
                this._roomPreviewer.addFurnitureIntoRoom(_local_2.type, new Vector3d(90, 0, 0), _local_2.stuffData);
            }
            this._placeInRoomButton.disable();
            this._offerInTradingButton.disable();
            this._offerInTradingCountButton.disable();
        }

        public function _Str_18112(k:Vector<GroupItem>)
        {
            if (this._grid != null)
            {
                this._grid._Str_25722(k);
            }
        }

        public function _Str_7221()
        {
            if (((this._view == null) || this._view.disposed))
            {
                return;
            }
            var k= Std.downcast(this._view.findChildByName("filter.options") , IDropMenuWindow);
            var _local_2= Std.downcast(this._view.findChildByName("placement.options") , IDropMenuWindow);
            var _local_3= this._view.findChildByName("filter").caption;
            var _local_4:String = k.items()[k.selection];
            if (this._model.controller._Str_18332()
                == InventorySubCategory.WIRED_TRADING
                && this._model.controller.wiredTradingModel != null
                && this._model.controller.wiredTradingModel.running)
            {
                this._grid.setWiredRequirements(
                    this._model.controller.wiredTradingModel.requirementsModel);
            }
            else
            {
                this._grid.setWiredRequirements(null);
            }
            this._grid._Str_25694(k.selection, _local_4, this._model._Str_22702, _local_3, _local_2.selection);
        }

        public function _Str_23210(k:String)
        {
            var _local_2= Std.downcast(this._view.findChildByName("filter.options") , IDropMenuWindow);
            var _local_3= Std.downcast(this._view.findChildByName("placement.options") , IDropMenuWindow);
            _local_2.selection = 0;
            switch (k)
            {
                case InventoryCategory.FURNI:
                    _local_3.selection = ((_local_3.numMenuItems > 2) ? 2 : 0);
                    _local_3.disable();
                    
                case InventoryCategory.RENTABLES:
                    _local_3.selection = this._rentablesPlacementSelection;
                    _local_3.enable();
                    
            }
            if (this._lastCategory != k)
            {
                this._view.findChildByName("filter").caption = "";
                this._view.findChildByName("clear_filter_button").visible = false;
            }
            this._lastCategory = k;
            this._Str_7221();
        }

        function init()
        {
            this._view = this._model.controller.view._Str_9043(InventoryCategory.FURNI);
            this._view.visible = false;
            this._view.procedure = this.windowEventProc;
            var k= Std.downcast(this._view.findChildByName("item_grid") , IItemGridWindow);
            var _local_2= Std.downcast(this._view.findChildByName("item_grid_pages") , IItemListWindow);
            this._grid = new FurniGridView(k, _local_2);
            this.populateFilterOptions();
            this._buttonList = Std.downcast(this._view.findChildByName("preview_element_list") , IItemListWindow);
            this._placeInRoomButton = Std.downcast(this._buttonList.removeListItem(this._buttonList.getListItemByName("placeinroom_btn")) , IButtonWindow);
            this._extendRentPeriodButton = Std.downcast(this._buttonList.removeListItem(this._buttonList.getListItemByName("extendrent_btn")) , IButtonWindow);
            this._buyRentedItemButton = Std.downcast(this._buttonList.removeListItem(this._buttonList.getListItemByName("buyrenteditem_btn")) , IButtonWindow);
            this._gotoRoomButton = Std.downcast(this._buttonList.removeListItem(this._buttonList.getListItemByName("goto_room_btn")) , IButtonWindow);
            this._useFurnitureButton = Std.downcast(this._buttonList.removeListItem(this._buttonList.getListItemByName("use_btn")) , IButtonWindow);
            this._offerInTradingCountButton = Std.downcast(this._buttonList.removeListItem(this._buttonList.getListItemByName("offertotrade_cnt")) , ITextFieldWindow);
            this._offerInTradingButton = Std.downcast(this._buttonList.removeListItem(this._buttonList.getListItemByName("offertotrade_btn")) , IButtonWindow);
            this._sellInMarketplaceButton = Std.downcast(this._buttonList.removeListItem(this._buttonList.getListItemByName("sell_btn")) , IButtonWindow);
            var _local_3= Std.downcast(Std.downcast(this._view.findChildByName("furni_preview_widget") , IWidgetWindow).widget , IRoomPreviewerWidget);
            this._roomPreviewer = _local_3.roomPreviewer;
            this._model.controller.registerUpdateReceiver(this, 1);
            this._Str_7636();
            this._isInitialized = true;
        }

        function _Str_24626()
        {
            var k= Std.downcast(this._view.findChildByName("furni_preview_widget") , IWidgetWindow);
            var _local_2= Std.downcast(Std.downcast(this._view.findChildByName("furni_preview_widget") , IWidgetWindow).widget , IRoomPreviewerWidget);
            _local_2.roomPreviewer.modifyRoomCanvas(k.width, k.height);
        }

        function updateActionButtons(k:Bool)
        {
            if (this._model._Str_7553)
            {
                this._Str_24626();
            }
            this.removeButtons();
            var _local_2= this._model._Str_7553;
            var _local_3= this._model._Str_3968();
            var _local_4:FurnitureItem = null;
            if (_local_3 != null)
            {
                _local_4 = _local_3._Str_3205();
            }
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= this._model.controller.getFurnitureData(_local_4.type, (_local_4.isWallItem ? ProductTypeEnum.WALL : ProductTypeEnum.FLOOR));
            var _local_6= (((((k && (this._marketplace != null)) && this._marketplace.isEnabled) && _local_4.sellable) && (!this._model.controller.sessionData.isAccountSafetyLocked())) && (!_local_2));
            var _local_7= ((this._model.isPrivateRoom && k) && (((((_local_4.category == FurniCategory.PET_SADDLE) || (_local_4.category == FurniCategory.PET_CUSTOM_PART)) || (_local_4.category == FurniCategory.PET_CUSTOM_PART_SHAMPOO)) || (_local_4.category == FurniCategory.PET_SHAMPOO)) || (_local_4.category == FurniCategory.MONSTERPLANT_REVIVAL)));
            var _local_8= true;
            if (_local_4.rentable)
            {
                if (_local_4.flatId > -1)
                {
                    _local_8 = false;
                }
            }
            var _local_9:ASAny = (_local_4.flatId > -1);
            var _local_10= (((_local_4.rentable && _local_8) && (_local_5 != null)) && _local_5.rentCouldBeUsedForBuyout);
            var _local_11= (((_local_4.rentable && _local_8) && (_local_5 != null)) && _local_5.purchaseCouldBeUsedForBuyout);
            if (((_local_5 != null) && _local_5.isExternalImageType))
            {
                _local_6 = false;
            }
            this.updateButtonAvailability(this._placeInRoomButton, ((!_local_2) && _local_8));
            this.updateButtonAvailability(this._extendRentPeriodButton, ((!_local_2) && _local_10));
            this.updateButtonAvailability(this._buyRentedItemButton, ((!_local_2) && _local_11));
            this.updateButtonAvailability(this._gotoRoomButton, ((!_local_2) && ASCompat.toBool(_local_9)));
            this.updateButtonAvailability(this._offerInTradingCountButton, (_local_2 && this._model.controller.getBoolean("multi.item.trading.enabled")));
            this.updateButtonAvailability(this._offerInTradingButton, _local_2);
            this.updateButtonAvailability(this._sellInMarketplaceButton, _local_6);
            this.updateButtonAvailability(this._useFurnitureButton, _local_7);
            if ((k && this._model.isPrivateRoom))
            {
                this._placeInRoomButton.enable();
            }
            else
            {
                this._placeInRoomButton.disable();
            }
            if ((((k && (!(_local_3 == null))) && (!(_local_4 == null))) && this._model._Str_16742()))
            {
                if (((_local_3.getUnlockedCount() != 0) && _local_4.tradeable))
                {
                    this._offerInTradingButton.enable();
                    this._offerInTradingCountButton.enable();
                }
                else
                {
                    this._offerInTradingButton.disable();
                    this._offerInTradingCountButton.disable();
                }
            }
            else
            {
                this._offerInTradingButton.disable();
                this._offerInTradingCountButton.disable();
            }
        }

        function updateButtonAvailability(k:IInteractiveWindow, _arg_2:Bool)
        {
            if (this._buttonList.getListItemByName(k.name) == null)
            {
                if (_arg_2)
                {
                    this._buttonList.addListItem(k);
                }
            }
            else
            {
                if (!_arg_2)
                {
                    this._buttonList.removeListItem(k);
                }
            }
        }

        function removeButtons()
        {
            this._buttonList.removeListItem(this._placeInRoomButton);
            this._buttonList.removeListItem(this._extendRentPeriodButton);
            this._buttonList.removeListItem(this._buyRentedItemButton);
            this._buttonList.removeListItem(this._gotoRoomButton);
            this._buttonList.removeListItem(this._useFurnitureButton);
            this._buttonList.removeListItem(this._offerInTradingCountButton);
            this._buttonList.removeListItem(this._offerInTradingButton);
            this._buttonList.removeListItem(this._sellInMarketplaceButton);
        }

        function updateContainerVisibility()
        {
            if (!this._isInitialized)
            {
                return;
            }
            if (((!(this._model.controller._Str_9777 == InventoryCategory.FURNI)) && (!(this._model.controller._Str_9777 == InventoryCategory.RENTABLES))))
            {
                return;
            }
            var k= this._model.controller.view._Str_10034;
            var _local_2= this._model.controller.view._Str_11062;
            var _local_3= Std.downcast(this._view.findChildByName("grid_container") , IWindowContainer);
            var _local_4= Std.downcast(this._view.findChildByName("preview_container") , IWindowContainer);
            var _local_5= Std.downcast(this._view.findChildByName("options_container") , IWindowContainer);
            switch (this._currentState)
            {
                case _Str_4299:
                    if (k != null)
                    {
                        k.visible = true;
                    }
                    if (_local_2 != null)
                    {
                        _local_2.visible = false;
                    }
                    _local_3.visible = false;
                    _local_4.visible = false;
                    _local_5.visible = false;
                    return;
                case _Str_5391:
                    if (k != null)
                    {
                        k.visible = false;
                    }
                    if (_local_2 != null)
                    {
                        _local_2.visible = true;
                    }
                    _local_3.visible = false;
                    _local_4.visible = false;
                    _local_5.visible = false;
                    return;
                case _Str_4660:
                    if (k != null)
                    {
                        k.visible = false;
                    }
                    if (_local_2 != null)
                    {
                        _local_2.visible = false;
                    }
                    _local_3.visible = true;
                    _local_4.visible = true;
                    _local_5.visible = true;
                    return;
            }
        }

        function showNextPreviewItem()
        {
            this._model._Str_3968()._Str_4405++;
            this._Str_2944();
        }

        function windowEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:GroupItem = null;
            var _local_4:FurnitureItem = null;
            var _local_5 = 0;
            var _local_6:GroupItem = null;
            var _local_7:IFurnitureItem = null;
            var _local_8:WindowKeyboardEvent = null;
            var _local_9:IDropMenuWindow = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "placeinroom_btn"
                       | "furni_preview_region":
                        if (!this._model._Str_7553)
                        {
                            this._model._Str_5337(false);
                        }
                        
                    case "nextItemButton":
                        this.showNextPreviewItem();
                        
                    case "viewItemButton":
                        _local_3 = this._model._Str_3968();
                        _local_4 = _local_3._Str_5087(_local_3._Str_4405);
                        if (_local_4 == null)
                        {
                            _local_4 = _local_3._Str_3205();
                        }
                        this._roomEngine.showUseProductSelection(_local_4.ref, _local_4.type, _local_4.id);
                        
                    case "goto_room_btn":
                        this._model.gotoRoom();
                        
                    case "offertotrade_btn":
                        _local_5 = Std.int(Math.max(1, ASCompat.toInt(this._offerInTradingCountButton.caption)));
                        if (_local_5 != ASCompat.toInt(this._offerInTradingCountButton.caption))
                        {
                            this._offerInTradingCountButton.caption = Std.string(_local_5);
                        }
                        this._model._Str_21349(_local_5, this._offerInTradingCountButton);
                        
                    case "sell_btn":
                        this._model._Str_25554();
                        
                    case "use_btn":
                        this._model.showUseProductSelection();
                        
                    case "extendrent_btn":
                        this._model._Str_25502();
                        
                    case "buyrenteditem_btn":
                        this._model._Str_22829();
                        
                    case "clear_filter_button":
                        this._view.findChildByName("filter").caption = "";
                        _arg_2.visible = false;
                        this._Str_7221();
                        
                    default:
                        this._model.cancelFurniInMover();
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.DOWN)
                {
                    switch (_arg_2.name)
                    {
                        case "furni_preview_region":
                            _local_6 = this._model._Str_3968();
                            if (_local_6 == null)
                            {
                                return;
                            }
                            _local_7 = _local_6._Str_3205();
                            if ((((_local_7.category == FurniCategory.WALL_PAPER) || (_local_7.category == FurniCategory.FLOOR)) || (_local_7.category == FurniCategory.LANDSCAPE)))
                            {
                                return;
                            }
                            if (!this._model._Str_7553)
                            {
                                this._model._Str_5337(false);
                            }
                            
                    }
                }
                else
                {
                    if (k.type == WindowKeyboardEvent.WINDOW_EVENT_KEY_UP)
                    {
                        _local_8 = Std.downcast(k , WindowKeyboardEvent);
                        switch (_arg_2.name)
                        {
                            case "filter":
                                this._view.findChildByName("clear_filter_button").visible = (_arg_2.caption.length > 0);
                                if (_local_8.keyCode == 13)
                                {
                                    this._Str_7221();
                                }
                                
                        }
                    }
                }
            }
            if (k.type == WindowEvent.WINDOW_EVENT_SELECTED)
            {
                switch (_arg_2.name)
                {
                    case "filter.options":
                        this._Str_7221();
                        return;
                    case "placement.options":
                        _local_9 = Std.downcast(this._view.findChildByName("placement.options") , IDropMenuWindow);
                        if (this._model.controller._Str_9777 == InventoryCategory.RENTABLES)
                        {
                            this._rentablesPlacementSelection = _local_9.selection;
                        }
                        this._Str_7221();
                        return;
                }
            }
        }

        function populateFilterOptions()
        {
            var k= Std.downcast(this._view.findChildByName("filter.options") , IDropMenuWindow);
            var _local_2:Array<ASAny> = [];
            _local_2.push(this._model.controller.localization.getLocalization("inventory.filter.option.everything", "Everything"));
            _local_2.push(this._model.controller.localization.getLocalization("inventory.furni.tab.floor", "Floor"));
            _local_2.push(this._model.controller.localization.getLocalization("inventory.furni.tab.wall", "Wall"));
            k.populate(_local_2);
            k.selection = 0;
            var _local_3= Std.downcast(this._view.findChildByName("placement.options") , IDropMenuWindow);
            _local_2 = [];
            _local_2.push(this._model.controller.localization.getLocalization("inventory.placement.option.anywhere", "Anywhere"));
            _local_2.push(this._model.controller.localization.getLocalization("inventory.placement.option.inroom", "In room"));
            _local_2.push(this._model.controller.localization.getLocalization("inventory.placement.option.notinroom", "Not in room"));
            _local_3.populate(_local_2);
            _local_3.selection = 2;
            this._rentablesPlacementSelection = 2;
            this._view.findChildByName("filter").caption = "";
            this._view.findChildByName("items.shown").visible = false;
            this._view.invalidate();
        }

        public function updateRentedItem()
        {
            var k= this._model._Str_3968();
            var _local_2:FurnitureItem = null;
            if (k != null)
            {
                _local_2 = k._Str_3205();
            }
            if (_local_2 == null)
            {
                return;
            }
            if (!_local_2.rentable)
            {
                return;
            }
            var _local_3:IWindow = Std.downcast(this._view.findChildByName("furni_extra") , ITextWindow);
            _local_3.visible = true;
            if (_local_2.hasRentPeriodStarted)
            {
                this._model.controller.localization.registerParameter("inventory.rent.expiration", "time", FriendlyTime.format(this._model.controller.localization, _local_2.secondsToExpiration));
                _local_3.caption = this._model.controller.localization.getLocalization("inventory.rent.expiration");
            }
            else
            {
                this._model.controller.localization.registerParameter("inventory.rent.inactive", "time", FriendlyTime.format(this._model.controller.localization, _local_2.secondsToExpiration));
                _local_3.caption = this._model.controller.localization.getLocalization("inventory.rent.inactive");
            }
        }

        public function update(k:UInt)
        {
            if (this._roomPreviewer != null)
            {
                this._roomPreviewer.updatePreviewRoomView();
            }
        }
    }

