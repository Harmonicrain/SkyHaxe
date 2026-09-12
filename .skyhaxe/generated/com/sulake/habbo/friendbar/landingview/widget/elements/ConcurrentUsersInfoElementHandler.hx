package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.ConcurrentUsersGoalProgressMessageEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.outgoing.quest.GetConcurrentUsersGoalProgressMessageComposer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.quest.GetConcurrentUsersRewardMessageComposer;

     class ConcurrentUsersInfoElementHandler implements IElementHandler implements  IDisposable 
    {
        static inline final STATE_DISABLED= 0;
        static inline final STATE_ACTIVE= 1;
        static inline final STATE_REDEEM= 2;
        static inline final STATE_REWARDED= 3;
        static inline final UPDATE_INTERVAL_MS= 5000;

        var _landingView:HabboLandingView;
        var _widget:GenericWidget;
        var _localizationKey:String;
        var _state:Int = -1;
        var _userCount:Int = -1;
        var _userCountGoal:Int = -1;
        var _window:IWindowContainer;
        var _updateTimer:Timer;
        var _isDisposed:Bool = false;

        public function new()
        {
            this._updateTimer = new Timer(UPDATE_INTERVAL_MS);
            this._updateTimer.addEventListener(TimerEvent.TIMER, (this._Str_11704 : ASAny));
        }

        function _Str_11704(k:TimerEvent)
        {
            if ((((this._window == null) || (this._window.visible == false)) || (!this._landingView.isLandingViewVisible)))
            {
                return;
            }
            this.refresh();
        }

        public function dispose()
        {
            if (this._updateTimer != null)
            {
                this._updateTimer.stop();
            }
            this._updateTimer = null;
            this._isDisposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            this._widget = _arg_4;
            this._landingView = k;
            this._window = Std.downcast(_arg_2 , IWindowContainer);
            this._localizationKey = _arg_3[1];
            this._window.findChildByName("users_desc").caption = (("${" + this._localizationKey) + "}");
            var _local_5= cast(this._window.findChildByName("badge_image"), IStaticBitmapWrapperWindow);
            var _local_6= ((_arg_3.length > 2) ? _arg_3[2] : "ConcurrentUsersReward");
            var _local_7:ASAny = (("${image.library.url}album1584/" + _local_6) + ".gif");
            _local_5.assetUri = _local_7;
            this._Str_5681();
            _arg_2.procedure = this._Str_17374;
            k.communicationManager.addHabboConnectionMessageEvent(new ConcurrentUsersGoalProgressMessageEvent(this._Str_16345));
            this._updateTimer.start();
        }

        public function refresh()
        {
            this._landingView.send(new GetConcurrentUsersGoalProgressMessageComposer());
        }

        function _Str_5681()
        {
            var k= "landing.view.concurrentusers.caption";
            var _local_2= "landing.view.concurrentusers.bodytext";
            this._landingView.windowManager.registerLocalizationParameter(this._localizationKey, "userCount", Std.string(this._userCount));
            this._landingView.windowManager.registerLocalizationParameter(this._localizationKey, "userGoal", Std.string(this._userCountGoal));
            this._landingView.windowManager.registerLocalizationParameter("landing.view.concurrentusers.bodytext", "userCount", Std.string(this._userCount));
            this._landingView.windowManager.registerLocalizationParameter("landing.view.concurrentusers.bodytext", "userGoal", Std.string(this._userCountGoal));
            this._landingView.windowManager.registerLocalizationParameter("landing.view.concurrentusers.bodytext", "domain", this._landingView.localizationManager.getLocalization("landing.view.hotel.domain", "Habbo"));
            switch (this._state)
            {
                case STATE_DISABLED:
                    this._window.findChildByName("state.active").visible = true;
                    this._window.findChildByName("state.achieved").visible = false;
                    
                case STATE_ACTIVE:
                    this._window.findChildByName("state.active").visible = true;
                    this._window.findChildByName("state.achieved").visible = false;
                    
                case STATE_REDEEM:
                    if (this._updateTimer != null)
                    {
                        this._updateTimer.stop();
                    }
                    k = (k + ".success");
                    _local_2 = (_local_2 + ".success");
                    this._window.findChildByName("state.active").visible = false;
                    this._window.findChildByName("state.active").enable();
                    this._window.findChildByName("state.achieved").visible = true;
                    this._window.findChildByName("action_button").visible = true;
                    
                case STATE_REWARDED:
                    if (this._updateTimer != null)
                    {
                        this._updateTimer.stop();
                    }
                    k = (k + ".success");
                    _local_2 = (_local_2 + ".success");
                    this._window.findChildByName("state.active").visible = false;
                    this._window.findChildByName("state.achieved").visible = true;
                    this._window.findChildByName("action_button").visible = false;
                    
            }
            var _local_3= Std.downcast(this._widget._Str_19931("bodytext") , TextElementHandler);
            if (_local_3 != null)
            {
                _local_3._Str_14499 = _local_2;
            }
            var _local_4= Std.downcast(this._widget._Str_19931("caption") , TextElementHandler);
            if (_local_4 != null)
            {
                _local_4._Str_14499 = k;
            }
        }

        function _Str_16345(k:ConcurrentUsersGoalProgressMessageEvent)
        {
            this._state = k.getParser().state;
            this._userCount = k.getParser().userCount;
            this._userCountGoal = k.getParser()._Str_21827;
            this._Str_5681();
        }

        function _Str_17374(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.onClick();
            }
        }

        function onClick()
        {
            this._landingView.send(new GetConcurrentUsersRewardMessageComposer());
            this._landingView.send(new GetConcurrentUsersGoalProgressMessageComposer());
            this._window.findChildByName("state.active").disable();
        }
    }

