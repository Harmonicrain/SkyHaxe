package com.sulake.habbo.inventory
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.inventory.purse.Purse;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import flash.utils.Timer;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.habbo.session.events.RoomSessionPropertyUpdateEvent;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.iid.IIDHabboSoundManager;
    import com.sulake.habbo.configuration._enum.HabboComponentFlags;
    import com.sulake.habbo.communication.messages.outgoing.inventory.purse.GetCreditsInfoComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.ScrGetUserInfoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.badges.GetBadgePointLimitsComposer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.inventory.furni.FurniModel;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.habbo.inventory.trading.TradingModel;
    import com.sulake.habbo.inventory.trading.ITradingModel;
    import com.sulake.habbo.inventory.wired_trading.WiredTradingModel;
    import com.sulake.habbo.inventory._enum.InventorySubCategory;
    import com.sulake.habbo.inventory.effects.EffectsModel;
    import com.sulake.habbo.inventory.badges.BadgesModel;
    import com.sulake.habbo.inventory.recycler.RecyclerModel;
    import com.sulake.habbo.inventory.pets.PetsModel;
    import com.sulake.habbo.inventory.bots.BotsModel;
    import com.sulake.habbo.inventory.marketplace.MarketplaceModel;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.Event;
    import com.sulake.habbo.inventory.events.HabboInventoryTrackingEvent;
    import com.sulake.habbo.inventory.events.HabboInventoryEffectsEvent;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.room._enum.RoomObjectPlacementSource;
    import com.sulake.habbo.inventory.items.IFurnitureItem;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.habbo.inventory._enum.UnseenItemCategoryEnum;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.inventory.badges.Badge;
    import com.sulake.iid.*;

     class HabboInventory extends Component implements IHabboInventory implements  ILinkEventTracker 
    {
        var _communication:IHabboCommunicationManager;
        var _incomingMessages:IncomingMessages;
        var _windowManager:IHabboWindowManager;
        var _sessionDataManager:ISessionDataManager;
        var _localization:IHabboLocalizationManager;
        var _soundManager:IHabboSoundManager;
        var _view:InventoryMainView;
        var _inventories:Map;
        var _roomEngine:IRoomEngine;
        var _roomSession:IRoomSession;
        var _initedInventoryCategories:Array<ASAny>;
        var _purse:Purse;
        var _avatarRenderer:IAvatarRenderManager;
        var _catalog:IHabboCatalog;
        var _isInitialized:Bool = false;
        var _unseenItemTracker:UnseenItemTracker;
        var _externalBadgesInitializationRequested:Bool = false;
        var _currentCategoryId:String;
        var _figureSetIds:Vector<Int>;
        var _boundFurnitureNames:Vector<String>;
        var _purseTimer:Timer;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._purse = new Purse();
            this._initedInventoryCategories = [];
            this._figureSetIds = new Vector<Int>(0);
        }

        public var isVisible(get,never):Bool;
public function  get_isVisible():Bool
        {
            return this._view.isVisible;
        }

        public var _Str_23029(get,never):Bool;
public function  get__Str_23029():Bool
        {
            return this._view.isActive;
        }

        public var isInitialized(get,never):Bool;
public function  get_isInitialized():Bool
        {
            return this._isInitialized;
        }

        public var unseenItemTracker(get,never):IUnseenItemTracker;
public function  get_unseenItemTracker():IUnseenItemTracker
        {
            return this._unseenItemTracker;
        }

        public var view(get,never):InventoryMainView;
public function  get_view():InventoryMainView
        {
            return this._view;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            }), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarRenderer = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), null, false, [{
                "type":RoomSessionEvent.STARTED,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionEvent.ENDED,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionPropertyUpdateEvent.RSDUE_ALLOW_PETS,
                "callback":this.roomSessionEventHandler
            }]), new ComponentDependency(new IIDHabboToolbar(), null, false, [{
                "type":HabboToolbarEvent.HTE_TOOLBAR_CLICK,
                "callback":this._Str_23889
            }]), new ComponentDependency(new IIDHabboSoundManager(), function (k:IHabboSoundManager)
            {
                _soundManager = k;
            })]));
        }

        function _Str_23889(k:HabboToolbarEvent)
        {
            if (this._view != null)
            {
                this._view._Str_3304(k);
            }
        }

        override function initComponent()
        {
            if (HabboComponentFlags.isRoomViewerMode(ASCompat.toInt(flags)))
            {
                return;
            }
            this._incomingMessages = new IncomingMessages(this);
            context.addLinkEventTracker(this);
            this._unseenItemTracker = new UnseenItemTracker(this._communication, events, this);
            this._view = new InventoryMainView(this, this._windowManager, assets);
            this._communication.connection.send(new GetCreditsInfoComposer());
            this._communication.connection.send(new ScrGetUserInfoMessageComposer("habbo_club"));
            this._communication.connection.send(new GetBadgePointLimitsComposer());
        }

        override public function dispose()
        {
            var k:Array<ASAny> = null;
            var _local_2 = 0;
            var _local_3:String = null;
            var _local_4:IInventoryModel = null;
            if (disposed)
            {
                return;
            }
            if (this._purseTimer != null)
            {
                this._purseTimer.stop();
                this._purseTimer.removeEventListener(TimerEvent.TIMER, (this.onPurseTimer : ASAny));
                this._purseTimer = null;
            }
            if (this._inventories != null)
            {
                k = this._inventories.getKeys();
                _local_2 = 0;
                while (_local_2 < k.length)
                {
                    _local_3 = k[_local_2];
                    _local_4 = ASCompat.dynamicAs(this._inventories.getValue(_local_3) , IInventoryModel);
                    if (_local_4 != null)
                    {
                        _local_4.dispose();
                    }
                    _local_2++;
                }
                this._inventories.dispose();
                this._inventories = null;
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._roomSession = null;
            if (this._unseenItemTracker != null)
            {
                this._unseenItemTracker.dispose();
                this._unseenItemTracker = null;
            }
            if (this._incomingMessages != null)
            {
                this._incomingMessages.dispose();
                this._incomingMessages = null;
            }
            super.dispose();
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public function getModel(k:String):IInventoryModel
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            return this._inventories.getValue(k);
        }

        public var furniModel(get,never):FurniModel;
public function  get_furniModel():FurniModel
        {
            return disposed ? null : cast(this.getModel(InventoryCategory.FURNI), FurniModel);
        }

        public var _Str_3957(get,never):TradingModel;
public function  get__Str_3957():TradingModel
        {
            return disposed ? null : cast(this.getModel(InventorySubCategory.TRADING), TradingModel);
        }

        public var wiredTradingModel(get,never):WiredTradingModel;
public function  get_wiredTradingModel():WiredTradingModel
        {
            return disposed ? null
                : cast(this.getModel(InventorySubCategory.WIRED_TRADING), WiredTradingModel);
        }

        public var _Str_3994(get,never):EffectsModel;
public function  get__Str_3994():EffectsModel
        {
            return disposed ? null : cast(this.getModel(InventoryCategory.EFFECTS), EffectsModel);
        }

        public var badgesModel(get,never):BadgesModel;
public function  get_badgesModel():BadgesModel
        {
            return disposed ? null : cast(this.getModel(InventoryCategory.BADGES), BadgesModel);
        }

        public var _Str_5568(get,never):RecyclerModel;
public function  get__Str_5568():RecyclerModel
        {
            return disposed ? null : cast(this.getModel(InventorySubCategory.RECYCLER), RecyclerModel);
        }

        public var _Str_4524(get,never):PetsModel;
public function  get__Str_4524():PetsModel
        {
            return disposed ? null : cast(this.getModel(InventoryCategory.PETS), PetsModel);
        }

        public var _Str_8302(get,never):BotsModel;
public function  get__Str_8302():BotsModel
        {
            return disposed ? null : cast(this.getModel(InventoryCategory.BOTS), BotsModel);
        }

        public var _Str_6398(get,never):MarketplaceModel;
public function  get__Str_6398():MarketplaceModel
        {
            return disposed ? null : cast(this.getModel(InventoryCategory.MARKETPLACE), MarketplaceModel);
        }

        public var sessionData(get,never):ISessionDataManager;
public function  get_sessionData():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var roomSession(get,never):IRoomSession;
public function  get_roomSession():IRoomSession
        {
            return this._roomSession;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var clubDays(get,never):Int;
public function  get_clubDays():Int
        {
            return this._purse.clubDays;
        }

        public var clubPeriods(get,never):Int;
public function  get_clubPeriods():Int
        {
            return this._purse.clubPeriods;
        }

        public var clubPastPeriods(get,never):Int;
public function  get_clubPastPeriods():Int
        {
            return this._purse.clubPastPeriods;
        }

        public var clubHasEverBeenMember(get,never):Bool;
public function  get_clubHasEverBeenMember():Bool
        {
            return this._purse.clubHasEverBeenMember;
        }

        public var clubIsExpiring(get,never):Bool;
public function  get_clubIsExpiring():Bool
        {
            return this._purse.clubIsExpiring;
        }

        public var citizenshipVipIsExpiring(get,never):Bool;
public function  get_citizenshipVipIsExpiring():Bool
        {
            return this._purse.citizenshipVipIsExpiring;
        }

        public var clubMinutesUntilExpiration(get,never):Int;
public function  get_clubMinutesUntilExpiration():Int
        {
            return this._purse.minutesUntilExpiration;
        }

        public var clubLevel(get,never):Int;
public function  get_clubLevel():Int
        {
            if (((this.clubDays == 0) && (this.clubPeriods == 0)))
            {
                return HabboClubLevelEnum.NO_CLUB;
            }
            if (this._purse.isVIP)
            {
                return HabboClubLevelEnum.VIP;
            }
            return HabboClubLevelEnum.CLUB;
        }

        public var hasRoomSession(get,never):Bool;
public function  get_hasRoomSession():Bool
        {
            return !(this._roomSession == null);
        }

        public function _Str_18332():String
        {
            return this._view._Str_18332();
        }

        public function _Str_23808(k:Int, _arg_2:Int, _arg_3:Bool, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool, _arg_7:Int, _arg_8:Int)
        {
            this._purse.clubPeriods = k;
            this._purse.clubDays = _arg_2;
            this._purse.clubHasEverBeenMember = _arg_3;
            this._purse.isVIP = _arg_4;
            this._purse.clubIsExpiring = _arg_5;
            this._purse.citizenshipVipIsExpiring = _arg_6;
            this._purse.minutesUntilExpiration = _arg_7;
            this._purse.minutesSinceLastModified = _arg_8;
            if (((_arg_7 > 0) && (_arg_7 < (((60 * 1000) * 60) * 24))))
            {
                if (this._purseTimer == null)
                {
                    this._purseTimer = new Timer((60 * 1000), 0);
                    this._purseTimer.addEventListener(TimerEvent.TIMER, (this.onPurseTimer : ASAny));
                }
                if (!this._purseTimer.running)
                {
                    this._purseTimer.start();
                }
            }
            else
            {
                if (this._purseTimer != null)
                {
                    this._purseTimer.stop();
                    this._purseTimer.removeEventListener(TimerEvent.TIMER, (this.onPurseTimer : ASAny));
                    this._purseTimer = null;
                }
            }
        }

        function onPurseTimer(k:TimerEvent)
        {
            this._communication.connection.send(new ScrGetUserInfoMessageComposer("habbo_club"));
        }

        function roomSessionEventHandler(k:RoomSessionEvent)
        {
            switch (k.type)
            {
                case RoomSessionEvent.STARTED:
                    this._roomSession = k.session;
                    if (this._isInitialized)
                    {
                        if (this._Str_4524 != null)
                        {
                            this._Str_4524._Str_19310();
                        }
                        if (this.furniModel != null)
                        {
                            this.furniModel.updateView();
                        }
                    }
                    return;
                case RoomSessionEvent.ENDED:
                    this._roomSession = null;
                    if (this._isInitialized)
                    {
                        this.deselectAllEffects();
                    }
                    return;
                case RoomSessionPropertyUpdateEvent.RSDUE_ALLOW_PETS:
                    if (this._isInitialized)
                    {
                        if (this._Str_4524 != null)
                        {
                            this._Str_4524._Str_19310();
                        }
                    }
                    return;
            }
        }

        function init()
        {
            if (!allRequiredDependenciesInjected)
            {
                return;
            }
            this._inventories = new Map();
            var marketplaceModel= new MarketplaceModel(this, this._windowManager, this._communication, assets, this._roomEngine, this._localization);
            this._inventories.add(InventoryCategory.MARKETPLACE, marketplaceModel);
            var furniModel= new FurniModel(this, marketplaceModel, this._windowManager, this._communication, assets, this._roomEngine, this._catalog, this._soundManager, this._localization);
            this._inventories.add(InventoryCategory.FURNI, furniModel);
            this._inventories.add(InventoryCategory.RENTABLES, furniModel);
            var badgesModel= new BadgesModel(this, this._windowManager, this._communication, assets);
            this._inventories.add(InventoryCategory.BADGES, badgesModel);
            var effectsModel= new EffectsModel(this, this._windowManager, this._communication, assets, this._localization);
            this._inventories.add(InventoryCategory.EFFECTS, effectsModel);
            var tradingModel= new TradingModel(this, this._windowManager, this._communication, assets, this._roomEngine, this._localization, this._soundManager);
            this._inventories.add(InventorySubCategory.TRADING, tradingModel);
            var wiredTradingModel= new WiredTradingModel(
                this, this._windowManager, this._communication, assets,
                this._roomEngine, this._localization, this._soundManager);
            this._inventories.add(
                InventorySubCategory.WIRED_TRADING, wiredTradingModel);
            var recyclerModel= new RecyclerModel(this, this._windowManager, this._communication, assets, this._roomEngine, this._localization);
            this._inventories.add(InventorySubCategory.RECYCLER, recyclerModel);
            var petsModel= new PetsModel(this, this._windowManager, this._communication, assets, this._roomEngine, this._catalog);
            this._inventories.add(InventoryCategory.PETS, petsModel);
            var botsModel= new BotsModel(this, this._windowManager, this._communication, assets, this._roomEngine, this._catalog, this._avatarRenderer);
            this._inventories.add(InventoryCategory.BOTS, botsModel);
            this._isInitialized = true;
        }

        public function getCategoryWindowContainer(k:String):IWindowContainer
        {
            var _local_2= cast(this._inventories.getValue(k), IInventoryModel);
            if (_local_2 == null)
            {
                return null;
            }
            return _local_2.getWindowContainer();
        }

        public function updateView(k:String)
        {
            var _local_2= cast(this._inventories.getValue(k), IInventoryModel);
            if (_local_2 == null)
            {
                return;
            }
            return _local_2.updateView();
        }

        public function _Str_24435(k:String):IWindowContainer
        {
            var _local_2= cast(this._inventories.getValue(k), IInventoryModel);
            return (_local_2 == null) ? null : _local_2.getWindowContainer();
        }

        public function getActivatedAvatarEffects():Array<ASAny>
        {
            return (this._Str_3994 == null) ? [] : this._Str_3994._Str_6532(EffectsModel._Str_14844);
        }

        public function getAvatarEffects():Array<ASAny>
        {
            return (this._Str_3994 == null) ? [] : this._Str_3994._Str_6532();
        }

        public function setEffectSelected(k:Int)
        {
            var _local_2= this._Str_3994;
            if (_local_2 == null)
            {
                return;
            }
            _local_2._Str_20338(k);
            this._Str_7796();
        }

        public function setEffectDeselected(k:Int)
        {
            var _local_2= this._Str_3994;
            if (_local_2 == null)
            {
                return;
            }
            _local_2.stopUsingEffect(k, true);
            this._Str_7796();
        }

        public function deselectAllEffects(k:Bool=false)
        {
            var _local_2= this._Str_3994;
            if (_local_2 == null)
            {
                return;
            }
            _local_2.stopUsingAllEffects(true, true, k);
            this._Str_7796();
        }

        public function getAvatarEffect(k:Int):IAvatarEffect
        {
            return (this._Str_3994 == null) ? null : this._Str_3994._Str_23964(k);
        }

        public function _Str_13252()
        {
            if (((this._view != null) && this._view.isVisible))
            {
                this._view._Str_15430();
            }
        }

        public function showView()
        {
            if (this._view != null)
            {
                this._view._Str_24385();
            }
        }

        public var _Str_23047(get,never):Bool;
public function  get__Str_23047():Bool
        {
            return !(this._view.mainContainer == null);
        }

        public function _Str_22707()
        {
            if (this._view != null)
            {
                this.toggleInventoryPage(InventoryCategory.FURNI);
                this._view._Str_15430();
            }
        }

        public function toggleInventoryPage(k:String, _arg_2:String=null, _arg_3:Bool=false)
        {
            this._currentCategoryId = k;
            var _local_4= this._view.toggleCategoryView(k, false, _arg_3);
            if (_local_4)
            {
                this._Str_18877(k);
                if (_arg_2 != null)
                {
                    cast(this._inventories.getValue(this._currentCategoryId), IInventoryModel).onSubcategorySwitch(_arg_2);
                }
            }
            if (!_local_4)
            {
                events.dispatchEvent(new Event(HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_CLOSED));
            }
        }

        public function toggleInventorySubPage(k:String)
        {
            var _local_3:IInventoryModel = null;
            this._view._Str_24934(k, false);
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._inventories.length)
            {
                _local_3 = ASCompat.dynamicAs(this._inventories.getWithIndex(_local_2) , IInventoryModel);
                _local_3.onCategorySwitch(k);
                _local_2++;
            }
            switch (k)
            {
                case InventorySubCategory.TRADING
                   | InventorySubCategory.WIRED_TRADING:
                    this._view.toggleCategoryView(InventoryCategory.FURNI, false);
                    return;
            }
        }

        public function _Str_24527()
        {
            this._view._Str_23647();
        }

        public function onInventoryClose()
        {
            var k = 0;
            var _local_2:IInventoryModel = null;
            if (this._inventories != null)
            {
                k = 0;
                while ((k : UInt) < this._inventories.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._inventories.getWithIndex(k) , IInventoryModel);
                    _local_2.onInventoryClose();
                    k++;
                }
            }
            events.dispatchEvent(new Event(HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_CLOSED));
        }

        public function _Str_24810()
        {
            if (!this._isInitialized)
            {
                this.init();
            }
        }

        public function _Str_18877(k:String)
        {
            var _local_3:IInventoryModel = null;
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._inventories.length)
            {
                _local_3 = ASCompat.dynamicAs(this._inventories.getWithIndex(_local_2) , IInventoryModel);
                _local_3.initCategory(k);
                _local_2++;
            }
        }

        public function setupTrading(k:Int, _arg_2:String)
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            var _local_3= this._Str_3957;
            if (_local_3 == null)
            {
                return;
            }
            _local_3.requestOpenTrading(k);
        }

        public var tradingActive(get,never):Bool;
public function  get_tradingActive():Bool
        {
            return this.activeTradingModel != null;
        }

        public var activeTradingModel(get,never):ITradingModel;
public function  get_activeTradingModel():ITradingModel
        {
            if (this._Str_3957 != null && this._Str_3957.running)
            {
                return this._Str_3957;
            }
            if (this.wiredTradingModel != null
                && this.wiredTradingModel.running)
            {
                return this.wiredTradingModel;
            }
            return null;
        }

        public function onWiredTradeActiveChanged()
        {
            if (this.furniModel != null)
            {
                this.furniModel.updateView();
            }
        }

        public function _Str_20251(k:Bool)
        {
            if (this._Str_5568 != null)
            {
                if (k)
                {
                    this._Str_5568._Str_22646();
                }
                else
                {
                    this._Str_5568._Str_20195();
                }
            }
        }

        public function _Str_15313():Int
        {
            return (this._Str_5568 != null) ? this._Str_5568._Str_22697() : 0;
        }

        public function returnInventoryFurniFromRecycler(k:Int):Bool
        {
            return (this._Str_5568 != null) ? this._Str_5568._Str_23825(k) : false;
        }

        public function _Str_16742():Bool
        {
            if (this.wiredTradingModel != null
                && this.wiredTradingModel.running)
            {
                return true;
            }
            var k= this._Str_3957;
            return (k != null) ? k._Str_23201 : false;
        }

        public function _Str_5943(k:String, _arg_2:Bool=true)
        {
            var _local_3 = 0;
            if (_arg_2)
            {
                if (this._initedInventoryCategories.indexOf(k) == -1)
                {
                    this._initedInventoryCategories.push(k);
                }
            }
            else
            {
                _local_3 = this._initedInventoryCategories.indexOf(k);
                if (_local_3 >= 0)
                {
                    this._initedInventoryCategories.splice(_local_3, 1);
                }
                if (((!(this._view == null)) && this._view.isVisible))
                {
                    if (k != InventoryCategory.RENTABLES)
                    {
                        this._Str_22178(k);
                    }
                }
            }
        }

        public function _Str_18826(k:String):Bool
        {
            return this._initedInventoryCategories.indexOf(k) >= 0;
        }

        public function checkCategoryInitilization(k:String):Bool
        {
            if (this._Str_18826(k))
            {
                return true;
            }
            this._Str_22178(k);
            return false;
        }

        public function _Str_22178(k:String)
        {
            var _local_2= ASCompat.dynamicAs(this._inventories.getValue(k) , IInventoryModel);
            if (_local_2 != null)
            {
                _local_2.onInventoryOpen();
            }
        }

        public function _Str_7796()
        {
            events.dispatchEvent(new HabboInventoryEffectsEvent(HabboInventoryEffectsEvent.HIEE_EFFECTS_CHANGED));
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public function requestSelectedFurniToMover(k:IFurnitureItem):Bool
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
            if (k.category == FurniCategory.POSTER)
            {
                _local_3 = this._roomEngine.initializeRoomObjectInsert(RoomObjectPlacementSource.INVENTORY, k.id, _local_2, k.type, k.stuffData.getLegacyString());
            }
            else
            {
                _local_3 = this._roomEngine.initializeRoomObjectInsert(RoomObjectPlacementSource.INVENTORY, k.id, _local_2, k.type, Std.string(k.extra), k.stuffData);
            }
            return _local_3;
        }

        public function getFloorItemById(k:Int):IFurnitureItem
        {
            var _local_2:GroupItem = null;
            var _local_3:IFurnitureItem = null;
            final _iter_ = this.furniModel.furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.getItem(k);
                if (((!(_local_3 == null)) && (!_local_3.isWallItem)))
                {
                    return _local_3;
                }
            }
            return null;
        }

        public function getWallItemById(k:Int):IFurnitureItem
        {
            var _local_2:GroupItem = null;
            var _local_3:IFurnitureItem = null;
            final _iter_ = this.furniModel.furniData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = _local_2.getItem(k);
                if (((!(_local_3 == null)) && _local_3.isWallItem))
                {
                    return _local_3;
                }
            }
            return null;
        }

        public function getNonRentedInventoryIds(k:String, _arg_2:Int):Array<ASAny>
        {
            var _local_3:FurniModel = this._inventories.getValue(k);
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= this.furniModel._Str_24542(_arg_2);
            if (_local_4 == null)
            {
                return null;
            }
            return _local_4._Str_25304();
        }

        public function placePetToRoom(k:Int, _arg_2:Bool=false):Bool
        {
            return this._Str_4524.placePetToRoom(k, _arg_2);
        }

        public function _Str_6956()
        {
            var k = 0;
            k = this._unseenItemTracker._Str_5621(UnseenItemCategoryEnum.FURNI);
            this._view._Str_23205(k);
            k = this._unseenItemTracker._Str_5621(UnseenItemCategoryEnum.RENTABLE);
            this._view._Str_25138(k);
            var _local_2= this._unseenItemTracker._Str_5621(UnseenItemCategoryEnum.PET);
            this._view._Str_22445(_local_2);
            var _local_3= this._unseenItemTracker._Str_5621(UnseenItemCategoryEnum.BADGE);
            this._view._Str_24193(_local_3);
            var _local_4= this._unseenItemTracker._Str_5621(UnseenItemCategoryEnum.BOT);
            this._view._Str_24185(_local_4);
        }

        public function getItemWithStripId(k:Int):Bool
        {
            var _local_2= this.furniModel.getItemWithStripId(k);
            if (_local_2)
            {
                this._Str_6956();
            }
            return _local_2;
        }

        public function removeUnseenFurniCounter(k:Int):Bool
        {
            var _local_2= this._Str_4524._Str_7938(k);
            if (_local_2)
            {
                this._Str_6956();
            }
            return _local_2;
        }

        public var _Str_24829(get,never):Int;
public function  get__Str_24829():Int
        {
            return getInteger("inventory.bots.max", 150);
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public var _Str_9777(get,never):String;
public function  get__Str_9777():String
        {
            return this._currentCategoryId;
        }

        public function getFurnitureData(k:Int, _arg_2:String):IFurnitureData
        {
            var _local_3:IFurnitureData = null;
            if (this._sessionDataManager == null)
            {
                return null;
            }
            if (_arg_2 == ProductTypeEnum.FLOOR)
            {
                _local_3 = this._sessionDataManager.getFloorItemData(k);
            }
            if (_arg_2 == ProductTypeEnum.WALL)
            {
                _local_3 = this._sessionDataManager.getWallItemData(k);
            }
            return _local_3;
        }

        public function getFurnitureDataByName(k:String, _arg_2:String, _arg_3:Int=0):IFurnitureData
        {
            var _local_4:IFurnitureData = null;
            if (this._sessionDataManager == null)
            {
                return null;
            }
            if (_arg_2 == ProductTypeEnum.FLOOR)
            {
                _local_4 = this._sessionDataManager.getFloorItemDataByName(k);
            }
            if (_arg_2 == ProductTypeEnum.WALL)
            {
                _local_4 = this._sessionDataManager.getWallItemDataByName(k);
            }
            return _local_4;
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "inventory/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "open":
                    if (_local_2.length == 2)
                    {
                        this.toggleInventoryPage(InventoryCategory.FURNI);
                    }
                    else
                    {
                        if (_local_2.length == 3)
                        {
                            this.toggleInventoryPage(_local_2[2]);
                        }
                        else
                        {
                            if (_local_2.length == 4)
                            {
                                this.toggleInventoryPage(_local_2[2], _local_2[3]);
                            }
                        }
                    }
                    return;
                default:
                    Logger.log([("Inventory unknown link-type received: " + _local_2[1])]);
            }
        }

        public function getAllMyBadgeIds(k:Array<ASAny>):Array<ASAny>
        {
            var _local_4:Badge = null;
            var _local_2:BadgesModel = this._inventories.getValue(InventoryCategory.BADGES);
            var _local_3:Array<ASAny> = [];
            if (((_local_2._Str_5453().length == 0) && (!this._externalBadgesInitializationRequested)))
            {
            this.badgesModel.onInventoryOpen();
                this._externalBadgesInitializationRequested = true;
            }
            final _iter_ = _local_2._Str_5453(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                if (((k == null) || (k.indexOf(_local_4.badgeId) == -1)))
                {
                    _local_3.push(_local_4.badgeId);
                }
            }
            return _local_3;
        }

        public function hasFigureSetIdInInventory(k:Int):Bool
        {
            return this._figureSetIds.indexOf(k) > -1;
        }

        public function hasBoundFigureSetFurniture(k:String):Bool
        {
            return this._boundFurnitureNames.indexOf(k) > -1;
        }

        public function _Str_22773(k:Vector<Int>, _arg_2:Vector<String>)
        {
            this._figureSetIds = k;
            this._boundFurnitureNames = _arg_2;
        }

        public function getLastActivatedEffect():Int
        {
            return this._Str_3994._Str_24332;
        }
    }

