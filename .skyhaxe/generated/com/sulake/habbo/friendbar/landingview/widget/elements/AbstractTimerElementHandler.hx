package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IFloatingElement;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.ILayoutNameProvider;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ICountdownWidget;

     class AbstractTimerElementHandler implements IElementHandler implements  IDisposable implements  IFloatingElement implements  ILayoutNameProvider 
    {
        var _landingView:HabboLandingView;
        var _window:IWindowContainer;
        var _floating:Bool = false;
        var _timeRemainingKey:String;
        var _expiredKey:String;


        public var layoutName(get,never):String;
public function  get_layoutName():String
        {
            return "element_timer";
        }

        public function _Str_7806(k:Bool):Bool
        {
            return this._floating;
        }

        public function dispose()
        {
            this._landingView = null;
            this._window = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        public function refresh()
        {
        }

        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            this._landingView = k;
            this._window = cast(_arg_2, IWindowContainer);
            this._floating = (_arg_3[1] == "true");
            this._timeRemainingKey = _arg_3[4];
            this._expiredKey = _arg_3[5];
            this._Str_4180(null);
            if (this._floating)
            {
                this._window.x = ASCompat.toInt(_arg_3[2]);
                this._window.y = ASCompat.toInt(_arg_3[3]);
            }
        }

        function _Str_14169(k:Int)
        {
            var _local_2= cast(this._window.findChildByName("countdown_widget"), IWidgetWindow);
            _local_2.visible = (k > 0);
            var _local_3= cast(_local_2.widget, ICountdownWidget);
            _local_3.seconds = k;
            this._Str_4180(((k > 0) ? this._timeRemainingKey : this._expiredKey));
        }

        function _Str_4180(k:String)
        {
            var _local_2= this._window.findChildByName("timer_caption_txt");
            var _local_3= ((!(k == null)) && (!(k == "")));
            _local_2.visible = _local_3;
            if (_local_3)
            {
                _local_2.caption = (("${" + k) + "}");
            }
        }

        public var landingView(get,never):HabboLandingView;
public function  get_landingView():HabboLandingView
        {
            return this._landingView;
        }

	public function new() {}
    }

