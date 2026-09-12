package com.sulake.habbo.friendbar.landingview.widget.elements
;
     class GoToHomeRoomButtonElementHandler extends AbstractButtonElementHandler 
    {
        override function onClick()
        {
            landingView.questEngine.reenableRoomCompetitionWindow();
            landingView.navigator.goToHomeRoom();
            landingView.tracking.trackGoogle("landingView", "click_gotohomeroom");
        }
public function new(){	super();
}
    }

