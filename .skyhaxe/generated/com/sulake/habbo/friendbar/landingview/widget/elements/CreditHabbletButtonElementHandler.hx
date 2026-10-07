package com.sulake.habbo.friendbar.landingview.widget.elements
;
     class CreditHabbletButtonElementHandler extends AbstractButtonElementHandler 
    {


        override function onClick()
        {
            landingView.catalog.openCreditsHabblet();
            landingView.tracking.trackGoogle("landingView", "click_credithabblet");
        }
public function new(){	super();
}
    }

