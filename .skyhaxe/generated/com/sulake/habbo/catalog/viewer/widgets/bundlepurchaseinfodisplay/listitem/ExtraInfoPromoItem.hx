package com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.listitem
;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.UpdateableExtraInfoListItem;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.catalog.viewer.widgets.BundlePurchaseExtraInfoCatalogWidget;
    import flash.utils.Timer;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoListItem;
    import flash.events.TimerEvent;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoItemData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.catalog.HabboCatalogUtils;
    import flash.display.BitmapData;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetBundleDisplayExtraInfoEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class ExtraInfoPromoItem extends UpdateableExtraInfoListItem 
    {
        static inline final CATALOG_BUNDLEWIDGET_DISCOUNT_PROMO= "catalog.bundlewidget.discount.promo";

        var _window:IWindowContainer = null;
        var _dirty:Bool = true;
        var _catalog:HabboCatalog;
        var _nextDiscountMap:Map;
        var _nextDiscountLevel:Int = 0;
        var _widget:BundlePurchaseExtraInfoCatalogWidget;
        var _effectLayerBlend:Float = 0;
        var _effectTimer:Timer;

        public function new(k:BundlePurchaseExtraInfoCatalogWidget, _arg_2:Int, _arg_3:ExtraInfoItemData, _arg_4:HabboCatalog)
        {
            super(null, _arg_2, _arg_3, ExtraInfoListItem.ALIGN_TOP);
            this._widget = k;
            this._catalog = _arg_4;
            this._Str_22791();
            this._Str_19616();
            this._effectTimer = new Timer(50);
            this._effectTimer.addEventListener(TimerEvent.TIMER, (this._Str_20806 : ASAny));
            this._effectTimer.start();
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this._effectTimer.stop();
                this._effectTimer.removeEventListener(TimerEvent.TIMER, (this._Str_20806 : ASAny));
                this._effectTimer = null;
                this._nextDiscountMap = null;
                this._catalog = null;
                super.dispose();
            }
        }

        override public function update(k:ExtraInfoItemData)
        {
            super.update(k);
            var _local_2= this._nextDiscountLevel;
            this._Str_19616();
            if (this._nextDiscountLevel != _local_2)
            {
                this._effectLayerBlend = 1;
            }
            this._dirty = true;
            this.render();
        }

        override public function getRenderedWindow():IWindowContainer
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            if (this._dirty)
            {
                this.render();
            }
            return this._window;
        }

        function createWindow()
        {
            this._window = cast(this._catalog.utils.createWindow("discountPromoItem"), IWindowContainer);
            this._window.procedure = this.windowProcedure;
            var k= cast(this._window.findChildByName("icon_bitmap"), IBitmapWrapperWindow);
            HabboCatalogUtils._Str_14396(k, cast(this._catalog.assets.getAssetByName("thumb_up").content, BitmapData).clone());
        }

        function render()
        {
            this._catalog.localization.registerParameter(CATALOG_BUNDLEWIDGET_DISCOUNT_PROMO, "quantity", Std.string(this._nextDiscountLevel));
            this._catalog.localization.registerParameter(CATALOG_BUNDLEWIDGET_DISCOUNT_PROMO, "discount", this._nextDiscountMap.getValue(this._nextDiscountLevel));
            var k= this._catalog.localization.getLocalizationRaw(CATALOG_BUNDLEWIDGET_DISCOUNT_PROMO).value;
            this._window.findChildByName("promo_text").caption = k;
            this._window.findChildByName("promo_text_effect").caption = k;
            this._dirty = false;
        }

        function _Str_19616()
        {
            var k= this._nextDiscountMap.getKeys();
            var _local_2 = 0;
            while (_local_2 < k.length)
            {
                if (ASCompat.toInt(k[_local_2]) > data.quantity)
                {
                    this._nextDiscountLevel = ASCompat.toInt(k[_local_2]);
                    return;
                }
                _local_2++;
            }
        }

        function _Str_22791()
        {
            var _local_3 = 0;
            var _local_4 = 0;
            this._nextDiscountMap = new Map();
            var k= 1;
            var _local_2 = 0;
            while (k <= 100)
            {
                _local_3 = this._catalog.utils._Str_4488(true, 1, k);
                _local_4 = (k - _local_3);
                if (((_local_4 > _local_2) && (this._catalog.utils._Str_20096.indexOf(k) == -1)))
                {
                    this._nextDiscountMap.add(k, _local_4);
                    _local_2 = _local_4;
                }
                k++;
            }
        }

        function _Str_20806(k:TimerEvent)
        {
            if (this._effectLayerBlend > 0)
            {
                this._effectLayerBlend = (this._effectLayerBlend - 0.1);
                if (this._effectLayerBlend < 0)
                {
                    this._effectLayerBlend = 0;
                }
                this._window.findChildByName("promo_text_effect").blend = this._effectLayerBlend;
            }
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (_arg_2.name == "click_region")
            {
                switch (k.type)
                {
                    case WindowMouseEvent.CLICK:
                        this._widget.events.dispatchEvent(new CatalogWidgetBundleDisplayExtraInfoEvent(CatalogWidgetBundleDisplayExtraInfoEvent.CWPPEIE_ITEM_CLICKED, data, id));
                        return;
                    case WindowMouseEvent.OVER:
                        cast(this._window.findChildByName("promo_text"), ITextWindow).textColor = 12582911;
                        return;
                    case WindowMouseEvent.OUT:
                        cast(this._window.findChildByName("promo_text"), ITextWindow).textColor = 0xFFFFFF;
                        return;
                }
            }
        }
    }

