package com.sulake.habbo.ui.widget.furniture.leaderboard
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.communication.messages.parser.games.OpenLeaderboardMessageParser;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.handler.LeaderboardWidgetHandler;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.window.IHabboWindowManager;

     class LeaderboardWidget extends RoomWidgetBase
    {
        var _view:LeaderboardView;

        public function new(handler:IRoomWidgetHandler, windowManager:IHabboWindowManager, assets:IAssetLibrary=null, localizations:IHabboLocalizationManager=null)
        {
            super(handler, windowManager, assets, localizations);
            if (Std.is(handler , LeaderboardWidgetHandler))
            {
                cast(handler, LeaderboardWidgetHandler).widget = this;
            }
        }

        override public function  get_mainWindow():IWindow
        {
            return this._view == null ? null : this._view.window;
        }

        public function openLeaderboard(data:OpenLeaderboardMessageParser=null)
        {
            if (this._view == null)
            {
                this._view = new LeaderboardView(this.windowManager, this.localizations, this.assets, this.requestLeaderboard, this.showProfile, this.avatarRenderManager);
            }
            this._view.show(data);
        }

        function requestLeaderboard(leaderboardId:Int, period:String, offset:Int, limit:Int)
        {
            if (Std.is(this._handler , LeaderboardWidgetHandler))
            {
                cast(this._handler, LeaderboardWidgetHandler).requestLeaderboard(leaderboardId, period, offset, limit);
            }
        }

        function showProfile(userId:Int)
        {
            if (Std.is(this._handler , LeaderboardWidgetHandler))
            {
                cast(this._handler, LeaderboardWidgetHandler).showExtendedProfile(userId);
            }
        }

        var avatarRenderManager(get,never):IAvatarRenderManager;
function  get_avatarRenderManager():IAvatarRenderManager
        {
            return Std.is(this._handler , LeaderboardWidgetHandler)
                ? cast(this._handler, LeaderboardWidgetHandler).avatarRenderManager
                : null;
        }

        override public function dispose()
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            super.dispose();
        }
    }

