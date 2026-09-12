package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.club.ClubOfferHandler;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog._enum.ClubOfferRequestSource;
    import com.sulake.habbo.catalog.club.ClubOffer;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.window.components.ITextWindow;
    import flash.text.TextFormatAlign;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.catalog.viewer.CatalogPage;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.catalog.club.ClubBuyOfferData;

     class LoyaltyVipBuyCatalogWidget extends CatalogWidget implements IVipBuyCatalogWidget 
    {
        var _controller:ClubOfferHandler;
        var _offers:Array<ASAny>;
        var _catalog:HabboCatalog;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_2;
        }

        public var isGift(get,never):Bool;
public function  get_isGift():Bool
        {
            return false;
        }

        override public function dispose()
        {
            if (this._controller != null)
            {
                this._controller._Str_18073(this);
                this._controller = null;
            }
            this.reset();
            super.dispose();
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            this._offers = [];
            this._controller = this._catalog.getClubBuyController();
            this._controller.registerVisualization(this);
            this._controller.requestOffers(ClubOfferRequestSource._Str_15727);
            return true;
        }

        public function reset()
        {
            var k:ClubOffer = null;
            final _iter_ = this._offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._offers = [];
        }

        public function _Str_15013(k:Int)
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            if (disposed)
            {
                return;
            }
            var _local_2= this._catalog.localization;
            var _local_3= this._catalog.getPurse();
            if (((!(_local_3 == null)) && (!(_local_2 == null))))
            {
                _local_4 = _local_3.clubDays;
                _local_5 = _local_3.clubPeriods;
                _local_6 = ((_local_5 * 31) + _local_4);
                _local_2.registerParameter("catalog.vip.extend.info", "days", Std.string(_local_6));
            }
            if (((!(_window == null)) && (k == HabboClubLevelEnum.VIP)))
            {
                _window.findChildByName("vip_title").caption = "${catalog.vip.extend.title}";
                _window.findChildByName("vip_info").caption = "${catalog.vip.extend.info}";
            }
            if (_window != null)
            {
                this._Str_11983(Std.downcast(_window.findChildByName("vip_title") , ITextWindow));
                this._Str_11983(Std.downcast(_window.findChildByName("vip_info") , ITextWindow), 3);
            }
            this._Str_7955();
        }

        function _Str_11983(k:ITextWindow, _arg_2:Float=0)
        {
            var _local_3= k.getTextFormat();
            _local_3.align = TextFormatAlign.CENTER;
            _local_3.leading = Std.int(_arg_2);
            k.setTextFormat(_local_3);
        }

        function _Str_7955()
        {
            var k:IWindow = null;
            if (_window != null)
            {
                k = _window.findChildByName("vip_link");
                if (k != null)
                {
                    k.addEventListener(WindowMouseEvent.CLICK, this._Str_17250);
                    k.mouseThreshold = 0;
                }
            }
        }

        public function _Str_17250(k:WindowMouseEvent)
        {
            this._catalog.utils.showVipBenefits();
        }

        public function _Str_6059(offer:ClubBuyOfferData)
        {
            var item:ClubOffer = null;
            if ((disposed || (!offer.vip)))
            {
                return;
            }
            Logger.log([("Offer: " + ASCompat.toString([offer.offerId, offer.productCode, offer.priceCredits, offer.vip, offer.months, offer._Str_11224, offer.year, offer.month, offer.day, offer._Str_10047]))]);
            offer.page = page;
            try
            {
                item = new ClubOffer(offer, this._catalog, "HabboCatalogBuy");
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("ClubBuyCatalogWidget", (((("showOffer - new ClubBuyItem(" + ASCompat.toString(offer)) + ", ") + ASCompat.toString(Std.downcast(page , CatalogPage))) + ") crashed!"));
                return;
            }
 }            var target= Std.downcast(_window.findChildByName("item_list_vip") , IItemListWindow);
            if (target != null)
            {
                target.addListItem(item.window);
            }
            this._offers.push(item);
        }
    }

