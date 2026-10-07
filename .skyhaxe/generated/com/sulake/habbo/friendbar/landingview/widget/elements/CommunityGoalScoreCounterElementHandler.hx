package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IFloatingElement;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.ILayoutNameProvider;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IDisableAwareElement;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.quest.CommunityGoalProgressMessageEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IRunningNumberWidget;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.habbo.communication.messages.outgoing.quest.GetCommunityGoalProgressMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.quest.CommunityGoalData;

     class CommunityGoalScoreCounterElementHandler implements IElementHandler implements  IDisposable implements  IFloatingElement implements  ILayoutNameProvider implements  IDisableAwareElement 
    {
        var _landingView:HabboLandingView;
        var _window:IWindowContainer;
        var _floating:Bool = false;
        var _pollTimer:Timer;
        var _counter_initialized:Bool = false;


        public function dispose()
        {
            if (this._landingView != null)
            {
                this._landingView.communicationManager.removeHabboConnectionMessageEvent(new CommunityGoalProgressMessageEvent(this.onCommunityGoalProgress));
                this._landingView = null;
            }
            if (this._pollTimer != null)
            {
                this._pollTimer.stop();
                this._pollTimer.removeEventListener(TimerEvent.TIMER, (this.onPollTimer : ASAny));
                this._pollTimer = null;
            }
            this._window = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            this._landingView = k;
            this._window = cast(_arg_2, IWindowContainer);
            var _local_5= ASCompat.toInt(_arg_3[1]);
            var _local_6= ASCompat.toInt(_arg_3[2]);
            var _local_7= ASCompat.toInt(_arg_3[3]);
            this._floating = (_arg_3[4] == "true");
            var _local_8= cast(this._window.findChildByName("running_number_widget"), IWidgetWindow);
            var _local_9= cast(_local_8.widget, IRunningNumberWidget);
            _local_9.digits = _local_5;
            _local_9.updateFrequency = _local_6;
            if (this._floating)
            {
                this._window.x = ASCompat.toInt(_arg_3[5]);
                this._window.y = ASCompat.toInt(_arg_3[6]);
            }
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new CommunityGoalProgressMessageEvent(this.onCommunityGoalProgress));
            this._pollTimer = new Timer(_local_7);
            this._pollTimer.addEventListener(TimerEvent.TIMER, (this.onPollTimer : ASAny));
        }

        public function disable()
        {
            this._pollTimer.stop();
        }

        public function refresh()
        {
            this._landingView.send(new GetCommunityGoalProgressMessageComposer());
            this._counter_initialized = false;
            this._pollTimer.start();
        }

        public function _Str_7806(k:Bool):Bool
        {
            return this._floating;
        }

        public var layoutName(get,never):String;
public function  get_layoutName():String
        {
            return "element_community_goal_score";
        }

        function onCommunityGoalProgress(k:CommunityGoalProgressMessageEvent)
        {
            var _local_2:CommunityGoalData = null;
            var _local_3:IWidgetWindow = null;
            var _local_4:IRunningNumberWidget = null;
            if (this._landingView != null)
            {
                _local_2 = k.getParser().data;
                _local_3 = cast(this._window.findChildByName("running_number_widget"), IWidgetWindow);
                _local_4 = cast(_local_3.widget, IRunningNumberWidget);
                if (this._counter_initialized)
                {
                    _local_4.number = _local_2._Str_12030;
                }
                else
                {
                    _local_4.setNumberImmediately = _local_2._Str_12030;
                    this._counter_initialized = true;
                }
            }
        }

        function onPollTimer(k:TimerEvent)
        {
            this._landingView.send(new GetCommunityGoalProgressMessageComposer());
        }
public function new(){}
    }

