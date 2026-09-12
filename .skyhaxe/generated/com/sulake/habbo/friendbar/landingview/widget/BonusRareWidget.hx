package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.session.product.IProductDataListener;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.BonusRareInfoMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetBonusRareInfoMessageComposer;
    import com.sulake.core.window.IWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;

     class BonusRareWidget implements ILandingViewWidget implements  IProductDataListener implements  ISettingsAwareWidget implements  IGetImageListener 
    {
        var _habboLandingView:HabboLandingView;
        var _container:IWindowContainer;
        var _productType:String;
        var _Str_4261:Int = -1;
        var _Str_5859:Int = 0;
        var _Str_7388:Int = 0;

        public function new(k:HabboLandingView)
        {
            this._habboLandingView = k;
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                this._habboLandingView.roomEngine.events.removeEventListener(RoomEngineEvent.ENGINE_INITIALIZED, this.onRoomEngineInitialized);
                this._habboLandingView.communicationManager.removeHabboConnectionMessageEvent(new BonusRareInfoMessageEvent(this._Str_21615));
                this._habboLandingView = null;
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
            this._container = cast(this._habboLandingView.getXmlWindow("bonus_rare_promo"), IWindowContainer);
            this._container.findChildByName("buy_button").procedure = this._Str_25025;
            this._container.visible = false;
            this._habboLandingView.communicationManager.addHabboConnectionMessageEvent(new BonusRareInfoMessageEvent(this._Str_21615));
            this._habboLandingView.roomEngine.events.addEventListener(RoomEngineEvent.ENGINE_INITIALIZED, this.onRoomEngineInitialized);
            this._Str_19551();
        }

        function _Str_19551()
        {
            this._habboLandingView.communicationManager.connection.send(new GetBonusRareInfoMessageComposer());
        }

        public function refresh()
        {
            this._Str_19551();
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

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            this.refreshContent();
        }

        public function imageFailed(k:Int)
        {
        }

        function onRoomEngineInitialized(k:RoomEngineEvent)
        {
            this.refreshContent();
        }

        function refreshContent()
        {
            if (this.disposed)
            {
                return;
            }
            this._container.visible = (!(this._Str_4261 == -1));
            var k= this._habboLandingView.getProductData(this._productType, this);
            if (k != null)
            {
                cast(this._container.findChildByName("promo_image"), IStaticBitmapWrapperWindow).assetUri = this._habboLandingView.getProperty("landing.view.bonus.rare.image.uri");
                this._container.findChildByName("header").caption = this._habboLandingView.localizationManager.getLocalizationWithParams("landing.view.bonus.rare.header", "", ["rarename", k.name, "amount", this._Str_5859]);
                this._container.findChildByName("status").caption = this._habboLandingView.localizationManager.getLocalizationWithParams("landing.view.bonus.rare.status", "", ["amount", this._Str_7388, "total", this._Str_5859]);
                this._Str_11199((this._Str_5859 - this._Str_7388), this._Str_5859);
            }
        }

        function _Str_21615(k:BonusRareInfoMessageEvent)
        {
            this._productType = k.getParser().productType;
            this._Str_4261 = k.getParser().productClassId;
            this._Str_5859 = k.getParser()._Str_25710;
            this._Str_7388 = k.getParser()._Str_25484;
            this.refreshContent();
        }

        function _Str_25025(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._habboLandingView.tracking.trackGoogle("landingView", "click_bonusRarePromoOpenCreditsPage");
                this._habboLandingView.catalog.openCreditsHabblet();
            }
        }

        public var settings(never,set):CommonWidgetSettings;
public function  set_settings(k:CommonWidgetSettings):CommonWidgetSettings        {
            WidgetContainerLayout.applyCommonWidgetSettings(this._container, k);
return k;
        }

        function _Str_11199(k:Int, _arg_2:Int)
        {
            var _local_3= this._container.findChildByName("bar_a_bkg").width;
            var _local_4= this._container.findChildByName("bar_a_bkg").x;
            var _local_5= Std.int((k / _arg_2) * _local_3);
            this._container.findChildByName("bar_a_c").width = _local_5;
            this._container.findChildByName("bar_a_r").x = (_local_5 + _local_4);
        }
    }

