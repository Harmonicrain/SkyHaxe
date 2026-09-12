package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.session.product.IProductDataListener;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.catalog.LimitedOfferAppearingNextMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetLimitedOfferAppearingNextComposer;
    import flash.events.TimerEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ICountdownWidget;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;

     class NextLimitedRareCountdownWidget implements ILandingViewWidget implements  IProductDataListener implements  ISettingsAwareWidget 
    {
        static final _Str_3981:Float = (30 * 1000);//30000

        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _appearsInSeconds:Int = 0;
        var _pageId:Int = 0;
        var _offerId:Int = 0;
        var _productType:String;
        var _lastRequestTime:Date;
        var _modeSwitchTimer:Timer;

        public function new(k:HabboLandingView)
        {
            this._landingView = k;
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (this._modeSwitchTimer != null)
                {
                    this._modeSwitchTimer.stop();
                    this._modeSwitchTimer = null;
                }
                this._landingView = null;
                this._container = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._container == null;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("next_ltd_available"), IWindowContainer);
            this._container.findChildByName("get").procedure = this._Str_9063;
            this._container.findChildByName("catalogue_button").procedure = this._Str_9063;
            this._container.visible = false;
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new LimitedOfferAppearingNextMessageEvent(this._Str_23091));
            this._Str_17444(null);
        }

        function _Str_17444(k:TimerEvent)
        {
            if (!this._landingView.getBoolean("next.limited.rare.countdown.widget.disabled"))
            {
                this._landingView.communicationManager.connection.send(new GetLimitedOfferAppearingNextComposer());
            }
        }

        public function refresh()
        {
            if (((this._lastRequestTime == null) || ((this._lastRequestTime.getTime() + _Str_3981) < Date.now().getTime())))
            {
                this._Str_17444(null);
                this._lastRequestTime = Date.now();
            }
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function productDataReady()
        {
            this.refreshContent();
        }

        function refreshContent()
        {
            if (this.disposed)
            {
                return;
            }
            if (this._landingView.getProductData(this._productType, this) != null)
            {
                this._container.findChildByName("get").caption = this._landingView.getProductData(this._productType, this).name;
            }
            if (this._pageId >= 0)
            {
                this._container.visible = true;
                this._container.findChildByName("get").visible = true;
                this._container.findChildByName("countdown").visible = false;
            }
            else
            {
                if (this._appearsInSeconds > 0)
                {
                    this._container.visible = true;
                    this._container.findChildByName("get").visible = false;
                    this._container.findChildByName("countdown").visible = true;
                }
                else
                {
                    this._container.visible = false;
                }
            }
            this._Str_11106();
        }

        function _Str_11106()
        {
            var k= cast(this._container.findChildByName("countdown"), IWidgetWindow);
            var _local_2= cast(k.widget, ICountdownWidget);
            _local_2.seconds = this._appearsInSeconds;
            _local_2.running = true;
        }

        function _Str_24349(k:Int)
        {
            if (k <= 0)
            {
                return;
            }
            if (this._modeSwitchTimer != null)
            {
                this._modeSwitchTimer.stop();
                this._modeSwitchTimer = null;
            }
            this._modeSwitchTimer = new Timer(((k + 1) * 1000), 1);
            this._modeSwitchTimer.addEventListener(TimerEvent.TIMER, (this._Str_17444 : ASAny));
            this._modeSwitchTimer.start();
        }

        function _Str_23091(k:LimitedOfferAppearingNextMessageEvent)
        {
            this._appearsInSeconds = k.getParser()._Str_23051;
            this._pageId = k.getParser().pageId;
            this._offerId = k.getParser().offerId;
            this._productType = k.getParser().productType;
            this.refreshContent();
            this._Str_24349(this._appearsInSeconds);
        }

        function _Str_9063(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._landingView.catalog.openCatalogPageById(this._pageId, this._offerId, CatalogType.NORMAL);
                this._landingView.tracking.trackGoogle("landingView", "click_goToNextLimitedCatalogPage");
            }
        }

        public var settings(never,set):CommonWidgetSettings;
public function  set_settings(k:CommonWidgetSettings):CommonWidgetSettings        {
            WidgetContainerLayout.applyCommonWidgetSettings(this._container, k);
return k;
        }
    }

