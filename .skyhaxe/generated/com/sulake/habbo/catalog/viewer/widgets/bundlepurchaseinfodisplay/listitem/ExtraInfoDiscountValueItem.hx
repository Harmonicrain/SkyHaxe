package com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.listitem
;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.UpdateableExtraInfoListItem;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoItemData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.habbo.catalog.HabboCatalogUtils;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.BitmapDataAsset;

     class ExtraInfoDiscountValueItem extends UpdateableExtraInfoListItem 
    {
        static inline final ICON_SPLASH_BITMAP= "icon_splash_bitmap";
        static inline final ICON_BITMAP= "icon_bitmap";
        static inline final TOTAL_CURRENCY_VALUE_LEFT= "total_currency_value_left";
        static inline final TOTAL_CURRENCY_ICON_LEFT= "total_currency_icon_left";
        static inline final STRIKETROUGH_TOTAL_CURRENCY_LEFT= "striketrough_total_currency_left";
        static inline final TOTAL_CURRENCY_VALUE_RIGHT= "total_currency_value_right";
        static inline final TOTAL_CURRENCY_ICON_RIGHT= "total_currency_icon_right";
        static inline final STRIKETROUGH_TOTAL_CURRENCY_RIGHT= "striketrough_total_currency_right";
        static inline final DISCOUNT_CURRENCY_VALUE_LEFT= "discount_currency_value_left";
        static inline final DISCOUNT_CURRENCY_ICON_LEFT= "discount_currency_icon_left";
        static inline final DISCOUNT_CURRENCY_VALUE_RIGHT= "discount_currency_value_right";
        static inline final DISCOUNT_CURRENCY_ICON_RIGHT= "discount_currency_icon_right";
        static inline final STRIKETHROUGH_LEFT_MARGIN= 4;
        static final STRIKETHROUGH_RIGHT_MARGIN:Int = (16 + STRIKETHROUGH_LEFT_MARGIN);//20

        var _window:IWindowContainer = null;
        var _dirty:Bool = true;
        var _catalog:HabboCatalog;
        var _starAnimationOffset:Int = 0;
        var _starAnimationTimer:Timer;
        var _creditsOnLeft:Bool = false;
        var _creditsOnRight:Bool = false;
        var _noCredits:Bool = false;
        var _currencyIconsSet:Bool = false;

        public function new(k:Int, _arg_2:ExtraInfoItemData, _arg_3:HabboCatalog)
        {
            super(null, k, _arg_2, com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoListItem.ALIGN_BOTTOM, true);
            this._catalog = _arg_3;
            this._starAnimationTimer = new Timer(150);
            this._starAnimationTimer.addEventListener(TimerEvent.TIMER, (this.starAnimationTimerEvent : ASAny));
        }

        override public function dispose()
        {
            if (!disposed)
            {
                if (this._starAnimationTimer != null)
                {
                    this._starAnimationTimer.stop();
                    this._starAnimationTimer = null;
                }
                this._catalog = null;
                super.dispose();
            }
        }

        override public function update(k:ExtraInfoItemData)
        {
            super.update(k);
            this._creditsOnLeft = false;
            this._creditsOnRight = false;
            this._noCredits = false;
            if (((k.priceCredits > 0) && (k.priceActivityPoints > 0)))
            {
                this._creditsOnLeft = true;
            }
            else
            {
                if (((k.priceActivityPoints > 0) && (k.priceCredits == 0)))
                {
                    this._noCredits = true;
                }
                else
                {
                    this._creditsOnRight = true;
                }
            }
            this._dirty = true;
            this.render();
            if (!this._currencyIconsSet)
            {
                this.setCurrencyIcons();
            }
        }

        override public function getRenderedWindow():IWindowContainer
        {
            if (this._dirty)
            {
                this.render();
            }
            return this._window;
        }

        function createWindow()
        {
            this._window = cast(this._catalog.utils.createWindow("discountValueItem"), IWindowContainer);
            this.setElementBitmap(ICON_BITMAP, "thumb_up");
            this.startSplashAnimation();
        }

        function render()
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            this.updateColumns();
            this.updatePriceIndicators();
            this.updateStrikeThroughElements();
            this._dirty = false;
        }

        function updateColumns()
        {
            if ((this._noCredits || this._creditsOnRight))
            {
                this.setLeftColumnVisibility(false);
            }
            else
            {
                this.setLeftColumnVisibility(true);
            }
        }

        function setCurrencyIcons()
        {
            if (this._creditsOnLeft)
            {
                this.setIconStyle(TOTAL_CURRENCY_ICON_LEFT, -1);
                this.setIconStyle(DISCOUNT_CURRENCY_ICON_LEFT, -1);
            }
            if (this._creditsOnRight)
            {
                this.setIconStyle(TOTAL_CURRENCY_ICON_RIGHT, -1);
                this.setIconStyle(DISCOUNT_CURRENCY_ICON_RIGHT, -1);
            }
            else
            {
                this.setIconStyle(TOTAL_CURRENCY_ICON_RIGHT, data.activityPointType);
                this.setIconStyle(DISCOUNT_CURRENCY_ICON_RIGHT, data.activityPointType);
            }
            this._currencyIconsSet = true;
        }

        function updatePriceIndicators()
        {
            if (this._creditsOnLeft)
            {
                this.setElementText(TOTAL_CURRENCY_VALUE_LEFT, Std.string((data.quantity * data.priceCredits)));
                this.setElementText(DISCOUNT_CURRENCY_VALUE_LEFT, Std.string(((data.quantity * data.priceCredits) - data.discountPriceCredits)));
            }
            if (this._creditsOnRight)
            {
                this.setElementText(TOTAL_CURRENCY_VALUE_RIGHT, Std.string((data.quantity * data.priceCredits)));
                this.setElementText(DISCOUNT_CURRENCY_VALUE_RIGHT, Std.string(((data.quantity * data.priceCredits) - data.discountPriceCredits)));
            }
            else
            {
                this.setElementText(TOTAL_CURRENCY_VALUE_RIGHT, Std.string((data.quantity * data.priceActivityPoints)));
                this.setElementText(DISCOUNT_CURRENCY_VALUE_RIGHT, Std.string(((data.quantity * data.priceActivityPoints) - data.discountPriceActivityPoints)));
            }
        }

        function updateStrikeThroughElements()
        {
            var k= cast(this._window.findChildByName(TOTAL_CURRENCY_VALUE_LEFT), ITextWindow);
            var _local_2= Std.int((k.x + k.width) - k.textWidth);
            var _local_3= cast(this._window.findChildByName(STRIKETROUGH_TOTAL_CURRENCY_LEFT), IWindowContainer);
            _local_3.x = (_local_2 - STRIKETHROUGH_LEFT_MARGIN);
            _local_3.width = Std.int((STRIKETHROUGH_LEFT_MARGIN + k.textWidth) + STRIKETHROUGH_RIGHT_MARGIN);
            var _local_4= cast(this._window.findChildByName(TOTAL_CURRENCY_VALUE_RIGHT), ITextWindow);
            var _local_5= Std.int((_local_4.x + _local_4.width) - _local_4.textWidth);
            var _local_6= cast(this._window.findChildByName(STRIKETROUGH_TOTAL_CURRENCY_RIGHT), IWindowContainer);
            _local_6.x = (_local_5 - STRIKETHROUGH_LEFT_MARGIN);
            _local_6.width = Std.int((STRIKETHROUGH_LEFT_MARGIN + _local_4.textWidth) + STRIKETHROUGH_RIGHT_MARGIN);
        }

        function setElementText(k:String, _arg_2:String)
        {
            this._window.findChildByName(k).caption = _arg_2;
        }

        function setElementBitmap(k:String, _arg_2:String)
        {
            var _local_3= cast(this._window.findChildByName(k), IBitmapWrapperWindow);
            var _local_4= cast(this._catalog.assets.getAssetByName(_arg_2).content, BitmapData);
            HabboCatalogUtils._Str_14396(_local_3, _local_4);
        }

        function setIconStyle(k:String, _arg_2:Int)
        {
            var _local_3= this._window.findChildByName(k);
            _local_3.style = ActivityPointTypeEnum.getIconStyleFor(_arg_2, this._catalog, false);
        }

        function setLeftColumnVisibility(k:Bool)
        {
            var _local_3:String = null;
            var _local_2:Array<ASAny> = [DISCOUNT_CURRENCY_ICON_LEFT, DISCOUNT_CURRENCY_VALUE_LEFT, TOTAL_CURRENCY_ICON_LEFT, STRIKETROUGH_TOTAL_CURRENCY_LEFT, TOTAL_CURRENCY_VALUE_LEFT];
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                this._window.findChildByName(_local_3).visible = k;
            }
        }

        function startSplashAnimation()
        {
            var k= cast(this._window.findChildByName(ICON_SPLASH_BITMAP), IBitmapWrapperWindow);
            k.bitmap = new BitmapData(k.width, k.height, true, 0);
            this.starAnimationTimerEvent(new TimerEvent(TimerEvent.TIMER));
            this._starAnimationTimer.start();
        }

        function starAnimationTimerEvent(k:TimerEvent)
        {
            var _local_2:IBitmapWrapperWindow = null;
            var _local_3:IAsset = null;
            if (this._window != null)
            {
                _local_2 = cast(this._window.findChildByName(ICON_SPLASH_BITMAP), IBitmapWrapperWindow);
                _local_3 = this._catalog.assets.getAssetByName(("bundle_discount_star_" + Std.string(this._starAnimationOffset)));
                HabboCatalogUtils._Str_14396(_local_2, cast(_local_3.content, BitmapData), cast(_local_3, BitmapDataAsset).rectangle);
                if (++this._starAnimationOffset > 7)
                {
                    this._starAnimationOffset = 0;
                }
            }
        }
    }


