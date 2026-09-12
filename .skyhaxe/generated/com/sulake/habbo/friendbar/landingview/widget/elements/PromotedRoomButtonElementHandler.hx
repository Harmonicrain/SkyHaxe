package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;

     class PromotedRoomButtonElementHandler extends AbstractButtonElementHandler 
    {
        var _categoryCode:String;


        override function onClick()
        {
            landingView.goToRoom(this._categoryCode);
            landingView.tracking.trackGoogle("landingView", ("click_promotedroom" + this._categoryCode));
        }

        override public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            super.initialize(k, _arg_2, _arg_3, _arg_4);
            if (_arg_3.length > 1)
            {
                this._categoryCode = _arg_3[2];
            }
        }
public function new(){	super();
}
    }

