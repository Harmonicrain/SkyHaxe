package com.sulake.habbo.catalog.marketplace
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.localization.ILocalization;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ILimitedItemGridOverlayWidget;
    import com.sulake.habbo.window.widgets._Str_3083;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.assets.XmlAsset;

     class MarketplaceConfirmationDialog implements IGetImageListener 
    {
        var _marketplace:MarketPlaceLogic;
        var _catalog:IHabboCatalog;
        var _roomEngine:IRoomEngine;
        var _window:IFrameWindow;
        var _offer:MarketPlaceOfferData;

        public function new(k:MarketPlaceLogic, _arg_2:IHabboCatalog, _arg_3:IRoomEngine)
        {
            this._marketplace = k;
            this._catalog = _arg_2;
            this._roomEngine = _arg_3;
        }

        public function dispose()
        {
            this._marketplace = null;
            this._catalog = null;
            this._roomEngine = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._offer = null;
        }

        public function showConfirmation(k:Int, _arg_2:MarketPlaceOfferData)
        {
            var _local_4:String = null;
            var _local_5:ILocalization = null;
            var _local_6:String = null;
            var _local_7:IWindow = null;
            var _local_8:IWidgetWindow = null;
            var _local_9:ILimitedItemGridOverlayWidget = null;
            var _local_10:IWidgetWindow = null;
            var _local_11:_Str_3083 = null;
            var _local_12:IWindow = null;
            if (_arg_2 == null)
            {
                return;
            }
            this._offer = _arg_2;
            if ((((!(this._marketplace != null)) || (!(this._catalog != null))) || (!(this._catalog.localization != null))))
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = Std.downcast(this.createWindow("marketplace_purchase_confirmation") , IFrameWindow);
            this._window.procedure = this.eventHandler;
            this._window.center();
            var _local_3= Std.downcast(this._window.findChildByName("header_text") , ITextWindow);
            if (_local_3 != null)
            {
                if (k == MarketPlaceLogic._Str_19658)
                {
                    _local_3.text = ("$" + "{catalog.marketplace.confirm_header}");
                }
                if (k == MarketPlaceLogic._Str_22006)
                {
                    _local_3.text = ("$" + "{catalog.marketplace.confirm_higher_header}");
                }
            }
            _local_3 = Std.downcast(this._window.findChildByName("item_name") , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.text = ((("$" + "{") + this._marketplace.getNameLocalizationKey(_arg_2)) + "}");
            }
            _local_3 = Std.downcast(this._window.findChildByName("item_price") , ITextWindow);
            if (_local_3 != null)
            {
                _local_4 = this._catalog.localization.getLocalization("catalog.marketplace.confirm_price");
                _local_4 = ASCompat.stringReplace(_local_4, "%price%", this._offer.price);
                _local_3.text = _local_4;
            }
            _local_3 = Std.downcast(this._window.findChildByName("item_average_price") , ITextWindow);
            if (_local_3 != null)
            {
                _local_5 = this._catalog.localization.getLocalizationRaw("catalog.marketplace.offer_details.average_price");
                if (_local_5 != null)
                {
                    _local_4 = _local_5.raw;
                    _local_4 = ASCompat.stringReplace(_local_4, "%days%", Std.string(this._marketplace.averagePricePeriod));
                    _local_6 = ((this._offer.averagePrice == 0) ? " - " : Std.string(this._offer.averagePrice));
                    _local_4 = ASCompat.stringReplace(_local_4, "%average%", _local_6);
                    _local_3.text = _local_4;
                }
                else
                {
                    _local_3.visible = false;
                }
            }
            _local_3 = Std.downcast(this._window.findChildByName("offer_count") , ITextWindow);
            if (_local_3 != null)
            {
                _local_5 = this._catalog.localization.getLocalizationRaw("catalog.marketplace.offer_details.offer_count");
                if (_local_5 != null)
                {
                    _local_4 = _local_5.raw;
                    _local_4 = ASCompat.stringReplace(_local_4, "%count%", this._offer.offerCount);
                    _local_3.text = _local_4;
                }
                else
                {
                    _local_3.visible = false;
                }
            }
            if (_arg_2.isUniqueLimitedItem)
            {
                _local_7 = this._window.findChildByName("unique_item_background_bitmap");
                _local_7.visible = true;
                _local_8 = cast(this._window.findChildByName("unique_item_overlay_widget"), IWidgetWindow);
                _local_9 = cast(_local_8.widget, ILimitedItemGridOverlayWidget);
                _local_8.visible = true;
                _local_9.serialNumber = _arg_2.stuffData.uniqueSerialNumber;
                _local_9.animated = true;
            }
            if (((_arg_2.stuffData != null) && (_arg_2.stuffData.rarityLevel >= 0)))
            {
                _local_10 = cast(this._window.findChildByName("rarity_item_overlay_widget"), IWidgetWindow);
                _local_11 = cast(_local_10.widget, _Str_3083);
                _local_10.visible = true;
                _local_11.rarityLevel = _arg_2.stuffData.rarityLevel;
            }
            this.setImage();
            if (Std.downcast(this._catalog , HabboCatalog).getBoolean("disclaimer.credit_spending.enabled"))
            {
                this._Str_3515(false);
            }
            else
            {
                _local_12 = this._window.findChildByName("disclaimer");
                this._window.height = (this._window.height - _local_12.height);
                _local_12.dispose();
                this._Str_3515(true);
            }
        }

        function setImage()
        {
            var k:ImageResult = null;
            var _local_2:IBitmapWrapperWindow = null;
            if ((((!(this._offer != null)) || (!(this._window != null))) || (!(this._roomEngine != null))))
            {
                return;
            }
            if (this._offer.image == null)
            {
                if (this._offer.furniType == 1)
                {
                    k = this._roomEngine.getFurnitureIcon(this._offer.furniId, this);
                }
                else
                {
                    if (this._offer.furniType == 2)
                    {
                        k = this._roomEngine.getWallItemIcon(this._offer.furniId, this);
                    }
                }
                if (((k != null) && (k.data != null)))
                {
                    this._offer.image = k.data ;
                    this._offer.imageCallback = k.id;
                }
            }
            if (this._offer.image != null)
            {
                _local_2 = Std.downcast(this._window.findChildByName("item_image") , IBitmapWrapperWindow);
                if (_local_2 != null)
                {
                    if (_local_2.bitmap != null)
                    {
                        _local_2.bitmap.dispose();
                        _local_2.bitmap = null;
                    }
                    _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height, true, 0);
                    _local_2.bitmap.draw(this._offer.image, new Matrix(1, 0, 0, 1, ((_local_2.width - this._offer.image.width) / 2), ((_local_2.height - this._offer.image.height) / 2)));
                }
            }
        }

        function eventHandler(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k != null)) || (!(_arg_2 != null))))
            {
                return;
            }
            if (((!(k.type == WindowMouseEvent.CLICK)) && (!(k.type == WindowMouseEvent.DOUBLE_CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "spending_disclaimer":
                    this._Str_3515(cast(_arg_2, ICheckBoxWindow).Selected);
                    return;
                case "buy_button":
                    this._catalog.buyMarketPlaceOffer(this._offer.offerId);
                    this.hide();
                    return;
                case "header_button_close"
                   | "cancel_button":
                    this.hide();
                    return;
            }
        }

        function hide()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (((this._offer != null) && (this._offer.imageCallback == k)))
            {
                this._offer.image = _arg_2;
                this.setImage();
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function createWindow(k:String):IWindow
        {
            if ((((!(this._catalog != null)) || (!(this._catalog.assets != null))) || (!(this._catalog.windowManager != null))))
            {
                return null;
            }
            var _local_2= Std.downcast(this._catalog.assets.getAssetByName(k) , XmlAsset);
            if (((!(_local_2 != null)) || (!_local_2.content)))
            {
                return null;
            }
            var _local_3= ((_local_2.content : com.sulake.core.utils.xml.XML) );
            if (_local_3 == null)
            {
                return null;
            }
            return this._catalog.windowManager.buildFromXML(_local_3);
        }

        function _Str_3515(k:Bool)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= this._window.findChildByName("buy_button");
            if (_local_2 == null)
            {
                return;
            }
            if (k)
            {
                _local_2.enable();
            }
            else
            {
                _local_2.disable();
            }
        }
    }

