package com.sulake.habbo.inventory.wired_trading
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade.WiredTradeAcceptMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade.WiredTradeCancelMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.trade.WiredTradeItemsMessageComposer;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.habbo.inventory.IInventoryModel;
    import com.sulake.habbo.inventory._enum.InventorySubCategory;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.habbo.inventory.trading.ITradingModel;
    import com.sulake.habbo.inventory.wired_trading.requirements.WiredTradeRequirementsModel;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.window.IHabboWindowManager;

    /**
     * July AIR single-user Wired Trading state machine.
     */
     class WiredTradingModel implements IInventoryModel implements  ITradingModel
    {
        public static inline final FAILURE_NONE= 0;
        public static inline final STATE_READY:UInt = 0;
        public static inline final STATE_ADDING_ITEMS:UInt = 1;
        public static inline final STATE_COUNTDOWN:UInt = 2;
        public static inline final STATE_CONFIRMING:UInt = 3;
        public static inline final STATE_CONFIRMED:UInt = 4;

        var _inventory:HabboInventory;
        var _communication:IHabboCommunicationManager;
        var _localization:IHabboLocalizationManager;
        var _view:WiredTradingView;
        var _requirements:WiredTradeRequirementsModel;
        var _running:Bool = false;
        var _disposed:Bool = false;
        var _state:UInt = 0;
        var _ownItems:Map;
        var _ownNumItems:Int = 0;
        var _ownNumCredits:Int = 0;
        var _wiredItems:Map;
        var _wiredNumItems:Int = 0;
        var _wiredNumCredits:Int = 0;
        var _canAccept:Bool = false;
        var _extra:Int = 0;
        var _timeoutSeconds:Int = 0;
        var _tradeStartTime:Int = 0;

        public function new(
            inventory:HabboInventory,
            windowManager:IHabboWindowManager,
            communication:IHabboCommunicationManager,
            assets:IAssetLibrary,
            roomEngine:IRoomEngine,
            localization:IHabboLocalizationManager,
            soundManager:IHabboSoundManager)
        {
            this._inventory = inventory;
            this._communication = communication;
            this._localization = localization;
            this._view = new WiredTradingView(
                this, windowManager, assets, roomEngine, localization, soundManager);
            this._requirements = new WiredTradeRequirementsModel(this);
            this.clear();
        }

        public function onWiredTradeInitiate(
            requirement:TradeRequirement,
            showRequirementsImmediate:Bool,
            overridePreviousTrade:Bool,
            timeoutSeconds:Int)
        {
            if (overridePreviousTrade)
            {
                this.close(false, false, false);
            }
            if (this._running)
            {
                this.close(false, false, false);
            }
            this._timeoutSeconds = timeoutSeconds;
            this._tradeStartTime = flash.Lib.getTimer();
            this._requirements.setRequirements(requirement, showRequirementsImmediate);
            this.initializeNewTrade();
            this._view.startSecondsLeftTimer();
            this._inventory.toggleInventorySubPage(InventorySubCategory.WIRED_TRADING);
            this._inventory.furniModel.updateView();
            if (overridePreviousTrade)
            {
                this._requirements.highlightRefresh();
            }
        }

        function initializeNewTrade()
        {
            this._running = true;
            this.clear();
            this.state = STATE_ADDING_ITEMS;
            this._inventory.onWiredTradeActiveChanged();
            this._inventory.furniModel.updateView();
        }

        function clear()
        {
            this._ownItems = new Map();
            this._ownNumItems = 0;
            this._ownNumCredits = 0;
            this._wiredItems = new Map();
            this._wiredNumItems = 0;
            this._wiredNumCredits = 0;
            this._canAccept = false;
            this._extra = 0;
            if (this._view != null)
            {
                this._view.updateAllUI();
            }
        }

        public function requestAddItemsToTrading(
            itemIds:Vector<Int>,
            isWallItem:Bool,
            type:Int,
            category:Int,
            groupable:Bool,
            stuffData:IStuffData)
        {
            if (this._state == STATE_ADDING_ITEMS && itemIds.length > 0)
            {
                this.send(new WiredTradeItemsMessageComposer(false, itemIds));
            }
        }

        public function requestRemoveItemFromTrading(index:Int)
        {
            if (this._state != STATE_ADDING_ITEMS || index < 0
                || (index : UInt) >= this._ownItems.length)
            {
                return;
            }
            var group= ASCompat.dynamicAs(this._ownItems.getWithIndex(index) , GroupItem);
            var item:FurnitureItem = group == null ? null : group._Str_3205();
            if (item != null)
            {
                this.send(new WiredTradeItemsMessageComposer(
                    true, Vector.ofArray([item.id])));
            }
        }

        public function requestAccept():Bool
        {
            if (this._state != STATE_ADDING_ITEMS || !this._canAccept)
            {
                return false;
            }
            this.send(new WiredTradeAcceptMessageComposer(false));
            this.state = STATE_COUNTDOWN;
            return true;
        }

        public function confirmCountdownReady()
        {
            if (this._state == STATE_COUNTDOWN)
            {
                this.state = STATE_CONFIRMING;
            }
        }

        public function requestConfirm():Bool
        {
            if (this._state != STATE_CONFIRMING)
            {
                return false;
            }
            this.send(new WiredTradeAcceptMessageComposer(true));
            this.state = STATE_CONFIRMED;
            return true;
        }

        public function requestCancelTrading()
        {
            this.send(new WiredTradeCancelMessageComposer());
        }

        public function updateItemGroupMaps(
            ownItems:Map,
            ownNumItems:Int,
            ownNumCredits:Int,
            wiredItems:Map,
            wiredNumItems:Int,
            wiredNumCredits:Int,
            canAccept:Bool,
            extra:Int)
        {
            if (!this._running)
            {
                return;
            }
            this._ownItems = ownItems;
            this._ownNumItems = ownNumItems;
            this._ownNumCredits = ownNumCredits;
            this._wiredItems = wiredItems;
            this._wiredNumItems = wiredNumItems;
            this._wiredNumCredits = wiredNumCredits;
            this._canAccept = canAccept;
            this._extra = extra;
            this._view.updateAllUI();
            this._requirements.requirementsStateUpdated();
            this._inventory.furniModel._Str_17963();
        }

        public function tradeIsCancelled(reason:Int)
        {
            this.close(true, false);
            this._view.alertTradeCancelled(reason);
        }

        public function tradeIsCompleted()
        {
            this.close(true, false);
        }

        public function close(
            hideView:Bool,
            notifyServer:Bool,
            refreshFurni:Bool=true)
        {
            if (!this._running)
            {
                return;
            }
            this._view.stopSecondsLeftTimer();
            this._view.stopConfirmCountdown();
            if (this._state != STATE_READY && notifyServer)
            {
                this.requestCancelTrading();
            }
            this._running = false;
            this.clear();
            this.state = STATE_READY;
            this._inventory.onWiredTradeActiveChanged();
            if (hideView)
            {
                this._inventory.toggleInventorySubPage(InventorySubCategory.EMPTY);
            }
            if (refreshFurni)
            {
                this._inventory.furniModel.updateView();
                this._inventory.furniModel._Str_17963();
            }
        }

        function send(composer:IMessageComposer)
        {
            if (this._communication != null && this._communication.connection != null)
            {
                this._communication.connection.send(composer);
            }
        }

        public function getOwnItemIdsInTrade():Array<ASAny>
        {
var             i = 0, group:GroupItem  = null,                 j = 0, item:FurnitureItem  = null;            var ids:Array<ASAny> = [];
            if (this._ownItems == null || this._ownItems.disposed)
            {
                return ids;
            }
            i= 0;while ((i : UInt) < this._ownItems.length)
            {
group= ASCompat.dynamicAs(this._ownItems.getWithIndex(i) , GroupItem);
                if (group == null)
                {
                    i++;continue;
                }
                j= 0;while (j < group.getTotalCount())
                {
item= group._Str_5087(j);
                    if (item != null)
                    {
                        ids.push(item.ref);
                    }
j++;
                }
i++;
            }
            return ids;
        }

        public function getWindowContainer():IWindowContainer
        {
            return this._view.getWindowContainer();
        }

        public function onInventoryOpen()
        {
        }

        public function initCategory(category:String)
        {
        }

        public function onCategorySwitch(category:String)
        {
            if (this._running && category != InventorySubCategory.WIRED_TRADING
                && this._state != STATE_READY)
            {
                this.close(false, true);
            }
        }

        public function onInventoryClose()
        {
            if (this._running)
            {
                this.close(false, true);
            }
        }

        public function updateView()
        {
        }

        public function onSubcategorySwitch(category:String)
        {
            this.onCategorySwitch(category);
        }

        public function getInventory():HabboInventory
        {
            return this._inventory;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._running)
            {
                this.close(false, false, false);
            }
            this._requirements.dispose();
            this._requirements = null;
            this._view.dispose();
            this._view = null;
            this._inventory = null;
            this._communication = null;
            this._localization = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        public var inventory(get,never):HabboInventory;
public function  get_inventory():HabboInventory { return this._inventory; }
        public var running(get,never):Bool;
public function  get_running():Bool { return this._running; }
                public var state(get,set):UInt;
public function  get_state():UInt { return this._state; }
public function  set_state(value:UInt):UInt        {
            this._state = value;
            if (this._view != null)
            {
                this._view.tradeStateUpdated();
            }
return value;
        }
        public var ownItems(get,never):Map;
public function  get_ownItems():Map { return this._ownItems; }
        public var ownNumItems(get,never):Int;
public function  get_ownNumItems():Int { return this._ownNumItems; }
        public var ownNumCredits(get,never):Int;
public function  get_ownNumCredits():Int { return this._ownNumCredits; }
        public var wiredItems(get,never):Map;
public function  get_wiredItems():Map { return this._wiredItems; }
        public var wiredNumItems(get,never):Int;
public function  get_wiredNumItems():Int { return this._wiredNumItems; }
        public var wiredNumCredits(get,never):Int;
public function  get_wiredNumCredits():Int { return this._wiredNumCredits; }
        public var canAccept(get,never):Bool;
public function  get_canAccept():Bool { return this._canAccept; }
        public var extra(get,never):Int;
public function  get_extra():Int { return this._extra; }
        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }
        public var requirementsModel(get,never):WiredTradeRequirementsModel;
public function  get_requirementsModel():WiredTradeRequirementsModel
        {
            return this._requirements;
        }
        public var tradingView(get,never):WiredTradingView;
public function  get_tradingView():WiredTradingView
        {
            return this._view;
        }
        public function isPayment():Bool
        {
            return this._requirements.requirement == null
                || this._requirements.requirement.isPaymentOnly();
        }
        public var paymentLayoutType(get,never):String;
public function  get_paymentLayoutType():String
        {
            return this._requirements.requirement == null
                ? null : this._requirements.requirement.layoutType;
        }
        public var tradeTypeLocalization(get,never):String;
public function  get_tradeTypeLocalization():String
        {
            return this._localization.getLocalization(
                this.isPayment()
                    ? "inventory.wired_trading.payment"
                    : "inventory.wired_trading.trade");
        }
        public var secondsLeft(get,never):Int;
public function  get_secondsLeft():Int
        {
            if (this._timeoutSeconds <= 0 || this._tradeStartTime <= 0)
            {
                return -1;
            }
            var elapsed= Std.int((flash.Lib.getTimer() - this._tradeStartTime) / 1000);
            return Std.int(Math.max(0, this._timeoutSeconds - elapsed));
        }
    }

