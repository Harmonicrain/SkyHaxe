package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class GoToRoomButtonElementHandler extends AbstractButtonElementHandler 
    {
        var _roomId:Int = 0;


        override public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            super.initialize(k, _arg_2, _arg_3, _arg_4);
            this._roomId = ASCompat.toInt(_arg_3[2]);
        }

        override function onClick()
        {
            landingView.navigator.goToPrivateRoom(this._roomId);
            landingView.tracking.trackGoogle("landingView", "click_gotoroom");
        }
public function new(){	super();
}
    }

