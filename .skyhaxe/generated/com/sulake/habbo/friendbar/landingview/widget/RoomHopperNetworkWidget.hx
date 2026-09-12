package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISettingsAwareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class RoomHopperNetworkWidget implements ILandingViewWidget implements  ISettingsAwareWidget 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _disposed:Bool = false;
        var _targetNetworkId:Int = 0;
        var _textElements:Array<ASAny>;

        public function new(k:HabboLandingView)
        {
            this._textElements = new Array<ASAny>();
            this._landingView = k;
            this._textElements.push("title");
            this._textElements.push("header");
            this._textElements.push("info");
        }

        static var xmlAssetName(get,never):String;
static function  get_xmlAssetName():String
        {
            return "room_hopper_network";
        }


        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow(xmlAssetName), IWindowContainer);
            this._targetNetworkId = this._landingView.getInteger("landing.view.roomhopper.network.id", 0);
            var k= cast(this._container.findChildByName("bitmap"), IStaticBitmapWrapperWindow);
            k.assetUri = this._landingView.getProperty("landing.view.roomhopper.image.uri");
            this._container.findChildByName("button").procedure = this._Str_22535;
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

        public var settings(never,set):CommonWidgetSettings;
public function  set_settings(k:CommonWidgetSettings):CommonWidgetSettings        {
            WidgetContainerLayout.applyCommonWidgetSettings(this._container, k);
return k;
        }

        function _Str_22535(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._landingView.navigator.goToRoomNetwork(this._targetNetworkId, false);
            }
        }
    }

