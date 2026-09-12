package com.sulake.habbo.catalog.habbicons
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseErrorMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseNotAllowedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseOKMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.HabbiconInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.HabbiconShopDataMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.HabbiconStatusChangedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.OwnedHabbiconsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.RoomUserHabbiconMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.BuyHabbiconCollectionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.BuyHabbiconMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.ClaimHabbiconRewardMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.FavouriteHabbiconMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.RequestHabbiconInfoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.RequestHabbiconShopDataMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.SendHabbiconInstantMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.UnfavouriteHabbiconMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.habbicons.UseHabbiconInRoomMessageComposer;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboInventory;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDRoomEngine;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.EventDispatcher;

     class HabbiconController extends Component implements IHabbiconController implements  ILinkEventTracker
    {
        static inline final RECENT_HABBICON_LIMIT= 10;
        static inline final UNSEEN_CATEGORY_HABBICONS= 8;

        public static var instance:HabbiconController;

        var _communication:IHabboCommunicationManager;
        var _windowManager:IHabboWindowManager;
        var _localization:IHabboLocalizationManager;
        var _inventory:IHabboInventory;
        var _roomEngine:IRoomEngine;
        var _roomSessionManager:IRoomSessionManager;
        var _messageEvents:Vector<IMessageEvent>;
        var _events__com_sulake_habbo_catalog_habbicons_HabbiconController/*redefined private*/:EventDispatcher;
        var _owned:ASDictionary<ASAny,ASAny>;
        var _recent:Array<ASAny>;
        var _collectionsById:ASDictionary<ASAny,ASAny>;
        var _shopItems:ASDictionary<ASAny,ASAny>;
        var _shopCollections:Vector<HabbiconCollectionData>;
        var _view:HabbiconView;
        var _hasLoadedOwned:Bool = false;
        var _hasLoadedShop:Bool = false;
        var _shopRequestPending:Bool = false;
        var _pendingPurchaseRefresh:Bool = false;
        var _assetsStarted:Bool = false;

        public function new(context:IContext, flags:UInt = 0, assets:IAssetLibrary = null)
        {
            super(context, flags, assets);
            instance = this;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([
                new ComponentDependency(new IIDHabboCommunicationManager(), function(manager:IHabboCommunicationManager)
                {
                    _communication = manager;
                }, true),
                new ComponentDependency(new IIDHabboWindowManager(), function(manager:IHabboWindowManager)
                {
                    _windowManager = manager;
                }, true),
                new ComponentDependency(new IIDHabboLocalizationManager(), function(manager:IHabboLocalizationManager)
                {
                    _localization = manager;
                }, false),
                new ComponentDependency(new IIDHabboInventory(), function(inventory:IHabboInventory)
                {
                    _inventory = inventory;
                }, false),
                new ComponentDependency(new IIDRoomEngine(), function(engine:IRoomEngine)
                {
                    _roomEngine = engine;
                }, false),
                new ComponentDependency(new IIDHabboRoomSessionManager(), function(manager:IRoomSessionManager)
                {
                    _roomSessionManager = manager;
                }, false)
            ]));
        }

        override function initComponent()
        {
            this._messageEvents = new Vector<IMessageEvent>(0);
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController = new EventDispatcher();
            this._owned = new ASDictionary<ASAny,ASAny>();
            this._recent = [];
            this._collectionsById = new ASDictionary<ASAny,ASAny>();
            this._shopItems = new ASDictionary<ASAny,ASAny>();
            this._shopCollections = new Vector<HabbiconCollectionData>(0);
            context.addLinkEventTracker(this);
            this.addMessageEvent(new OwnedHabbiconsMessageEvent(this.onOwnedHabbicons));
            this.addMessageEvent(new HabbiconStatusChangedMessageEvent(this.onHabbiconStatusChanged));
            this.addMessageEvent(new HabbiconShopDataMessageEvent(this.onHabbiconShopData));
            this.addMessageEvent(new HabbiconInfoMessageEvent(this.onHabbiconInfo));
            this.addMessageEvent(new RoomUserHabbiconMessageEvent(this.onRoomUserHabbicon));
            this.addMessageEvent(new PurchaseOKMessageEvent(this.onPurchaseOk));
            this.addMessageEvent(new PurchaseErrorMessageEvent(this.onPurchaseFailed));
            this.addMessageEvent(new PurchaseNotAllowedMessageEvent(this.onPurchaseFailed));
            this.ensureAssetManagerStarted();
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "habbicons/";
        }

        public function linkReceived(link:String)
        {
            var parts:Array<ASAny> = null;
            if (!this.habbiconsEnabled())
            {
                return;
            }
            parts = (cast link.split("/"));
            if (parts.length >= 2 && parts[1] == "open")
            {
                this.openHabbiconHub();
            }
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public var hasLoadedShopData(get,never):Bool;
public function  get_hasLoadedShopData():Bool
        {
            return this._hasLoadedShop;
        }

        public var ownedHabbicons(get,never):Array<ASAny>;
public function  get_ownedHabbicons():Array<ASAny>
        {
var item:HabbiconOwnedItem  = null;            var result:Array<ASAny> = [];
            final _iter_ = this._owned; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item = _tmp_;
                result.push(item);
            }
            return result;
        }

        public var recentHabbiconIds(get,never):Array<ASAny>;
public function  get_recentHabbiconIds():Array<ASAny>
        {
            return this._recent.copy();
        }

        public var shopCollections(get,never):Vector<HabbiconCollectionData>;
public function  get_shopCollections():Vector<HabbiconCollectionData>
        {
            return this._shopCollections.concat();
        }

        public var unseenHabbiconCount(get,never):Int;
public function  get_unseenHabbiconCount():Int
        {
            if (this._inventory == null || this._inventory.unseenItemTracker == null)
            {
                return 0;
            }
            return this._inventory.unseenItemTracker._Str_5621(UNSEEN_CATEGORY_HABBICONS);
        }

        public function addEventListener(type:String, listener:ASFunction)
        {
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.addEventListener(type, (listener : ASAny));
        }

        public function removeEventListener(type:String, listener:ASFunction)
        {
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.removeEventListener(type, (listener : ASAny));
        }

        public function openHabbiconHub()
        {
            if (!this.habbiconsEnabled() || this._windowManager == null)
            {
                return;
            }
            this.ensureAssetManagerStarted();
            this.resetUnseenHabbicons();
            if (this._view == null || this._view.disposed)
            {
                this._view = new HabbiconView(this);
            }
            this._view.show();
            this.getShopData(false);
        }

        public function getShopData(force:Bool = false)
        {
            if (!this.habbiconsEnabled())
            {
                return;
            }
            this.ensureAssetManagerStarted();
            if (this._hasLoadedShop && !force)
            {
                this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED));
                return;
            }
            if (this._shopRequestPending)
            {
                return;
            }
            this._shopRequestPending = this.send(new RequestHabbiconShopDataMessageComposer());
        }

        public function getHabbiconInfo(habbiconId:Int)
        {
            if (habbiconId > 0)
            {
                this.send(new RequestHabbiconInfoMessageComposer(habbiconId));
            }
        }

        public function noteHabbiconUsed(habbiconId:Int)
        {
            if (!this.habbiconsEnabled() || habbiconId <= 0)
            {
                return;
            }
            this.addRecentHabbiconId(habbiconId);
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.RECENT_HABBICONS_UPDATED, habbiconId));
        }

        public function isUnseenHabbicon(habbiconId:Int):Bool
        {
            return this._inventory != null && this._inventory.unseenItemTracker != null && this._inventory.unseenItemTracker.isUnseen(UNSEEN_CATEGORY_HABBICONS, habbiconId);
        }

        public function removeUnseenHabbicon(habbiconId:Int)
        {
            if (this._inventory == null || this._inventory.unseenItemTracker == null)
            {
                return;
            }
            this._inventory.unseenItemTracker._Str_16745(UNSEEN_CATEGORY_HABBICONS, habbiconId);
            this._inventory.unseenItemTracker._Str_17159(UNSEEN_CATEGORY_HABBICONS);
        }

        public function resetUnseenHabbicons()
        {
            if (this._inventory != null && this._inventory.unseenItemTracker != null)
            {
                this._inventory.unseenItemTracker._Str_8813(UNSEEN_CATEGORY_HABBICONS);
            }
        }

        public function buyHabbicon(habbiconId:Int)
        {
            this._pendingPurchaseRefresh = true;
            this.send(new BuyHabbiconMessageComposer(habbiconId));
        }

        public function buyHabbiconCollection(collectionId:Int)
        {
            this._pendingPurchaseRefresh = true;
            this.send(new BuyHabbiconCollectionMessageComposer(collectionId));
        }

        public function claimHabbicon(habbiconId:Int)
        {
            this._pendingPurchaseRefresh = true;
            this.send(new ClaimHabbiconRewardMessageComposer(habbiconId));
        }

        public function favoriteHabbicon(habbiconId:Int)
        {
            this.send(new FavouriteHabbiconMessageComposer(habbiconId));
        }

        public function unfavoriteHabbicon(habbiconId:Int)
        {
            this.send(new UnfavouriteHabbiconMessageComposer(habbiconId));
        }

        public function useHabbiconInRoom(habbiconId:Int)
        {
            if (habbiconId <= 0)
            {
                return;
            }
            this.removeUnseenHabbicon(habbiconId);
            this.noteHabbiconUsed(habbiconId);
            this.send(new UseHabbiconInRoomMessageComposer(habbiconId));
        }

        public function sendHabbiconInstantMessage(chatId:Int, habbiconId:Int, confirmationId:Int)
        {
            if (chatId == 0 || habbiconId <= 0)
            {
                return;
            }
            this.removeUnseenHabbicon(habbiconId);
            this.noteHabbiconUsed(habbiconId);
            this.send(new SendHabbiconInstantMessageComposer(chatId, habbiconId, confirmationId));
        }

        public function tryGetOwnedHabbicon(habbiconId:Int):HabbiconOwnedItem
        {
            return ASCompat.dynamicAs(this._owned[habbiconId] , HabbiconOwnedItem);
        }

        public function tryGetShopItem(habbiconId:Int):HabbiconShopItem
        {
            return ASCompat.dynamicAs(this._shopItems[habbiconId] , HabbiconShopItem);
        }

        public function localize(key:String, fallback:String = ""):String
        {
            if (this._localization == null)
            {
                return fallback;
            }
            return this._localization.getLocalization(key, fallback);
        }

        public function resolveHabbiconDisplayName(habbiconId:Int, fallback:String = null):String
        {
            var nameKey= HabbiconAssetManager.getHabbiconNameKey(habbiconId);
            if (nameKey != null && nameKey.length > 0)
            {
                return this.localize("habbicon_" + nameKey.toLowerCase() + "_name", fallback != null ? fallback : nameKey);
            }
            return fallback != null && fallback.length > 0 ? fallback : this.localize("habbicon.generic.name", "Habbicon");
        }

        public function createHabbiconBitmap(habbiconId:Int, small:Bool = false):BitmapData
        {
            var bitmap= HabbiconAssetManager.getPreviewBitmap(habbiconId, small);
            return bitmap != null ? bitmap.clone() : null;
        }

        function addMessageEvent(event:IMessageEvent)
        {
            if (this._communication == null)
            {
                return;
            }
            this._messageEvents.push(this._communication.addHabboConnectionMessageEvent(event));
        }

        function send(composer:IMessageComposer):Bool
        {
            var connection:IConnection = this._communication != null ? this._communication.connection : null;
            if (connection == null)
            {
                return false;
            }
            connection.send(composer);
            return true;
        }

        function ensureAssetManagerStarted()
        {
            if (this._assetsStarted || !this.habbiconsEnabled())
            {
                return;
            }
            HabbiconAssetManager.configure(this);
            HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            HabbiconAssetManager.preload();
            this._assetsStarted = true;
        }

        function onOwnedHabbicons(event:OwnedHabbiconsMessageEvent)
        {
            var parser= event.getParser();
            var oldOwned= this._owned;
            var wasLoaded= this._hasLoadedOwned;
            var owned:HabbiconOwnedItem = null;
            this._owned = new ASDictionary<ASAny,ASAny>();
            final _iter_ = parser.habbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
owned  = _tmp_;
                this._owned[owned.habbiconId] = owned;
                if (wasLoaded && HabbiconState.isOwnedState(owned.habbiconState) && oldOwned[owned.habbiconId] == null)
                {
                    this.handleNewOwnedHabbicon(owned.habbiconId);
                }
            }
            this.setRecentHabbiconIds(parser.recentHabbiconIds);
            this._hasLoadedOwned = true;
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED));
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED));
        }

        function onHabbiconStatusChanged(event:HabbiconStatusChangedMessageEvent)
        {
            var parser= event.getParser();
            var item= ASCompat.dynamicAs(this._owned[parser.habbiconId] , HabbiconOwnedItem);
            var oldState= item != null ? item.habbiconState : 0;
            if (HabbiconState.isOwnedState(parser.habbiconState))
            {
                if (item == null)
                {
                    item = new HabbiconOwnedItem();
                    item.habbiconId = parser.habbiconId;
                    this._owned[parser.habbiconId] = item;
                    this.handleNewOwnedHabbicon(parser.habbiconId);
                }
                item.habbiconState = parser.habbiconState;
                if (oldState == HabbiconState.CLAIMABLE && (parser.habbiconState == HabbiconState.OWNED || parser.habbiconState == HabbiconState.FAVOURITE))
                {
                    this.handleNewOwnedHabbicon(parser.habbiconId);
                }
            }
            else
            {
                this._owned.remove(parser.habbiconId);
            }
            this.updateCachedShopItemState(parser.habbiconId, parser.habbiconState, null);
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.STATUS_CHANGED, parser.habbiconId));
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, parser.habbiconId));
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED, parser.habbiconId));
        }

        function onHabbiconShopData(event:HabbiconShopDataMessageEvent)
        {
            var parser= event.getParser();
            var collection:HabbiconCollectionData = null;
            var shopItem:HabbiconShopItem = null;
            this._collectionsById = new ASDictionary<ASAny,ASAny>();
            this._shopItems = new ASDictionary<ASAny,ASAny>();
            this._shopCollections = new Vector<HabbiconCollectionData>(0);
            final _iter_ = parser.collections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                if (collection != null)
                {
                    this._collectionsById[collection.collectionId] = collection;
                    this._shopCollections.push(collection);
                    final _iter_ = collection.habbicons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
shopItem  = _tmp_;
                        this._shopItems[shopItem.habbiconId] = shopItem;
                    }
                }
            }
            this._hasLoadedShop = true;
            this._shopRequestPending = false;
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED));
        }

        function onHabbiconInfo(event:HabbiconInfoMessageEvent)
        {
            var parser= event.getParser();
            var item= parser.habbicon;
            if (item == null)
            {
                return;
            }
            this._shopItems[item.habbiconId] = item;
            this.updateCachedShopItemState(item.habbiconId, item.state, item);
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED, item.habbiconId, item.collectionId));
        }

        function onRoomUserHabbicon(event:RoomUserHabbiconMessageEvent)
        {
            var parser= event.getParser();
            var roomId= this._roomEngine != null ? this._roomEngine.activeRoomId : 0;
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.ROOM_USE_HABBICON, parser.habbiconId, 0, parser.roomIndex));
            if (this._roomEngine != null && roomId != 0)
            {
                this._roomEngine.updateObjectUserAction(roomId, parser.roomIndex, RoomObjectVariableEnum.FIGURE_HABBICON, parser.habbiconId);
            }
        }

        function onPurchaseOk(event:PurchaseOKMessageEvent)
        {
            if (this._pendingPurchaseRefresh)
            {
                this._pendingPurchaseRefresh = false;
                this.getShopData(true);
            }
        }

        function onPurchaseFailed(event:IMessageEvent)
        {
            this._pendingPurchaseRefresh = false;
        }

        function onHabbiconAssetsLoaded(event:Event)
        {
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED));
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController.dispatchEvent(new HabbiconControllerEvent(HabbiconControllerEvent.SHOP_DATA_UPDATED));
        }

        function updateCachedShopItemState(habbiconId:Int, state:Int, replacement:HabbiconShopItem = null)
        {
var             index = 0;            var collection:HabbiconCollectionData = null;
            var index = 0;
            var item= replacement != null ? replacement : ASCompat.dynamicAs(this._shopItems[habbiconId] , HabbiconShopItem);
            final _iter_ = this._shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                if (collection != null && collection.rewardHabbiconId == habbiconId)
                {
                    collection.rewardState = state;
                    return;
                }
            }
            if (item == null)
            {
                return;
            }
            item.state = state;
            this._shopItems[habbiconId] = item;
            collection = ASCompat.dynamicAs(this._collectionsById[item.collectionId] , HabbiconCollectionData);
            if (collection == null || collection.habbicons == null)
            {
                return;
            }
            index= 0;while (index < collection.habbicons.length)
            {
                if (cast(collection.habbicons[index], HabbiconShopItem).habbiconId == habbiconId)
                {
                    collection.habbicons[index] = item;
                    break;
                }
index++;
            }
        }

        function handleNewOwnedHabbicon(habbiconId:Int)
        {
            if (this._inventory != null && this._inventory.unseenItemTracker != null)
            {
                // The 2016 unseen tracker only exposes server-driven add/update APIs.
                // Habbicon ownership still refreshes locally via the status/owned packets.
            }
        }

        function setRecentHabbiconIds(ids:Array<ASAny>)
        {
var id = 0;            this._recent = [];
            if (ids == null)
            {
                return;
            }
            if (checkNullIteratee(ids)) for (_tmp_ in ids)
            {
id = ASCompat.toInt(_tmp_);
                this._recent.push(id);
            }
        }

        function addRecentHabbiconId(habbiconId:Int)
        {
            var index= this._recent.indexOf(habbiconId);
            if (index >= 0)
            {
                this._recent.splice(index, 1);
            }
            this._recent.unshift(habbiconId);
            if (this._recent.length > RECENT_HABBICON_LIMIT)
            {
                this._recent.resize(RECENT_HABBICON_LIMIT);
            }
        }

        function habbiconsEnabled():Bool
        {
            return this.getBoolean("habbicons.enabled");
        }

        override public function dispose()
        {
            var messageEvent:IMessageEvent = null;
            if (disposed)
            {
                return;
            }
            if (instance == this)
            {
                instance = null;
            }
            if (this._communication != null && this._messageEvents != null)
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
messageEvent  = _tmp_;
                    this._communication.removeHabboConnectionMessageEvent(messageEvent);
                }
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            if (context != null)
            {
                context.removeLinkEventTracker(this);
            }
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            this._messageEvents = null;
            this._events__com_sulake_habbo_catalog_habbicons_HabbiconController = null;
            this._owned = null;
            this._recent = null;
            this._collectionsById = null;
            this._shopItems = null;
            this._shopCollections = null;
            this._communication = null;
            this._windowManager = null;
            this._localization = null;
            this._inventory = null;
            this._roomEngine = null;
            this._roomSessionManager = null;
            super.dispose();
        }
    }

