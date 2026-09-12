package com.sulake.habbo.gamecenter
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextLinkWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.game.WindowUtils;
    import com.sulake.habbo.communication.messages.incoming.game.score.WeeklyCompetitiveLeaderboardEvent;
    import com.sulake.habbo.communication.messages.incoming.game.score.Game2WeeklyLeaderboardEvent;
    import com.sulake.habbo.communication.messages.outgoing.game.score.Game2GetWeeklyLeaderboardComposer;
    import com.sulake.habbo.communication.messages.outgoing.game.score._Str_11321;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.score.LeaderboardEntry;
    import com.sulake.habbo.communication.messages.parser.game.score.Game2WeeklyLeaderboardParser;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.core.communication.messages.IMessageComposer;

     class LeaderboardView implements IDisposable implements  IAvatarImageListener implements  IGameRewardListener 
    {
        static inline final GAME_CENTER_LEADERBOARD_VIEW_XML= "game_center_leaderboard_view_xml";
        static inline final _Str_18486:UInt = 0xFFC1C1C1;
        static inline final _Str_16286:UInt = 0xFFDCDCDC;
        static inline final _Str_13218:UInt = 0xFFFFFFFF;

        var _disposed:Bool = false;
        var _initialized:Bool = false;
        var _gameCenterView:GameCenterView;
        var _leaderboardDialog:IModalDialog;
        var _leaderboardWindow:IWindowContainer;
        var _entryWindow:IWindowContainer;
        var _thisWeekList:IItemListWindow;
        var _thisWeekToggle:ITextLinkWindow;
        var _lastWeekList:IItemListWindow;
        var _ownEntryList:IItemListWindow;
        var _selectedGame:Int = 0;
        var _waitingRewardFurniId:Int = 0;
        var _waitingWeeklyTopFigure:String;
        var _thisWeekTopScoresMode:Bool = false;

        public function new(k:GameCenterView)
        {
            this._gameCenterView = k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this._leaderboardDialog != null)
            {
                this._leaderboardDialog.dispose();
                this._leaderboardDialog = null;
            }
            if (this._entryWindow != null)
            {
                this._entryWindow.dispose();
                this._entryWindow = null;
            }
            if (this._thisWeekToggle != null)
            {
                this._thisWeekToggle.removeEventListener(WindowMouseEvent.CLICK, this._Str_21106);
            }
            this._thisWeekList = null;
            this._lastWeekList = null;
            this._ownEntryList = null;
            this._thisWeekToggle = null;
            this._gameCenterView = null;
            this._disposed = true;
            this._initialized = false;
        }

        public function activate(k:Int)
        {
            this._selectedGame = k;
            if (this._leaderboardDialog == null)
            {
                this.createWindow();
            }
            this._leaderboardWindow.invalidate();
            this._leaderboardWindow.visible = true;
            this.updateLayout();
        }

        public function disable()
        {
            if (this._leaderboardDialog == null)
            {
                return;
            }
            this._leaderboardDialog.dispose();
            this._leaderboardDialog = null;
            this._leaderboardWindow = null;
        }

        public function _Str_18157(k:Int)
        {
            if (((this._leaderboardWindow != null) && this._leaderboardWindow.visible))
            {
                this.activate(k);
            }
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this.disable();
        }

        function createWindow()
        {
            var k= this._gameCenterView.assets.getAssetByName(GAME_CENTER_LEADERBOARD_VIEW_XML);
            var _local_2= cast(k, XmlAsset);
            this._leaderboardDialog = this._gameCenterView.windowManager.buildModalDialogFromXML(new com.sulake.core.utils.xml.XML(_local_2.content));
            this._leaderboardWindow = Std.downcast(this._leaderboardDialog.rootWindow , IWindowContainer);
            this._leaderboardWindow.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            this._thisWeekList = Std.downcast(this._leaderboardWindow.findChildByName("this_week_list") , IItemListWindow);
            this._thisWeekToggle = Std.downcast(this._leaderboardWindow.findChildByName("this_week_toggle") , ITextLinkWindow);
            this._thisWeekToggle.addEventListener(WindowMouseEvent.CLICK, this._Str_21106);
            this._lastWeekList = Std.downcast(this._leaderboardWindow.findChildByName("last_week_list") , IItemListWindow);
            this._ownEntryList = Std.downcast(this._leaderboardWindow.findChildByName("own_entry_list") , IItemListWindow);
            var _local_3= Std.downcast(this._leaderboardWindow.findChildByName("weekly_top_container") , IWindowContainer);
            if (_local_3 != null)
            {
                _local_3.visible = false;
            }
            if (!this._initialized)
            {
                this._entryWindow = Std.downcast(WindowUtils.createWindow("game_leaderboard_entry_small_xml") , IWindowContainer);
                this._gameCenterView.communication.addHabboConnectionMessageEvent(new WeeklyCompetitiveLeaderboardEvent(this.onWeeklyCompetitiveLeaderboard));
                this._gameCenterView.communication.addHabboConnectionMessageEvent(new Game2WeeklyLeaderboardEvent(this.onWeeklyTopScoresLeaderboard));
                this._initialized = true;
            }
        }

        function updateLayout()
        {
            this._Str_20297(null);
            this._leaderboardWindow.findChildByName("weekly_top_avatar_name").caption = "";
            this._leaderboardWindow.findChildByName("weekly_top_avatar_score").caption = "";
            this._leaderboardWindow.findChildByName("weekly_top_avatar_score").caption = "";
            this._gameCenterView.registerParameter(this._selectedGame, "gamecenter.full_leaderboard_title");
            this._thisWeekList.destroyListItems();
            this._lastWeekList.destroyListItems();
            this._ownEntryList.destroyListItems();
            this.updateThisWeek();
            this.send(new Game2GetWeeklyLeaderboardComposer(this._selectedGame, 1, 0, 0, 5, 5));
            this._gameCenterView.getWeeklyGameRewardInformation(this);
        }

        function updateThisWeek()
        {
            if (this._thisWeekTopScoresMode)
            {
                this._thisWeekToggle.caption = "${gamecenter.leaderboard_my_ranking_link}";
                this.send(new Game2GetWeeklyLeaderboardComposer(this._selectedGame, 0, 0, 0, 10, 10));
            }
            else
            {
                this._thisWeekToggle.caption = "${gamecenter.leaderboard_top_scores_link}";
                this.send(new _Str_11321(this._selectedGame, 5));
            }
        }

        function onWeeklyCompetitiveLeaderboard(k:IMessageEvent)
        {
            if (this._leaderboardWindow == null)
            {
                return;
            }
            var _local_2= Std.downcast(k , WeeklyCompetitiveLeaderboardEvent);
            this.populateLeaderboard(this._thisWeekList, _local_2.getParser(), 10, false);
        }

        function onWeeklyTopScoresLeaderboard(k:IMessageEvent)
        {
            var _local_4:LeaderboardEntry = null;
            var _local_5:LeaderboardEntry = null;
            if (this._leaderboardWindow == null)
            {
                return;
            }
            var _local_2= Std.downcast(k , Game2WeeklyLeaderboardEvent);
            var _local_3= _local_2.getParser();
            if (_local_3.currentOffset == 0)
            {
                this.populateLeaderboard(this._thisWeekList, _local_3, 10, true);
            }
            else
            {
                _local_4 = this.populateLeaderboard(this._lastWeekList, _local_3, 5, true);
                if (_local_4 != null)
                {
                    this._Str_20301(this._ownEntryList, _local_4, _Str_13218);
                }
                if (_local_3.leaderboard.length > 0)
                {
                    _local_5 = ASCompat.dynamicAs(_local_3.leaderboard[0] , LeaderboardEntry);
                    this._Str_20814(_local_5.figure, _local_5.gender);
                    this._leaderboardWindow.findChildByName("weekly_top_avatar_name").caption = _local_5.name;
                    this._leaderboardWindow.findChildByName("weekly_top_avatar_score").caption = this._gameCenterView.localization.registerParameter("gamecenter.leaderboard_score", "score", Std.string(_local_5.score));
                }
            }
        }

        function populateLeaderboard(k:IItemListWindow, _arg_2:Game2WeeklyLeaderboardParser, _arg_3:Int, _arg_4:Bool):LeaderboardEntry
        {
            var _local_5:LeaderboardEntry = null;
            var _local_6:IWindowContainer = null;
            var _local_7 = 0;
            var _local_8:LeaderboardEntry = null;
            var _local_9:UInt = 0;
            if (((k != null) && (_arg_2.gameTypeId == this._selectedGame)))
            {
                k.destroyListItems();
                _local_6 = Std.downcast(WindowUtils.createWindow("game_leaderboard_entry_small_xml") , IWindowContainer);
                _local_7 = 1;
                final _iter_ = _arg_2.leaderboard; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_8  = _tmp_;
                    if (((_arg_4 && (_local_7 == _arg_2.leaderboard.length)) && (_local_8.userId == this._gameCenterView.sessionDataManager.userId)))
                    {
                        _local_5 = _local_8;
                        break;
                    }
                    if (_local_7 > _arg_3)
                    {
                        break;
                    }
                    if (_local_8.userId == this._gameCenterView.sessionDataManager.userId)
                    {
                        _local_9 = _Str_13218;
                    }
                    else
                    {
                        if ((_local_7 % 2) == 0)
                        {
                            _local_9 = _Str_16286;
                        }
                        else
                        {
                            _local_9 = _Str_18486;
                        }
                    }
                    this._Str_20301(k, _local_8, _local_9);
                    _local_7++;
                }
                return _local_5;
            }
            return null;
        }

        function _Str_20301(k:IItemListWindow, _arg_2:LeaderboardEntry, _arg_3:UInt)
        {
            var _local_4= Std.downcast(this._entryWindow.clone() , IWindowContainer);
            _local_4.color = _arg_3;
            _local_4.findChildByName("avatar_rank").caption = (Std.string(_arg_2.rank) + ". ");
            _local_4.findChildByName("avatar_name").caption = _arg_2.name;
            _local_4.findChildByName("avatar_score").caption = this._gameCenterView.localization.registerParameter("gamecenter.leaderboard_score", "score", Std.string(_arg_2.score));
            _local_4.name = _arg_2.figure;
            var _local_5= Std.downcast(_local_4.findChildByName("avatar_image") , IBitmapWrapperWindow);
            this._Str_21627(_local_5, _arg_2.figure, _arg_2.gender);
            k.addListItem(_local_4);
        }

        function _Str_21106(k:WindowMouseEvent)
        {
            if (this._thisWeekTopScoresMode)
            {
                this._thisWeekTopScoresMode = false;
            }
            else
            {
                this._thisWeekTopScoresMode = true;
            }
            this.updateThisWeek();
        }

        function _Str_21627(k:IBitmapWrapperWindow, _arg_2:String, _arg_3:String=null)
        {
            var _local_5:BitmapData = null;
            var _local_4= this._gameCenterView.gameManager.getBoolean("zoom.enabled");
            var _local_6= this._gameCenterView.avatarRenderManager.createAvatarImage(_arg_2, (_local_4 ? AvatarScaleType.LARGE : AvatarScaleType.SMALL), _arg_3, this);
            if (_local_6 != null)
            {
                _local_6.setDirection(AvatarSetType.FULL, 2);
_local_5 = _local_6.getCroppedImage(AvatarSetType.HEAD, (_local_4 ? 0.5 : 1));
                WindowUtils.setElementImage(k, _local_5);
                _local_5.dispose();
            }
        }

        public function avatarImageReady(k:String)
        {
            this._Str_17941(this._thisWeekList, k);
            this._Str_17941(this._lastWeekList, k);
            this._Str_17941(this._ownEntryList, k);
            this._Str_23178(k);
        }

        function _Str_17941(k:IItemListWindow, _arg_2:String)
        {
            var _local_3 = 0;
            var _local_4:IWindowContainer = null;
            var _local_5:IBitmapWrapperWindow = null;
            if (k != null)
            {
                _local_3 = 0;
                while ((_local_3 : UInt) < k.iterator.length)
                {
                    _local_4 = Std.downcast(k.getListItemAt(_local_3) , IWindowContainer);
                    _local_5 = Std.downcast(_local_4.findChildByName("avatar_image") , IBitmapWrapperWindow);
                    if (_local_4.name == _arg_2)
                    {
                        this._Str_21627(_local_5, _arg_2);
                    }
                    _local_3++;
                }
            }
        }

        function _Str_23178(k:String)
        {
            if (this._waitingWeeklyTopFigure == k)
            {
                this._Str_20814(k);
            }
        }

        function _Str_20814(k:String, _arg_2:String=null)
        {
            var _local_3:BitmapData = null;
            var _local_4= this._gameCenterView.avatarRenderManager.createAvatarImage(k, AvatarScaleType.LARGE, _arg_2, this);
            if (_local_4 != null)
            {
                _local_4.setDirection(AvatarSetType.FULL, 4);
_local_3 = _local_4.getCroppedImage(AvatarSetType.FULL);
                this._Str_20297(_local_3);
                _local_3.dispose();
            }
        }

        public function setGameRewardImage(k:BitmapData)
        {
            var _local_2= Std.downcast(this._leaderboardWindow.findChildByName("weekly_top_reward_image") , IBitmapWrapperWindow);
            this._Str_14846(_local_2, k);
        }

        public function setGameRewardName(k:String)
        {
            this._leaderboardWindow.findChildByName("weekly_top_reward_name").caption = k;
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
            this._leaderboardWindow.findChildByName("weekly_top_container").visible = false;
        }

        function _Str_20297(k:BitmapData)
        {
            var _local_2= Std.downcast(this._leaderboardWindow.findChildByName("weekly_top_avatar_image") , IBitmapWrapperWindow);
            this._Str_14846(_local_2, k);
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

        public function send(k:IMessageComposer)
        {
            this._gameCenterView.send(k);
        }
    }

