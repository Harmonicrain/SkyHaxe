package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.catalog.marketplace.IMarketPlaceVisualization;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.marketplace.MarketPlaceOfferState;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.catalog.marketplace.IMarketPlace;
    import com.sulake.habbo.catalog.marketplace.MarketPlaceOfferData;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ILimitedItemGridOverlayWidget;
    import com.sulake.habbo.window.widgets._Str_3083;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class MarketPlaceOwnItemsCatalogWidget extends CatalogWidget implements IGetImageListener implements  IMarketPlaceVisualization 
    {
        static inline final _Str_11360= 1;
        static inline final _Str_10266= 2;

        var _itemTemplates:Map;
        var _itemList:IItemListWindow;
        var _offers:Map;

        public function new(k:IWindowContainer)
        {
            super(k);
            this._itemTemplates = new Map();
        }

        override public function dispose()
        {
            super.dispose();
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            if (this.marketPlace == null)
            {
                return false;
            }
            var k= this.marketPlace.windowManager;
            if (k == null)
            {
                return false;
            }
            this.displayMainView();
            var _local_2= Std.downcast(_window.findChildByName("item_list") , IItemListWindow);
            this._itemTemplates.add(MarketPlaceOfferState.ONGOING_OWN, _local_2.removeListItem(_local_2.getListItemByName("ongoing_item")));
            this._itemTemplates.add(MarketPlaceOfferState.SOLD, _local_2.removeListItem(_local_2.getListItemByName("sold_item")));
            this._itemTemplates.add(MarketPlaceOfferState.EXPIRED, _local_2.removeListItem(_local_2.getListItemByName("expired_item")));
            this.marketPlace.registerVisualization(this);
            this.marketPlace.requestOwnItems();
            this._Str_10239(MarketPlaceOwnItemsCatalogWidget._Str_11360);
            this._Str_21553(false);
            return true;
        }

        function _Str_21553(k:Bool)
        {
            if (window == null)
            {
                return;
            }
            var _local_2= Std.downcast(window.findChildByName("redeem_border") , IWindowContainer);
            if (_local_2 != null)
            {
                _local_2.visible = k;
            }
        }

        public function listUpdatedNotify()
        {
            if (this.marketPlace == null)
            {
                return;
            }
            this._Str_11855(this.marketPlace.latestOwnOffers());
        }

        function _Str_10239(k:Int, _arg_2:Int=-1)
        {
            var _local_5:String = null;
            if (((!(this.marketPlace != null)) || (!(window != null))))
            {
                return;
            }
            var _local_3= this.marketPlace.localization;
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= window.findChildByName("status_text");
            if (_local_4 == null)
            {
                return;
            }
            if (k == MarketPlaceOwnItemsCatalogWidget._Str_11360)
            {
                _local_5 = _local_3.getLocalization("catalog.marketplace.searching");
            }
            else
            {
                if (MarketPlaceOwnItemsCatalogWidget._Str_10266 != 0)
                {
                    if (_arg_2 > 0)
                    {
                        _local_5 = _local_3.getLocalization("catalog.marketplace.items_found");
                        _local_5 = ASCompat.stringReplace(_local_5, "%count%", _arg_2);
                    }
                    else
                    {
                        _local_5 = _local_3.getLocalization("catalog.marketplace.no_items");
                    }
                }
            }
            _local_4.caption = _local_5;
        }

        var marketPlace(get,never):IMarketPlace;
function  get_marketPlace():IMarketPlace
        {
            if ((((!(page != null)) || (!(page.viewer != null))) || (!(page.viewer.catalog != null))))
            {
                return null;
            }
            return page.viewer.catalog.getMarketPlace();
        }

        function _Str_11855(k:Map)
        {
            var _local_4:IWindowContainer = null;
            var _local_10 = 0;
            var _local_11:MarketPlaceOfferData = null;
            var _local_12:IWindowContainer = null;
            var _local_13:IWindow = null;
            var _local_14:IWindow = null;
            var _local_15:IWindow = null;
            var _local_16:String = null;
            var _local_17:IWindow = null;
            var _local_18 = 0;
            var _local_19 = 0;
            var _local_20 = 0;
            var _local_21:String = null;
            var _local_22:String = null;
            var _local_23:IWindow = null;
            var _local_24:IWindow = null;
            var _local_25:ImageResult = null;
            var _local_26:IBitmapWrapperWindow = null;
            var _local_27:Point = null;
            var _local_28:IWindow = null;
            var _local_29:IWidgetWindow = null;
            var _local_30:ILimitedItemGridOverlayWidget = null;
            var _local_31:IWidgetWindow = null;
            var _local_32:_Str_3083 = null;
            if ((((!(k != null)) || (!(this.marketPlace != null))) || (!(window != null))))
            {
                return;
            }
            this._offers = k;
            var _local_2= this.marketPlace.localization;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(window.findChildByName("item_list") , IItemListWindow);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.destroyListItems();
            var _local_5 = 0;
            var _local_6= k.getKeys();
            if (_local_6 == null)
            {
                return;
            }
            this._Str_10239(MarketPlaceOwnItemsCatalogWidget._Str_10266, _local_6.length);
            var _local_7 = 0;
            while (_local_7 < _local_6.length)
            {
                _local_10 = ASCompat.toInt(_local_6[_local_7]);
                _local_11 = ASCompat.dynamicAs(k.getValue(_local_10) , MarketPlaceOfferData);
                if (_local_11.status == MarketPlaceOfferState.SOLD)
                {
                    _local_5++;
                }
                _local_4 = this._itemTemplates.getValue(_local_11.status);
                if (_local_4 != null)
                {
                    _local_12 = Std.downcast(_local_4.clone() , IWindowContainer);
                    if (!((!(_local_12 != null)) || _local_12.disposed))
                    {
                        _local_13 = _local_12.findChildByName("item_name");
                        if (_local_13 != null)
                        {
                            _local_13.caption = ((this.marketPlace != null) ? ((("$" + "{") + this.marketPlace.getNameLocalizationKey(_local_11)) + "}") : "");
                        }
                        _local_14 = _local_12.findChildByName("item_desc");
                        if (_local_14 != null)
                        {
                            _local_14.caption = ((this.marketPlace != null) ? ((("$" + "{") + this.marketPlace.getDescriptionLocalizationKey(_local_11)) + "}") : "");
                        }
                        _local_15 = _local_12.findChildByName("item_price");
                        if (_local_15 != null)
                        {
                            _local_16 = _local_2.getLocalization("catalog.marketplace.offer.price_own_item");
                            _local_16 = ASCompat.stringReplace(_local_16, "%price%", _local_11.price);
                            _local_15.caption = _local_16;
                        }
                        if (_local_11.status == MarketPlaceOfferState.ONGOING_OWN)
                        {
                            _local_17 = _local_12.findChildByName("item_time");
                            if (_local_17 != null)
                            {
                                _local_18 = Std.int(Math.max(1, _local_11.timeLeftMinutes));
                                _local_19 = Std.int(Math.ffloor((_local_18 / 60)));
                                _local_20 = (_local_18 - (_local_19 * 60));
                                _local_21 = ((Std.string(_local_20) + " ") + _local_2.getLocalization("catalog.marketplace.offer.minutes"));
                                if (_local_19 > 0)
                                {
                                    _local_21 = ((((Std.string(_local_19) + " ") + _local_2.getLocalization("catalog.marketplace.offer.hours")) + " ") + _local_21);
                                }
                                _local_22 = _local_2.getLocalization("catalog.marketplace.offer.time_left");
                                _local_22 = ASCompat.stringReplace(_local_22, "%time%", _local_21);
                                _local_17.caption = _local_22;
                            }
                        }
                        if (_local_11.status == MarketPlaceOfferState.SOLD)
                        {
                            _local_23 = _local_12.findChildByName("item_sold");
                            if (_local_23 != null)
                            {
                                _local_23.caption = _local_2.getLocalization("catalog.marketplace.offer.sold");
                            }
                        }
                        if (_local_11.status == MarketPlaceOfferState.EXPIRED)
                        {
                            _local_24 = _local_12.findChildByName("item_expired");
                            if (_local_24 != null)
                            {
                                _local_24.caption = _local_2.getLocalization("catalog.marketplace.offer.expired");
                            }
                        }
                        if (_local_11.image == null)
                        {
                            _local_25 = this._Str_6819(_local_11.furniId, _local_11.furniType, _local_11.extraData);
                            if (((!(_local_25 == null)) && (!(_local_25.data == null))))
                            {
                                _local_11.image = _local_25.data ;
                                _local_11.imageCallback = _local_25.id;
                                _local_12.id = _local_25.id;
                            }
                        }
                        if (_local_11.image != null)
                        {
                            _local_26 = Std.downcast(_local_12.findChildByName("item_image") , IBitmapWrapperWindow);
                            if (_local_26 != null)
                            {
                                _local_27 = new Point(((_local_26.width - _local_11.image.width) / 2), ((_local_26.height - _local_11.image.height) / 2));
                                if (_local_26.bitmap == null)
                                {
                                    _local_26.bitmap = new BitmapData(_local_26.width, _local_26.height, true, 0);
                                }
                                _local_26.bitmap.copyPixels(_local_11.image, _local_11.image.rect, _local_27);
                            }
                        }
                        if (_local_11.isUniqueLimitedItem)
                        {
                            _local_28 = _local_12.findChildByName("unique_item_background_bitmap");
                            _local_29 = cast(_local_12.findChildByName("unique_item_overlay_widget"), IWidgetWindow);
                            _local_30 = cast(_local_29.widget, ILimitedItemGridOverlayWidget);
                            _local_30.serialNumber = _local_11.stuffData.uniqueSerialNumber;
                            _local_30.animated = true;
                            _local_28.visible = true;
                            _local_29.visible = true;
                        }
                        if (((_local_11.stuffData != null) && (_local_11.stuffData.rarityLevel >= 0)))
                        {
                            _local_31 = cast(_local_12.findChildByName("rarity_item_overlay_widget"), IWidgetWindow);
                            _local_32 = cast(_local_31.widget, _Str_3083);
                            _local_31.visible = true;
                            _local_32.rarityLevel = _local_11.stuffData.rarityLevel;
                        }
                        _local_3.addListItem(_local_12);
                        _local_12.procedure = this._Str_23504;
                    }
                }
                _local_7++;
            }
            this._Str_21553(true);
            var _local_8= Std.downcast(window.findChildByName("redeem_sold") , IButtonWindow);
            var _local_9= window.findChildByName("redeem_info");
            if (((_local_8 != null) && (_local_9 != null)))
            {
                if (_local_5 > 0)
                {
                    _local_8.enable();
                    _local_2.registerParameter("catalog.marketplace.redeem.get_credits", "count", Std.string(_local_5));
                    _local_2.registerParameter("catalog.marketplace.redeem.get_credits", "credits", Std.string(this.marketPlace.creditsWaiting));
                    _local_9.caption = ("$" + "{catalog.marketplace.redeem.get_credits}");
                }
                else
                {
                    _local_8.disable();
                    _local_9.caption = ("$" + "{catalog.marketplace.redeem.no_sold_items}");
                }
            }
        }

        public function displayMainView()
        {
            _Str_2819(CatalogWidgetEnum.MARKET_PLACE_OWN_ITEMS);
            window.procedure = this._Str_17366;
            this._itemList = Std.downcast(window.findChildByName("item_list") , IItemListWindow);
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            var _local_4:IWindowContainer = null;
            var _local_5:MarketPlaceOfferData = null;
            var _local_6:IBitmapWrapperWindow = null;
            var _local_7:Point = null;
            if (((((disposed || (!(this.marketPlace != null))) || (!(_arg_2 != null))) || (!(this._itemList != null))) || (!(this._offers != null))))
            {
                return;
            }
            var _local_3:Array<ASAny> = [];
            if (this._itemList.groupListItemsWithID(k, _local_3) != 0)
            {
                if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                {
_local_4  = _tmp_;
                    if (_local_4 != null)
                    {
                        _local_6 = Std.downcast(_local_4.findChildByName("item_image") , IBitmapWrapperWindow);
                        if (_local_6 != null)
                        {
                            _local_6.bitmap = new BitmapData(_local_6.width, _local_6.height, true, 0xFFFFFF);
                            _local_7 = new Point(((_local_6.width - _arg_2.width) / 2), ((_local_6.height - _arg_2.height) / 2));
                            _local_6.bitmap.copyPixels(_arg_2, _arg_2.rect, _local_7, null, null, true);
                        }
                        _local_4.id = 0;
                    }
                }
            }
            final _iter_ = this._offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_5  = _tmp_;
                if (_local_5.imageCallback == k)
                {
                    _local_5.imageCallback = 0;
                    _local_5.image = _arg_2;
                }
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_6819(k:Int, _arg_2:Int, _arg_3:String=null):ImageResult
        {
            if ((((!(page != null)) || (!(page.viewer != null))) || (!(page.viewer.roomEngine != null))))
            {
                return null;
            }
            if (_arg_2 == 1)
            {
                return page.viewer.roomEngine.getFurnitureIcon(k, this);
            }
            if (_arg_2 == 2)
            {
                return page.viewer.roomEngine.getWallItemIcon(k, this, _arg_3);
            }
            return null;
        }

        function _Str_23504(k:WindowEvent, _arg_2:IWindow=null)
        {
            var _local_3:IItemListWindow = null;
            var _local_4 = 0;
            var _local_5:Map = null;
            var _local_6:MarketPlaceOfferData = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if ((((!(this.marketPlace != null)) || (!(_arg_2 != null))) || (!(window != null))))
                {
                    return;
                }
                if (_arg_2.name == "pick_button")
                {
                    _local_3 = Std.downcast(window.findChildByName("item_list") , IItemListWindow);
                    if (_local_3 == null)
                    {
                        return;
                    }
                    _local_4 = _local_3.getListItemIndex(k.window.parent);
                    _local_5 = this.marketPlace.latestOwnOffers();
                    if (_local_5 == null)
                    {
                        return;
                    }
                    _local_6 = ASCompat.dynamicAs(_local_5.getWithIndex(_local_4) , MarketPlaceOfferData);
                    if (_local_6 != null)
                    {
                        this.marketPlace.redeemExpiredOffer(_local_6.offerId);
                    }
                }
            }
        }

        function _Str_17366(k:WindowEvent, _arg_2:IWindow)
        {
            if (_arg_2 == null)
            {
                _arg_2 = k.target ;
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "redeem_sold":
                        if (this.marketPlace != null)
                        {
                            this.marketPlace.redeemSoldOffers();
                        }
                        return;
                }
            }
        }

        public function updateStats()
        {
        }
    }

