package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.communication.messages.incoming.competition.IsUserPartOfCompetitionMessageEvent;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.habbo.communication.messages.outgoing.competition.GetIsUserPartOfCompetitionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.competition.ForwardToASubmittableRoomMessageComposer;

     class SubmitCompetitionRoomElementHandler extends AbstractButtonElementHandler 
    {
        var _submittedKey:String;
        var _goalCode:String;
        var _isPartOf:Bool = false;
        var _targetId:Int = 0;


        override public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            super.initialize(k, _arg_2, _arg_3, _arg_4);
            this._submittedKey = _arg_3[2];
            this._goalCode = _arg_3[3];
            k.communicationManager.addHabboConnectionMessageEvent(new IsUserPartOfCompetitionMessageEvent(this.onInfo));
        }

        override public function refresh()
        {
            super.refresh();
            landingView.send(new GetIsUserPartOfCompetitionMessageComposer(this._goalCode));
        }

        override function onClick()
        {
            landingView.questEngine.reenableRoomCompetitionWindow();
            if (this._isPartOf)
            {
                landingView.navigator.goToPrivateRoom(this._targetId);
                landingView.tracking.trackGoogle("landingView", "click_submittedroom");
            }
            else
            {
                landingView.send(new ForwardToASubmittableRoomMessageComposer());
                landingView.tracking.trackGoogle("landingView", "click_startsubmit");
            }
        }

        function onInfo(k:IsUserPartOfCompetitionMessageEvent)
        {
            this._isPartOf = k.getParser()._Str_25348;
            this._targetId = k.getParser()._Str_10760;
            if (this._isPartOf)
            {
                window.caption = (("${" + this._submittedKey) + "}");
            }
        }
public function new(){	super();
}
    }

