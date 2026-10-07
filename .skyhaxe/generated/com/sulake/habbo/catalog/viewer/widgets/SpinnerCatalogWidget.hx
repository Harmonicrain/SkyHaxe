package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import flash.utils.Timer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetSpinnerEvent;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class SpinnerCatalogWidget extends CatalogWidget
    {
        static inline final _Str_18462= 75;
        static inline final _Str_14344= 35;

        var _catalog:HabboCatalog;
        var _value:Int = 1;
        var _minValue:Int = 1;
        var _maxValue:Int = 100;
        var _spinTimer:Timer;
        var _moreButtonDown:Bool = false;
        var _lessButtonDown:Bool = false;
        var _ignoreNextClickEvent:Bool = false;
        var _holdStartedAt:Int = 1;
        var _skipSteps:Array<ASAny>;
        var _promoInfo:IWindow;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            this._skipSteps = ASCompat.allocArray(0);
            super(k);
            this._catalog = _arg_2;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                if (this._spinTimer != null)
                {
                    this._spinTimer.stop();
                    this._spinTimer = null;
                }
                events.removeEventListener(CatalogWidgetSpinnerEvent.CWSE_RESET, this._Str_21604);
                events.removeEventListener(CatalogWidgetSpinnerEvent.CWSE_SHOW, this._Str_10637);
                events.removeEventListener(CatalogWidgetSpinnerEvent.CWSE_HIDE, this._Str_10890);
                events.removeEventListener(CatalogWidgetSpinnerEvent.CWSE_SET_MAX, this._Str_19953);
                events.removeEventListener(CatalogWidgetSpinnerEvent.CWSE_SET_MIN, this._Str_20928);
                super.dispose();
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            _Str_2819(CatalogWidgetEnum.SPINNER);
            window.visible = false;
            if (!this._catalog.multiplePurchaseEnabled)
            {
                return true;
            }
            window.procedure = this._Str_24619;
            var k= Std.downcast(window.findChildByName("text_value") , ITextFieldWindow);
            if (k != null)
            {
                k.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_22259);
            }
            events.addEventListener(CatalogWidgetSpinnerEvent.CWSE_RESET, this._Str_21604);
            events.addEventListener(CatalogWidgetSpinnerEvent.CWSE_SHOW, this._Str_10637);
            events.addEventListener(CatalogWidgetSpinnerEvent.CWSE_HIDE, this._Str_10890);
            events.addEventListener(CatalogWidgetSpinnerEvent.CWSE_SET_MAX, this._Str_19953);
            events.addEventListener(CatalogWidgetSpinnerEvent.CWSE_SET_MIN, this._Str_20928);
            this._spinTimer = new Timer(_Str_18462);
            this._spinTimer.addEventListener(TimerEvent.TIMER, (this._Str_22918 : ASAny));
            this._promoInfo = window.findChildByName("promo.info");
            return true;
        }

        function refresh()
        {
            var k = 0;
            this._value = Std.int(Math.max(this._value, this._minValue));
            this._value = Std.int(Math.min(this._value, this._maxValue));
            events.dispatchEvent(new CatalogWidgetSpinnerEvent(CatalogWidgetSpinnerEvent.CWSE_VALUE_CHANGED, this._value));
            this._Str_23729(Std.string(this._value));
            if (this._promoInfo != null)
            {
                k = this._catalog.utils._Str_20487(this._value);
                window.findChildByName("discountContainer").visible = (k > 0);
                this._catalog.localization.registerParameter("catalog.bundlewidget.discount", "amount", Std.string(k));
            }
        }

        function _Str_21604(k:CatalogWidgetSpinnerEvent)
        {
            this._value = k.value;
            if (k._Str_21173 != null)
            {
                this._skipSteps = k._Str_21173;
            }
            this.refresh();
        }

        function _Str_10637(k:CatalogWidgetSpinnerEvent)
        {
            window.visible = true;
        }

        function _Str_10890(k:CatalogWidgetSpinnerEvent)
        {
            window.visible = false;
        }

        function _Str_19953(k:CatalogWidgetSpinnerEvent)
        {
            this._maxValue = k.value;
        }

        function _Str_20928(k:CatalogWidgetSpinnerEvent)
        {
            this._minValue = k.value;
        }

        function _Str_22918(k:TimerEvent)
        {
            if (disposed)
            {
                return;
            }
            this._ignoreNextClickEvent = true;
            if (this._moreButtonDown)
            {
                this._Str_18793();
                if ((this._value - this._holdStartedAt) > _Str_14344)
                {
                    this._Str_18793();
                }
            }
            if (this._lessButtonDown)
            {
                this._Str_15984();
                if ((this._holdStartedAt - this._value) > _Str_14344)
                {
                    this._Str_15984();
                }
            }
            this.refresh();
        }

        function _Str_18793()
        {
            var k= (this._value + 1);
            while (this._skipSteps.indexOf(k) != -1)
            {
                k++;
            }
            this._value = k;
        }

        function _Str_15984()
        {
            var k= (this._value - 1);
            while (this._skipSteps.indexOf(k) != -1)
            {
                k--;
            }
            this._value = k;
        }

        function _Str_23729(k:String)
        {
            if (_window == null)
            {
                return;
            }
            if (Std.is(_window.findChildByName("text_value") , ITextFieldWindow))
            {
                if (_window.findChildByName("text_value").caption.length > 0)
                {
                    _window.findChildByName("text_value").caption = k;
                }
            }
            else
            {
                _window.findChildByName("text_value").caption = k;
            }
        }

        function _Str_24619(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k == null)
            {
                return;
            }
            if (((((!(k.type == WindowMouseEvent.CLICK)) && (!(k.type == WindowMouseEvent.DOWN))) && (!(k.type == WindowMouseEvent.UP))) && (!(k.type == WindowMouseEvent.UP_OUTSIDE))))
            {
                return;
            }
            switch (k.target.name)
            {
                case "button_less":
                    switch (k.type)
                    {
                        case WindowMouseEvent.DOWN:
                            this._lessButtonDown = true;
                            this._holdStartedAt = this._value;
                            this._spinTimer.start();
                            
                        case WindowMouseEvent.UP
                           | WindowMouseEvent.UP_OUTSIDE:
                            this._lessButtonDown = false;
                            this._spinTimer.stop();
                            
                        case WindowMouseEvent.CLICK:
                            if (!this._ignoreNextClickEvent)
                            {
                                this._Str_15984();
                            }
                            this.refresh();
                            this._ignoreNextClickEvent = false;
                            
                    }
                    return;
                case "button_more":
                    switch (k.type)
                    {
                        case WindowMouseEvent.DOWN:
                            this._moreButtonDown = true;
                            this._holdStartedAt = this._value;
                            this._spinTimer.start();
                            
                        case WindowMouseEvent.UP
                           | WindowMouseEvent.UP_OUTSIDE:
                            this._moreButtonDown = false;
                            this._spinTimer.stop();
                            
                        case WindowMouseEvent.CLICK:
                            if (!this._ignoreNextClickEvent)
                            {
                                this._Str_18793();
                            }
                            this.refresh();
                            this._ignoreNextClickEvent = false;
                            
                    }
                    return;
            }
        }

        function _Str_22259(k:WindowKeyboardEvent)
        {
            this._value = ASCompat.parseInt(k.target.caption);
            this.refresh();
        }
    }

