package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.habbo.communication.messages.outgoing.competition.ForwardToRandomCompetitionRoomMessageComposer;

     class GoToCompetitionRoomButtonElementHandler extends AbstractButtonElementHandler 
    {
        var _goalCode:String;


        override public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            super.initialize(k, _arg_2, _arg_3, _arg_4);
            this._goalCode = _arg_3[2];
        }

        override function onClick()
        {
            landingView.questEngine.reenableRoomCompetitionWindow();
            landingView.send(new ForwardToRandomCompetitionRoomMessageComposer(this._goalCode));
            landingView.tracking.trackGoogle("landingView", "click_gotocompetitionroom");
        }
public function new(){	super();
}
    }

