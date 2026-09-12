package com.sulake.habbo.inventory.furni
;
    import com.sulake.habbo.inventory.IInventoryModel;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import flash.utils.Timer;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import flash.events.TimerEvent;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.habbo.inventory.marketplace.MarketplaceModel;
    import com.sulake.habbo.inventory._enum.InventorySubCategory;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniData;
    import com.sulake.habbo.inventory.events.HabboInventoryItemAddedEvent;
    import com.sulake.core.utils.Map;
    import flash.display.BitmapData;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.inventory.items.CreditTradingItem;
    import com.sulake.habbo.communication.messages.outgoing.inventory.furni.RequestFurniInventoryComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.furni.RequestFurniInventoryWhenNotInRoomComposer;
    import com.sulake.habbo.inventory._enum.UnseenItemCategoryEnum;
    import com.sulake.habbo.inventory.items.IFurnitureItem;
    import com.sulake.habbo.room.object.data.LegacyStuffData;
    import com.sulake.habbo.communication.messages.outgoing.inventory.furni.RequestRoomPropertySet;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.communication.messages.outgoing.room.session.OpenFlatConnectionMessageComposer;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room._enum.RoomObjectPlacementSource;
    import com.sulake.habbo.room.events.RoomEngineObjectPlacedEvent;
    import flash.events.Event;

     class FurniModel implements IInventoryModel 
    {
        static inline final _Str_14184= 100;

        var _controller:HabboInventory;
        var _view:FurniView;
        var _furniData:Vector<GroupItem>;
        var _assets:IAssetLibrary;
        var _windowManager:IHabboWindowManager;
        var _roomEngine:IRoomEngine;
        var _communication:IHabboCommunicationManager;
        var _soundManager:IHabboSoundManager;
        var _disposed:Bool = false;
        var _itemIdInFurniPlacing:Int = -1;
        var _isObjectMoverRequested:Bool = false;
        var _imageUpdateTimer:Timer;
        var _isListInitialized:Bool = false;
        var _catalog:IHabboCatalog;
        var _thumbWindowTemplates:ASDictionary<ASAny,ASAny>;
        var _localization:IHabboLocalizationManager;
        var _bottomAlignedFurniture:Array<ASAny>;
        var _showingRentedFurni:Bool = false;
        var _categorySelection:ASDictionary<ASAny,ASAny>;
        var _category:String;
        var _imageUpdateCumulativeTime:Int = 0;
        var _roomItemToSelect:FurnitureItem = null;
        var _isInRoom:Bool = false;

        public function new(k:HabboInventory, _arg_2:MarketplaceModel, _arg_3:IHabboWindowManager, _arg_4:IHabboCommunicationManager, _arg_5:IAssetLibrary, _arg_6:IRoomEngine, _arg_7:IHabboCatalog, _arg_8:IHabboSoundManager, _arg_9:IHabboLocalizationManager)
        {
            this._controller = k;
            this._communication = _arg_4;
            this._windowManager = _arg_3;
            this._assets = _arg_5;
            this._roomEngine = _arg_6;
            this._roomEngine.events.addEventListener(RoomEngineObjectEvent.PLACED, this._Str_6946);
            this._catalog = _arg_7;
            this._soundManager = _arg_8;
            this._localization = _arg_9;
            this._thumbWindowTemplates = new ASDictionary<ASAny,ASAny>();
            this._bottomAlignedFurniture = (cast this._controller.getProperty("catalog.preview.alignment.bottom").split(","));
            this._imageUpdateTimer = new Timer(_Str_14184);
            this._imageUpdateTimer.addEventListener(TimerEvent.TIMER, (this._Str_20314 : ASAny));
            this._categorySelection = new ASDictionary<ASAny,ASAny>();
            this._categorySelection[InventoryCategory.FURNI] = null;
            this._categorySelection[InventoryCategory.RENTABLES] = null;
            this.removeUnseenFurniCounter();
            this._view = new FurniView(this, _arg_2, this._windowManager, this._assets, this._roomEngine);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var controller(get,never):HabboInventory;
public function  get_controller():HabboInventory
        {
            return this._controller;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public var _Str_7553(get,never):Bool;
public function  get__Str_7553():Bool
        {
            var subCategory= this._controller._Str_18332();
            return subCategory == InventorySubCategory.TRADING
                || subCategory == InventorySubCategory.WIRED_TRADING;
        }

        public var isPrivateRoom(get,never):Bool;
public function  get_isPrivateRoom():Bool
        {
            if (((!(this._controller != null)) || (!(this._controller.roomSession != null))))
            {
                return false;
            }
            return this._controller.roomSession.isPrivateRoom;
        }

        public var furniData(get,never):Vector<GroupItem>;
public function  get_furniData():Vector<GroupItem>
        {
            return this._furniData;
        }

        public var soundManager(get,never):IHabboSoundManager;
public function  get_soundManager():IHabboSoundManager
        {
            return this._soundManager;
        }

        public var _Str_22702(get,never):Bool;
public function  get__Str_22702():Bool
        {
            return this._showingRentedFurni;
        }

        public var _Str_21498(never,set):GroupItem;
public function  set__Str_21498(k:GroupItem):GroupItem        {
            this._categorySelection[this._category] = k;
return k;
        }

        public function dispose()
        {
            var k:IWindowContainer = null;
            if (!this._disposed)
            {
                this._controller = null;
                if (this._furniData != null)
                {
                    this._furniData = null;
                }
                if (this._view != null)
                {
                    this._view.dispose();
                    this._view = null;
                }
                if (this._roomEngine != null)
                {
                    if (this._roomEngine.events != null)
                    {
                        this._roomEngine.events.removeEventListener(RoomEngineObjectEvent.PLACED, this._Str_6946);
                    }
                    this._roomEngine = null;
                }
                this._communication = null;
                this._assets = null;
                this._windowManager = null;
                this._catalog = null;
                this._soundManager = null;
                this._localization = null;
                if (this._imageUpdateTimer != null)
                {
                    this._imageUpdateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_20314 : ASAny));
                    this._imageUpdateTimer.stop();
                    this._imageUpdateTimer = null;
                }
                final _iter_ = this._thumbWindowTemplates; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    if (k != null)
                    {
                        k.dispose();
                    }
                }
                this._thumbWindowTemplates = null;
                this._disposed = true;
            }
        }

        public function createItemWindow(k:ASAny):IWindowContainer
        {
            var _local_2:IAsset = null;
            var _local_3:XmlAsset = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            if (this._thumbWindowTemplates[k] == null)
            {
                _local_2 = this._assets.getAssetByName(k);
                _local_3 = cast(_local_2, XmlAsset);
                _local_4 = new com.sulake.core.utils.xml.XML(_local_3.content);
                this._thumbWindowTemplates[k] = Std.downcast(this._windowManager.buildFromXML(_local_4) , IWindowContainer);
            }
            return this._thumbWindowTemplates[k].clone();
        }

        public function insertFurniture(k:Map)
        {
            var _local_2:FurnitureItem = null;
            var _local_3:FurniData = null;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_10 = false;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13:HabboInventoryItemAddedEvent = null;
            this._controller._Str_5943(InventoryCategory.FURNI);
            this._controller._Str_5943(InventoryCategory.RENTABLES);
            var _local_6= this._Str_23292();
            var _local_7= k.getKeys();
            var _local_8= new Vector<Int>(0);
            var _local_9= new Vector<Int>(0);
            _local_4 = 0;
            while (_local_4 < _local_7.length)
            {
                _local_12 = ASCompat.toInt(_local_7[_local_4]);
                if (_local_6.indexOf(_local_12) == -1)
                {
                    _local_8.push(_local_12);
                }
                _local_4++;
            }
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_5  = _tmp_;
                if (_local_7.indexOf(_local_5) == -1)
                {
                    _local_9.push(_local_5);
                }
            }
            _local_10 = (_local_6.length == 0);
            if (checkNullIteratee(_local_9)) for (_tmp_ in _local_9)
            {
_local_5  = _tmp_;
                this._Str_17979(_local_5);
            }
            if (checkNullIteratee(_local_8)) for (_tmp_ in _local_8)
            {
_local_5  = _tmp_;
                _local_3 = cast(k.getValue(_local_5), FurniData);
                _local_2 = new FurnitureItem(_local_3);
                this._Str_20455(_local_2, true);
            }
            if (!_local_10)
            {
                if (_local_8.length > 0)
                {
                    this._Str_17963();
                }
            }
            this._Str_11524();
            this._view._Str_18112(this._furniData);
            if (_local_10)
            {
                this._Str_14744();
            }
            else
            {
                if (this._Str_3968() == null)
                {
                    this._Str_14744();
                }
            }
            this._Str_7636();
            this._Str_19135();
            if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
            {
_local_11  = ASCompat.toInt(_tmp_);
                if (_local_8.indexOf(_local_11) > -1)
                {
                    _local_13 = new HabboInventoryItemAddedEvent(_local_3.spriteId, _local_3.itemId, _local_3.category);
                    this._controller.events.dispatchEvent(_local_13);
                }
            }
        }

        public function _Str_21873():Bool
        {
            return this._isListInitialized;
        }

        public function _Str_11524()
        {
            if (!this._isListInitialized)
            {
                this._isListInitialized = true;
                this._Str_7636();
            }
        }

        public function createGroupItem(k:Int, _arg_2:Int, _arg_3:IStuffData, _arg_4:Float=null, _arg_5:Bool=false):GroupItem
{
            if (_arg_4 == null) _arg_4 = Math.NaN;
            var _local_6:BitmapData = null;
            var _local_7:IAsset = null;
            if (_arg_2 == FurniCategory.WALL_PAPER)
            {
                _local_7 = this._windowManager.assets.getAssetByName("inventory_furni_icon_wallpaper");
                if (_local_7 != null)
                {
                    _local_6 = ASCompat.dynamicAs(_local_7.content , BitmapData).clone();
                }
            }
            else
            {
                if (_arg_2 == FurniCategory.FLOOR)
                {
                    _local_7 = this._windowManager.assets.getAssetByName("inventory_furni_icon_floor");
                    if (_local_7 != null)
                    {
                        _local_6 = ASCompat.dynamicAs(_local_7.content , BitmapData).clone();
                    }
                }
                else
                {
                    if (_arg_2 == FurniCategory.LANDSCAPE)
                    {
                        _local_7 = this._windowManager.assets.getAssetByName("inventory_furni_icon_landscape");
                        if (_local_7 != null)
                        {
                            _local_6 = ASCompat.dynamicAs(_local_7.content , BitmapData).clone();
                        }
                    }
                }
            }
            var _local_8= "center";
            var _local_9= this._roomEngine.getFurnitureType(k);
            if (this._bottomAlignedFurniture.indexOf(_local_9) > -1)
            {
                _local_8 = "bottom";
            }
            return new GroupItem(this, k, _arg_2, this._roomEngine, this._controller._Str_5568.running, _arg_3, _arg_4, _local_6, _arg_5, _local_8);
        }

        public function createCreditGroupItem(k:Int):GroupItem
        {
            return new CreditTradingItem(this, this._windowManager.assets, this._roomEngine, k);
        }

        public function onInventoryOpen()
        {
            var k= this._communication.connection;
            if (k != null)
            {
                if (this._isInRoom)
                {
                    k.send(new RequestFurniInventoryComposer());
                }
                else
                {
                    k.send(new RequestFurniInventoryWhenNotInRoomComposer());
                }
            }
        }

        public function initCategory(k:String)
        {
            if (this._controller.isVisible)
            {
                Logger.log([("FurniMode.categorySwitch: " + k)]);
                switch (k)
                {
                    case InventoryCategory.FURNI
                       | InventoryCategory.RENTABLES:
                        this._category = k;
                        this._showingRentedFurni = (this._category == InventoryCategory.RENTABLES);
                        this._view._Str_23210(k);
                        this._Str_24099();
                        this._Str_17963();
                        return;
                }
            }
        }

        public function getWindowContainer():IWindowContainer
        {
            this._controller.checkCategoryInitilization(InventoryCategory.MARKETPLACE);
            return this._view.getWindowContainer();
        }

        public function onInventoryClose()
        {
            if (this._view.isVisible)
            {
                this._Str_4409();
            }
        }

        public function _Str_17963()
        {
            var _local_5:GroupItem = null;
            var k= new Array<ASAny>();
            var _local_2= this._controller.activeTradingModel;
            if (_local_2 != null)
            {
                k = k.concat(_local_2.getOwnItemIdsInTrade());
            }
            var _local_3= this._controller._Str_5568;
            if (_local_3 != null)
            {
                k = k.concat(_local_3._Str_23744());
            }
            var _local_4= this._controller._Str_6398;
            if (((!(_local_4 == null)) && (!(_local_4.getOfferItem() == null))))
            {
                k = k.concat([_local_4.getOfferItem().ref]);
            }
            if (k.length == 0)
            {
                this._Str_12838();
                return;
            }
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                _local_5._Str_25603(k);
            }
            this._view._Str_2944();
        }

        public function _Str_15750(k:Int)
        {
            var _local_2:GroupItem = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2._Str_15750(k);
            }
            this._view._Str_2944();
        }

        public function _Str_10184(k:Int)
        {
            var _local_2:GroupItem = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2._Str_10184(k);
            }
            this._view._Str_2944();
        }

        public function _Str_14978(k:Bool)
        {
            var _local_2:GroupItem = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2._Str_14978 = k;
            }
            this._view._Str_2944();
        }

        public function removeUnseenFurniCounter()
        {
            this._furniData = new Vector<GroupItem>(0);
            if (this._view != null)
            {
                this._view._Str_22617();
            }
        }

        public function getItemWithStripId(k:Int):Bool
        {
            var _local_2 = false;
            var _local_3 = 0;
            var _local_4= this._controller.unseenItemTracker;
            if (_local_4 == null)
            {
                return false;
            }
            var _local_5= this._Str_14402(k);
            if (_local_5 == null)
            {
                return false;
            }
            if (this._category == InventoryCategory.RENTABLES)
            {
                _local_3 = UnseenItemCategoryEnum.RENTABLE;
            }
            else
            {
                _local_3 = UnseenItemCategoryEnum.FURNI;
            }
            var _local_6= this._controller.unseenItemTracker.isUnseen(_local_3, k);
            if (_local_6)
            {
                _local_2 = _local_4._Str_16745(_local_3, k);
            }
            if (_local_2)
            {
                _local_4._Str_17159(_local_3);
            }
            return _local_2;
        }

        public function _Str_25496(k:Int):GroupItem
        {
            var _local_2:GroupItem = null;
            var _local_3:IFurnitureItem = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.getItem(k);
                if (_local_3 != null)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_24542(k:Int):GroupItem
        {
            var _local_2:GroupItem = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.type == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_20455(k:FurnitureItem, _arg_2:Bool)
        {
            var _local_3:GroupItem = null;
            if (!k.groupable)
            {
                _local_3 = this._Str_22387(k, _arg_2);
            }
            else
            {
                _local_3 = this._Str_23860(k, _arg_2);
            }
            if (!_arg_2)
            {
                _local_3._Str_6126 = true;
            }
            if (_local_3.Selected)
            {
                this._view._Str_2944();
            }
        }

        public function _Str_7636()
        {
            this._view._Str_7636();
        }

        public function _Str_17979(k:Int):GroupItem
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:GroupItem = null;
            var _local_5:IFurnitureItem = null;
            var _local_4 = 0;
            while (_local_4 < this._furniData.length)
            {
                _local_3 = this._furniData[_local_4] ;
                _local_5 = _local_3.remove(k);
                if (_local_5 != null)
                {
                    if (this._itemIdInFurniPlacing == _local_5.ref)
                    {
                        this.cancelFurniInMover();
                        if (!this._Str_5337())
                        {
                            this._controller.showView();
                        }
                    }
                    if (_local_3.getTotalCount() <= 0)
                    {
                        this._furniData.splice(_local_4, 1);
                        if (((this._view != null) && (this._view.grid != null)))
                        {
                            this._view.grid._Str_9854(_local_3);
                        }
                        if (_local_3.Selected)
                        {
                            this._Str_14744();
                        }
                        _local_3.dispose();
                    }
                    else
                    {
                        this._view._Str_2944();
                    }
                    this._view._Str_7636();
                    return _local_3;
                }
                _local_4++;
            }
            return null;
        }

        public function _Str_22816(k:Int, _arg_2:Int)
        {
            var _local_3:GroupItem = null;
            var _local_4:FurnitureItem = null;
            var _local_5:LegacyStuffData = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_4 = _local_3.getItem(k) ;
                if (_local_4 != null)
                {
                    _local_5 = Std.downcast(_local_4.stuffData , LegacyStuffData);
                    _local_5.setString(Std.string(_arg_2));
                    _local_4.stuffData = _local_5;
                    _local_3._Str_23685(k, _local_4);
                }
            }
        }

        public function _Str_14744()
        {
            var _local_2:GroupItem = null;
            var k= this._view._Str_15980();
            if (k == null)
            {
                return;
            }
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.window == k)
                {
                    _local_2.Selected = true;
                    _local_2._Str_4405 = -1;
                    break;
                }
            }
            this._view._Str_2944();
        }

        public function _Str_12834(k:GroupItem)
        {
            if (((this._view != null) && (!this._view.disposed)))
            {
                this._view._Str_12834(k);
            }
        }

        public function _Str_3968():GroupItem
        {
            var k:GroupItem = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.Selected)
                {
                    return k;
                }
            }
            return null;
        }

        public function _Str_19669()
        {
            var k:GroupItem = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.Selected = false;
            }
        }

        public function _Str_16742():Bool
        {
            return this._controller._Str_16742();
        }

        public function _Str_12838()
        {
            var k:GroupItem = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k._Str_12838();
            }
            if (this._view != null)
            {
                this._view._Str_2944();
            }
        }

        public function cancelFurniInMover()
        {
            if (this._itemIdInFurniPlacing > -1)
            {
                this._roomEngine.cancelRoomObjectInsert();
                this._isObjectMoverRequested = false;
                this._itemIdInFurniPlacing = -1;
            }
        }

        public function _Str_5337(k:Bool=false):Bool
        {
            var _local_3:FurnitureItem = null;
            var _local_2= this._Str_3968();
            if (_local_2 == null)
            {
                return false;
            }
            if (_local_2.getUnlockedCount() == 0)
            {
                return false;
            }
            if (_local_2._Str_4405 >= 0)
            {
                _local_3 = _local_2._Str_5087(_local_2._Str_4405);
                if (_local_3 == null)
                {
                    _local_3 = _local_2._Str_3205();
                }
            }
            else
            {
                _local_3 = _local_2._Str_3205();
            }
            if (_local_3 == null)
            {
                return false;
            }
            if ((_local_3.rentable && (_local_3.flatId > -1)))
            {
                return false;
            }
            if ((((_local_3.category == FurniCategory.FLOOR) || (_local_3.category == FurniCategory.WALL_PAPER)) || (_local_3.category == FurniCategory.LANDSCAPE)))
            {
                if (k)
                {
                    return false;
                }
                this._communication.connection.send(new RequestRoomPropertySet(_local_3.id));
            }
            else
            {
                this.requestSelectedFurniToMover(_local_3);
            }
            this._view._Str_2944();
            return true;
        }

        public function _Str_21349(itemsToTrade:Int=1, offerInTradingCount:ITextFieldWindow=null)
        {
            var furnitureItem:IFurnitureItem = null;
            var ownItemCount = 0;
            var groupItem= this._Str_3968();
            if (groupItem == null)
            {
                return;
            }
            var itemsInTrade= groupItem._Str_25861(itemsToTrade);
            if (itemsInTrade.length == 0)
            {
                return;
            }
            var coreItem:IFurnitureItem = null;
            var itemIds= new Vector<Int>();
            if (checkNullIteratee(itemsInTrade)) for (_tmp_ in itemsInTrade)
            {
furnitureItem  = _tmp_;
                itemIds.push(furnitureItem.id);
                if (coreItem == null)
                {
                    coreItem = furnitureItem;
                }
            }
            if (coreItem == null)
            {
                return;
            }
            var trading= this._controller.activeTradingModel;
            if (trading != null)
            {
                ownItemCount = trading.getOwnItemIdsInTrade().length;
                if ((ownItemCount + itemIds.length) <= 1500)
                {
                    if (offerInTradingCount != null)
                    {
                        offerInTradingCount.caption = Std.string(itemIds.length);
                    }
                    trading.requestAddItemsToTrading(itemIds, coreItem.isWallItem, coreItem.type, coreItem.category, coreItem.groupable, coreItem.stuffData);
                }
                else
                {
                    if (offerInTradingCount != null)
                    {
                        offerInTradingCount.caption = "1";
                    }
                    this._windowManager.alert("${trading.items.too_many_items.title}", "${trading.items.too_many_items.desc}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
                    {
                        k.dispose();
                    });
                }
            }
            else
            {
                if (offerInTradingCount != null)
                {
                    offerInTradingCount.caption = "1";
                }
            }
            this._view._Str_2944();
        }

        public function gotoRoom()
        {
            var k= this._Str_3968();
            if (k == null)
            {
                return;
            }
            var _local_2= k._Str_3205();
            if (_local_2 == null)
            {
                return;
            }
            if (this._communication == null)
            {
                return;
            }
            var _local_3= this._communication.connection;
            if (_local_3 == null)
            {
                return;
            }
            _local_3.send(new OpenFlatConnectionMessageComposer(_local_2.flatId));
            this._roomItemToSelect = _local_2;
        }

        public function _Str_25554()
        {
            var k= this._Str_3968();
            if (k == null)
            {
                return;
            }
            var _local_2= k._Str_21356();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._controller._Str_6398;
            if (_local_3 == null)
            {
                return;
            }
            _local_3.startOfferMaking(_local_2);
        }

        public function _Str_15313():IFurnitureItem
        {
            var k= this._Str_3968();
            if (k == null)
            {
                return null;
            }
            var _local_2:IFurnitureItem = k._Str_25739();
            if (_local_2 == null)
            {
                return null;
            }
            this._view._Str_2944();
            return _local_2;
        }

        public function _Str_25520()
        {
            if (this._Str_7553)
            {
                this._Str_21349();
            }
            else
            {
                this._Str_5337(false);
            }
        }

        public function _Str_22716()
        {
            this._controller._Str_13252();
        }

        public function showUseProductSelection()
        {
            var _local_2:IFurnitureItem = null;
            var k= this._Str_3968();
            if (((!(k == null)) && (!(k._Str_3205() == null))))
            {
                _local_2 = k._Str_3205();
                if (_local_2 != null)
                {
                    this._roomEngine.showUseProductSelection(_local_2.ref, _local_2.type);
                }
            }
        }

        public function onCategorySwitch(k:String)
        {
            switch (k)
            {
                case InventorySubCategory.TRADING:
                    this.cancelFurniInMover();
                    if (this._view != null)
                    {
                        this._view._Str_2944();
                    }
                    return;
                case InventorySubCategory.EMPTY:
                    this._Str_12838();
                    if (this._view != null)
                    {
                        this._view._Str_2944();
                    }
                    return;
            }
        }

        public function _Str_2944()
        {
            this._view._Str_2944();
        }

        public function updateView()
        {
            if (this._view != null)
            {
                this._view._Str_2944();
                this._view._Str_7221();
            }
        }

        public function _Str_4409()
        {
            var _local_2:GroupItem = null;
            if (this._view == null)
            {
                return;
            }
            var k = false;
            if (this._category == InventoryCategory.RENTABLES)
            {
            this._controller.unseenItemTracker._Str_8813(UnseenItemCategoryEnum.RENTABLE);
                k = true;
            }
            else
            {
            this._controller.unseenItemTracker._Str_8813(UnseenItemCategoryEnum.FURNI);
            }
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if ((_local_2._Str_6126 && (_local_2._Str_3459 == k)))
                {
                    _local_2._Str_6126 = false;
                }
            }
            this._controller._Str_6956();
        }

        public function _Str_22285()
        {
            var _local_4:Array<ASAny> = null;
            var _local_5:GroupItem = null;
            var _local_6 = 0;
            if (((!(this._view != null)) || (!(this._view.grid != null))))
            {
                return;
            }
            var k:Array<ASAny> = [];
            var _local_2= this._controller.unseenItemTracker._Str_11239(UnseenItemCategoryEnum.FURNI);
            var _local_3= this._controller.unseenItemTracker._Str_11239(UnseenItemCategoryEnum.RENTABLE);
            k = k.concat(_local_2);
            k = k.concat(_local_3);
            if (((!(k != null)) || (k.length == 0)))
            {
                return;
            }
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                _local_4 = _local_5._Str_24519();
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_6  = ASCompat.toInt(_tmp_);
                    if (k.indexOf(_local_6) != -1)
                    {
                        _local_5._Str_6126 = true;
                        this._Str_21263(_local_5);
                        this._view.grid._Str_9854(_local_5);
                        break;
                    }
                }
            }
        }

        public function _Str_25502()
        {
            var k= this._Str_3968();
            if (k == null)
            {
                return;
            }
            var _local_2= k._Str_3205();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._controller.getFurnitureData(_local_2.type, (_local_2.isWallItem ? ProductTypeEnum.WALL : ProductTypeEnum.FLOOR));
            this._catalog.openRentConfirmationWindow(_local_3, false, -1, _local_2.id);
        }

        public function _Str_22829()
        {
            var k= this._Str_3968();
            if (k == null)
            {
                return;
            }
            var _local_2= k._Str_3205();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._controller.getFurnitureData(_local_2.type, (_local_2.isWallItem ? ProductTypeEnum.WALL : ProductTypeEnum.FLOOR));
            this._catalog.openRentConfirmationWindow(_local_3, true, -1, _local_2.id);
        }

        function _Str_18724(k:GroupItem)
        {
            this._furniData.unshift(k);
        }

        function _Str_19354(k:GroupItem)
        {
            this._furniData.push(k);
        }

        function removeItem(k:GroupItem)
        {
            var _local_2= this._furniData.indexOf(k);
            if (_local_2 > -1)
            {
                this._furniData.splice(_local_2, 1);
            }
        }

        function _Str_21263(k:GroupItem)
        {
            this.removeItem(k);
            this._Str_18724(k);
        }

        function _Str_23292():Vector<Int>
        {
            var _local_2:GroupItem = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var k= new Vector<Int>(0);
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.getTotalCount();
                if (_local_2.category == FurniCategory.POST_IT)
                {
                    _local_3 = 1;
                }
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    k.push(_local_2._Str_5087(_local_4).id);
                    _local_4++;
                }
            }
            return k;
        }

        function _Str_19135()
        {
            var k:GroupItem = null;
            if (!this._imageUpdateTimer.running)
            {
                this._imageUpdateTimer.start();
            }
            if (((this._view != null) && (this._view._Str_12561 != null)))
            {
                final _iter_ = this._view._Str_12561; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    if (!k._Str_23694)
                    {
                        k._Str_20973(false);
                        break;
                    }
                }
            }
        }

        function _Str_14402(k:Int):GroupItem
        {
            var _local_2:GroupItem = null;
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.getItem(k) != null)
                {
                    return _local_2;
                }
            }
            return null;
        }

        function isUnseen(k:FurnitureItem):Bool
        {
            var _local_2 = 0;
            if (k.rentable)
            {
                _local_2 = UnseenItemCategoryEnum.RENTABLE;
            }
            else
            {
                _local_2 = UnseenItemCategoryEnum.FURNI;
            }
            return this._controller.unseenItemTracker.isUnseen(_local_2, k.id);
        }

        function _Str_22387(k:FurnitureItem, _arg_2:Bool):GroupItem
        {
            var _local_3:GroupItem = null;
            var _local_5 = false;
            var _local_4= new Vector<GroupItem>(0);
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.type == k.type)
                {
                    _local_4.push(_local_3);
                }
            }
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_3  = _tmp_;
                if (_local_3.getItem(k.id) != null)
                {
                    return _local_3;
                }
            }
            _local_5 = this.isUnseen(k);
            _local_3 = this.createGroupItem(k.type, k.category, k.stuffData, k.extra, _arg_2);
            _local_3.push(k, _local_5);
            if (_local_5)
            {
                _local_3._Str_6126 = true;
                this._Str_18724(_local_3);
            }
            else
            {
                this._Str_19354(_local_3);
            }
            if (((this._view != null) && (this._view.grid != null)))
            {
                this._view.grid._Str_9854(_local_3);
            }
            return _local_3;
        }

        function _Str_23860(k:FurnitureItem, _arg_2:Bool):GroupItem
        {
            var _local_4:GroupItem = null;
            var _local_5:GroupItem = null;
            var _local_3= this.isUnseen(k);
            final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                if (((_local_5.type == k.type) && (_local_5.isWallItem == k.isWallItem)))
                {
                    if (((k.category == FurniCategory.FURNI_CHEST) ||
                         (k.category == FurniCategory.COINS_CHEST)))
                    {
                        // July keeps named or non-empty chests separate so one
                        // thumbnail cannot hide another chest's state/count.
                        if (((_local_5.stuffData.contentsCount == 0) &&
                             (k.stuffData.contentsCount == 0)) &&
                            ((_local_5.stuffData.chestName == "") &&
                             (k.stuffData.chestName == "")))
                        {
                            _local_4 = _local_5;
                            break;
                        }
                    }
                    else if (_local_5.isGroupable)
                    {
                        if (k.category == FurniCategory.POSTER)
                        {
                            if (_local_5.stuffData.getLegacyString() == k.stuffData.getLegacyString())
                            {
                                _local_4 = _local_5;
                                break;
                            }
                        }
                        else
                        {
                            if (k.category == FurniCategory.GUILD_FURNI)
                            {
                                if (k.stuffData.compare(_local_5.stuffData))
                                {
                                    _local_4 = _local_5;
                                    break;
                                }
                            }
                            else
                            {
                                _local_4 = _local_5;
                                break;
                            }
                        }
                    }
                }
            }
            if (_local_4 != null)
            {
                _local_4.push(k, _local_3);
                if (_local_3)
                {
                    _local_4._Str_6126 = true;
                    this._Str_21263(_local_4);
                }
                if (((this._view != null) && (this._view.grid != null)))
                {
                    this._view.grid._Str_9854(_local_4);
                }
                return _local_4;
            }
            _local_5 = this.createGroupItem(k.type, k.category, k.stuffData, k.extra, _arg_2);
            _local_5.push(k, _local_3);
            if (_local_3)
            {
                _local_5._Str_6126 = true;
                this._Str_18724(_local_5);
            }
            else
            {
                this._Str_19354(_local_5);
            }
            if (((this._view != null) && (this._view.grid != null)))
            {
                this._view.grid._Str_9854(_local_5);
            }
            return _local_5;
        }

        function requestSelectedFurniToMover(k:FurnitureItem)
        {
            var _local_2 = 0;
            var _local_3 = false;
            if (k.isWallItem)
            {
                _local_2 = RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM;
            }
            else
            {
                _local_2 = RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE;
            }
            if (((k.category == FurniCategory.POSTER) || this._Str_22524(k)))
            {
                _local_3 = this._roomEngine.initializeRoomObjectInsert(RoomObjectPlacementSource.INVENTORY, k.id, _local_2, k.type, k.stuffData.getLegacyString());
            }
            else
            {
                _local_3 = this._roomEngine.initializeRoomObjectInsert(RoomObjectPlacementSource.INVENTORY, k.id, _local_2, k.type, Std.string(k.extra), k.stuffData);
            }
            if (_local_3)
            {
                this._itemIdInFurniPlacing = k.ref;
                if (!this._controller._Str_5568.running)
                {
                    this._Str_22716();
                }
                this._isObjectMoverRequested = true;
            }
            this._view._Str_2944();
        }

        function _Str_22524(k:FurnitureItem):Bool
        {
            var _local_2= this._catalog.getFurnitureData(k.type, ProductTypeEnum.WALL);
            return (_local_2 != null) && _local_2.isExternalImageType;
        }

        function _Str_24099()
        {
            var _local_2 = 0;
            this._Str_19669();
            var k:GroupItem = this._categorySelection[this._category];
            if (k != null)
            {
                _local_2 = this._furniData.indexOf(k);
                if (_local_2 > -1)
                {
                    k.Selected = true;
                    k._Str_4405 = -1;
                }
            }
            else
            {
                this._Str_14744();
            }
            this._view._Str_2944();
        }

        public function _Str_6946(k:Event)
        {
            if ((this._isObjectMoverRequested && (k.type == RoomEngineObjectEvent.PLACED)))
            {
                this._isObjectMoverRequested = false;
                if (!Std.downcast(k , RoomEngineObjectPlacedEvent).isPlacedInRoom)
                {
                    this._controller.showView();
                }
                else
                {
                    if (this._category == InventoryCategory.RENTABLES)
                    {
                        this._controller.showView();
                    }
                }
            }
        }

        function _Str_20314(k:TimerEvent)
        {
            var _local_2:Vector<Int> = null;
            var _local_3:GroupItem = null;
            var _local_4 = 0;
            var _local_5:FurnitureItem = null;
            this._Str_19135();
            this._imageUpdateCumulativeTime = (this._imageUpdateCumulativeTime + _Str_14184);
            if (this._imageUpdateCumulativeTime >= 1000)
            {
                _local_2 = new Vector<Int>(0);
                final _iter_ = this._furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    _local_5 = _local_3._Str_5087(0);
                    if (((((_local_5 != null) && _local_5.rentable) && _local_5.hasRentPeriodStarted) && (_local_5.secondsToExpiration <= 0)))
                    {
                        _local_2.push(_local_5.id);
                    }
                }
                if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                {
_local_4  = _tmp_;
                    this._Str_17979(_local_4);
                }
                if (_local_2.length > 0)
                {
                    this._view._Str_7221();
                }
                this._view.updateRentedItem();
                this._imageUpdateCumulativeTime = 0;
            }
        }

        public function roomEntered()
        {
            var k = 0;
            this._isInRoom = true;
            if (this._roomItemToSelect == null)
            {
                return;
            }
            if (this._roomEngine != null)
            {
                k = (this._roomItemToSelect.isWallItem ? RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM : RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                this._roomEngine.selectRoomObject(this._roomItemToSelect.flatId, Std.int(Math.abs(this._roomItemToSelect.id)), k);
            }
            this._roomItemToSelect = null;
        }

        public function roomLeft()
        {
            this._isInRoom = false;
        }

        public function onSubcategorySwitch(k:String)
        {
            var _local_2= this._Str_14402(-ASCompat.toInt(k));
            if (_local_2 != null)
            {
                this._Str_21498 = _local_2;
            }
        }
    }

