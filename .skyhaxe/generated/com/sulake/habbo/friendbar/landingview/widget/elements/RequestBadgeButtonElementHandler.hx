package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IFloatingElement;
    import com.sulake.habbo.communication.messages.incoming.inventory.badges.IsBadgeRequestFulfilledEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredRewardResultMessageEvent;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.habbo.communication.messages.outgoing.inventory.badges.GetIsBadgeRequestFulfilledComposer;

     class RequestBadgeButtonElementHandler extends AbstractButtonElementHandler implements IFloatingElement 
    {
        var _badgeRequestCode:String;
        var _isFloating:Bool = true;


        override public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            super.initialize(k, _arg_2, _arg_3, _arg_4);
            this._badgeRequestCode = _arg_3[2];
            _arg_2.x = ASCompat.toInt(_arg_3[3]);
            _arg_2.y = ASCompat.toInt(_arg_3[4]);
            if (_arg_3.length > 5)
            {
                this._isFloating = (_arg_3[5] == "true");
            }
            k.communicationManager.addHabboConnectionMessageEvent(new IsBadgeRequestFulfilledEvent(this.onInfo));
            k.communicationManager.addHabboConnectionMessageEvent(new WiredRewardResultMessageEvent(this._Str_23794));
        }

        override function onClick()
        {
            landingView.requestBadge(this._badgeRequestCode);
            landingView.tracking.trackGoogle("landingView", ("click_requestbadge_" + this._badgeRequestCode));
        }

        override public function refresh()
        {
            super.refresh();
            landingView.send(new GetIsBadgeRequestFulfilledComposer(this._badgeRequestCode));
        }

        public function _Str_7806(k:Bool):Bool
        {
            return this._isFloating;
        }

        function onInfo(k:IsBadgeRequestFulfilledEvent)
        {
            if (k.getParser().requestCode == this._badgeRequestCode)
            {
                window.visible = (!k.getParser().fulfilled);
            }
        }

        function _Str_23794(k:WiredRewardResultMessageEvent)
        {
            if (window != null)
            {
                landingView.send(new GetIsBadgeRequestFulfilledComposer(this._badgeRequestCode));
            }
        }
public function new(){	super();
}
    }

