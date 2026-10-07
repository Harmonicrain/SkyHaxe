package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;
    import com.sulake.core.window.events.WindowEvent;

     class HabboTalentsPromoWidget implements ILandingViewWidget 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;

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
            this._container = cast(this._landingView.getXmlWindow("habbo_talents_promo"), IWindowContainer);
            this._container.findChildByName("go_button").procedure = this.onGoButton;
            HabboLandingView._Str_9079(this._container, "title_txt", "hdr_line");
        }

        public function refresh()
        {
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
                this._landingView.tracking.trackTalentTrackOpen(this._landingView.sessionDataManager.currentTalentTrack, "landingpagepromo");
                this._landingView.send(new GetTalentTrackMessageComposer(this._landingView.sessionDataManager.currentTalentTrack));
            }
        }
    }


