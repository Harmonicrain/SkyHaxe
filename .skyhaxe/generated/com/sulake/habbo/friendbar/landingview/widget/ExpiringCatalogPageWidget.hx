package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageWithEarliestExpiryMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetCatalogPageWithEarliestExpiryComposer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ICountdownWidget;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.CatalogPageWithEarliestExpiryMessageParser;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;

     class ExpiringCatalogPageWidget implements ILandingViewWidget implements  ISettingsAwareWidget 
    {
        static final _Str_3981:Float = (30 * 1000);//30000

        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _pageName:String = "";
        var _secondsToExpiry:Int = 0;
        var _teaserImage:String;
        var _lastRequestTime:Date;

        public function new(k:HabboLandingView)
        {
            this._landingView = k;
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            this._landingView = null;
            this._container = null;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("expiring_catalog_page"), IWindowContainer);
            this._container.findChildByName("open_catalog_button").procedure = this._Str_9063;
            this._container.visible = false;
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new CatalogPageWithEarliestExpiryMessageEvent(this.onCatalogPage));
            HabboLandingView._Str_9079(this._container, "page_expiry_title", "hdr_line");
        }

        public function refresh()
        {
            if (((this._lastRequestTime == null) || ((this._lastRequestTime.getTime() + _Str_3981) < Date.now().getTime())))
            {
                this._landingView.send(new GetCatalogPageWithEarliestExpiryComposer());
                this._lastRequestTime = Date.now();
            }
        }

        function refreshContent()
        {
            if (this._pageName == "")
            {
                this._container.visible = false;
                return;
            }
            this._container.visible = true;
            this._container.findChildByName("page_header_txt").caption = this.getText("landing.view.pageexpiry", ("page." + this._pageName), "header");
            this._container.findChildByName("page_desc_txt").caption = this.getText("landing.view.pageexpiry", ("page." + this._pageName), "desc");
            var k= cast(this._container.findChildByName("promo_bitmap"), IStaticBitmapWrapperWindow);
            k.assetUri = (("${image.library.url}reception/catalog_teaser_" + this._pageName) + ".png");
            this._Str_11106();
        }

        function _Str_11106()
        {
            var k= cast(this._container.findChildByName("countdown_widget"), IWidgetWindow);
            var _local_2= cast(k.widget, ICountdownWidget);
            _local_2.seconds = this._secondsToExpiry;
        }

        function getText(k:String, _arg_2:String, _arg_3:String):String
        {
            var _local_4= (((k + (this._Str_24631 ? "" : ("." + _arg_2))) + ".") + _arg_3);
            return ("${" + _local_4) + "}";
        }

        var _Str_24631(get,never):Bool;
function  get__Str_24631():Bool
        {
            return false;
        }

        function _Str_9063(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._landingView.catalog.openCatalogPage(this._pageName);
                this._landingView.tracking.trackGoogle("landingView", "click_goToExpiringCatalogPage");
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        function onCatalogPage(k:IMessageEvent)
        {
            var _local_2= cast(k.parser, CatalogPageWithEarliestExpiryMessageParser);
            this._pageName = _local_2.pageName;
            this._secondsToExpiry = _local_2._Str_17123;
            this._teaserImage = _local_2.image;
            this.refreshContent();
        }

        public var settings(never,set):CommonWidgetSettings;
public function  set_settings(k:CommonWidgetSettings):CommonWidgetSettings        {
            WidgetContainerLayout.applyCommonWidgetSettings(this._container, k);
return k;
        }
    }





