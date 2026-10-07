package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.club.ClubOfferHandler;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog._enum.ClubOfferRequestSource;
    import com.sulake.habbo.catalog.club.ClubBuyDialog;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.catalog.purse.IPurse;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.catalog.viewer.CatalogPage;
    import com.sulake.habbo.catalog.club.ClubBuyOfferData;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.events.WindowEvent;

     class ClubBuyCatalogWidget extends CatalogWidget implements IVipBuyCatalogWidget 
    {
        var _controller:ClubOfferHandler;
        var _offers:Array<ASAny>;

        public function new(k:IWindowContainer)
        {
            super(k);
        }

        override public function dispose()
        {
            if (this._controller != null)
            {
                this._controller._Str_18073(this);
            }
            this._controller = null;
            this.reset();
            super.dispose();
        }

        public var isGift(get,never):Bool;
public function  get_isGift():Bool
        {
            return false;
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            this._offers = [];
            _Str_2819(CatalogWidgetEnum.CLUB_BUY);
            this._controller = Std.downcast(page.viewer.catalog , HabboCatalog).getClubBuyController();
            this._controller.registerVisualization(this);
            this._controller.requestOffers(ClubOfferRequestSource._Str_15734);
            return true;
        }

        public function reset()
        {
            var k:ClubBuyDialog = null;
            final _iter_ = this._offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._offers = [];
        }

        public function _Str_15013(clubType:Int)
        {
            var catalog:HabboCatalog = null;
            var localization:IHabboLocalizationManager = null;
            var purse:IPurse = null;
            var clubDays = 0;
            var clubPeriods = 0;
            var clubDaysTotal = 0;
            if (disposed)
            {
                return;
            }
            var viewer= page.viewer;
            if (viewer != null)
            {
                catalog = Std.downcast(viewer.catalog , HabboCatalog);
                if (catalog != null)
                {
                    localization = catalog.localization;
                    purse = catalog.getPurse();
                    if (((purse != null) && (localization != null)))
                    {
                        clubDays = purse.clubDays;
                        clubPeriods = purse.clubPeriods;
                        clubDaysTotal = ((clubPeriods * 31) + clubDays);
                        localization.registerParameter("catalog.club.buy.remaining.hc", "days", Std.string(clubDaysTotal));
                        localization.registerParameter("catalog.club.buy.remaining.vip", "days", Std.string(clubDaysTotal));
                    }
                }
            }
            try
            {
                if (_window != null)
                {
                    switch (clubType)
                    {
                        case HabboClubLevelEnum.NO_CLUB:
                            _window.findChildByName("club_header").caption = "${catalog.club.buy.header.none}";
                            _window.findChildByName("club_info").caption = "${catalog.club.buy.info.none}";
                            _window.findChildByName("club_remaining").visible = false;
                            _window.findChildByName("club_remaining_bg").visible = false;
                            
                        case HabboClubLevelEnum.CLUB:
                            _window.findChildByName("club_header").caption = "${catalog.club.buy.header.hc}";
                            _window.findChildByName("club_info").caption = "${catalog.club.buy.info.hc}";
                            _window.findChildByName("club_remaining").caption = "${catalog.club.buy.remaining.hc}";
                            
                        case HabboClubLevelEnum.VIP:
                            _window.findChildByName("club_header").caption = "${catalog.club.buy.header.vip}";
                            _window.findChildByName("club_info").caption = "${catalog.club.buy.info.vip}";
                            _window.findChildByName("club_remaining").caption = "${catalog.club.buy.remaining.vip}";
                            this._Str_22558();
                            
                    }
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("ClubBuyCatalogWidget", "initClubType - Window not properly constructed!");
            }
 }            this._Str_7955();
        }

        function _Str_7955()
        {
            var k:IWindow = null;
            if (_window != null)
            {
                k = _window.findChildByName("club_link");
                if (k != null)
                {
                    k.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR);
                    k.mouseThreshold = 0;
                    k.addEventListener(WindowMouseEvent.CLICK, this._Str_18285);
                }
            }
        }

        public function _Str_6059(offer:ClubBuyOfferData)
        {
            var target:IItemListWindow = null;
            var item:ClubBuyDialog = null;
            if (disposed)
            {
                return;
            }
            Logger.log([("Offer: " + ASCompat.toString([offer.offerId, offer.productCode, offer.priceCredits, offer.vip, offer.months, offer._Str_11224, offer.year, offer.month, offer.day, offer._Str_10047]))]);
            offer.page = page;
            try
            {
                item = new ClubBuyDialog(offer, Std.downcast(page , CatalogPage));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("ClubBuyCatalogWidget", (((("showOffer - new ClubBuyItem(" + ASCompat.toString(offer)) + ", ") + ASCompat.toString(Std.downcast(page , CatalogPage))) + ") crashed!"));
                return;
            }
 }            if (offer.vip)
            {
                target = Std.downcast(_window.findChildByName("item_list_vip") , IItemListWindow);
            }
            else
            {
                target = Std.downcast(_window.findChildByName("item_list_hc") , IItemListWindow);
            }
            if (target != null)
            {
                target.addListItem(item.window);
            }
            this._offers.push(item);
        }

        function _Str_18285(k:WindowMouseEvent)
        {
            var _local_3:IHabboConfigurationManager = null;
            var _local_4:String = null;
            var _local_2= k.target.name;
            _local_3 = Std.downcast(page.viewer.catalog , HabboCatalog);
            switch (_local_2)
            {
                case "club_link":
                    _local_4 = _local_3.getProperty("link.format.club");
                    this.openExternalLink(_local_4);
                    return;
            }
        }

        function openExternalLink(k:String)
        {
            if (k != "")
            {
                page.viewer.catalog.windowManager.alert("${catalog.alert.external.link.title}", "${catalog.alert.external.link.desc}", 0, this.onExternalLink);
                HabboWebTools.navigateToURL(k, "habboMain");
            }
        }

        function onExternalLink(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        function _Str_22558()
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:IWindow = null;
            var k= Std.downcast(_window.findChildByName("item_list_hc") , IItemListWindow);
            if (k != null)
            {
                _local_2 = getAssetXML("club_buy_info_item");
                _local_3 = page.viewer.catalog.windowManager.buildFromXML(_local_2);
                k.addListItem(_local_3);
            }
        }
    }

