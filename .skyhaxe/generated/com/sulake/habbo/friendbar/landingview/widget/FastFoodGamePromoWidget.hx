package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.game.HabboGames;
    import com.sulake.core.window.events.WindowEvent;

     class FastFoodGamePromoWidget implements ILandingViewWidget 
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
            if (this._container != null)
            {
                this._container.dispose();
            }
            this._container = null;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("fast_food_game_promo"), IWindowContainer);
            this._container.findChildByName("go_button").procedure = this.onGoButton;
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
                this._landingView.openGameCenterByGameName(HabboGames.BASEJUMP);
            }
        }
    }

