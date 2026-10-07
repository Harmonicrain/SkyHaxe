package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.communication.messages.incoming.competition.SecondsUntilMessageEvent;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.habbo.communication.messages.outgoing.competition.GetSecondsUntilMessageComposer;

     class CustomTimerElementHandler extends AbstractTimerElementHandler 
    {
        var _timeStr:String;


        override public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            super.initialize(k, _arg_2, _arg_3, _arg_4);
            this._timeStr = _arg_3[6];
            k.communicationManager.addHabboConnectionMessageEvent(new SecondsUntilMessageEvent(this._Str_24489));
        }

        override public function refresh()
        {
            landingView.send(new GetSecondsUntilMessageComposer(this._timeStr));
        }

        function _Str_24489(k:SecondsUntilMessageEvent)
        {
            if (k.getParser()._Str_23288 == this._timeStr)
            {
                _Str_14169(k.getParser()._Str_25497);
            }
        }
public function new(){	super();
}
    }

