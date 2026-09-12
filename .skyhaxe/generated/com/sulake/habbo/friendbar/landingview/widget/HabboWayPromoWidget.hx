package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.CommunityGoalProgressMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.quest.GetCommunityGoalProgressMessageComposer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class HabboWayPromoWidget implements ILandingViewWidget 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _completions:Int = 0;

        public function new(k:HabboLandingView)
        {
            this._landingView = k;
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            this._landingView = null;
            this._container = null;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("habbo_way_promo"), IWindowContainer);
            this._container.findChildByName("go_button").procedure = this.onGoButton;
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new CommunityGoalProgressMessageEvent(this.onCommunityGoalProgress));
        }

        public function refresh()
        {
            this._landingView.send(new GetCommunityGoalProgressMessageComposer());
            this.refreshContent();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        function onGoButton(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._landingView.habboHelp.showHabboWay();
            }
        }

        function onCommunityGoalProgress(k:CommunityGoalProgressMessageEvent)
        {
            this._completions = k.getParser().data._Str_12030;
            this.refreshContent();
        }

        function refreshContent()
        {
            var k= ("" + Std.string(this._completions));
            while (k.length < 8)
            {
                k = ("0" + k);
            }
            this._container.findChildByName("counter_txt").caption = k;
        }
    }


