package com.sulake.habbo.inventory.marketplace
;
    import com.sulake.habbo.inventory.IInventoryModel;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.GetMarketplaceCanMakeOfferComposer;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.BuyMarketplaceTokensMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.MakeOfferMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.GetMarketplaceItemStatsComposer;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.GetMarketplaceConfigurationMessageComposer;
    import com.sulake.habbo.inventory.items.IFurnitureItem;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.communication.messages.IMessageComposer;

     class MarketplaceModel implements IInventoryModel 
    {
        var _controller:HabboInventory;
        var _assets:IAssetLibrary;
        var _windowManager:IHabboWindowManager;
        var _roomEngine:IRoomEngine;
        var _communication:IHabboCommunicationManager;
        var _disposed:Bool = false;
        var _item:FurnitureItem;
        var _isEnabled:Bool = false;
        var _commission:Int = 0;
        var _tokenBatchPrice:Int = 0;
        var _tokensBatchSize:Int = 0;
        var _offerMinPrice:Int = 0;
        var _offerMaxPrice:Int = 0;
        var _expirationHours:Int = 0;
        var _averagePricePeriod:Int = 0;
        var _statsRequestCategoryId:Int = 0;
        var _statsRequestTypeId:Int = 0;
        var _view:MarketplaceView;
        var _isBuyingTokens:Bool = false;

        public function new(k:HabboInventory, _arg_2:IHabboWindowManager, _arg_3:IHabboCommunicationManager, _arg_4:IAssetLibrary, _arg_5:IRoomEngine, _arg_6:IHabboLocalizationManager)
        {
            this._controller = k;
            this._communication = _arg_3;
            this._windowManager = _arg_2;
            this._assets = _arg_4;
            this._roomEngine = _arg_5;
            this._view = new MarketplaceView(this, this._windowManager, this._assets, _arg_5, _arg_6, k);
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return InventoryCategory.MARKETPLACE;
        }

        
        public var isEnabled(get,set):Bool;
public function  set_isEnabled(k:Bool):Bool        {
            return this._isEnabled = k;
        }

        
        public var commission(get,set):Int;
public function  set_commission(k:Int):Int        {
            return this._commission = k;
        }

        
        public var tokenBatchPrice(get,set):Int;
public function  set_tokenBatchPrice(k:Int):Int        {
            return this._tokenBatchPrice = k;
        }

        
        public var tokenBatchSize(get,set):Int;
public function  set_tokenBatchSize(k:Int):Int        {
            return this._tokensBatchSize = k;
        }

        
        public var offerMinPrice(get,set):Int;
public function  set_offerMinPrice(k:Int):Int        {
            return this._offerMinPrice = k;
        }

        
        public var offerMaxPrice(get,set):Int;
public function  set_offerMaxPrice(k:Int):Int        {
            return this._offerMaxPrice = k;
        }

        
        public var expirationHours(get,set):Int;
public function  set_expirationHours(k:Int):Int        {
            return this._expirationHours = k;
        }

        public var averagePricePeriod(never,set):Int;
public function  set_averagePricePeriod(k:Int):Int        {
            return this._averagePricePeriod = k;
        }
public function  get_isEnabled():Bool
        {
            return this._isEnabled;
        }
public function  get_commission():Int
        {
            return this._commission;
        }
public function  get_tokenBatchPrice():Int
        {
            return this._tokenBatchPrice;
        }
public function  get_tokenBatchSize():Int
        {
            return this._tokensBatchSize;
        }
public function  get_offerMinPrice():Int
        {
            return this._offerMinPrice;
        }
public function  get_offerMaxPrice():Int
        {
            return this._offerMaxPrice;
        }
public function  get_expirationHours():Int
        {
            return this._expirationHours;
        }

        public var controller(get,never):HabboInventory;
public function  get_controller():HabboInventory
        {
            return this._controller;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            this._controller = null;
            this._communication = null;
            this._windowManager = null;
            this._assets = null;
            this._roomEngine = null;
        }

        public function releaseItem()
        {
            if ((((!(this._controller == null)) && (!(this._controller.furniModel == null))) && (!(this._item == null))))
            {
                this._controller.furniModel._Str_10184(this._item.id);
                this._item = null;
            }
        }

        public function startOfferMaking(k:FurnitureItem)
        {
            if (((!(this._item == null)) || (k == null)))
            {
                return;
            }
            if (this._controller == null)
            {
                return;
            }
            var _local_2= this._controller.furniModel;
            if (_local_2 == null)
            {
                return;
            }
            this._item = k;
            _local_2._Str_15750(k.id);
            this.send(new GetMarketplaceCanMakeOfferComposer());
        }

        public function buyMarketplaceTokens()
        {
            this.send(new BuyMarketplaceTokensMessageComposer());
            this._isBuyingTokens = true;
        }

        public function makeOffer(k:Int)
        {
            if (this._item == null)
            {
                return;
            }
            var _local_2= (this._item.isWallItem ? MakeOfferMessageComposer.ITEMTYPE_WALLITEM : MakeOfferMessageComposer.ITEMTYPE_STUFF);
            this.send(new MakeOfferMessageComposer(k, _local_2, this._item.ref));
            this.releaseItem();
        }

        public function getItemStats()
        {
            if (this._item == null)
            {
                return;
            }
            var k= (this._item.isWallItem ? 2 : 1);
            this._statsRequestCategoryId = k;
            this._statsRequestTypeId = this._item.type;
            this.send(new GetMarketplaceItemStatsComposer(k, this._item.type));
        }

        public function proceedOfferMaking(k:Int, _arg_2:Int)
        {
            this._isBuyingTokens = false;
            switch (k)
            {
                case 1:
                    this._view.showMakeOffer(this._item);
                    return;
                case 2:
                    this._view.showAlert(("$" + "{inventory.marketplace.no_trading_privilege.title}"), ("$" + "{inventory.marketplace.no_trading_privilege.info}"));
                    return;
                case 3:
                    this._view.showAlert(("$" + "{inventory.marketplace.no_trading_pass.title}"), ("$" + "{inventory.marketplace.no_trading_pass.info}"));
                    return;
                case 4:
                    this._view.showBuyTokens(this._tokenBatchPrice, this._tokensBatchSize);
                    return;
                case 5:
                    return;
                case 6:
                    this._view.showAlert(("$" + "{inventory.marketplace.trading_lock.title}"), ("$" + "{inventory.marketplace.trading_lock.info}"));
                    return;
            }
        }

        public function endOfferMaking(k:Int)
        {
            if (this._view == null)
            {
                return;
            }
            this._view.showResult(k);
        }

        public function setAveragePrice(k:Int, _arg_2:Int, _arg_3:Int)
        {
            if (((!(k == this._statsRequestCategoryId)) || (!(_arg_2 == this._statsRequestTypeId))))
            {
                return;
            }
            if (this._view == null)
            {
                return;
            }
            this._view.updateAveragePrice(_arg_3, this._averagePricePeriod);
        }

        public function onNotEnoughCredits()
        {
            if (this._isBuyingTokens)
            {
                this._isBuyingTokens = false;
                this.releaseItem();
            }
        }

        public function onInventoryOpen()
        {
            this.send(new GetMarketplaceConfigurationMessageComposer());
        }

        public function getOfferItem():IFurnitureItem
        {
            return this._item;
        }

        public function getWindowContainer():IWindowContainer
        {
            return null;
        }

        public function initCategory(k:String)
        {
        }

        public function onCategorySwitch(k:String)
        {
        }

        public function onInventoryClose()
        {
        }

        public function updateView()
        {
        }

        function send(k:IMessageComposer)
        {
            if (((!(this._communication == null)) && (!(this._communication.connection == null))))
            {
                this._communication.connection.send(k);
            }
        }

        public function onSubcategorySwitch(k:String)
        {
            Logger.log(["NOT SUPPORTED: MARKETPLACE SELECT BY ID"]);
        }
    }

