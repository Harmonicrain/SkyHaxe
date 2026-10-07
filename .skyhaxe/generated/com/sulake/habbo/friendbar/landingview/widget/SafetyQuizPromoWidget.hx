package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;

     class SafetyQuizPromoWidget implements ILandingViewWidget 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _disposed:Bool = false;

        public function new(k:HabboLandingView)
        {
            this._landingView = k;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("safety_quiz_promo"), IWindowContainer);
            this._container.procedure = this._Str_16893;
            this.refresh();
        }

        function _Str_16893(k:WindowEvent, _arg_2:IWindow)
        {
            if (((k.type == WindowMouseEvent.CLICK) && (_arg_2.name == "safety_quiz_button")))
            {
                this._landingView.habboHelp.showSafetyBooklet();
            }
        }

        public function refresh()
        {
            if (((!(this._container == null)) && (!this._container.disposed)))
            {
                cast(cast(this._container.findChildByName("avatar"), IWidgetWindow).widget, IAvatarImageWidget).figure = this._landingView.sessionDataManager.figure;
            }
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._container != null)
                {
                    this._container.dispose();
                    this._container = null;
                }
                this._landingView = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }



