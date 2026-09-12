package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetSpinnerEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import flash.events.Event;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IItemListWindow;

     class TotalPriceCatalogWidget extends CatalogWidget
    {
        static inline final TOTALPRICE_CONTAINER= "totalprice_container";
        static inline final PLUS= "plus";
        static inline final AMOUNT_TEXT_LEFT= "amount_text_left";
        static inline final AMOUNT_TEXT_RIGHT= "amount_text_right";
        static inline final TOTAL_LEFT= "total_left";
        static inline final TOTAL_RIGHT= "total_right";
        static inline final CURRENCY_INDICATOR_BITMAP_LEFT= "currency_indicator_bitmap_left";
        static inline final CURRENCY_INDICATOR_BITMAP_RIGHT= "currency_indicator_bitmap_right";

        var _habboCatalog:HabboCatalog;
        var _Str_6654:Int = 0;
        var _Str_5642:Int = 0;
        var _Str_10800:Int = 0;
        var _Str_8846:IWindow;
        var _Str_13390:IWindow;
        var _Str_4850:IWindowContainer;
        var _Str_6091:IWindowContainer;
        var _Str_2769:Int = 1;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._habboCatalog = _arg_2;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this._habboCatalog = null;
                events.removeEventListener(CatalogWidgetSpinnerEvent.CWSE_VALUE_CHANGED, this._Str_20196);
                events.removeEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this._Str_19239);
                this.clear();
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            _Str_2819(CatalogWidgetEnum.TOTAL_PRICE);
            window.visible = false;
            if (!this._habboCatalog.multiplePurchaseEnabled)
            {
                return true;
            }
            events.addEventListener(CatalogWidgetSpinnerEvent.CWSE_VALUE_CHANGED, this._Str_20196);
            events.addEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this._Str_19239);
            events.dispatchEvent(new Event(CatalogWidgetEvent.TOTAL_PRICE_WIDGET_INITIALIZED));
            return true;
        }

        function _Str_20196(k:CatalogWidgetSpinnerEvent)
        {
            this._Str_2769 = k.value;
            this._Str_20864();
        }

        function _Str_19239(k:SelectProductEvent)
        {
            window.visible = k.offer.bundlePurchaseAllowed;
            this._Str_6654 = k.offer.priceInCredits;
            this._Str_5642 = k.offer.priceInActivityPoints;
            this._Str_10800 = k.offer.activityPointType;
            this._Str_2769 = 1;
            this.clear();
            this._Str_18628();
            this._Str_20864();
        }

        function clear()
        {
            this._Str_8846 = null;
            this._Str_13390 = null;
            this._Str_4850 = null;
            this._Str_6091 = null;
            _window.findChildByName(PLUS).visible = false;
            _window.findChildByName(AMOUNT_TEXT_LEFT).visible = false;
            if (_window.findChildByName(TOTAL_LEFT) != null)
            {
                _window.findChildByName(TOTAL_LEFT).visible = false;
            }
            if (_window.findChildByName(TOTAL_RIGHT) != null)
            {
                _window.findChildByName(TOTAL_RIGHT).visible = false;
            }
            _window.findChildByName(CURRENCY_INDICATOR_BITMAP_LEFT).visible = false;
        }

        function _Str_20864()
        {
            var _local_5:IWindow = null;
            var _local_6:IWindow = null;
            var k= (this._Str_2769 * this._Str_6654);
            var _local_2= (this._Str_2769 * this._Str_5642);
            var _local_3= k;
            var _local_4= _local_2;
            if (this._habboCatalog.discountEnabled)
            {
                _local_3 = this._habboCatalog.utils._Str_4488(true, this._Str_6654, this._Str_2769);
                _local_4 = this._habboCatalog.utils._Str_4488(true, this._Str_5642, this._Str_2769);
            }
            if (this._Str_8846 != null)
            {
                this._Str_8846.caption = (this._habboCatalog.discountEnabled ? Std.string(_local_3) : Std.string(k));
            }
            if (this._Str_13390 != null)
            {
                this._Str_13390.caption = (this._habboCatalog.discountEnabled ? Std.string(_local_4) : Std.string(_local_2));
            }
            if (this._Str_4850 != null)
            {
                this._Str_4850.visible = (!(k == _local_3));
                _local_5 = this._Str_4850.findChildByName("text");
                _local_5.caption = (this._Str_4850.visible ? Std.string(k) : "0");
                this._Str_4850.findChildByName("strike").width = _local_5.width;
            }
            if (this._Str_6091 != null)
            {
                this._Str_6091.visible = (!(_local_2 == _local_4));
                _local_6 = this._Str_6091.findChildByName("text");
                _local_6.caption = (this._Str_6091.visible ? Std.string(_local_2) : "0");
                this._Str_6091.findChildByName("strike").width = _local_6.width;
            }
        }

        function _Str_18628()
        {
            var k:IWindow = null;
            var _local_2:IWindow = null;
            if (this._Str_6654 > 0)
            {
                if (this._Str_5642 > 0)
                {
                    this._Str_8846 = _window.findChildByName(AMOUNT_TEXT_LEFT);
                    this._Str_8846.visible = true;
                    this._Str_4850 = Std.downcast(_window.findChildByName(TOTAL_LEFT) , IWindowContainer);
                    if (this._Str_4850 != null)
                    {
                        this._Str_4850.visible = false;
                    }
                    k = _window.findChildByName(CURRENCY_INDICATOR_BITMAP_LEFT);
                    k.visible = true;
                    _window.findChildByName("plus").visible = true;
                }
                else
                {
                    this._Str_8846 = _window.findChildByName(AMOUNT_TEXT_RIGHT);
                    this._Str_4850 = Std.downcast(_window.findChildByName(TOTAL_RIGHT) , IWindowContainer);
                    if (this._Str_4850 != null)
                    {
                        this._Str_4850.visible = false;
                    }
                    k = _window.findChildByName(CURRENCY_INDICATOR_BITMAP_RIGHT);
                }
                if (page.acceptSeasonCurrencyAsCredits)
                {
                    k.style = ActivityPointTypeEnum.getIconStyleFor(this._habboCatalog.getSeasonalCurrencyActivityPointType(), this._habboCatalog, true, true);
                    k.width = 53;
                }
                else
                {
                    k.style = ActivityPointTypeEnum.getIconStyleFor(-1, this._habboCatalog, true);
                    k.width = 22;
                }
            }
            if (this._Str_5642 > 0)
            {
                this._Str_13390 = cast(_window.findChildByName(AMOUNT_TEXT_RIGHT), ITextWindow);
                this._Str_6091 = Std.downcast(_window.findChildByName(TOTAL_LEFT) , IWindowContainer);
                if (this._Str_6091 != null)
                {
                    this._Str_6091.visible = false;
                }
                _local_2 = _window.findChildByName(CURRENCY_INDICATOR_BITMAP_RIGHT);
                _local_2.style = ActivityPointTypeEnum.getIconStyleFor(this._Str_10800, this._habboCatalog, true);
            }
            cast(_window.findChildByName(TOTALPRICE_CONTAINER), IItemListWindow).arrangeListItems();
        }
    }

