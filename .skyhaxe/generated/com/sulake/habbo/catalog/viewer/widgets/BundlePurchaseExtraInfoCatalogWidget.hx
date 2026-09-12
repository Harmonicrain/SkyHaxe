package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoViewManager;
    import flash.utils.Timer;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetBundleDisplayExtraInfoEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetSpinnerEvent;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoItemData;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.UpdateableExtraInfoListItem;

     class BundlePurchaseExtraInfoCatalogWidget extends CatalogWidget
    {
        static inline final _Str_17825:UInt = 4000;

        var _habboCatalog:HabboCatalog;
        var _Str_4613:ExtraInfoViewManager;
        var _Str_11260:Int = 1;
        var _Str_6654:Int = 0;
        var _Str_5642:Int = 0;
        var _Str_10800:Int = 0;
        var _Str_25522:String;
        var _Str_6878:Int = -1;
        var _Str_6832:Int = -1;
        var _Str_9708:Int = -1;
        var _Str_16462:Bool = false;
        var _Str_8255:Timer;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._habboCatalog = _arg_2;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this._Str_4613.dispose();
                this._Str_4613 = null;
                this._habboCatalog = null;
                this._Str_8255.stop();
                this._Str_8255.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
                this._Str_8255 = null;
                events.removeEventListener(CatalogWidgetBundleDisplayExtraInfoEvent.CWPPEIE_RESET, this._Str_21011);
                events.removeEventListener(CatalogWidgetBundleDisplayExtraInfoEvent.CWPPEIE_HIDE, this._Str_10890);
                events.removeEventListener(CatalogWidgetSpinnerEvent.CWSE_VALUE_CHANGED, this._Str_10389);
                events.removeEventListener(CatalogWidgetBundleDisplayExtraInfoEvent.CWPPEIE_ITEM_CLICKED, this._Str_20926);
                super.dispose();
            }
        }

        override public function init():Bool
        {
            if (!(this._habboCatalog.multiplePurchaseEnabled && this._habboCatalog.discountEnabled))
            {
                return true;
            }
            this._Str_4613 = new ExtraInfoViewManager(this, this._habboCatalog);
            events.addEventListener(CatalogWidgetBundleDisplayExtraInfoEvent.CWPPEIE_RESET, this._Str_21011);
            events.addEventListener(CatalogWidgetBundleDisplayExtraInfoEvent.CWPPEIE_HIDE, this._Str_10890);
            events.addEventListener(CatalogWidgetSpinnerEvent.CWSE_VALUE_CHANGED, this._Str_10389);
            events.addEventListener(CatalogWidgetBundleDisplayExtraInfoEvent.CWPPEIE_ITEM_CLICKED, this._Str_20926);
            this._Str_8255 = new Timer(_Str_17825, 1);
            this._Str_8255.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
            return true;
        }

        function _Str_20610()
        {
            var k= new ExtraInfoItemData(ExtraInfoItemData._Str_13400);
            k.quantity = this._Str_11260;
            this._Str_6878 = this._Str_4613.addItem(k);
        }

        function _Str_23161(k:Int)
        {
            var _local_2:UpdateableExtraInfoListItem = null;
            var _local_3:ExtraInfoItemData = null;
            if (this._Str_6878 != -1)
            {
                _local_2 = cast(this._Str_4613.getItem(this._Str_6878), UpdateableExtraInfoListItem);
                _local_3 = _local_2.data;
                _local_3.quantity = k;
                _local_2.update(_local_3);
            }
        }

        function _Str_23704()
        {
            if (this._Str_6878 != -1)
            {
                this._Str_4613.removeItem(this._Str_6878);
                this._Str_6878 = -1;
            }
        }

        function _Str_22355()
        {
            var k= new ExtraInfoItemData(ExtraInfoItemData._Str_14097);
            k.quantity = this._Str_11260;
            k.priceActivityPoints = this._Str_5642;
            k.activityPointType = this._Str_10800;
            k.priceCredits = this._Str_6654;
            this._Str_6832 = this._Str_4613.addItem(k);
            this._habboCatalog.utils._Str_25517();
        }

        function _Str_23762(k:Int)
        {
            var _local_2:UpdateableExtraInfoListItem = null;
            var _local_3:ExtraInfoItemData = null;
            if (this._Str_6832 != -1)
            {
                _local_2 = cast(this._Str_4613.getItem(this._Str_6832), UpdateableExtraInfoListItem);
                _local_3 = _local_2.data;
                _local_3.quantity = k;
                _local_3.discountPriceCredits = this._habboCatalog.utils._Str_4488(true, this._Str_6654, k);
                _local_3.discountPriceActivityPoints = this._habboCatalog.utils._Str_4488(true, this._Str_5642, k);
                _local_2.update(_local_3);
            }
        }

        function _Str_24383()
        {
            if (this._Str_6832 != -1)
            {
                this._Str_4613.removeItem(this._Str_6832);
                this._Str_6832 = -1;
            }
        }

        function _Str_22330()
        {
            var k= new ExtraInfoItemData(ExtraInfoItemData._Str_14719);
            this._Str_9708 = this._Str_4613.addItem(k);
            this._habboCatalog.utils._Str_22409();
        }

        function _Str_20722()
        {
            if (this._Str_9708 != -1)
            {
                this._Str_4613.removeItem(this._Str_9708);
                this._Str_9708 = -1;
            }
        }

        function _Str_21011(k:CatalogWidgetBundleDisplayExtraInfoEvent)
        {
            if (disposed)
            {
                return;
            }
            window.visible = true;
            this._Str_6654 = k.data.priceCredits;
            this._Str_5642 = k.data.priceActivityPoints;
            this._Str_10800 = k.data.activityPointType;
            this._Str_25522 = k.data.badgeCode;
            this._Str_4613.clear();
            this._Str_6832 = -1;
            this._Str_6878 = -1;
            this._Str_8255.start();
        }

        function _Str_10389(k:CatalogWidgetSpinnerEvent)
        {
            if (disposed)
            {
                return;
            }
            if (this._habboCatalog.bundleDiscountRuleset == null)
            {
                return;
            }
            if (k.type == CatalogWidgetSpinnerEvent.CWSE_VALUE_CHANGED)
            {
                if (k.value != this._Str_11260)
                {
                    if (((k.value >= this._habboCatalog.bundleDiscountRuleset._Str_9227) && (this._Str_6832 == -1)))
                    {
                        this._Str_22355();
                    }
                    else
                    {
                        if (k.value < this._habboCatalog.bundleDiscountRuleset._Str_9227)
                        {
                            this._Str_24383();
                        }
                    }
                    this._Str_23161(k.value);
                    this._Str_23762(k.value);
                    this._Str_11260 = k.value;
                    this._Str_20722();
                    if (this._Str_11260 >= this._habboCatalog.utils._Str_23617)
                    {
                        this._Str_23704();
                        this._Str_16462 = true;
                    }
                    else
                    {
                        if (this._Str_16462)
                        {
                            this._Str_20610();
                            this._Str_16462 = false;
                        }
                    }
                    this._habboCatalog.utils._Str_25512();
                }
            }
        }

        function _Str_10890(k:CatalogWidgetBundleDisplayExtraInfoEvent)
        {
            window.visible = false;
        }

        function _Str_20926(k:CatalogWidgetBundleDisplayExtraInfoEvent)
        {
            switch (k.id)
            {
                case (_ == this._Str_6878 => true):
                    if (this._Str_9708 == -1)
                    {
                        this._Str_22330();
                    }
                    return;
                case (_ == this._Str_9708 => true):
                    this._Str_20722();
                    return;

default:
            }
        }

        function onTimerComplete(k:TimerEvent)
        {
            this._Str_20610();
        }
    }

