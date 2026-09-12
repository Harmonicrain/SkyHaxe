package com.sulake.habbo.catalog.viewer
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog.viewer.widgets.ItemGridCatalogWidget;
    import com.sulake.habbo.catalog.navigation.CatalogNavigator;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.catalog.viewer.widgets.CatalogWidgetEnum;
    import com.sulake.habbo.catalog.viewer.widgets.CatalogWidget;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.catalog.viewer.widgets.ProductViewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.SongDiskProductViewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.SingleViewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.PurchaseCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.ColourGridCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.TraxPreviewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.RedeemItemCodeCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.SpacesNewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.RoomPreviewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.TrophyCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.AddOnBadgeViewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.PetsCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.NewPetsCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.RoomAdsCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.TextInputCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.SpecialInfoCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.RecyclerCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.RecyclerPrizesCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.MarketPlaceCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.MarketPlaceOwnItemsCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.ClubGiftWidget;
    import com.sulake.habbo.catalog.viewer.widgets.ClubBuyCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.VipBuyCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.LoyaltyVipBuyCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.ActivityPointDisplayCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.MadMoneyCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.BuyGuildCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.GuildBadgeViewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.GuildSelectorCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.GuildForumSelectorCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.PetPreviewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.SpinnerCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.BundlePurchaseExtraInfoCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.TotalPriceCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.UniqueLimitedItemWidget;
    import com.sulake.habbo.catalog.viewer.widgets.SoldLtdItemsCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.UserBadgeSelectorCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.BundleGridViewCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.SimplePriceCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.BuilderCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.BuilderSubscriptionCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.BuilderAddonsCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.BuilderLoyaltyCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.WarningCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.FirstProductSelectorCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.FeaturedItemsCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.viewer.widgets.LocalizationCatalogWidget;
    import flash.events.Event;
    import com.sulake.habbo.catalog.viewer.widgets.events.ProductOfferUpdatedEvent;

     class CatalogPage implements ICatalogPage 
    {
        static inline final LAYOUT_= "layout_";
        public static inline final MODE_NORMAL= 0;
        public static inline final _Str_7035= 1;

        var _Str_2897:com.sulake.core.utils.xml.XML;
        var _window:IWindowContainer;
        var _viewer:ICatalogViewer;
        var _Str_2709:Int = 0;
        var _layoutCode:String;
        var _offers:Vector<IPurchasableOffer>;
        var _localization:IPageLocalization;
        var _widgets:Array<ASAny>;
        var _Str_5564:EventDispatcherWrapper;
        var _habboCatalog:HabboCatalog;
        var _Str_23068:Int = 0;
        var _Str_11744:ItemGridCatalogWidget;
        var _acceptSeasonCurrencyAsCredits:Bool = false;
        var _mode:Int = 0;

        public function new(k:ICatalogViewer, _arg_2:Int, _arg_3:String, _arg_4:IPageLocalization, _arg_5:Vector<IPurchasableOffer>, _arg_6:HabboCatalog, _arg_7:Bool, _arg_8:Int=-1)
        {
            var _local_9:IPurchasableOffer = null;
            this._widgets = [];
            this._viewer = k;
            this._Str_2709 = _arg_2;
            this._layoutCode = _arg_3;
            this._localization = _arg_4;
            this._offers = _arg_5;
            this._habboCatalog = _arg_6;
            if (checkNullIteratee(_arg_5)) for (_tmp_ in _arg_5)
            {
_local_9  = _tmp_;
                _local_9.page = this;
            }
            this._Str_5564 = new EventDispatcherWrapper();
            this._widgets = new Array<ASAny>();
            this._acceptSeasonCurrencyAsCredits = _arg_7;
            if (_arg_8 == -1)
            {
                this._mode = MODE_NORMAL;
            }
            else
            {
                this._mode = _arg_8;
            }
            this.init();
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public var viewer(get,never):ICatalogViewer;
public function  get_viewer():ICatalogViewer
        {
            return this._viewer;
        }

        public var pageId(get,never):Int;
public function  get_pageId():Int
        {
            return (this._mode == _Str_7035) ? CatalogNavigator.DUMMY_PAGE_ID_FOR_OFFER_SEARCH : this._Str_2709;
        }

        public var layoutCode(get,never):String;
public function  get_layoutCode():String
        {
            return this._layoutCode;
        }

        public var offers(get,never):Vector<IPurchasableOffer>;
public function  get_offers():Vector<IPurchasableOffer>
        {
            return this._offers;
        }

        public var localization(get,never):IPageLocalization;
public function  get_localization():IPageLocalization
        {
            return this._localization;
        }

        public var links(get,never):Array<ASAny>;
public function  get_links():Array<ASAny>
        {
            return this._localization._Str_20312(this._layoutCode);
        }

        public var hasLinks(get,never):Bool;
public function  get_hasLinks():Bool
        {
            return this._localization.hasLinks(this._layoutCode);
        }

        public var acceptSeasonCurrencyAsCredits(get,never):Bool;
public function  get_acceptSeasonCurrencyAsCredits():Bool
        {
            return this._acceptSeasonCurrencyAsCredits;
        }

        public var _Str_21031(get,never):Bool;
public function  get__Str_21031():Bool
        {
            return !(this._layoutCode == "sold_ltd_items");
        }

        public var _Str_22520(never,set):Int;
public function  set__Str_22520(k:Int):Int        {
            return this._Str_23068 = k;
        }

        public var mode(get,never):Int;
public function  get_mode():Int
        {
            return this._mode;
        }

        public var _Str_21286(get,never):Bool;
public function  get__Str_21286():Bool
        {
            return this._habboCatalog.catalogType == CatalogType.BUILDER;
        }

        public function selectOffer(k:Int)
        {
            var _local_2:IPurchasableOffer = null;
            var _local_3:IGridItem = null;
            var _local_4:ITextFieldWindow = null;
            if (((!(this._Str_11744 == null)) && (k > -1)))
            {
                Logger.log([("selecting offer " + Std.string(k))]);
                final _iter_ = this._offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.offerId == k)
                    {
                        _local_3 = _local_2.gridItem;
                        this._Str_11744.select(_local_3, true);
                    }
                }
            }
            if (((this._window != null) && (!(this._window.findChildByName(CatalogWidgetEnum.TROPHY) == null))))
            {
                _local_4 = Std.downcast(this._window.findChildByName("input_text") , ITextFieldWindow);
                _local_4.focus();
                _local_4.activate();
            }
        }

        public function dispose()
        {
            var k:CatalogWidget = null;
            var _local_2:IPurchasableOffer = null;
            final _iter_ = this._widgets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._widgets = null;
            this._localization.dispose();
            final _iter_ = this._offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.dispose();
            }
            this._offers = new Vector<IPurchasableOffer>(0);
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._Str_5564 != null)
            {
                this._Str_5564.dispose();
                this._Str_5564 = null;
            }
            this._viewer = null;
            this._Str_2897 = null;
            this._Str_2709 = 0;
            this._layoutCode = "";
            this._acceptSeasonCurrencyAsCredits = false;
        }

        public function init()
        {
            if (this.createWindow(this.layoutCode))
            {
                this._Str_22448();
            }
        }

        public function closed()
        {
            var k:CatalogWidget = null;
            if (this._widgets != null)
            {
                final _iter_ = this._widgets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.closed();
                }
            }
        }

        function createWindow(k:String):Bool
        {
            if (k == "frontpage4")
            {
                k = "frontpage_featured";
            }
            var _local_2= (LAYOUT_ + k);
            if (this._viewer._Str_20991.indexOf("UBUNTU") > -1)
            {
                if (!this.viewer.catalog.assets.hasAsset(_local_2))
                {
                    _local_2 = ("old_" + _local_2);
                }
            }
            else
            {
                _local_2 = ("old_" + _local_2);
            }
            var _local_3= Std.downcast(this.viewer.catalog.assets.getAssetByName(_local_2) , XmlAsset);
            if (_local_3 == null)
            {
                Logger.log([("Could not find asset for layout " + _local_2)]);
                return false;
            }
            this._Str_2897 = ((_local_3.content : com.sulake.core.utils.xml.XML) );
            this._window = Std.downcast(this.viewer.catalog.windowManager.buildFromXML(this._Str_2897) , IWindowContainer);
            if (this._window == null)
            {
                Logger.log([("Could not create layout " + k)]);
                return false;
            }
            return true;
        }

        function _Str_19940()
        {
        }

        function _Str_22448()
        {
            this._Str_20303(this._window);
            this._Str_25518();
        }

        function _Str_20303(k:IWindowContainer)
        {
            var _local_2 = 0;
            var _local_3:IWindowContainer = null;
            if (k != null)
            {
                _local_2 = 0;
                while (_local_2 < k.numChildren)
                {
                    _local_3 = Std.downcast(k.getChildAt(_local_2) , IWindowContainer);
                    if (_local_3 != null)
                    {
                        this.createWidget(_local_3);
                        this._Str_20303(_local_3);
                    }
                    _local_2++;
                }
            }
        }

        function createWidget(k:IWindowContainer)
        {
            if (k == null)
            {
                return;
            }
            switch (k.name)
            {
                case CatalogWidgetEnum.ITEM_GRID:
                    if (this._Str_11744 == null)
                    {
                        this._Str_11744 = new ItemGridCatalogWidget(k, this._habboCatalog.sessionDataManager, this._habboCatalog.catalogType);
                        this._widgets.push(this._Str_11744);
                    }
                    return;
                case CatalogWidgetEnum.PRODUCT_VIEW:
                    this._widgets.push(new ProductViewCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.SONG_DISK_PRODUCT_VIEW:
                    this._widgets.push(new SongDiskProductViewCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.SINGLE_VIEW:
                    this._widgets.push(new SingleViewCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.PURCHASE:
                    this._widgets.push(new PurchaseCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.COLOUR_GRID:
                    this._widgets.push(new ColourGridCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.TRAX_PREVIEW:
                    this._widgets.push(new TraxPreviewCatalogWidget(k, this._habboCatalog.soundManager));
                    return;
                case CatalogWidgetEnum.REDEEM_ITEM_CODE:
                    this._widgets.push(new RedeemItemCodeCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.SPACES_NEW:
                    this._widgets.push(new SpacesNewCatalogWidget(k, this._habboCatalog.sessionDataManager, this._habboCatalog.catalogType));
                    return;
                case CatalogWidgetEnum.ROOM_PREVIEW:
                    this._widgets.push(new RoomPreviewCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.TROPHY:
                    this._widgets.push(new TrophyCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.ADD_ON_BADGE_VIEW:
                    this._widgets.push(new AddOnBadgeViewCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.PETS:
                    this._widgets.push(new PetsCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.NEW_PETS:
                    this._widgets.push(new NewPetsCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.ROOM_ADS:
                    this._widgets.push(new RoomAdsCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.TEXT_INPUT:
                    this._widgets.push(new TextInputCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.SPECIAL_INFO:
                    this._widgets.push(new SpecialInfoCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.RECYCLER:
                    this._widgets.push(new RecyclerCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.RECYCLER_PRIZES:
                    this._widgets.push(new RecyclerPrizesCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.MARKET_PLACE:
                    this._widgets.push(new MarketPlaceCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.MARKET_PLACE_OWN_ITEMS:
                    this._widgets.push(new MarketPlaceOwnItemsCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.CLUB_GIFT:
                    this._widgets.push(new ClubGiftWidget(k, this._habboCatalog.getClubGiftController(), this._habboCatalog));
                    return;
                case CatalogWidgetEnum.CLUB_BUY:
                    this._widgets.push(new ClubBuyCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.VIP_BUY:
                    this._widgets.push(new VipBuyCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.LOYALTY_VIP_BUY:
                    this._widgets.push(new LoyaltyVipBuyCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.VIP_GIFT:
                    this._widgets.push(new VipBuyCatalogWidget(k, this._habboCatalog, true));
                    return;
                case CatalogWidgetEnum.ACTIVITY_POINT_DISPLAY:
                    this._widgets.push(new ActivityPointDisplayCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.MAD_MONEY:
                    this._widgets.push(new MadMoneyCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.BUY_GUILD:
                    this._widgets.push(new BuyGuildCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.GUILD_BADGE_VIEW:
                    this._widgets.push(new GuildBadgeViewCatalogWidget(k, this._habboCatalog.getGroupMembershipsController()));
                    return;
                case CatalogWidgetEnum.GUILD_SELECTOR:
                    this._widgets.push(new GuildSelectorCatalogWidget(k, this._habboCatalog.getGroupMembershipsController()));
                    return;
                case CatalogWidgetEnum.GUILD_FORUM_SELECTOR:
                    this._widgets.push(new GuildForumSelectorCatalogWidget(k, this._habboCatalog.getGroupMembershipsController()));
                    return;
                case CatalogWidgetEnum.PET_PREVIEW:
                    this._widgets.push(new PetPreviewCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.SPINNER:
                    this._widgets.push(new SpinnerCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.BUNDLE_PURCHASE_EXTRA_INFO:
                    this._widgets.push(new BundlePurchaseExtraInfoCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.TOTAL_PRICE:
                    this._widgets.push(new TotalPriceCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.LIMITED_ITEM:
                    this._widgets.push(new UniqueLimitedItemWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.SOLD_LTD_ITEMS:
                    this._widgets.push(new SoldLtdItemsCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.USER_BADGE_SELECTOR:
                    this._widgets.push(new UserBadgeSelectorCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.BUILDER_GRID_SCROLL:
                    this._widgets.push(new BundleGridViewCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.SIMPLE_PRICE:
                    this._widgets.push(new SimplePriceCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.BUILDER:
                    this._widgets.push(new BuilderCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.BUILDER_SUBSCRIPTION:
                    this._widgets.push(new BuilderSubscriptionCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.BUILDER_ADDONS:
                    this._widgets.push(new BuilderAddonsCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.BUILDER_LOYALTY:
                    this._widgets.push(new BuilderLoyaltyCatalogWidget(k, this._habboCatalog));
                    return;
                case CatalogWidgetEnum.WARNING:
                    this._widgets.push(new WarningCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.FIRST_PRODUCT_AUTO_SELECTOR:
                    this._widgets.push(new FirstProductSelectorCatalogWidget(k));
                    return;
                case CatalogWidgetEnum.FEATURED_ITEMS:
                    this._widgets.push(new FeaturedItemsCatalogWidget(k, this._habboCatalog));
                    return;
            }
        }

        function _Str_25518()
        {
            var k:CatalogWidget = null;
            var _local_3:ColourGridCatalogWidget = null;
            var _local_4:ItemGridCatalogWidget = null;
            var _local_5:IWindowContainer = null;
            var _local_6 = 0;
            var _local_7:IWindowContainer = null;
            var _local_2:Array<ASAny> = [];
            if (this._layoutCode == "default_3x3_color_grouping")
            {
                _local_5 = Std.downcast(this._window.findChildByName("itemGridWidget") , IWindowContainer);
                _local_6 = 3;
                _local_5.height = (104 - _local_6);
                _local_7 = Std.downcast(this._window.findChildByName("colourGridWidget") , IWindowContainer);
                _local_7.visible = true;
                _local_7.width = 360;
                _local_7.x = _local_5.x;
                _local_7.y = ((_local_5.y + _local_5.height) + _local_6);
                _local_7.height = 51;
                _local_3 = new ColourGridCatalogWidget(_local_7);
                this._widgets.push(_local_3);
            }
            final _iter_ = this._widgets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.page = this;
                if (Std.is(k , ItemGridCatalogWidget))
                {
                    _local_4 = Std.downcast(k , ItemGridCatalogWidget);
                }
                k.events = this._Str_5564;
                if (!k.init())
                {
                    _local_2.push(k);
                }
            }
            this._Str_24047(_local_2);
            this.initializeLocalizations();
            this._Str_5564.dispatchEvent(new _Str_3308(CatalogWidgetEvent.WIDGETS_INITIALIZED));
        }

        function initializeLocalizations()
        {
            var k:CatalogWidget = new LocalizationCatalogWidget(this._window, this._habboCatalog);
            this._widgets.push(k);
            k.page = this;
            k.events = this._Str_5564;
            k.init();
        }

        function _Str_24047(k:Array<ASAny>)
        {
            var _local_2:CatalogWidget = null;
            var _local_3:CatalogWidget = null;
            var _local_4 = 0;
            if (((k == null) || (k.length == 0)))
            {
                return;
            }
            final _iter_ = this._widgets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.window != null)
                {
                    if (checkNullIteratee(k)) for (_tmp_ in k)
                    {
_local_3  = _tmp_;
                        if (_local_3.window != null)
                        {
                            if (_local_3.window.getChildIndex(_local_2.window) >= 0)
                            {
                                if (k.indexOf(_local_2) < 0)
                                {
                                    k.push(_local_2);
                                }
                                break;
                            }
                        }
                    }
                }
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                if (_local_3.window != null)
                {
                    this._window.removeChild(_local_3.window);
                    _local_3.window.dispose();
                }
                _local_4 = this._widgets.indexOf(_local_3);
                if (_local_4 >= 0)
                {
                    this._widgets.splice(_local_4, 1);
                }
                _local_3.dispose();
            }
        }

        public function dispatchWidgetEvent(k:Event):Bool
        {
            if (this._Str_5564 != null)
            {
                return this._Str_5564.dispatchEvent(k);
            }
            return false;
        }

        public function replaceOffers(k:Vector<IPurchasableOffer>, _arg_2:Bool=false)
        {
            var _local_3:IPurchasableOffer = null;
            if (_arg_2)
            {
                final _iter_ = this._offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    _local_3.dispose();
                }
            }
            this._offers = k;
        }

        public function _Str_19621(k:Int, _arg_2:Int)
        {
            var _local_3:IPurchasableOffer = null;
            final _iter_ = this._offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.offerId == k)
                {
                    _local_3.product.uniqueLimitedItemsLeft = _arg_2;
                    this._Str_5564.dispatchEvent(new ProductOfferUpdatedEvent(_local_3));
                    return;
                }
            }
        }
    }

