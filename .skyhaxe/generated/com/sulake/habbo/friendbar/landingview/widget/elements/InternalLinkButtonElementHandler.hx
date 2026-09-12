package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class InternalLinkButtonElementHandler extends AbstractButtonElementHandler 
    {
        var _link:String;
        var _configurationCode:String;


        override public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            super.initialize(k, _arg_2, _arg_3, _arg_4);
            this._link = _arg_3[2];
            this._configurationCode = _arg_4._Str_12275;
        }

        override function onClick()
        {
            landingView.context.createLinkEvent(this._link);
            landingView.tracking.trackEventLog("LandingView", this._configurationCode, "client_link", this._link);
        }
public function new(){	super();
}
    }

