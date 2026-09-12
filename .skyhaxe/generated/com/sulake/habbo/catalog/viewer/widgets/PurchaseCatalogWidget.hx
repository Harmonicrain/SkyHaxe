package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_4201;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetSpinnerEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetPurchaseOverrideEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.catalog.purchase._Str_11981;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetExtraPurchaseParameterEvent;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetInitPurchaseEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetRoomPreviewerStuffDataEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;

     class PurchaseCatalogWidget extends CatalogWidget
    {
        var _stubPurchaseVipXML:com.sulake.core.utils.xml.XML;
        var _stub:IWindowContainer;
        var _offer:IPurchasableOffer;
        var _additionalParameters:String = "";
        var _previewStuffData:IStuffData = null;
        var _quantity:Int = 1;
        var _purchaseCallback:ASFunction;
        var _catalog:HabboCatalog;
        var _noGiftOption:Bool = false;
        var _extraParamRequired:Bool = false;
        var _enabled:Bool = true;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_2;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            events.removeEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
            events.removeEventListener(CatalogWidgetEvent.SET_EXTRA_PARM, this._Str_19234);
            events.removeEventListener(CatalogWidgetEvent.PURCHASE_OVERRIDE, this._Str_21783);
            events.removeEventListener(CatalogWidgetEvent.SET_PREVIEWER_STUFFDATA, this._Str_20167);
            events.removeEventListener(CatalogWidgetEvent.TOGGLE, this._Str_19636);
            super.dispose();
        }

        function _Str_19636(k:_Str_4201)
        {
            if (k._Str_25555 == CatalogWidgetEnum.PURCHASE)
            {
                this._enabled = k.enabled;
                window.visible = this._enabled;
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            if (this._catalog.catalogType == CatalogType.BUILDER)
            {
                _window.visible = false;
                return true;
            }
            _Str_2819(CatalogWidgetEnum.PURCHASE);
            _window.findChildByName("selection_information").visible = true;
            _window.findChildByName("default_buttons").visible = false;
            this._noGiftOption = false;
            if (window.tags.indexOf("ROOM_INITIATE_PURCHASE") > -1)
            {
                this._catalog.sendRoomAdPurchaseInitiatedEvent();
            }
            _window.findChildByName("buy_button").addEventListener(WindowMouseEvent.CLICK, this._Str_8396);
            var k= Std.downcast(_window.findChildByName("gift_button") , IButtonWindow);
            if (window.tags.indexOf("NO_GIFT_OPTION") > -1)
            {
                this._noGiftOption = true;
                k.visible = false;
            }
            k.addEventListener(WindowMouseEvent.CLICK, this._Str_18825);
            k.disable();
            var _local_2= Std.downcast(this._catalog.assets.getAssetByName("purchaseWidgetBuyVipStub") , XmlAsset);
            if (_local_2 != null)
            {
                this._stubPurchaseVipXML = ((_local_2.content : com.sulake.core.utils.xml.XML) );
            }
            events.addEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
            events.addEventListener(CatalogWidgetEvent.SET_EXTRA_PARM, this._Str_19234);
            events.addEventListener(CatalogWidgetEvent.PURCHASE_OVERRIDE, this._Str_21783);
            events.addEventListener(CatalogWidgetEvent.INIT_PURCHASE, this._Str_25569);
            events.addEventListener(CatalogWidgetEvent.SET_PREVIEWER_STUFFDATA, this._Str_20167);
            events.addEventListener(CatalogWidgetSpinnerEvent.CWSE_VALUE_CHANGED, this._Str_25792);
            events.addEventListener(CatalogWidgetEvent.EXTRA_PARAM_REQUIRED_FOR_BUY, this._Str_22307);
            events.addEventListener(CatalogWidgetEvent.TOGGLE, this._Str_19636);
            return true;
        }

        function _Str_21783(k:CatalogWidgetPurchaseOverrideEvent)
        {
            this._purchaseCallback = k.callback;
        }

        function _Str_24516(k:IPurchasableOffer)
        {
            var _local_2:IWindowContainer = null;
            if (this._stub != null)
            {
                this._stub.visible = false;
                _window.removeChild(this._stub);
                this._stub.dispose();
                this._stub = null;
            }
        }

        var _Str_7923(get,never):Bool;
function  get__Str_7923():Bool
        {
            return !(this._extraParamRequired && (this._additionalParameters == ""));
        }

        function onSelectProduct(k:SelectProductEvent)
        {
            var _local_2:IWindow = null;
            var _local_3 = false;
            this._quantity = 1;
            this._offer = k.offer;
            _window.findChildByName("selection_information").visible = false;
            _window.findChildByName("default_buttons").visible = true;
            this._Str_24516(this._offer);
            this._catalog.purchaseWillBeGift(false);
            if (this._stub == null)
            {
                this._Str_10113(this._Str_7923);
                this.enableGiftButton(this._Str_7923);
                _Str_11981._Str_21471(this._offer, _window.findChildByName("purchase_label"));
                _local_2 = _window.findChildByName("gift_button");
                if (_local_2 != null)
                {
                    _local_2.visible = ((!this._offer.isRentOffer) && (!this._noGiftOption));
                }
                if (!this._offer.giftable)
                {
                    this.enableGiftButton(false);
                }
                _local_3 = this._Str_24901(this._offer);
                if (_local_3)
                {
                    this._Str_10113(false);
                    this.enableGiftButton(false);
                }
                window.visible = this._enabled;
            }
            else
            {
                this._Str_10113(false);
                this.enableGiftButton(false);
            }
        }

        function _Str_24901(k:IPurchasableOffer):Bool
        {
            var _local_2:IProduct = null;
            var _local_3 = false;
            if (k != null)
            {
                if (k.pricingModel == Offer.PRICING_MODEL_SINGLE)
                {
                    _local_2 = this._offer.product;
                    if (((!(_local_2 == null)) && _local_2.isUniqueLimitedItem))
                    {
                        _local_3 = (_local_2.uniqueLimitedItemsLeft == 0);
                        return _local_3;
                    }
                }
            }
            return false;
        }

        function _Str_10113(k:Bool)
        {
            if (this._catalog.sessionDataManager.isAccountSafetyLocked())
            {
                k = false;
            }
            this._Str_8735("buy_button", k);
        }

        function enableGiftButton(k:Bool)
        {
            if (this._catalog.sessionDataManager.isAccountSafetyLocked())
            {
                k = false;
            }
            this._Str_8735("gift_button", k);
        }

        function _Str_8735(k:String, _arg_2:Bool)
        {
            if (_window == null)
            {
                return;
            }
            var _local_3= _window.findChildByName(k);
            if (_local_3 == null)
            {
                return;
            }
            if (_arg_2)
            {
                _local_3.enable();
                _local_3.blend = 1;
            }
            else
            {
                _local_3.disable();
                _local_3.blend = 0.5;
            }
        }

        function _Str_19234(k:SetExtraPurchaseParameterEvent)
        {
            this._additionalParameters = k.parameter;
            this._Str_10113(this._Str_7923);
            this.enableGiftButton(((((!(this._offer == null)) && this._offer.giftable) && this._Str_7923) && (this._quantity == 1)));
        }

        function _Str_8396(event:WindowMouseEvent, isGift:Bool=false)
        {
            if (!this._catalog.verifyClubLevel(this._offer.clubLevel))
            {
                this._catalog.openClubCenter();
                return;
            }
            this._catalog.purchaseWillBeGift(isGift);
            if (this._purchaseCallback == null)
            {
                if (this._offer != null)
                {
                    if (((!(this._catalog.roomAdPurchaseData == null)) && (this._catalog.roomAdPurchaseData.offerId == this._offer.offerId)))
                    {
                        if (this._catalog.roomAdPurchaseData.flatId == 0)
                        {
                            this._catalog.windowManager.alert("${roomad.error.title}", "${roomad.alert.no.available.room}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
                            {
                                k.dispose();
                            });
                            return;
                        }
                        if ((((this._catalog.roomAdPurchaseData.name == null) || (this._catalog.roomAdPurchaseData.name.length < 5)) || (this._catalog.roomAdPurchaseData.name.substr(0, 1) == " ")))
                        {
                            this._catalog.windowManager.alert("${roomad.error.title}", "${roomad.alert.name.empty}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
                            {
                                k.dispose();
                            });
                            return;
                        }
                    }
                    this._catalog.showPurchaseConfirmation(this._offer, page.pageId, this._additionalParameters, this._quantity, this._previewStuffData, null, true, null);
                }
            }
            else
            {
                this._purchaseCallback(event);
            }
        }

        function _Str_18825(k:WindowMouseEvent)
        {
            this._Str_8396(k, true);
            HabboTracking.getInstance().trackEventLog("Catalog", "click", "client.buy_as_gift.clicked");
        }

        function _Str_25569(k:CatalogWidgetInitPurchaseEvent)
        {
            if (this._offer != null)
            {
                this._catalog.showPurchaseConfirmation(this._offer, page.pageId, this._additionalParameters, this._quantity, this._previewStuffData, null, true, null);
            }
        }

        function _Str_25989(k:WindowMouseEvent)
        {
            this._catalog.rememberPageDuringVipPurchase(page.pageId);
            this._catalog.openClubCenter();
            HabboTracking.getInstance().trackEventLog("Catalog", "click", "BUY_CLUB");
        }

        function _Str_20167(k:SetRoomPreviewerStuffDataEvent)
        {
            this._previewStuffData = k.stuffData;
        }

        function _Str_25792(k:CatalogWidgetSpinnerEvent)
        {
            this._quantity = k.value;
            if (this._quantity > 1)
            {
                this.enableGiftButton(false);
            }
            else
            {
                if (((!(this._offer == null)) && this._Str_7923))
                {
                    this.enableGiftButton(this._offer.giftable);
                }
            }
        }

        function _Str_22307(k:_Str_3308)
        {
            this._extraParamRequired = true;
            this._Str_10113(this._Str_7923);
            this.enableGiftButton((((!(this._offer == null)) && this._Str_7923) && (this._quantity == 1)));
        }
    }

