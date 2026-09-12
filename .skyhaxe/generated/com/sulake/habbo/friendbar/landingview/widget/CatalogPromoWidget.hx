package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;

     class CatalogPromoWidget implements ILandingViewWidget implements  ISettingsAwareWidget 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _targetCatalogPageName:String;
        var _disposed:Bool = false;

        public function new(k:HabboLandingView)
        {
            this._landingView = k;
        }

        var xmlAssetName(get,never):String;
function  get_xmlAssetName():String
        {
            return "catalog_promo";
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow(this.xmlAssetName), IWindowContainer);
            this._targetCatalogPageName = this._landingView.getProperty("landing.view.catalog.promo.target");
            var k= cast(this._container.findChildByName("picture"), IStaticBitmapWrapperWindow);
            k.assetUri = this._landingView.getProperty("landing.view.catalog.promo.image.uri");
            this._container.findChildByName("open_page_button").addEventListener(WindowMouseEvent.CLICK, this._Str_24375);
            if (((this._targetCatalogPageName == "") && (k.assetUri == "")))
            {
                this._container.visible = false;
            }
            else
            {
                this._container.visible = true;
            }
            var _local_2= new Map();
            _local_2.add("catalog_promo_caption", "landing.view.catalog.promo.caption");
            _local_2.add("catalog_promo_info", "landing.view.catalog.promo.info");
            _local_2.add("open_page_button", "landing.view.catalog.open.page");
            _local_2.add("catalog_promo_picture_text", "landing.view.catalog.promo.picture.text");
            _local_2.add("catalog_promo_title", "landing.view.catalog.promo.title");
            var _local_3 = 0;
            while ((_local_3 : UInt) < _local_2.length)
            {
                this._Str_22932(_local_2.getKeys()[_local_3], _local_2.getValues()[_local_3], this._targetCatalogPageName);
                _local_3++;
            }
        }

        public function refresh()
        {
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                this._landingView = null;
                if (this._container != null)
                {
                    this._container.dispose();
                    this._container = null;
                }
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function _Str_24375(k:WindowMouseEvent)
        {
            this._landingView.catalog.openCatalogPage(this._targetCatalogPageName);
        }

        function _Str_22932(k:String, _arg_2:String, _arg_3:String)
        {
            var _local_5:IWindow = null;
            var _local_4= this._landingView.localizationManager.getLocalizationRaw(((_arg_2 + ".") + _arg_3));
            if (_local_4 != null)
            {
                _local_5 = this._container.findChildByName(k);
                if (_local_5 != null)
                {
                    _local_5.caption = (((("${" + _arg_2) + ".") + _arg_3) + "}");
                }
            }
        }

        public var settings(never,set):CommonWidgetSettings;
public function  set_settings(k:CommonWidgetSettings):CommonWidgetSettings        {
            WidgetContainerLayout.applyCommonWidgetSettings(this._container, k);
return k;
        }
    }


