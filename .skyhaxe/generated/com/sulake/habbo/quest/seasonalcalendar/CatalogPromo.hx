package com.sulake.habbo.quest.seasonalcalendar
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.session.product.IProductDataListener;
    import com.sulake.habbo.quest.HabboQuestEngine;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageProductData;
    import com.sulake.habbo.communication.messages.incoming.catalog.SeasonalCalendarDailyOfferMessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPublishedMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetSeasonalCalendarDailyOfferComposer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.core.window.IWindow;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;

     class CatalogPromo implements IDisposable implements  IGetImageListener implements  IProductDataListener 
    {
        var _questEngine:HabboQuestEngine;
        var _window:IWindowContainer;
        var _connection:IConnection;
        var _mainWindow:MainWindow;
        var _productData:CatalogPageMessageProductData = null;
        var _offerId:Int = -1;
        var _pageId:Int = -1;
        var _cachedDailyOfferMessageEvent:SeasonalCalendarDailyOfferMessageEvent = null;
        var _dailyOfferListener:IMessageEvent = null;
        var _catalogPublishedListener:IMessageEvent = null;

        public function new(k:HabboQuestEngine, _arg_2:MainWindow)
        {
            this._questEngine = k;
            this._mainWindow = _arg_2;
        }

        public function dispose()
        {
            if (this._connection != null)
            {
                if (this._dailyOfferListener != null)
                {
                    this._connection.removeMessageEvent(this._dailyOfferListener);
                    this._dailyOfferListener = null;
                }
                if (this._catalogPublishedListener != null)
                {
                    this._connection.removeMessageEvent(this._catalogPublishedListener);
                    this._catalogPublishedListener = null;
                }
                this._connection = null;
            }
            this._questEngine = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function onActivityPoints(k:Int, _arg_2:Int)
        {
            if (k == this._Str_13323())
            {
                this._questEngine.localization.registerParameter("quests.seasonalcalendar.promo.balance", "amount", ("" + Std.string(_arg_2)));
                if (this._window != null)
                {
                    this.refresh();
                }
            }
        }

        function _Str_13323():Int
        {
            var k= this._questEngine.configuration.getProperty("seasonalQuestCalendar.currency");
            return Math.isNaN(ASCompat.toNumber(k)) ? 0 : ASCompat.toInt(k);
        }

        public function prepare(k:IFrameWindow)
        {
            this._window = cast(k.findChildByName("catalog_promo_cont"), IWindowContainer);
            this._window.findChildByName("buy_button").disable();
            this._window.findChildByName("buy_button").procedure = this._Str_24042;
            this._connection = this._questEngine.communication.connection;
            if (this._connection != null)
            {
                this._dailyOfferListener = new SeasonalCalendarDailyOfferMessageEvent(this._Str_22066);
                this._catalogPublishedListener = new CatalogPublishedMessageEvent(this.onCatalogPublished);
                this._connection.addMessageEvent(this._dailyOfferListener);
                this._connection.addMessageEvent(this._catalogPublishedListener);
                this._connection.send(new GetSeasonalCalendarDailyOfferComposer());
            }
        }

        public function refresh()
        {
            var _local_4:String = null;
            var _local_5:ImageResult = null;
            var k= cast(this._window.findChildByName("your_balance_txt"), ITextWindow);
            var _local_2= cast(this._window.findChildByName("currency_icon_cont"), IWindowContainer);
            _local_2.x = (k.x + k.width);
            Util.hideChildren(_local_2);
            var _local_3= _local_2.findChildByName(("currency_icon_" + Std.string(this._Str_13323())));
            if (_local_3 != null)
            {
                _local_3.visible = true;
            }
            if (this._productData != null)
            {
                _local_4 = null;
                _local_5 = null;
                if (this._productData.productType == CatalogPageMessageProductData.PRODUCT_TYPE_ITEM)
                {
                    _local_5 = this._questEngine.roomEngine.getWallItemImage(this._productData.furniClassId, new Vector3d(90, 0, 0), 64, this, 0, this._productData.extraParam);
                }
                else
                {
                    if (this._productData.productType == CatalogPageMessageProductData.PRODUCT_TYPE_STUFF)
                    {
                        _local_5 = this._questEngine.roomEngine.getFurnitureImage(this._productData.furniClassId, new Vector3d(90, 0, 0), 64, this);
                    }
                }
                if (((!(_local_5 == null)) && (!(_local_5.data == null))))
                {
                    this._Str_20112(_local_5.data);
                }
            }
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            this._Str_20112(_arg_2);
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_24042(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                Logger.log(["Buy button clicked"]);
                if (this._offerId != -1)
                {
                    this._questEngine.catalog.openCatalogPageById(this._pageId, this._offerId, CatalogType.NORMAL);
                }
            }
        }

        function _Str_22066(k:SeasonalCalendarDailyOfferMessageEvent)
        {
            this._window.findChildByName("buy_button").enable();
            var _local_2= this._questEngine.sessionDataManager.getProductData(k.offer.localizationId);
            if (_local_2 != null)
            {
                cast(this._window.findChildByName("promo_info"), ITextWindow).text = _local_2.name;
                this._pageId = k.pageId;
                this._offerId = k.offer.offerId;
                if (k.offer.products.length > 0)
                {
                    this._productData = k.offer.products[0];
                    this.refresh();
                }
            }
            else
            {
                if (this._cachedDailyOfferMessageEvent == null)
                {
                    this._cachedDailyOfferMessageEvent = k;
                    this._questEngine.sessionDataManager.addProductsReadyEventListener(this);
                }
            }
        }

        public function productDataReady()
        {
            this._Str_22066(this._cachedDailyOfferMessageEvent);
        }

        function _Str_20112(k:BitmapData)
        {
            var _local_2= cast(this._window.findChildByName("furni_preview"), IBitmapWrapperWindow);
            var _local_3= new BitmapData(_local_2.width, _local_2.height, true, 0);
            var _local_4= k.rect;
            if (_local_4.width > _local_3.rect.width)
            {
                _local_4.x = ((_local_4.width - _local_3.rect.width) / 2);
                _local_4.width = _local_3.rect.width;
            }
            if (_local_4.height > _local_3.rect.height)
            {
                _local_4.y = ((_local_4.height - _local_3.rect.height) / 2);
                _local_4.height = _local_3.rect.height;
            }
            var _local_5= new Point(0, 0);
            if (_local_3.rect.width > _local_4.width)
            {
                _local_5.x = ((_local_3.rect.width - _local_4.width) / 2);
            }
            if (_local_3.rect.height > _local_4.height)
            {
                _local_5.y = ((_local_3.rect.height - _local_4.height) / 2);
            }
            _local_3.copyPixels(k, _local_4, _local_5);
            _local_2.bitmap = _local_3;
        }

        function onCatalogPublished(k:IMessageEvent)
        {
            if (this._connection != null)
            {
                this._connection.send(new GetSeasonalCalendarDailyOfferComposer());
            }
        }
    }

