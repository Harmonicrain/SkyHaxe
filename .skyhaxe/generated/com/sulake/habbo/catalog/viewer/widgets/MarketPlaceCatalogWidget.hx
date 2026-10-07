package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.catalog.marketplace.IMarketPlaceVisualization;
    import com.sulake.habbo.catalog.marketplace.MarketPlaceOfferData;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import com.sulake.core.utils.Map;
    import flash.events.TimerEvent;
    import com.sulake.habbo.catalog.marketplace.MarketplaceChart;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.catalog.marketplace.IMarketPlace;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.room.ImageResult;
    import flash.geom.Point;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ILimitedItemGridOverlayWidget;
    import com.sulake.habbo.window.widgets._Str_3083;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.widgets.ILimitedItemPreviewOverlayWidget;
    import flash.geom.Matrix;
    import com.sulake.core.window.components.ITextFieldWindow;

     class MarketPlaceCatalogWidget extends CatalogWidget implements IGetImageListener implements  IMarketPlaceVisualization 
    {
        static inline final _Str_11360= 1;
        static inline final _Str_10266= 2;
        static inline final _Str_25315= 40;
        static inline final _Str_22318= 10;

        var _sortTypes:Array<ASAny>;
        var _selectedOffer:MarketPlaceOfferData;
        var _itemList:IItemListWindow;
        var _listItemBase:IWindowContainer;
        var _populationTimer:Timer;
        var _offers:Map;
        var _populationIndex:Int = 0;

        public function new(k:IWindowContainer)
        {
            this._sortTypes = [];
            super(k);
        }

        override public function dispose()
        {
            super.dispose();
            this._selectedOffer = null;
            this._offers = null;
            this._itemList = null;
            if (this._listItemBase != null)
            {
                this._listItemBase.dispose();
                this._listItemBase = null;
            }
            if (this._populationTimer != null)
            {
                this._populationTimer.removeEventListener(TimerEvent.TIMER, (this._Str_21007 : ASAny));
                this._populationTimer = null;
            }
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
            this.marketPlace.registerVisualization(this);
            this.displayMainView();
            var k= Std.downcast(_window.findChildByName("offer_list") , IItemListWindow);
            this._listItemBase = Std.downcast(k.removeListItem(k.getListItemByName("offer_item")) , IWindowContainer);
            return true;
        }

        public function listUpdatedNotify()
        {
            this._Str_22046();
            this._Str_11855();
        }

        public function updateStats()
        {
            var _local_6:MarketplaceChart = null;
            var _local_9:BitmapData = null;
            var _local_10:String = null;
            if ((((!(this.marketPlace != null)) || (!(this.marketPlace.localization != null))) || (!(_window != null))))
            {
                return;
            }
            var k= this.marketPlace.itemStats;
            if (k == null)
            {
                return;
            }
            var _local_2= Std.downcast(_window.findChildByName("details_container") , IWindowContainer);
            if (((!(_local_2 != null)) || (!_local_2.visible)))
            {
                return;
            }
            var _local_3= _local_2.findChildByName("offer_count");
            if (_local_3 != null)
            {
                this.marketPlace.localization.registerParameter("catalog.marketplace.offer_details.offer_count", "count", Std.string(k.offerCount));
                _local_3.visible = true;
            }
            var _local_4= Std.downcast(_local_2.findChildByName("chart_selector") , ISelectorWindow);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= _local_4.getSelected();
            if (_local_5 == null)
            {
                return;
            }
            switch (_local_5.name)
            {
                case "price_development":
                    _local_6 = new MarketplaceChart(k.dayOffsets, k.averagePrices);
                    
                case "trade_volume":
                    _local_6 = new MarketplaceChart(k.dayOffsets, k.soldAmounts);
                    
                default:
                    return;
            }
            if (_local_6 == null)
            {
                return;
            }
            var _local_7= Std.downcast(_local_2.findChildByName("chart_bitmap") , IBitmapWrapperWindow);
            if (_local_7 != null)
            {
                _local_7.bitmap = null;
                _local_7.bitmap = new BitmapData(_local_7.width, _local_7.height);
                _local_9 = _local_6.draw(_local_7.width, _local_7.height);
                _local_7.bitmap.draw(_local_9);
                _local_9.dispose();
            }
            var _local_8= _local_2.findChildByName("chart_title");
            if (_local_8 != null)
            {
                if (_local_6.available)
                {
                    _local_10 = ("catalog.marketplace.offer_details.chart_title." + _local_5.name);
                    this.marketPlace.localization.registerParameter(_local_10, "days", Std.string(k.historyLength));
                }
                else
                {
                    _local_10 = "catalog.marketplace.offer_details.chart_title.not_available";
                }
                _local_8.caption = this.marketPlace.localization.getLocalization(_local_10);
            }
        }

        var marketPlace(get,never):IMarketPlace;
function  get_marketPlace():IMarketPlace
        {
            if ((((page != null) && (page.viewer != null)) && (page.viewer.catalog != null)))
            {
                return page.viewer.catalog.getMarketPlace();
            }
            return null;
        }

        public function displayMainView()
        {
            _Str_2819(CatalogWidgetEnum.MARKET_PLACE);
            window.procedure = this._Str_17366;
            this._itemList = Std.downcast(window.findChildByName("offer_list") , IItemListWindow);
            this._Str_19529("search_by_activity");
        }

        function _Str_19529(k:String)
        {
            var _local_5:String = null;
            var _local_2= Std.downcast(_window.findChildByName("search_selector") , ISelectorWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.getSelectableByName(k);
            if (_local_3 == null)
            {
                return;
            }
            _local_2.setSelected(_local_3);
            var _local_4= Std.downcast(_window.findChildByName("search_container") , IWindowContainer);
            if (_local_4 == null)
            {
                return;
            }
            while (_local_4.numChildren > 0)
            {
                _local_4.removeChildAt(0);
            }
            switch (k)
            {
                case "search_by_value":
                    _local_5 = "marketplace_search_simple";
                    this._sortTypes = [1, 2];
                    
                case "search_by_activity":
                    _local_5 = "marketplace_search_simple";
                    this._sortTypes = [3, 4, 5, 6];
                    
                case "search_advanced":
                    _local_5 = "marketplace_search_advanced";
                    this._sortTypes = [1, 2, 3, 4, 5, 6];
                    
                default:
                    return;
            }
            var _local_6= Std.downcast(this.createWindow(_local_5) , IWindowContainer);
            _local_4.addChild(_local_6);
            var _local_7= Std.downcast(_window.findChildByName("sort_dropmenu") , IDropMenuWindow);
            if (_local_7 != null)
            {
                _local_7.populate(this._Str_24972(this._sortTypes));
                _local_7.selection = 0;
            }
        }

        function _Str_24972(k:Array<ASAny>):Array<ASAny>
        {
            var _local_3 = 0;
            var _local_2:Array<ASAny> = [];
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = ASCompat.toInt(_tmp_);
                _local_2.push(((("$" + "{catalog.marketplace.sort.") + Std.string(_local_3)) + "}"));
            }
            return _local_2;
        }

        function createWindow(k:String):IWindow
        {
            if ((((((!(page != null)) || (!(page.viewer != null))) || (!(page.viewer.catalog != null))) || (!(page.viewer.catalog.assets != null))) || (!(page.viewer.catalog.windowManager != null))))
            {
                return null;
            }
            var _local_2= Std.downcast(page.viewer.catalog.assets.getAssetByName(k) , XmlAsset);
            if (((!(_local_2 != null)) || (!_local_2.content)))
            {
                return null;
            }
            var _local_3= ((_local_2.content : com.sulake.core.utils.xml.XML) );
            if (_local_3 == null)
            {
                return null;
            }
            return page.viewer.catalog.windowManager.buildFromXML(_local_3);
        }

        function _Str_10239(k:Int, _arg_2:Int=-1, _arg_3:Int=-1)
        {
            var _local_6:String = null;
            var _local_4= this.marketPlace.localization;
            if (_local_4 == null)
            {
                return;
            }
            if (((((!(window != null)) || (!(page != null))) || (!(page.viewer != null))) || (!(page.viewer.catalog != null))))
            {
                return;
            }
            var _local_5= window.findChildByName("status_text");
            if (_local_5 == null)
            {
                return;
            }
            if (k == MarketPlaceCatalogWidget._Str_11360)
            {
                _local_6 = _local_4.getLocalization("catalog.marketplace.searching");
            }
            else
            {
                if (MarketPlaceCatalogWidget._Str_10266 != 0)
                {
                    if (_arg_3 > 0)
                    {
                        _local_6 = _local_4.getLocalization("catalog.marketplace.items_found");
                        _local_6 = ASCompat.stringReplace(_local_6, "%count%", _arg_3);
                        if (((_arg_2 > 0) && (_arg_2 < _arg_3)))
                        {
                            _local_6 = (_local_6 + ((". " + _local_4.getLocalization("catalog.marketplace.items_shown")) + "."));
                            _local_6 = ASCompat.stringReplace(_local_6, "%count%", _arg_2);
                        }
                    }
                    else
                    {
                        _local_6 = _local_4.getLocalization("catalog.marketplace.no_items");
                    }
                }
            }
            _local_5.caption = _local_6;
        }

        function _Str_11855()
        {
            if (((!(this.marketPlace != null)) || (!(window != null))))
            {
                return;
            }
            var k= this.marketPlace.latestOffers();
            if (k == null)
            {
                return;
            }
            var _local_2= this.marketPlace.totalItemsFound();
            this._offers = k;
            if (this._itemList == null)
            {
                return;
            }
            this._itemList.destroyListItems();
            if (this._listItemBase == null)
            {
                return;
            }
            var _local_3= k.getKeys();
            if (_local_3 == null)
            {
                return;
            }
            this._Str_10239(MarketPlaceCatalogWidget._Str_10266, _local_3.length, _local_2);
            if (this._populationTimer == null)
            {
                this._populationTimer = new Timer(25);
                this._populationTimer.addEventListener(TimerEvent.TIMER, (this._Str_21007 : ASAny));
            }
            this._populationIndex = 0;
            this._Str_21752();
            this._populationTimer.start();
        }

        function _Str_21007(k:TimerEvent)
        {
            if (this._populationTimer == null)
            {
                return;
            }
            if (this._Str_21752())
            {
                this._populationTimer.stop();
            }
        }

        function _Str_21752():Bool
        {
            if (this._offers == null)
            {
                return true;
            }
            var k = 0;
            while (k < 5)
            {
                if ((this._populationIndex : UInt) >= this._offers.length)
                {
                    return true;
                }
                this.addListItem(this._offers.getWithIndex(this._populationIndex));
                this._populationIndex++;
                k++;
            }
            return false;
        }

        function addListItem(k:MarketPlaceOfferData)
        {
            var _local_7:String = null;
            var _local_8:String = null;
            var _local_9:ImageResult = null;
            var _local_10:IBitmapWrapperWindow = null;
            var _local_11:Point = null;
            var _local_12:IWindow = null;
            var _local_13:IWidgetWindow = null;
            var _local_14:ILimitedItemGridOverlayWidget = null;
            var _local_15:IWidgetWindow = null;
            var _local_16:_Str_3083 = null;
            var _local_17:IWindow = null;
            if (((((!(k != null)) || (!(this._itemList != null))) || (!(this._listItemBase != null))) || (!(this.marketPlace.localization != null))))
            {
                return;
            }
            var _local_2= Std.downcast(this._listItemBase.clone() , IWindowContainer);
            if (((!(_local_2 != null)) || _local_2.disposed))
            {
                return;
            }
            var _local_3= _local_2.findChildByName("item_name");
            if (_local_3 != null)
            {
                _local_3.caption = ((("$" + "{") + this.marketPlace.getNameLocalizationKey(k)) + "}");
            }
            var _local_4= _local_2.findChildByName("item_desc");
            if (_local_4 != null)
            {
                _local_4.caption = ((("$" + "{") + this.marketPlace.getDescriptionLocalizationKey(k)) + "}");
            }
            var _local_5= _local_2.findChildByName("item_price");
            if (_local_5 != null)
            {
                _local_7 = this.marketPlace.localization.getLocalization("catalog.marketplace.offer.price_public_item");
                _local_7 = ASCompat.stringReplace(_local_7, "%price%", k.price);
                _local_7 = ASCompat.stringReplace(_local_7, "%average%", ((k.averagePrice != 0) ? Std.string(k.averagePrice) : " - "));
                _local_5.caption = _local_7;
            }
            var _local_6= _local_2.findChildByName("offer_count");
            if (_local_6 != null)
            {
                _local_8 = this.marketPlace.localization.getLocalization("catalog.marketplace.offer_count");
                _local_8 = ASCompat.stringReplace(_local_8, "%count%", k.offerCount);
                _local_6.caption = _local_8;
            }
            if (k.image == null)
            {
                _local_9 = this._Str_6819(k.furniId, k.furniType, k.extraData);
                if (((!(_local_9 == null)) && (!(_local_9.data == null))))
                {
                    k.image = _local_9.data ;
                    k.imageCallback = _local_9.id;
                }
                _local_2.id = _local_9.id;
            }
            if (k.image != null)
            {
                _local_10 = Std.downcast(_local_2.findChildByName("item_image") , IBitmapWrapperWindow);
                if (_local_10 != null)
                {
                    _local_11 = new Point(((_local_10.width - k.image.width) / 2), ((_local_10.height - k.image.height) / 2));
                    if (_local_10.bitmap == null)
                    {
                        _local_10.bitmap = new BitmapData(_local_10.width, _local_10.height, true, 0);
                    }
                    _local_10.bitmap.copyPixels(k.image, k.image.rect, _local_11);
                }
            }
            if (k.isUniqueLimitedItem)
            {
                _local_12 = _local_2.findChildByName("unique_item_background_bitmap");
                _local_13 = cast(_local_2.findChildByName("unique_item_overlay_widget"), IWidgetWindow);
                _local_14 = cast(_local_13.widget, ILimitedItemGridOverlayWidget);
                _local_14.serialNumber = k.stuffData.uniqueSerialNumber;
                _local_14.animated = true;
                _local_12.visible = true;
                _local_13.visible = true;
            }
            if (((k.stuffData != null) && (k.stuffData.rarityLevel >= 0)))
            {
                _local_15 = cast(_local_2.findChildByName("rarity_item_overlay_widget"), IWidgetWindow);
                _local_16 = cast(_local_15.widget, _Str_3083);
                _local_15.visible = true;
                _local_16.rarityLevel = k.stuffData.rarityLevel;
            }
            if (this.marketPlace.isAccountSafetyLocked())
            {
                _local_17 = _local_2.findChildByName("buy_button");
                if (_local_17 != null)
                {
                    _local_17.disable();
                }
            }
            this._itemList.addListItem(_local_2);
            _local_2.procedure = this._Str_23334;
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

        function _Str_23334(k:WindowEvent, _arg_2:IWindow=null)
        {
            var _local_3 = 0;
            var _local_4:Map = null;
            var _local_5:MarketPlaceOfferData = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if ((((!(window != null)) || (!(this.marketPlace != null))) || (!(_arg_2 != null))))
                {
                    return;
                }
                if (this._itemList == null)
                {
                    return;
                }
                _local_3 = this._itemList.getListItemIndex(k.window.parent);
                _local_4 = this.marketPlace.latestOffers();
                _local_5 = ASCompat.dynamicAs(_local_4.getWithIndex(_local_3) , MarketPlaceOfferData);
                if (_local_5 == null)
                {
                    return;
                }
                switch (_arg_2.name)
                {
                    case "buy_button":
                        this.marketPlace.buyOffer(_local_5.offerId);
                        return;
                    case "more_button":
                        this._Str_5386(_local_5);
                        return;
                }
            }
        }

        function _Str_5386(k:MarketPlaceOfferData)
        {
            var _local_10:ImageResult = null;
            var _local_11:IBitmapWrapperWindow = null;
            var _local_12:ILimitedItemPreviewOverlayWidget = null;
            var _local_13:_Str_3083 = null;
            var _local_14:IWindow = null;
            if ((((!(k != null)) || (!(_window != null))) || (!(this.marketPlace != null))))
            {
                return;
            }
            this._selectedOffer = k;
            var _local_2= this.marketPlace.localization;
            if (_local_2 == null)
            {
                return;
            }
            _window.getChildAt(0).visible = false;
            var _local_3= Std.downcast(_window.findChildByName("details_container") , IWindowContainer);
            if (_local_3 != null)
            {
                _local_3.visible = true;
            }
            else
            {
                _local_3 = Std.downcast(this.createWindow("marketplace_offer_details") , IWindowContainer);
                _window.addChild(_local_3);
                _local_3.procedure = this._Str_25254;
            }
            var _local_4= _local_3.findChildByName("item_name");
            if (_local_4 != null)
            {
                _local_4.caption = ((("$" + "{") + this.marketPlace.getNameLocalizationKey(k)) + "}");
            }
            _local_4 = _local_3.findChildByName("item_description");
            if (_local_4 != null)
            {
                _local_4.caption = ((("$" + "{") + this.marketPlace.getDescriptionLocalizationKey(k)) + "}");
            }
            _local_4 = _local_3.findChildByName("item_count");
            if (_local_4 != null)
            {
                _local_4.visible = false;
            }
            _local_2.registerParameter("catalog.marketplace.offer_details.price", "price", Std.string(k.price));
            _local_2.registerParameter("catalog.marketplace.offer_details.average_price", "days", Std.string(this.marketPlace.averagePricePeriod));
            var _local_5= ((k.averagePrice == 0) ? " - " : Std.string(k.averagePrice));
            _local_2.registerParameter("catalog.marketplace.offer_details.average_price", "average", _local_5);
            if (k.image == null)
            {
                _local_10 = this._Str_6819(k.furniId, k.furniType, k.extraData);
                if (((!(_local_10 == null)) && (!(_local_10.data == null))))
                {
                    k.image = _local_10.data ;
                    k.imageCallback = _local_10.id;
                }
            }
            if (k.image != null)
            {
                _local_11 = Std.downcast(_local_3.findChildByName("item_image") , IBitmapWrapperWindow);
                if (_local_11 != null)
                {
                    _local_11.bitmap = null;
                    _local_11.bitmap = new BitmapData(_local_11.width, _local_11.height, true, 0);
                    _local_11.bitmap.draw(k.image, new Matrix(1, 0, 0, 1, ((_local_11.width - k.image.width) / 2), ((_local_11.height - k.image.height) / 2)));
                }
            }
            var _local_6= Std.downcast(_local_3.findChildByName("chart_selector") , ISelectorWindow);
            if (_local_6 != null)
            {
                _local_6.setSelected(_local_6.getSelectableAt(0));
            }
            var _local_7= Std.downcast(_local_3.findChildByName("chart_bitmap") , IBitmapWrapperWindow);
            if (_local_7 != null)
            {
                _local_7.bitmap = null;
            }
            var _local_8= cast(_local_3.findChildByName("unique_item_overlay_widget"), IWidgetWindow);
            if (k.isUniqueLimitedItem)
            {
                _local_12 = cast(_local_8.widget, ILimitedItemPreviewOverlayWidget);
                _local_12.serialNumber = k.stuffData.uniqueSerialNumber;
                _local_12.seriesSize = k.stuffData.uniqueSeriesSize;
                _local_8.visible = true;
            }
            else
            {
                _local_8.visible = false;
            }
            var _local_9= cast(_local_3.findChildByName("rarity_item_overlay_widget"), IWidgetWindow);
            if (((k.stuffData != null) && (k.stuffData.rarityLevel >= 0)))
            {
                _local_13 = cast(_local_9.widget, _Str_3083);
                _local_9.visible = true;
                _local_13.rarityLevel = k.stuffData.rarityLevel;
            }
            else
            {
                _local_9.visible = false;
            }
            if (this.marketPlace.isAccountSafetyLocked())
            {
                _local_14 = _local_3.findChildByName("buy_button");
                if (_local_14 != null)
                {
                    _local_14.disable();
                }
            }
            this.marketPlace.requestItemStats(k.furniType, k.furniId);
        }

        function _Str_22046()
        {
            if (_window == null)
            {
                return;
            }
            this._selectedOffer = null;
            var k= _window.findChildByName("details_container");
            if (k != null)
            {
                k.visible = false;
            }
            _window.getChildAt(0).visible = true;
        }

        function doSearch()
        {
            var _local_5:IWindow = null;
            this._Str_10239(MarketPlaceCatalogWidget._Str_11360);
            var k= -1;
            var _local_2= -1;
            var _local_3= "";
            var _local_4= 1;
            _local_5 = _window.findChildByName("min_price_input");
            if (_local_5 != null)
            {
                if (_local_5.caption == "")
                {
                    k = -1;
                }
                else
                {
                    k = ASCompat.parseInt(_local_5.caption);
                }
            }
            _local_5 = _window.findChildByName("max_price_input");
            if (_local_5 != null)
            {
                if (_local_5.caption == "")
                {
                    _local_2 = -1;
                }
                else
                {
                    _local_2 = ASCompat.parseInt(_local_5.caption);
                }
            }
            _local_5 = _window.findChildByName("search_input");
            if (_local_5 != null)
            {
                _local_3 = _local_5.caption;
            }
            var _local_6= Std.downcast(_window.findChildByName("sort_dropmenu") , IDropMenuWindow);
            if ((((_local_6 != null) && (_local_6.selection >= 0)) && (_local_6.selection < this._sortTypes.length)))
            {
                _local_4 = ASCompat.toInt(this._sortTypes[_local_6.selection]);
            }
            this.marketPlace.requestOffers(k, _local_2, _local_3, _local_4);
        }

        function _Str_17366(k:WindowEvent, _arg_2:IWindow=null)
        {
            var _local_5:ISelectorWindow = null;
            var _local_6:ISelectableWindow = null;
            var _local_7:ITextFieldWindow = null;
            var _local_8 = 0;
            if ((((!(k != null)) || (!(_arg_2 != null))) || (!(this.marketPlace != null))))
            {
                return;
            }
            var _local_3= this.marketPlace.localization;
            var _local_4= window.findChildByName("search_input");
            if (k.type == WindowEvent.WINDOW_EVENT_SELECTED)
            {
                switch (_arg_2.name)
                {
                    case "sort_dropmenu":
                        _local_5 = Std.downcast(_window.findChildByName("search_selector") , ISelectorWindow);
                        if (_local_5 == null)
                        {
                            return;
                        }
                        _local_6 = _local_5.getSelected();
                        if (_local_6 == null)
                        {
                            return;
                        }
                        if (((_local_6.name == "search_by_value") || (_local_6.name == "search_by_activity")))
                        {
                            this.doSearch();
                        }
                        
                    case "search_by_value"
                       | "search_by_activity"
                       | "search_advanced":
                        this._Str_19529(_arg_2.name);
                        
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.CLICK)
                {
                    switch (_arg_2.name)
                    {
                        case "search_input":
                            if ((((_local_3 != null) && (_local_4 != null)) && (_local_4.caption == _local_3.getLocalization("catalog.marketplace.search_name"))))
                            {
                                _local_4.caption = "";
                            }
                            
                        case "search_button":
                            if ((((_local_3 != null) && (_local_4 != null)) && (_local_4.caption == _local_3.getLocalization("catalog.marketplace.search_name"))))
                            {
                                return;
                            }
                            this.doSearch();
                            
                    }
                }
                else
                {
                    if (k.type == WindowEvent.WINDOW_EVENT_CHANGE)
                    {
                        _local_7 = Std.downcast(_arg_2 , ITextFieldWindow);
                        if (_local_7 == null)
                        {
                            return;
                        }
                        switch (_local_7.name)
                        {
                            case "min_price_input"
                               | "max_price_input":
                                _local_8 = MarketPlaceCatalogWidget._Str_22318;
                                
                            case "search_input":
                                _local_8 = MarketPlaceCatalogWidget._Str_25315;
                                
                            default:
                                return;
                        }
                        if (_local_7.text.length > _local_8)
                        {
                            _local_7.text = _local_7.text.substr(0, _local_8);
                        }
                        _local_7.scrollH = 0;
                    }
                }
            }
        }

        function _Str_25254(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k != null)) || (!(_arg_2 != null))))
            {
                return;
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "back_button":
                        this._Str_22046();
                        return;
                    case "buy_button":
                        this.marketPlace.buyOffer(this._selectedOffer.offerId);
                        return;
                }
                return;
            }
            if (k.type == WindowEvent.WINDOW_EVENT_SELECTED)
            {
                switch (_arg_2.name)
                {
                    case "price_development"
                       | "trade_volume":
                        this.updateStats();
                        return;
                }
            }
        }
    }

