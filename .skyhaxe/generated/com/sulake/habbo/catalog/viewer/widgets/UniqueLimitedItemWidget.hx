package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.window.utils.ILimitedItemOverlay;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import flash.utils.Timer;
    import com.sulake.habbo.window.widgets.ILimitedItemSupplyLeftOverlayWidget;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.ProductOfferUpdatedEvent;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.catalog.viewer.Offer;

     class UniqueLimitedItemWidget extends CatalogWidget
    {
        static inline final _Str_18612= 20000;

        var _habboCatalog:HabboCatalog;
        var _Str_8367:ILimitedItemOverlay;
        var _Str_12055:IPurchasableOffer;
        var _Str_6632:Timer;
        var _Str_17834:ILimitedItemSupplyLeftOverlayWidget;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._habboCatalog = _arg_2;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                if (this._Str_6632 != null)
                {
                    this._Str_6632.stop();
                    this._Str_6632.removeEventListener(TimerEvent.TIMER, (this._Str_19874 : ASAny));
                    this._Str_6632 = null;
                }
                window.visible = false;
                this._habboCatalog = null;
                this._Str_12055 = null;
                if (this._Str_8367 != null)
                {
                    this._Str_8367.dispose();
                    this._Str_8367 = null;
                }
                events.removeEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
                events.removeEventListener(CatalogWidgetEvent.PRODUCT_OFFER_UPDATED, this._Str_20503);
                super.dispose();
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            var k= cast(_window.findChildByName("unique_item_overlay_container"), IWidgetWindow);
            this._Str_17834 = cast(k.widget, ILimitedItemSupplyLeftOverlayWidget);
            window.visible = false;
            events.addEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
            events.addEventListener(CatalogWidgetEvent.PRODUCT_OFFER_UPDATED, this._Str_20503);
            this._Str_6632 = new Timer(_Str_18612);
            this._Str_6632.addEventListener(TimerEvent.TIMER, (this._Str_19874 : ASAny));
            return true;
        }

        function onSelectProduct(k:SelectProductEvent)
        {
            if (k == null)
            {
                return;
            }
            this._Str_12055 = k.offer;
            this.update(k.offer, true);
        }

        function _Str_20503(k:ProductOfferUpdatedEvent)
        {
            this._Str_12055 = k.offer;
            this.update(k.offer);
        }

        function update(k:IPurchasableOffer, _arg_2:Bool=false)
        {
            var _local_3:IProduct = null;
            if (((k.pricingModel == Offer.PRICING_MODEL_SINGLE) && k.product.isUniqueLimitedItem))
            {
                _local_3 = k.product;
                this._Str_17834.supplyLeft = _local_3.uniqueLimitedItemsLeft;
                this._Str_17834.seriesSize = _local_3.uniqueLimitedItemSeriesSize;
                window.visible = true;
                if (_arg_2)
                {
                    this._habboCatalog.sendGetProductOffer(k.offerId);
                }
                this._Str_6632.start();
            }
            else
            {
                window.visible = false;
                this._Str_6632.stop();
            }
        }

        function _Str_19874(k:TimerEvent)
        {
            if ((_window.visible && (!(this._Str_12055 == null))))
            {
                this.update(this._Str_12055, true);
            }
        }
    }

