package com.sulake.habbo.friendbar.landingview.widget.elements
;
     class BuyVipButtonElementHandler extends AbstractButtonElementHandler 
    {
        override function onClick()
        {
            landingView.catalog.openClubCenter();
            landingView.tracking.trackGoogle("landingView", "click_buyVip");
        }
public function new(){	super();
}
    }

