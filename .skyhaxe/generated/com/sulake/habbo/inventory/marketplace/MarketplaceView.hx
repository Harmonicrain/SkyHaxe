package com.sulake.habbo.inventory.marketplace
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ILimitedItemPreviewOverlayWidget;
    import com.sulake.habbo.window.widgets._Str_3083;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habboclient.ExternalVariables;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.habbo.window.utils.IAlertDialog;

     class MarketplaceView implements IGetImageListener 
    {
        var _windowManager:IHabboWindowManager;
        var _assetLibrary:IAssetLibrary;
        var _view:IFrameWindow;
        var _model:MarketplaceModel;
        var _roomEngine:IRoomEngine;
        var _localization:IHabboLocalizationManager;
        var _disposed:Bool = false;
        var _furniImageId:Int = 0;
        var _askingPrice:Int = 0;
        var _furniName:String;
        var _habboInventory:HabboInventory;

        public function new(k:MarketplaceModel, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IRoomEngine, _arg_5:IHabboLocalizationManager, _arg_6:HabboInventory)
        {
            this._model = k;
            this._assetLibrary = _arg_3;
            this._windowManager = _arg_2;
            this._roomEngine = _arg_4;
            this._localization = _arg_5;
            this._habboInventory = _arg_6;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._model = null;
                this._assetLibrary = null;
                this._windowManager = null;
                this._roomEngine = null;
                this._localization = null;
                this.disposeView();
                this._disposed = true;
            }
        }

        function disposeView()
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
        }

        public function showBuyTokens(k:Int, _arg_2:Int)
        {
            if (this._localization != null)
            {
                this._localization.registerParameter("inventory.marketplace.buy_tokens.info", "price", Std.string(k));
                this._localization.registerParameter("inventory.marketplace.buy_tokens.info", "count", Std.string(_arg_2));
                this._localization.registerParameter("inventory.marketplace.buy_tokens.info", "free", Std.string((_arg_2 - 1)));
                this._localization.registerParameter("inventory.marketplace.buy_tokens.buy", "price", Std.string(k));
            }
            this._view = Std.downcast(this.createWindow("buy_marketplace_tokens_xml") , IFrameWindow);
            if (this._view == null)
            {
                return;
            }
            this._view.procedure = this.clickHandler;
            this._view.center();
        }

        public function showMakeOffer(k:FurnitureItem)
        {
            var _local_4:ImageResult = null;
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_8:IWidgetWindow = null;
            var _local_9:ILimitedItemPreviewOverlayWidget = null;
            var _local_10:IWidgetWindow = null;
            var _local_11:_Str_3083 = null;
            if (((((!(k != null)) || (!(this._localization != null))) || (!(this._roomEngine != null))) || (!(this._model != null))))
            {
                return;
            }
            this._view = Std.downcast(this.createWindow("make_marketplace_offer_xml") , IFrameWindow);
            if (this._view == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._view.findChildByName("price_input") , ITextFieldWindow);
            if (_local_2 != null)
            {
                _local_2.restrict = "0-9";
            }
            this.checkPrice();
            this._localization.registerParameter("inventory.marketplace.make_offer.expiration_info", "time", Std.string(this._model.expirationHours));
            this._localization.registerParameter("inventory.marketplace.make_offer.min_price", "minprice", Std.string(this._model.offerMinPrice));
            this._localization.registerParameter("inventory.marketplace.make_offer.max_price", "maxprice", Std.string(this._model.offerMaxPrice));
            var _local_3:UInt = 0xFFEEEEEE;
            if (!k.isWallItem)
            {
                _local_4 = this._roomEngine.getFurnitureImage(k.type, new Vector3d(90, 0, 0), 64, this, _local_3, Std.string(k.extra));
            }
            else
            {
                _local_4 = this._roomEngine.getWallItemImage(k.type, new Vector3d(90, 0, 0), 64, this, _local_3, k.stuffData.getLegacyString());
            }
            if (_local_4 == null)
            {
                return;
            }
            this._furniImageId = _local_4.id;
            this.setFurniImage(_local_4.data);
            if (k.isWallItem)
            {
                _local_5 = ("wallItem.name." + Std.string(k.type));
                _local_6 = ("wallItem.desc." + Std.string(k.type));
            }
            else
            {
                _local_5 = ("roomItem.name." + Std.string(k.type));
                _local_6 = ("roomItem.desc." + Std.string(k.type));
            }
            if (k.category == FurniCategory.POSTER)
            {
                _local_5 = (("poster_" + k.stuffData.getLegacyString()) + "_name");
                _local_6 = (("poster_" + k.stuffData.getLegacyString()) + "_desc");
            }
            this._furniName = this._localization.getLocalization(_local_5);
            this.setText("furni_name", ((("$" + "{") + _local_5) + "}"));
            this.setText("furni_desc", ((("$" + "{") + _local_6) + "}"));
            this._view.procedure = this.clickHandler;
            this._view.center();
            var _local_7= Std.downcast(this._view.findChildByName("average_price") , ITextWindow);
            if (_local_7 != null)
            {
                _local_7.visible = false;
            }
            if (((!(k.stuffData == null)) && (k.stuffData.uniqueSerialNumber > 0)))
            {
                _local_8 = cast(this._view.findChildByName("unique_item_overlay_widget"), IWidgetWindow);
                _local_8.visible = true;
                _local_9 = cast(_local_8.widget, ILimitedItemPreviewOverlayWidget);
                _local_9.serialNumber = k.stuffData.uniqueSerialNumber;
                _local_9.seriesSize = k.stuffData.uniqueSeriesSize;
            }
            if (((!(k.stuffData == null)) && (k.stuffData.rarityLevel >= 0)))
            {
                _local_10 = cast(this._view.findChildByName("rarity_item_overlay_widget"), IWidgetWindow);
                _local_10.visible = true;
                _local_11 = cast(_local_10.widget, _Str_3083);
                _local_11.rarityLevel = k.stuffData.rarityLevel;
            }
            this._model.getItemStats();
        }

        function setFurniImage(k:BitmapData)
        {
            if (((k == null) || (this._view == null)))
            {
                return;
            }
            var _local_2= Std.downcast(this._view.findChildByName("furni_image") , IBitmapWrapperWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= new BitmapData(_local_2.width, _local_2.height, true, 0);
            var _local_4= Std.int((_local_3.width - k.width) * 0.5);
            var _local_5= Std.int((_local_3.height - k.height) * 0.5);
            _local_3.draw(k, new Matrix(1, 0, 0, 1, _local_4, _local_5));
            _local_2.bitmap = _local_3;
        }

        function setText(k:String, _arg_2:String)
        {
            if (this._view == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._view.findChildByName(k) , ITextWindow);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.text = _arg_2;
        }

        public function showNoCredits(k:Int)
        {
            if (this._localization != null)
            {
                this._localization.registerParameter("inventory.marketplace.no_credits.info", "price", Std.string(k));
            }
            this._view = Std.downcast(this.createWindow("marketplace_no_credits_xml") , IFrameWindow);
            if (this._view == null)
            {
                return;
            }
            this._view.procedure = this.clickHandler;
            this._view.center();
        }

        function showConfirmation()
        {
            this._localization.registerParameter("inventory.marketplace.confirm_offer.info", "furniname", this._furniName);
            this._localization.registerParameter("inventory.marketplace.confirm_offer.info", "price", Std.string(this._askingPrice));
            var k= ("$" + "{inventory.marketplace.confirm_offer.title}");
            var _local_2= ("$" + "{inventory.marketplace.confirm_offer.info}");
            this._windowManager.confirm(k, _local_2, 0, this.confirmationCallback);
        }

        function confirmationCallback(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            k.dispose();
            if (this._model == null)
            {
                return;
            }
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this._model.makeOffer(this._askingPrice);
            }
            this._model.releaseItem();
        }

        function createWindow(k:String):IWindow
        {
            if (((this._assetLibrary == null) || (this._windowManager == null)))
            {
                return null;
            }
            var _local_2= Std.downcast(this._assetLibrary.getAssetByName(k) , XmlAsset);
            if (_local_2 == null)
            {
                return null;
            }
            return this._windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) ));
        }

        function clickHandler(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:ITextFieldWindow = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "buy_tokens_button":
                        this._model.buyMarketplaceTokens();
                        this.disposeView();
                        
                    case "cancel_buy_tokens_button"
                       | "cancel_make_offer_button"
                       | "cancel_no_credits_button"
                       | "header_button_close":
                        this._model.releaseItem();
                        this.disposeView();
                        
                    case "make_offer_button":
                        _local_3 = Std.downcast(this._view.findChildByName("price_input") , ITextFieldWindow);
                        if (_local_3 != null)
                        {
                            this._askingPrice = ASCompat.parseInt(_local_3.text);
                            this.showConfirmation();
                        }
                        this.disposeView();
                        
                    case "get_credits_button":
                        this._model.releaseItem();
                        this.openCreditsPage();
                        this.disposeView();
                        
                }
            }
            if (k.type == WindowEvent.WINDOW_EVENT_CHANGE)
            {
                if (_arg_2.name == "price_input")
                {
                    this.checkPrice();
                }
            }
        }

        function openCreditsPage()
        {
            HabboWebTools.openWebPageAndMinimizeClient(this._habboInventory.getProperty(ExternalVariables.WEB_SHOP_RELATIVE_URL));
        }

        function checkPrice()
        {
            if (this._view == null)
            {
                return;
            }
            var k= Std.downcast(this._view.findChildByName("price_input") , ITextFieldWindow);
            if (k == null)
            {
                return;
            }
            var _local_2= ASCompat.parseInt(k.text);
            if (_local_2 > this._model.offerMaxPrice)
            {
                k.text = Std.string(this._model.offerMaxPrice);
                _local_2 = this._model.offerMaxPrice;
            }
            var _local_3= Std.int(Math.max(Math.fceil(((this._model.commission * 0.01) * _local_2)), 1));
            var _local_4= (_local_2 + _local_3);
            var _local_5= Std.downcast(this._view.findChildByName("make_offer_button") , IButtonWindow);
            var _local_6= Std.downcast(this._view.findChildByName("final_price") , ITextWindow);
            if (((_local_5 == null) || (_local_6 == null)))
            {
                return;
            }
            this._localization.registerParameter("inventory.marketplace.make_offer.final_price", "commission", Std.string(_local_3));
            this._localization.registerParameter("inventory.marketplace.make_offer.final_price", "finalprice", Std.string(_local_4));
            if (_local_2 < this._model.offerMinPrice)
            {
                _local_6.text = ("$" + "{inventory.marketplace.make_offer.min_price}");
                _local_5.disable();
            }
            else
            {
                _local_6.text = ("$" + "{inventory.marketplace.make_offer.final_price}");
                _local_5.enable();
            }
        }

        public function showResult(k:Int)
        {
            var _local_2:String = null;
            if (k == 1)
            {
                _local_2 = ("$" + "{inventory.marketplace.result.title.success}");
            }
            else
            {
                _local_2 = ("$" + "{inventory.marketplace.result.title.failure}");
            }
            var _local_3:ASAny = ((("$" + "{inventory.marketplace.result.") + Std.string(k)) + "}");
            this._windowManager.alert(_local_2, _local_3, 0, this.closeAlert);
        }

        function closeAlert(k:IAlertDialog, _arg_2:WindowEvent)
        {
            if (k == null)
            {
                return;
            }
            this._model.releaseItem();
            k.dispose();
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (this._furniImageId == k)
            {
                this.setFurniImage(_arg_2);
            }
        }

        public function imageFailed(k:Int)
        {
        }

        public function showAlert(k:String, _arg_2:String)
        {
            this._windowManager.alert(k, _arg_2, 0, this.closeAlert);
        }

        public function updateAveragePrice(k:Int, _arg_2:Int)
        {
            if ((((!(this._view != null)) || (!(this._localization != null))) || (!(this._model != null))))
            {
                return;
            }
            var _local_3= Std.downcast(this._view.findChildByName("average_price") , ITextWindow);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= Std.int(Math.ffloor((k / (1 + (this._model.commission * 0.01)))));
            this._localization.registerParameter("inventory.marketplace.make_offer.average_price", "days", Std.string(_arg_2));
            var _local_5= ((k == 0) ? " - " : Std.string(k));
            this._localization.registerParameter("inventory.marketplace.make_offer.average_price", "price", _local_5);
            var _local_6= ((_local_4 == 0) ? " - " : Std.string(_local_4));
            this._localization.registerParameter("inventory.marketplace.make_offer.average_price", "price_no_commission", _local_6);
            _local_3.visible = true;
        }
    }

