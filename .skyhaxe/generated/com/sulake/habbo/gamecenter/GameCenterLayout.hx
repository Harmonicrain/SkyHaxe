package com.sulake.habbo.gamecenter
;
    import com.sulake.core.runtime.IDisposable;
	import com.sulake.habbo.game.HabboGames;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.components.IScrollbarWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.inventory.events.HabboUnseenItemsUpdatedEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.UserGameAchievementsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.score.WeeklyCompetitiveFriendsLeaderboardEvent;
    import com.sulake.habbo.communication.messages.incoming.game.score.Game2WeeklyLeaderboardEvent;
    import com.sulake.habbo.communication.messages.incoming.game.score.WeeklyGameRewardWinnersEvent;
    import com.sulake.habbo.communication.messages.incoming.game.directory.Game2AccountGameStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.GameStatusMessageEvent;
    import com.sulake.habbo.inventory._enum.UnseenItemCategoryEnum;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.game.GameAssetEnum;
    import com.sulake.habbo.communication.messages.outgoing.game.lobby.GetUserGameAchievementsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.game.score._Str_11951;
    import com.sulake.habbo.communication.messages.outgoing.game.score.Game2GetWeeklyLeaderboardComposer;
    import com.sulake.habbo.communication.messages.outgoing.game.lobby.GetGameStatusMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.game.directory.Game2GetAccountGameStatusMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.game.score.GetWeeklyGameRewardWinnersComposer;
    import flash.display.BitmapData;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.Achievement;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.habbo.game.WindowUtils;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.score.LeaderboardEntry;
    import com.sulake.habbo.communication.messages.parser.game.score.Game2LeaderboardParser;
    import com.sulake.habbo.communication.messages.parser.game.score.GameRewardWinnerEntry;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.window._enum._Str_12232;

     class GameCenterLayout implements IDisposable implements  IAvatarImageListener implements  IGameRewardListener 
    {
        static inline final GAME_CENTER_VIEW_GENERIC_XML= "game_center_view_generic_xml";
        static final _Str_4658:Rectangle = new Rectangle(0, 0, 0, 0);
        static inline final WINDOW_LAYER_INDEX= 0;

        var _selectedGame:Int = -1;
        var _gamesLeft:Int = 0;
        var _gameEnabled:Bool = true;
        var _disposed:Bool = false;
        var _gameCenterView:GameCenterView;
        var _gameCenterViewWindow:IWindowContainer;
        var _gameCenterContainer:IWindowContainer;
        var _storiesEntryContainer:IWindowContainer;
        var _gameContentScrollContainer:IScrollableListWindow;
        var _gameContent:IWindowContainer;
        var _gameListScroller:IScrollbarWindow;
        var _gameListContainer:IItemListWindow;
        var _gameListItemBase:IWindowContainer;
        var _gameSelectionIcon:IBitmapWrapperWindow;
        var _themeImage:IStaticBitmapWrapperWindow;
        var _logoImage:IStaticBitmapWrapperWindow;
        var _achievementList:IItemListWindow;
        var _leaderboardList:IItemListWindow;
        var _luckyLosersList:IItemListWindow;
        var _gamesLeftContainer:IWindowContainer;
        var _playNowLimitedButton:IWindowContainer;
        var _playNowUnlimitedButton:IWindowContainer;
        var _gameOfflineText:ITextWindow;
        var _achievementsContainer:IWindowContainer;
        var _leaderboardContainer:IWindowContainer;
        var _filterTextField:ITextFieldWindow;
        var _gameGeneralInfoContainer:IWindowContainer;

        public function new(k:GameCenterView)
        {
            this._gameCenterView = k;
            this._gameCenterView.gameManager.inventory.events.addEventListener(HabboUnseenItemsUpdatedEvent.HUIUE_UNSEEN_ITEMS_CHANGED, this._Str_14461);
            this._gameCenterView.gameManager.events.addEventListener(GameCenterEvent.GAME_CONFIGURATIONS_INITIALIZED, this._Str_25836);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                this._filterTextField = null;
                if (this._achievementList != null)
                {
                    this._achievementList.dispose();
                    this._achievementList = null;
                }
                if (this._leaderboardList != null)
                {
                    this._leaderboardList.dispose();
                    this._leaderboardList = null;
                }
                if (this._luckyLosersList != null)
                {
                    this._luckyLosersList.dispose();
                    this._luckyLosersList = null;
                }
                if (this._gamesLeftContainer != null)
                {
                    this._gamesLeftContainer.dispose();
                    this._gamesLeftContainer = null;
                }
                if (this._gameSelectionIcon != null)
                {
                    this._gameSelectionIcon.dispose();
                    this._gameSelectionIcon = null;
                }
                if (this._gameCenterContainer != null)
                {
                    this._gameCenterContainer.dispose();
                    this._gameCenterContainer = null;
                }
                if (this._gameCenterViewWindow != null)
                {
                    this._gameCenterViewWindow.dispose();
                    this._gameCenterViewWindow = null;
                }
                if (((this._gameCenterView.windowManager != null) && (!this._gameCenterView.windowManager.disposed)))
                {
                    this._gameCenterView.windowManager.getWindowContext(WINDOW_LAYER_INDEX).getDesktopWindow().removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
                }
                if (this._gameCenterView.gameManager.inventory.events != null)
                {
                    this._gameCenterView.gameManager.inventory.events.removeEventListener(HabboUnseenItemsUpdatedEvent.HUIUE_UNSEEN_ITEMS_CHANGED, this._Str_14461);
                }
                this._playNowLimitedButton.removeEventListener(WindowMouseEvent.CLICK, this._Str_13877);
                this._playNowUnlimitedButton.removeEventListener(WindowMouseEvent.CLICK, this._Str_13877);
                if (this._playNowLimitedButton != null)
                {
                    this._playNowLimitedButton.dispose();
                    this._playNowLimitedButton = null;
                }
                if (this._playNowUnlimitedButton != null)
                {
                    this._playNowUnlimitedButton.dispose();
                    this._playNowUnlimitedButton = null;
                }
                this._gameOfflineText = null;
                this._gameCenterViewWindow.findChildByName("leaderboard_link").removeEventListener(WindowMouseEvent.CLICK, this._Str_20562);
                this._gameCenterViewWindow.findChildByName("support_link").removeEventListener(WindowMouseEvent.CLICK, this._Str_21942);
                this._themeImage = null;
                this._logoImage = null;
                this._gameListContainer = null;
                this._gameListItemBase = null;
                this._gameContent = null;
                this._gameContentScrollContainer = null;
                this._gameCenterViewWindow = null;
                this._gameCenterView = null;
                this._gameListScroller = null;
                this._disposed = true;
            }
        }

        function createWindow()
        {
            var k:IWindowContainer = null;
            if (this._gameCenterViewWindow == null)
            {
                this._gameCenterViewWindow = Std.downcast(this._gameCenterView.windowManager.buildFromXML(((this._gameCenterView.assets.getAssetByName(GAME_CENTER_VIEW_GENERIC_XML).content : com.sulake.core.utils.xml.XML) ), WINDOW_LAYER_INDEX) , IWindowContainer);
                this._gameCenterContainer = Std.downcast(this._gameCenterViewWindow.findChildByName("game_center_container") , IWindowContainer);
                this._storiesEntryContainer = Std.downcast(this._gameCenterViewWindow.findChildByName("entering_stories_container") , IWindowContainer);
                this._gameContentScrollContainer = Std.downcast(this._gameCenterViewWindow.findChildByName("game_content_container") , IScrollableListWindow);
                this._gameContent = Std.downcast(this._gameContentScrollContainer.getListItemByName("game_content") , IWindowContainer);
                this._themeImage = Std.downcast(this._gameCenterViewWindow.findChildByName("theme_image") , IStaticBitmapWrapperWindow);
                this._logoImage = Std.downcast(this._gameCenterViewWindow.findChildByName("logo_image") , IStaticBitmapWrapperWindow);
                this._playNowLimitedButton = Std.downcast(this._gameCenterViewWindow.findChildByName("playnow_limited_button") , IWindowContainer);
                this._playNowUnlimitedButton = Std.downcast(this._gameCenterViewWindow.findChildByName("playnow_unlimited_button") , IWindowContainer);
                this._gameOfflineText = Std.downcast(this._gameCenterViewWindow.findChildByName("game_offline_description") , ITextWindow);
                this._playNowLimitedButton.addEventListener(WindowMouseEvent.CLICK, this._Str_13877);
                this._playNowUnlimitedButton.addEventListener(WindowMouseEvent.CLICK, this._Str_13877);
                this._gameListContainer = Std.downcast(this._gameCenterViewWindow.findChildByName("game_icon_list") , IItemListWindow);
                this._gameListItemBase = Std.downcast(this._gameListContainer.getListItemAt(0) , IWindowContainer);
                this._gameListContainer.removeListItemAt(0);
                this._gameSelectionIcon = Std.downcast(this._gameListItemBase.findChildByName("selected_icon") , IBitmapWrapperWindow);
                this._gameListItemBase.removeChild(this._gameSelectionIcon);
                this._gameListScroller = Std.downcast(this._gameCenterViewWindow.findChildByName("game_icon_list_scroll") , IScrollbarWindow);
                this._gameCenterViewWindow.findChildByName("game_center_filter_container").visible = this._gameCenterView.gameManager.getBoolean("games.filter.enabled");
                this._filterTextField = Std.downcast(this._gameCenterViewWindow.findChildByName("game_center_filter") , ITextFieldWindow);
                this._filterTextField.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this._Str_25099);
                this._Str_16015();
                this.setElementImage(this._gameSelectionIcon, this.getBitmap("game_center_icon_selected"));
                this._gameCenterView.windowManager.getWindowContext(WINDOW_LAYER_INDEX).getDesktopWindow().addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
                this._achievementList = Std.downcast(this._gameCenterViewWindow.findChildByName("achievements_list") , IItemListWindow);
                this._gameCenterView.communication.addHabboConnectionMessageEvent(new UserGameAchievementsMessageEvent(this.onUserGameAchievements));
                this._leaderboardList = Std.downcast(this._gameCenterViewWindow.findChildByName("leaderboard_list") , IItemListWindow);
                this._gameCenterView.communication.addHabboConnectionMessageEvent(new WeeklyCompetitiveFriendsLeaderboardEvent(this.onFriendLeaderboard));
                this._gameCenterView.communication.addHabboConnectionMessageEvent(new Game2WeeklyLeaderboardEvent(this.onTopScoresLeaderboard));
                this._luckyLosersList = Std.downcast(this._gameCenterViewWindow.findChildByName("lucky_losers_list") , IItemListWindow);
                this._gameCenterView.communication.addHabboConnectionMessageEvent(new WeeklyGameRewardWinnersEvent(this.onWeeklyWinners));
                this._gameCenterViewWindow.findChildByName("leaderboard_link").addEventListener(WindowMouseEvent.CLICK, this._Str_20562);
                this._gameCenterViewWindow.findChildByName("support_link").addEventListener(WindowMouseEvent.CLICK, this._Str_21942);
                this._gameCenterViewWindow.findChildByName("room_link").addEventListener(WindowMouseEvent.CLICK, this.onRoomLink);
                this._gamesLeftContainer = this._gameCenterView.windowManager.createUnseenItemCounter();
                k = Std.downcast(this._playNowLimitedButton.findChildByName("games_left_container") , IWindowContainer);
                k.addChild(this._gamesLeftContainer);
                this._gameCenterView.communication.addHabboConnectionMessageEvent(new Game2AccountGameStatusMessageEvent(this.onAccountGameStatus));
                this._gameCenterView.communication.addHabboConnectionMessageEvent(new GameStatusMessageEvent(this.onGameStatus));
                    this._Str_22075(this._gameCenterView.gameManager.inventory.unseenItemTracker._Str_11239(UnseenItemCategoryEnum.GAMES));
                this._achievementsContainer = Std.downcast(this._gameCenterViewWindow.findChildByName("achievements_container") , IWindowContainer);
                this._leaderboardContainer = Std.downcast(this._gameCenterViewWindow.findChildByName("leaderboard_container") , IWindowContainer);
                this._gameGeneralInfoContainer = Std.downcast(this._gameCenterViewWindow.findChildByName("game_general_info_container") , IWindowContainer);
            }
        }

        function _Str_25099(k:WindowKeyboardEvent)
        {
            if (k.keyCode == 13)
            {
                this._Str_16015();
            }
        }

        function _Str_25836(k:GameCenterEvent)
        {
            this._Str_16015();
        }

        public function _Str_16015()
        {
            var _local_2 = 0;
            if (this._gameListContainer == null)
            {
                return;
            }
            if (this._gameListContainer != null)
            {
                this._gameListContainer.removeListItems();
            }
            var k= GameConfigurations.gameIds();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = ASCompat.toInt(_tmp_);
                this._Str_24792(_local_2);
            }
            this._Str_20470();
            this._Str_20908(this._selectedGame);
        }

        function _Str_20470()
        {
            this._gameListScroller.visible = (this._gameListContainer.maxScrollH > 0);
        }

        function _Str_24792(k:Int)
        {
            var _local_2= GameConfigurations.getNameId(k);
            if (!ASCompat.stringAsBool(_local_2))
            {
                return;
            }
            if ((((!(this._filterTextField == null)) && (!(this._filterTextField.caption == ""))) && (_local_2.toLowerCase().indexOf(this._filterTextField.caption.toLowerCase()) < 0)))
            {
                return;
            }
            var _local_3= Std.downcast(this._gameListItemBase.clone() , IRegionWindow);
            var _local_4= GameConfigurations.getAssetUrl(k, GameAssetEnum.ICON);
            _local_3.name = _local_2;
            this._gameListContainer.addListItem(_local_3);
            _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_23441);
            var _local_5= _local_3.findChildByTag("ICON");
            var _local_6= Std.downcast(_local_5 , IStaticBitmapWrapperWindow);
            _local_6.assetUri = "game_center_loading_icon";
            _local_6.assetUri = _local_4;
            _local_3.toolTipCaption = this._gameCenterView.localization.getLocalization((("gamecenter." + _local_2) + ".name"), (("gamecenter." + _local_2) + ".name"));
        }

        public function activate(k:Int, _arg_2:Bool)
        {
            if (this._gameCenterViewWindow == null)
            {
                this.createWindow();
                this._gameCenterView.gameManager._SafeStr_7683();
            }
            this._selectedGame = -1;
            this._gameCenterViewWindow.invalidate();
            this._gameCenterViewWindow.visible = true;
            this.selectGame(k, _arg_2);
            this.resizeWindow();
        }

        public function disable()
        {
            if (this._gameCenterViewWindow == null)
            {
                return;
            }
            this._gameCenterViewWindow.visible = false;
        }

        function resizeWindow()
        {
            if (this._gameCenterViewWindow == null)
            {
                return;
            }
            this._gameCenterViewWindow.x = Std.int(_Str_4658.x);
            this._gameCenterViewWindow.y = Std.int(_Str_4658.y);
            this._gameCenterViewWindow.width = Std.int(this._gameCenterViewWindow.desktop.width - _Str_4658.right);
            this._gameCenterViewWindow.height = Std.int(this._gameCenterViewWindow.desktop.height - _Str_4658.bottom);
            this._gameCenterViewWindow.invalidate();
            if (this._gameCenterContainer == null)
            {
                return;
            }
            var k= this._gameCenterContainer.limits;
            if (this._gameCenterViewWindow.width > k.maxWidth)
            {
                this._gameCenterContainer.width = k.maxWidth;
            }
            else
            {
                if (this._gameCenterViewWindow.width < k.minWidth)
                {
                    this._gameCenterContainer.width = k.minWidth;
                }
                else
                {
                    this._gameCenterContainer.width = this._gameCenterContainer.width;
                }
            }
            this._gameCenterContainer.x = Std.int((this._gameCenterViewWindow.width - this._gameCenterContainer.width) / 2);
            this._gameContent.height = this._gameContentScrollContainer.height;
            this._gameContent.width = this._gameContentScrollContainer.width;
            this._gameCenterContainer.invalidate();
            this._Str_20470();
        }

        function onDesktopResized(k:WindowEvent)
        {
            this.resizeWindow();
        }

        function _Str_23441(k:WindowMouseEvent)
        {
            var _local_2 = 0;
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    _local_2 = GameConfigurations.getId(k.target.name);
                    this.selectGame(_local_2, false);
                    this._gameCenterView._Str_3777(GameConfigurations.getNameId(_local_2), "showGameCenter.selectGame");
                    return;
            }
        }

        function _Str_13877(k:WindowMouseEvent)
        {
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    this._Str_21892();
                    return;
            }
        }

        function _Str_21892()
        {
            // GameCenter games are WIP/TBA; keep BaseJump visible but do not launch yet.
            if (GameConfigurations.getNameId(this._selectedGame) == HabboGames.BASEJUMP)
            {
                return;
            }
            if (this._gamesLeft != 0)
            {
				if (((this._selectedGame == HabboGames._SafeStr_7697) && (!this._gameCenterView.gameManager._SafeStr_7684())))
                {
                    return;
                }
                this._playNowUnlimitedButton.disable();
                this._playNowLimitedButton.disable();
                this._gameCenterView.joinPlayerQueue(this._selectedGame);
            }
            else
            {
                this._gameCenterView.openVipBuying(this._selectedGame);
            }
        }

        function updateLayout(k:Bool)
        {
            var _local_2= GameConfigurations.getNameId(this._selectedGame);
            this._gameCenterContainer.color = GameConfigurations.getBgColor(this._selectedGame);
            this._themeImage.assetUri = null;
            this._logoImage.assetUri = null;
            this._gameCenterContainer.visible = (!(k && (_local_2 == "elisa_habbo_stories")));
            this._storiesEntryContainer.visible = (!this._gameCenterContainer.visible);
            this._storiesEntryContainer.x = Std.int((this._storiesEntryContainer.desktop.width / 2) - (this._storiesEntryContainer.width / 2));
            this._storiesEntryContainer.y = Std.int((this._storiesEntryContainer.desktop.height / 2) - (this._storiesEntryContainer.height / 2));
            this._themeImage.assetUri = GameConfigurations.getAssetUrl(this._selectedGame, GameAssetEnum.THEME);
            this._logoImage.assetUri = GameConfigurations.getAssetUrl(this._selectedGame, GameAssetEnum.LOGO);
            this._Str_4343(this._gameCenterViewWindow, "description_title", (("gamecenter." + _local_2) + ".description_title"), true);
            this._Str_4343(this._gameCenterViewWindow, "game_description", (("${gamecenter." + _local_2) + ".description_content}"));
            this._Str_4343(this._gameCenterViewWindow, "achievements_title", "${gamecenter.achievements_title}");
            this._Str_4343(this._gameCenterViewWindow, "leaderboard_title", "${gamecenter.leaderboard_title}");
            this._Str_4343(this._gameCenterViewWindow, "leaderboard_link", "${gamecenter.leaderboard_link}");
            this._Str_4343(this._gameCenterViewWindow, "game_offline_description", "${gamecenter.game_offline}");
            var _local_3= GameConfigurations.getSupportUrl(this._selectedGame);
            var _local_4= ((ASCompat.stringAsBool(_local_3) && (!(_local_3 == ""))) ? "${gamecenter.support_link_text}" : null);
            this._Str_4343(this._gameCenterViewWindow, "support_link", _local_4);
            this._gameOfflineText.visible = false;
            this._gameCenterView.localization.registerParameter("gamecenter.achievements_title", "game", this._gameCenterView.getLocalization(this._selectedGame));
            this._gameCenterViewWindow.findChildByName("play_now_unlimited_button_text").caption = "${gamecenter.play_now}";
            this._achievementList.destroyListItems();
            this._leaderboardList.destroyListItems();
            this._achievementsContainer.visible = false;
            this._gameCenterView.send(new GetUserGameAchievementsMessageComposer(this._selectedGame));
            this._leaderboardContainer.visible = false;
            this._gameCenterView.send(new _Str_11951(this._selectedGame, 1));
            this._gameCenterView.send(new Game2GetWeeklyLeaderboardComposer(this._selectedGame, 0, 0, 0, 1, 1));
            this._gameCenterView.send(new Game2GetWeeklyLeaderboardComposer(this._selectedGame, 1, 0, 0, 1, 1));
            this._gameCenterView.send(new GetGameStatusMessageComposer(this._selectedGame));
            this._playNowLimitedButton.visible = false;
            this._playNowUnlimitedButton.visible = false;
            this._gameCenterViewWindow.findChildByName("playnow_text").caption = "";
            this._gameCenterView.send(new Game2GetAccountGameStatusMessageComposer(this._selectedGame));
            this._gameCenterView.send(new GetWeeklyGameRewardWinnersComposer(this._selectedGame));
            this._gameCenterView.getWeeklyGameRewardInformation(this);
            var _local_5= ("gamecenter.roomlink." + _local_2);
            var _local_6= this._gameCenterView.gameManager.getProperty(_local_5);
            var _local_7= Std.downcast(this._gameCenterViewWindow.findChildByName("room_link_container") , IWindowContainer);
            _local_7.visible = (ASCompat.stringAsBool(_local_6) && (!(_local_6 == "")));
            if (_local_2 == "elisa_habbo_stories")
            {
                this._gameGeneralInfoContainer.visible = false;
            }
            else
            {
                this._gameGeneralInfoContainer.visible = true;
                this._Str_4343(this._gameCenterViewWindow, "game_general_info_text", "${gamecenter.game_info.text}");
            }
        }

        function setElementImage(k:IBitmapWrapperWindow, _arg_2:BitmapData)
        {
            if (_arg_2 != null)
            {
                k.bitmap = _arg_2.clone();
                k.invalidate();
            }
        }

        function _Str_4343(k:IWindowContainer, _arg_2:String, _arg_3:String=null, _arg_4:Bool=false)
        {
            var _local_5= Std.downcast(k.findChildByName(_arg_2) , ITextWindow);
            _local_5.textColor = GameConfigurations.getTextColor(this._selectedGame);
            if (ASCompat.stringAsBool(_arg_3))
            {
                _local_5.caption = (_arg_4 ? this._gameCenterView.localization.getLocalization(_arg_3, "") : _arg_3);
            }
            else
            {
                _local_5.caption = "";
            }
        }

        function selectGame(k:Int, _arg_2:Bool)
        {
            if (this._selectedGame == k)
            {
                return;
            }
            var _local_3= GameConfigurations.gameIds();
            if (((!(_local_3 != null)) || (_local_3.length == 0)))
            {
                return;
            }
            if (_local_3.indexOf(k) == -1)
            {
                HabboGamesCom.log([(((("Game id '" + Std.string(k)) + "' was not enabled, defaulting select to '") + _local_3[0]) + "'!")]);
                k = ASCompat.toInt(_local_3[0]);
            }
            this._selectedGame = k;
            this._gamesLeft = 0;
            this._gamesLeftContainer.caption = "0";
            this._Str_20908(k);
            this.updateLayout(_arg_2);
            this._gameCenterView._Str_18157(k);
        }

        function _Str_20908(k:Int)
        {
            var _local_2= Std.downcast(this._gameListContainer.getListItemByName(GameConfigurations.getNameId(k)) , IWindowContainer);
            if (_local_2 != null)
            {
                _local_2.removeChild(this._gameSelectionIcon);
                _local_2.addChildAt(this._gameSelectionIcon, 0);
            }
        }

        function getBitmap(k:String):BitmapData
        {
            var _local_2= this._gameCenterView.assets.getAssetByName(k);
            if (_local_2 != null)
            {
                return ASCompat.dynamicAs(_local_2.content , BitmapData);
            }
            return null;
        }

        function onUserGameAchievements(k:IMessageEvent)
        {
            var _local_4:IWindowContainer = null;
            var _local_5:Achievement = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8:String = null;
            var _local_9:IWindowContainer = null;
            var _local_10:IBadgeImageWidget = null;
            var _local_2= Std.downcast(k , UserGameAchievementsMessageEvent);
            var _local_3= _local_2.getParser() ;
            if (((this._achievementList != null) && (_local_3.gameTypeId == this._selectedGame)))
            {
                this._achievementList.destroyListItems();
                if (_local_3.achievements.length > 0)
                {
                    this._achievementsContainer.visible = true;
                }
                _local_4 = Std.downcast(WindowUtils.createWindow("game_achievement_entry_xml") , IWindowContainer);
                final _iter_ = _local_3.achievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_5  = _tmp_;
                    _local_6 = ((_local_5._Str_10438 && (!_local_5._Str_7518)) ? this._gameCenterView.localization.getPreviousLevelBadgeId(_local_5.badgeId) : _local_5.badgeId);
                    _local_7 = this._gameCenterView.localization.getBadgeName(_local_6);
                    _local_8 = this._gameCenterView.localization.getBadgeDesc(_local_6);
                    _local_9 = Std.downcast(_local_4.clone() , IWindowContainer);
                    this._Str_4343(_local_9, "achievement_name", _local_7);
                    this._Str_4343(_local_9, "achievement_desc", _local_8);
                    _local_10 = Std.downcast(cast(_local_9.findChildByName("achievement_image"), IWidgetWindow).widget , IBadgeImageWidget);
                    _local_10.badgeId = _local_6;
                    _local_10.greyscale = (!_local_5._Str_10438);
                    _local_9.findChildByName("achievement_locked_image").visible = (!_local_5._Str_10438);
                    this._achievementList.addListItem(_local_9);
                }
            }
        }

        function onFriendLeaderboard(k:IMessageEvent)
        {
            var _local_4:IWindowContainer = null;
            var _local_5:LeaderboardEntry = null;
            var _local_6:LeaderboardEntry = null;
            var _local_7:IWindowContainer = null;
            var _local_8:IBitmapWrapperWindow = null;
            var _local_2= Std.downcast(k , WeeklyCompetitiveFriendsLeaderboardEvent);
            var _local_3:Game2LeaderboardParser = _local_2.getParser();
            if (((this._leaderboardList != null) && (_local_3.gameTypeId == this._selectedGame)))
            {
                this._leaderboardList.destroyListItems();
                if (_local_3.leaderboard.length > 0)
                {
                    _local_6 = _local_3.leaderboard[0];
                    if (_local_6.score > 0)
                    {
                        this._leaderboardContainer.visible = true;
                    }
                }
                _local_4 = Std.downcast(WindowUtils.createWindow("game_leaderboard_entry_xml") , IWindowContainer);
                final _iter_ = _local_3.leaderboard; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_5  = _tmp_;
                    _local_7 = Std.downcast(_local_4.clone() , IWindowContainer);
                    if (_local_3.leaderboard.length == 1)
                    {
                        _local_7.findChildByName("avatar_rank_name").visible = false;
                        _local_7.findChildByName("avatar_score").visible = false;
                        _local_7.findChildByName("empty_leaderboard_text").visible = true;
                        this._Str_4343(_local_7, "empty_leaderboard_text", "${gamecenter.leaderboard_empty}");
                    }
                    else
                    {
                        this._Str_4343(_local_7, "avatar_rank_name", ((Std.string(_local_5.rank) + ". ") + _local_5.name));
                        this._Str_4343(_local_7, "avatar_score", this._gameCenterView.localization.registerParameter("gamecenter.leaderboard_score", "score", Std.string(_local_5.score)));
                    }
                    _local_7.name = _local_5.figure;
                    _local_8 = Std.downcast(_local_7.findChildByName("avatar_image") , IBitmapWrapperWindow);
                    this.setAvatarImage(_local_8, _local_5.figure, _local_5.gender);
                    this._leaderboardList.addListItem(_local_7);
                }
            }
        }

        function onTopScoresLeaderboard(k:IMessageEvent)
        {
            var _local_4:LeaderboardEntry = null;
            var _local_2= Std.downcast(k , Game2WeeklyLeaderboardEvent);
            var _local_3= _local_2.getParser();
            if (((_local_3.gameTypeId == this._selectedGame) && (_local_3.leaderboard.length > 0)))
            {
                _local_4 = _local_3.leaderboard[0];
                if (_local_4.score > 0)
                {
                    this._leaderboardContainer.visible = true;
                }
            }
        }

        function onWeeklyWinners(k:IMessageEvent)
        {
            var _local_4:IWindowContainer = null;
            var _local_5:GameRewardWinnerEntry = null;
            var _local_6:IWindowContainer = null;
            var _local_2= Std.downcast(k , WeeklyGameRewardWinnersEvent);
            var _local_3= _local_2.getParser();
            if (((this._luckyLosersList != null) && (_local_3.gameTypeId == this._selectedGame)))
            {
                this._gameCenterViewWindow.findChildByName("previous_winner").visible = false;
                this._luckyLosersList.destroyListItems();
                _local_4 = Std.downcast(WindowUtils.createWindow("game_center_lucky_loser_entry_xml") , IWindowContainer);
                final _iter_ = _local_3._Str_24920; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_5  = _tmp_;
                    if (_local_5.rank == 1)
                    {
                        this._gameCenterViewWindow.findChildByName("previous_winner").visible = true;
                        this._gameCenterViewWindow.findChildByName("previous_winner_name").caption = _local_5.name;
                        this._gameCenterViewWindow.findChildByName("previous_winner_score").caption = this._gameCenterView.localization.registerParameter("gamecenter.featured_player_points", "score", Std.string(_local_5.score));
                        Std.downcast(Std.downcast(this._gameCenterViewWindow.findChildByName("previous_winner_avatar") , IWidgetWindow).widget , IAvatarImageWidget).figure = _local_5.figure;
                    }
                    else
                    {
                        _local_6 = Std.downcast(_local_4.clone() , IWindowContainer);
                        _local_6.findChildByName("avatar_rank_name").caption = ((Std.string(_local_5.rank) + ". ") + _local_5.name);
                        _local_6.findChildByName("avatar_score").caption = this._gameCenterView.localization.registerParameter("gamecenter.featured_player_points", "score", Std.string(_local_5.score));
                        _local_6.name = _local_5.figure;
                        this._luckyLosersList.addListItem(_local_6);
                    }
                }
            }
        }

        function setAvatarImage(k:IBitmapWrapperWindow, _arg_2:String, _arg_3:String=null)
        {
            var _local_4:BitmapData = null;
            var _local_5= this._gameCenterView.avatarRenderManager.createAvatarImage(_arg_2, AvatarScaleType.LARGE, _arg_3, this);
            if (_local_5 != null)
            {
                _local_5.setDirection(AvatarSetType.FULL, 2);
_local_4 = _local_5.getCroppedImage(AvatarSetType.HEAD);
                WindowUtils.setElementImage(k, _local_4);
                _local_4.dispose();
            }
        }

        public function avatarImageReady(k:String)
        {
            var _local_2 = 0;
            var _local_3:IWindowContainer = null;
            var _local_4:IBitmapWrapperWindow = null;
            if (this._leaderboardList != null)
            {
                _local_2 = 0;
                while ((_local_2 : UInt) < this._leaderboardList.iterator.length)
                {
                    _local_3 = Std.downcast(this._leaderboardList.getListItemAt(_local_2) , IWindowContainer);
                    _local_4 = Std.downcast(_local_3.findChildByName("avatar_image") , IBitmapWrapperWindow);
                    if (_local_3.name == k)
                    {
                        this.setAvatarImage(_local_4, k);
                    }
                    _local_2++;
                }
            }
        }

        public function setGameRewardImage(k:BitmapData)
        {
            var _local_2= Std.downcast(this._gameCenterViewWindow.findChildByName("reward_bitmap") , IBitmapWrapperWindow);
            this._Str_14846(_local_2, k);
        }

        public function setGameRewardName(k:String)
        {
        }

        public function setTimeRemaining(k:Int)
        {
        }

        public function getCurrentlySelectedGame():Int
        {
            return this._selectedGame;
        }

        public function setRewardingOn(k:Bool)
        {
        }

        function _Str_14846(k:IBitmapWrapperWindow, _arg_2:BitmapData)
        {
            if (_arg_2 != null)
            {
                WindowUtils.setElementImage(k, _arg_2);
            }
            else
            {
                k.bitmap = null;
                k.invalidate();
            }
        }

        function _Str_20562(k:WindowMouseEvent)
        {
            this._gameCenterView.showLeaderboard(this._selectedGame);
        }

        function _Str_21942(k:WindowMouseEvent)
        {
            HabboWebTools.openWebPage(GameConfigurations.getGame(this._selectedGame).supportUrl);
        }

        function onRoomLink(k:WindowMouseEvent)
        {
            var _local_2= GameConfigurations.getNameId(this._selectedGame);
            var _local_3= this._gameCenterView.gameManager.getProperty(("gamecenter.roomlink." + _local_2));
            if (ASCompat.stringAsBool(_local_3))
            {
                this._gameCenterView.gameManager.navigator.goToPrivateRoom(ASCompat.parseInt(_local_3));
            }
        }

        function onAccountGameStatus(k:IMessageEvent)
        {
            var _local_4:IHabboLocalizationManager = null;
            var _local_2= Std.downcast(k , Game2AccountGameStatusMessageEvent);
            var _local_3= _local_2.getParser();
            if (_local_3.gameTypeId == this._selectedGame)
            {
                _local_4 = this._gameCenterView.localization;
                this._gamesLeft = _local_3.freeGamesLeft;
                if (this._gamesLeft >= 0)
                {
                    this._Str_4343(this._gameCenterViewWindow, "playnow_text", _local_4.registerParameter("gamecenter.play_now_desc.limited_games", "games_left", Std.string(this._gamesLeft)));
                    Std.downcast(this._gamesLeftContainer.findChildByName(_Str_12232.COUNT) , ITextWindow).text = Std.string(this._gamesLeft);
                    this._playNowUnlimitedButton.visible = false;
                    this._playNowLimitedButton.visible = this._gameEnabled;
                }
                else
                {
                    this._gameCenterViewWindow.findChildByName("playnow_text").caption = "";
                    this._playNowUnlimitedButton.visible = this._gameEnabled;
                    this._playNowLimitedButton.visible = false;
                }
                if (this._gameCenterView.startPlaying)
                {
                    this._Str_21892();
                }
            }
        }

        function onGameStatus(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , GameStatusMessageEvent);
            var _local_3= _local_2.getParser();
            if (_local_3.gameTypeId == this._selectedGame)
            {
                if ((_local_3.isOk && (!this._gameCenterView.isHotelClosed)))
                {
                    this._playNowUnlimitedButton.enable();
                    this._playNowLimitedButton.enable();
                    this._gameOfflineText.visible = false;
                    this._gameEnabled = true;
                }
                else
                {
                    this._playNowUnlimitedButton.disable();
                    this._playNowLimitedButton.disable();
                    this._gameOfflineText.visible = true;
                    this._gameEnabled = false;
                }
            }
        }

        function _Str_14461(k:HabboUnseenItemsUpdatedEvent)
        {
                var _local_2= this._gameCenterView.gameManager.inventory.unseenItemTracker._Str_11239(UnseenItemCategoryEnum.GAMES);
            this._Str_22075(_local_2);
        }

        function _Str_22075(k:Array<ASAny>)
        {
            var _local_2 = 0;
            var _local_3:IWindowContainer = null;
            var _local_4:IWindowContainer = null;
            var _local_5 = false;
            final _iter_ = GameConfigurations.gameIds(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toInt(_tmp_);
                _local_3 = Std.downcast(this._gameListContainer.getListItemByName(GameConfigurations.getNameId(_local_2)) , IWindowContainer);
                if (_local_3 != null)
                {
                    _local_4 = Std.downcast(_local_3.findChildByName("unseen_item_container") , IWindowContainer);
                    _local_5 = ((k != null) ? (k.indexOf(_local_2) >= 0) : false);
                    if (_local_5)
                    {
                        if (_local_4 == null)
                        {
                            _local_4 = this._gameCenterView.windowManager.createUnseenItemCounter();
                            _local_4.findChildByName("count").caption = " ! ";
                            _local_3.addChild(_local_4);
                            _local_4.x = (_local_3.width - _local_4.width);
                            _local_4.y = 0;
                        }
                    }
                    else
                    {
                        if (_local_4 != null)
                        {
                            _local_3.removeChild(_local_4);
                        }
                    }
                }
            }
        }
    }

