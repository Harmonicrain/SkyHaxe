package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.ILayoutNameProvider;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class AbstractButtonElementHandler implements IElementHandler implements  IDisposable implements  ILayoutNameProvider 
    {
        var _landingView:HabboLandingView;
        var _window:IWindow;


        public var layoutName(get,never):String;
public function  get_layoutName():String
        {
            return "element_button";
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

        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            this._landingView = k;
            this._window = _arg_2;
            var _local_5:String = _arg_3[1];
            _arg_2.procedure = this._Str_17374;
            _arg_2.caption = (("${" + _local_5) + "}");
        }

        function _Str_17374(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.onClick();
            }
        }

        function onClick()
        {
        }

        public function refresh()
        {
        }

        public var landingView(get,never):HabboLandingView;
public function  get_landingView():HabboLandingView
        {
            return this._landingView;
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }

	public function new() {}
    }

