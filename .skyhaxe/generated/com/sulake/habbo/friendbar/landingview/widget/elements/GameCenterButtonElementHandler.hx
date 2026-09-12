package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class GameCenterButtonElementHandler extends AbstractButtonElementHandler 
    {
        var _gameName:String;


        override public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            super.initialize(k, _arg_2, _arg_3, _arg_4);
            this._gameName = _arg_3[2];
        }

        override function onClick()
        {
            if (ASCompat.stringAsBool(this._gameName))
            {
                landingView.openGameCenterByGameName(this._gameName);
            }
            else
            {
                landingView.openGameCenter();
            }
            landingView.tracking.trackGoogle("landingView", "click_gamecenter");
        }
public function new(){	super();
}
    }

