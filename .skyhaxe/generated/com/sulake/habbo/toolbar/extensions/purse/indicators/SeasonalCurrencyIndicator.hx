package com.sulake.habbo.toolbar.extensions.purse.indicators
;
    import com.sulake.habbo.toolbar.extensions.purse.CurrencyIndicatorBase;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.localization.ICoreLocalizationManager;
    import com.sulake.habbo.catalog.purse.PurseEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.core.window.events.WindowMouseEvent;

     class SeasonalCurrencyIndicator extends CurrencyIndicatorBase 
    {
        static inline final _Str_3591:UInt = 0xFF78746D;
        static inline final _Str_3385:UInt = 0xFF55534E;
        static final _Str_8605:Array<ASAny> = ["toolbar_credit_icon_0", "toolbar_credit_icon_1", "toolbar_credit_icon_2", "toolbar_credit_icon_1", "toolbar_credit_icon_0"];

        var _catalog:IHabboCatalog;
        var _Str_4692:Int = -1;
        var _habboToolbar:HabboToolbar;
		var currencyId:Int = -1;

        public function new(k:HabboToolbar, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboCatalog, _arg_5:ICoreLocalizationManager, currencyId:Int = -1)
        {
            super(_arg_2, _arg_3);
			this.currencyId = currencyId;
            this._habboToolbar = k;
			if (this.currencyId == -1)
			{
				this.currencyId = this._habboToolbar.getInteger("seasonalcurrencyindicator.currency", 1);
			}
            this._catalog = _arg_4;
            this._Str_19567 = _Str_3591;
            this._Str_21715 = _Str_3385;
            this._Str_15051 = "amount";
            this._Str_8446 = _arg_5.getLocalization("purse.snowflakes.zero.amount.text", "Info");
            createWindow("purse_indicator_seasonal_xml", null);
            window.findChildByName("seasonal_icon").style = ActivityPointTypeEnum.getIconStyleFor(this._Str_20938(), k, true);
            this.setAmount(0);
            k.extensionView.attachExtension(ToolbarDisplayExtensionIds.PURSE_SEASONAL_CURRENCY, window, ExtensionFixedSlotsEnum._Str_18616);
            this.registerUpdateEvents(_arg_4.events);
        }

        function _Str_20938():Int
        {
            return this.currencyId;
        }

        function _Str_25094():String
        {
            return this._habboToolbar.getProperty("seasonalcurrencyindicator.page");
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(PurseEvent.CATALOG_PURSE_ACTIVITY_POINT_BALANCE, this._Str_21326);
        }

        override function onContainerClick(k:WindowMouseEvent)
        {
            this._catalog.openCatalogPage(this._Str_25094());
        }

        public function _Str_21326(k:PurseEvent)
        {
            if (k.activityPointType == this._Str_20938())
            {
                this.setAmount(k.balance);
                if (this._Str_4692 != -1)
                {
                    _Str_19581(this._Str_4692, k.balance);
                }
                this._Str_4692 = k.balance;
            }
        }

        override function setAmount(k:Int, _arg_2:Int=-1)
        {
            var _local_3= Std.string(k);
            if (k == 0)
            {
                _local_3 = this._Str_8446;
                _Str_13549(true);
            }
            else
            {
                _Str_13549(false);
            }
            setText(_local_3);
        }
    }

