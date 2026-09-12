package snowwar.ui
;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.habbo.catalog.IVideoOfferLauncher;
	import com.sulake.habbo.game.HabboGames;
	import com.sulake.core.utils.Map;
	import com.sulake.core.window.IWindow;
	import com.sulake.core.window.IWindowContainer;
	import com.sulake.habbo.avatar._enum.AvatarScaleType;
	import com.sulake.habbo.avatar._enum.AvatarSetType;
	import com.sulake.habbo.avatar.IAvatarImageListener;
	import com.sulake.core.window.components.IBitmapWrapperWindow;
	import com.sulake.core.window.components.IItemListWindow;
	import com.sulake.core.window.components.IRegionWindow;
	import com.sulake.core.window.components.ITextWindow;
	import snowwar._str_254.SnowWarAnimatedWindowElement;
	import com.sulake.habbo.game.WindowUtils;
	import com.sulake.core.window.events.WindowEvent;
	import com.sulake.core.window.events.WindowMouseEvent;
	import snowwar._str_345._SafeStr_1434;
	import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
	import snowwar._str_373._SafeStr_3665;
	import com.sulake.habbo.communication.messages.outgoing.navigator.GetGuestRoomMessageComposer;
	import snowwar._str_400._SafeStr_3624;
	import snowwar._str_400._SafeStr_3813;
	import snowwar._str_496.Game2GameResult;
	import snowwar._str_496.Game2SnowWarGameStats;
	import snowwar._str_496.Game2TeamPlayerData;
	import snowwar._str_496.Game2TeamScoreData;
	import snowwar._str_496._SafeStr_4018;
	import snowwar._str_496._SafeStr_4032;
	import snowwar.SnowWarEngine;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

     class GameEndingViewController implements IDisposable implements  IAvatarImageListener implements  IVideoOfferLauncher 
    {
        static inline final _SafeStr_18873:UInt = 2;
        static inline final _SafeStr_18874= 0;
        static inline final _SafeStr_18875= 1;
        static inline final _SafeStr_18876= 2;
        static inline final _SafeStr_18877= 3;
        static inline final _SafeStr_18878= 4;
        static inline final _SafeStr_18879= 5;
        static inline final _SafeStr_18751= 0;
        static inline final _SafeStr_18752= 1;
        static inline final _SafeStr_18753= 2;

        var _SafeStr_9274:IWindowContainer;
        var _SafeStr_18579:SnowWarEngine;
        var _SafeStr_5041:Bool = false;
        var _SafeStr_18880:Array<ASAny>;
        var _SafeStr_13149:ASDictionary<ASAny,ASAny>;
        var _SafeStr_18793:GameLoadingViewController;
        var _SafeStr_18872:Game2GameResult;
        var _SafeStr_18584:Timer;
        var _SafeStr_5217:Int = 0;
        var _SafeStr_5998:Int = 0;
        var _SafeStr_18881:Map;
        var _SafeStr_18882:Map;
        var _SafeStr_18761:Int = 0;
        var _SafeStr_18762:Int = -1;

        public function new(k:SnowWarEngine, _arg_2:Array<ASAny>, _arg_3:Game2SnowWarGameStats, _arg_4:Game2GameResult, _arg_5:Int)
        {
            var teamScoreData:Game2TeamScoreData = null;
            var _local_7:ITextWindow = null;
            this._SafeStr_18880 = _arg_2;
            this._SafeStr_13149 = new ASDictionary<ASAny,ASAny>();
            this._SafeStr_18579 = k;
            this._SafeStr_18872 = _arg_4;
            this._SafeStr_18882 = new Map();
            this._SafeStr_18761 = (this._SafeStr_18579.config.getBoolean("games.buy.x.games.enabled") ? _SafeStr_18752 : _SafeStr_18751);
            if ((this._SafeStr_18579.catalog.videoOffers.enabled && this._SafeStr_18579.config.getBoolean("games.buy.x.games.video.enabled")))
            {
                this._SafeStr_18761 = _SafeStr_18753;
                this._SafeStr_18579.catalog.videoOffers.load(this);
            }
            k.roomUI.visible = false;
            k.windowManager.getDesktop(1).visible = false;
            this._SafeStr_18793 = new GameLoadingViewController(this._SafeStr_18579);
            this._SafeStr_18793.background.visible = true;
            this._SafeStr_14365();
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
teamScoreData  = _tmp_;
                this._SafeStr_18886(teamScoreData);
            }
            _local_7 = Std.downcast(this.findChildByName(this._SafeStr_9274, "endingInformation") , ITextWindow);
            if (this._SafeStr_18872.resultType == Game2GameResult._SafeStr_18781)
            {
                WindowUtils._Str_26442(_local_7.parent, this._SafeStr_18894());
                WindowUtils._Str_4180(_local_7, "${snowwar.result.tie}");
            }
            else
            {
                WindowUtils._Str_26442(_local_7.parent, this._SafeStr_18895(this._SafeStr_18872._SafeStr_18785));
                WindowUtils._Str_4180(_local_7, ((("$" + "{snowwar.team_") + Std.string(this._SafeStr_18872._SafeStr_18785)) + "_wins}"));
            }
            this._SafeStr_18891(_arg_3._SafeStr_18905);
            this._SafeStr_18892(_arg_3._SafeStr_18906);
            this._SafeStr_18899(_arg_5);
            if (this._SafeStr_18579._SafeStr_13223)
            {
                WindowUtils._Str_26294(this._SafeStr_9274, "statusContainer");
            }
            else
            {
                WindowUtils._Str_26291(this._SafeStr_9274, "statusContainer");
                this._SafeStr_18579.communication.connection.send(new _SafeStr_3624(HabboGames._SafeStr_7697));
            }
            this._SafeStr_13277();
        }

        public function dispose()
        {
            var k:SnowWarAnimatedWindowElement = null;
            this._SafeStr_18579.windowManager.getDesktop(1).visible = true;
            this._SafeStr_18885();
            if (this._SafeStr_18882 != null)
            {
                final _iter_ = this._SafeStr_18882; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                }
                this._SafeStr_18882.dispose();
                this._SafeStr_18882 = null;
            }
            if (this._SafeStr_18793 != null)
            {
                this._SafeStr_18793.dispose();
                this._SafeStr_18793 = null;
            }
            if (this._SafeStr_9274 != null)
            {
                this._SafeStr_9274.dispose();
                this._SafeStr_9274 = null;
            }
            this._SafeStr_18880 = null;
            this._SafeStr_13149 = null;
            this._SafeStr_18872 = null;
            this._SafeStr_5041 = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._SafeStr_5041;
        }

        function _SafeStr_14365()
        {
            this._SafeStr_9274 = Std.downcast(WindowUtils.createWindow("snowwar_ending") , IWindowContainer);
            this._SafeStr_9274.x = Std.int((this._SafeStr_9274.desktop.width - this._SafeStr_9274.width) / 2);
            this._SafeStr_9274.y = ((this._SafeStr_9274.desktop.height > 685) ? 115 : 10);
            this._SafeStr_9274.findChildByName("leave_link_region").procedure = this._SafeStr_16837;
            this._SafeStr_9274.findChildByName("button_rematch").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18883);
            this._SafeStr_9274.findChildByName("button_play_again").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18884);
            this._SafeStr_9274.findChildByName("button_buy_games").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18765);
            this._SafeStr_9274.findChildByName("button_watch_video").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18765);
            this._SafeStr_9274.findChildByName("loadingContainer").visible = false;
            this._SafeStr_9274.findChildByName("statusContainer").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18770);
        }

        function _SafeStr_18883(k:WindowMouseEvent=null, _arg_2:IWindow=null)
        {
            var _local_3:IWindow = null;
            if (this._SafeStr_18579._SafeStr_13224 == 0)
            {
                this._SafeStr_18770(k);
            }
            else
            {
                this._SafeStr_5998 = _SafeStr_18875;
                this._SafeStr_18579._SafeStr_13215();
                _local_3 = this._SafeStr_9274.findChildByName("button_rematch");
                _local_3.color = 0xCCCCCC;
                _local_3.disable();
                this._SafeStr_9274.findChildByName("statusContainer").visible = false;
            }
        }

        function _SafeStr_18884(k:WindowEvent=null, _arg_2:IWindow=null)
        {
            this._SafeStr_18579._SafeStr_13185();
            this._SafeStr_9274.findChildByName("button_play_again").visible = false;
            this._SafeStr_9274.findChildByName("statusContainer").visible = false;
        }

        function _SafeStr_18765(k:WindowMouseEvent)
        {
            this._SafeStr_18770(k);
        }

        function _SafeStr_18772()
        {
            var k= this._SafeStr_9274.findChildByName("button_rematch");
            var _local_2= this._SafeStr_9274.findChildByName("button_buy_games");
            var _local_3= this._SafeStr_9274.findChildByName("button_watch_video");
            var _local_4= this._SafeStr_9274.findChildByName("status.text_get_vip");
            var _local_5= this._SafeStr_9274.findChildByName("status.text_get_more_games");
            var _local_6= this._SafeStr_9274.findChildByName("status.text_watch_video");
            k.visible = false;
            _local_2.visible = false;
            _local_3.visible = false;
            _local_4.visible = false;
            _local_5.visible = false;
            _local_6.visible = false;
            switch (this._SafeStr_18761)
            {
                case _SafeStr_18752:
                    if (this._SafeStr_18579._SafeStr_13224 == 0)
                    {
                        _local_2.visible = true;
                    }
                    else
                    {
                        k.visible = true;
                    }
                    _local_5.visible = true;
                    return;
                case _SafeStr_18753:
                    if (this._SafeStr_18579._SafeStr_13224 == 0)
                    {
                        _local_3.visible = true;
                    }
                    else
                    {
                        k.visible = true;
                    }
                    if (this._SafeStr_18762 > 0)
                    {
                        _local_6.visible = true;
                    }
                    return;
                default:
                    k.visible = true;
                    _local_4.visible = true;
            }
        }

        function _SafeStr_16837(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._SafeStr_9859(true);
        }

        public function _SafeStr_9859(k:Bool)
        {
            if (k)
            {
                this._SafeStr_18579._SafeStr_13222(true);
                if (((this._SafeStr_5998 == _SafeStr_18877) || (this._SafeStr_5998 == _SafeStr_18876)))
                {
                    this._SafeStr_18579.communication.connection.send(new _SafeStr_3813());
                    if (this._SafeStr_18579.rejoinRoom > -1)
                    {
                        this._SafeStr_18579.communication.connection.send(new GetGuestRoomMessageComposer(this._SafeStr_18579.rejoinRoom, false, true));
                    }
                }
                else
                {
                    if (this._SafeStr_5998 == _SafeStr_18879)
                    {
                        if (this._SafeStr_18579.rejoinRoom > -1)
                        {
                            this._SafeStr_18579.communication.connection.send(new GetGuestRoomMessageComposer(this._SafeStr_18579.rejoinRoom, false, true));
                        }
                        else
                        {
                            this._SafeStr_18579.communication.connection.send(new _SafeStr_3665());
                        }
                    }
                    else
                    {
                        this._SafeStr_18579.communication.connection.send(new _SafeStr_3665());
                    }
                }
                this._SafeStr_18885();
            }
        }

        function _SafeStr_18885()
        {
            if (this._SafeStr_18584 != null)
            {
                this._SafeStr_18584.removeEventListener(TimerEvent.TIMER, (this._SafeStr_18589 : ASAny));
                this._SafeStr_18584.stop();
                this._SafeStr_18584 = null;
                this._SafeStr_5217 = 0;
            }
        }

        function _SafeStr_18886(k:Game2TeamScoreData)
        {
            var _local_3:Game2TeamPlayerData = null;
            var _local_2= k._SafeStr_18907;
            final _iter_ = k._SafeStr_13266; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._SafeStr_18887(_local_3);
            }
            WindowUtils._Str_4180(this.findChildByName(this._SafeStr_9274, (("team" + Std.string(_local_2)) + "Score")), Std.string(k.score));
        }

        function _SafeStr_18887(k:Game2TeamPlayerData)
        {
            this._SafeStr_13149[k.userId] = k;
            var _local_2= Std.downcast(this._SafeStr_9274.findChildByName((("team" + Std.string(k.__as3_final)) + "PlayersList")) , IItemListWindow);
            var _local_3= Std.downcast(WindowUtils.createWindow(("snowwar_results_player_team_" + Std.string(k.__as3_final))) , IItemListWindow);
            var _local_4= Std.downcast(_local_3.getListItemByName("playerImageContainer") , IWindowContainer);
            var _local_5= Std.downcast(_local_3.getListItemByName("playerDataContainer") , IWindowContainer);
            var _local_6= Std.downcast(_local_3.getListItemByName("playerScoreContainer") , IWindowContainer);
            WindowUtils.setElementImage(this.findChildByName(_local_4, "playerImage"), this._SafeStr_18801(k.__as3_final, k.figure, k.gender), 0, 0, 0);
            WindowUtils._Str_4180(this.findChildByName(_local_5, "playerName"), k.userName);
            WindowUtils._Str_26294(_local_5, "playerTotalStats");
            WindowUtils._Str_4180(this.findChildByName(_local_5, "playerHits"), Std.string(k.playerStats._SafeStr_18908));
            WindowUtils._Str_4180(this.findChildByName(_local_5, "playerKills"), Std.string(k.playerStats._SafeStr_18909));
            WindowUtils._Str_4180(this.findChildByName(_local_6, "playerScore"), Std.string(k.score));
            var _local_7= Std.downcast(_local_4.findChildByName("addFriend") , IWindowContainer);
            if ((this._SafeStr_18579.friendList.canBeAskedForAFriend(k.userId) && (!(k.userId == this._SafeStr_18579.sessionDataManager.userId))))
            {
                _local_7.id = k.userId;
                _local_7.getChildAt(0).id = k.__as3_final;
                _local_7.addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18888);
                _local_7.addEventListener(WindowMouseEvent.OVER, this._SafeStr_18889);
                _local_7.addEventListener(WindowMouseEvent.OUT, this._SafeStr_18890);
                _local_7.visible = true;
            }
            _local_2.addListItem(_local_3);
            _local_3.name = ("player" + Std.string(k.userId));
        }

        function _SafeStr_18888(k:WindowMouseEvent)
        {
            var _local_2= k.window.id;
            var _local_3:Game2TeamPlayerData = this._SafeStr_13149[_local_2];
            if (_local_3 != null)
            {
                this._SafeStr_18579.friendList.askForAFriend(_local_2, _local_3.userName);
                this._SafeStr_18579.communication.connection.send(new _SafeStr_1434("GameFramework", "SnowStorm", "gameFramework.sendFriendRequest.rematchView"));
                this._SafeStr_18579._SafeStr_13216(_local_2, "${snowwar.friend_request.sent}", true);
            }
            k.window.visible = false;
        }

        function _SafeStr_18889(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(k.window , IWindowContainer).getChildAt(0);
            WindowUtils.setElementImage(_local_2, this._SafeStr_12987("add_friend_icon_green"));
        }

        function _SafeStr_18890(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(k.window , IWindowContainer).getChildAt(0);
            var _local_3= ("add_friend_icon_" + ((_local_2.id == 1) ? "blue" : "red"));
            WindowUtils.setElementImage(_local_2, this._SafeStr_12987(_local_3));
        }

        function _SafeStr_18891(k:Int)
        {
            var _local_2:Game2TeamPlayerData = this._SafeStr_13149[k];
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._SafeStr_9274.findChildByName("mostHitsContainer") , IWindowContainer);
            if (_local_2.playerStats._SafeStr_18908 == 0)
            {
                _local_3.visible = false;
                return;
            }
            WindowUtils.setElementImage(this.findChildByName(_local_3, "backgroundImage"), this._SafeStr_12987(this.squareNameForTeam(_local_2.__as3_final)));
            WindowUtils.setElementImage(this.findChildByName(_local_3, "playerImage"), this._SafeStr_18801(_local_2.__as3_final, _local_2.figure, _local_2.gender), 0, 0, 0);
            WindowUtils._Str_4180(this.findChildByName(_local_3, "playerName"), _local_2.userName);
            WindowUtils._Str_26442(_local_3, this._SafeStr_18895(_local_2.__as3_final));
        }

        function _SafeStr_18892(k:Int)
        {
            var _local_2:Game2TeamPlayerData = this._SafeStr_13149[k];
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._SafeStr_9274.findChildByName("mostKillsContainer") , IWindowContainer);
            if (_local_2.playerStats._SafeStr_18909 == 0)
            {
                _local_3.visible = false;
                return;
            }
            WindowUtils.setElementImage(this.findChildByName(_local_3, "backgroundImage"), this._SafeStr_12987(this.squareNameForTeam(_local_2.__as3_final)));
            WindowUtils.setElementImage(this.findChildByName(_local_3, "playerImage"), this._SafeStr_18801(_local_2.__as3_final, _local_2.figure, _local_2.gender), 0, 0, 0);
            WindowUtils._Str_4180(this.findChildByName(_local_3, "playerName"), _local_2.userName);
            WindowUtils._Str_26442(_local_3, this._SafeStr_18895(_local_2.__as3_final));
        }

        function squareNameForTeam(k:Int):String
        {
            var squareName:String = null;
            switch (k)
            {
                case 1:
                    squareName = "blue_square";
                    
                case 2:
                    squareName = "red_square";
                    
                default:
                    squareName = "blue_square";
            }
            return squareName;
        }

        function _SafeStr_18894():UInt
        {
            return 8227482;
        }

        function _SafeStr_18895(k:Int):UInt
        {
            switch (k)
            {
                case 1:
                    return 0xFF1077AC;
                case 2:
                    return 0xFFFD6859;
            }
            return 0xFF1077AC;
        }

        function _SafeStr_18896(k:Int):UInt
        {
            switch (k)
            {
                case 1:
                    return 2;
                case 2:
                    return 4;
            }
            return 2;
        }

        function _SafeStr_18801(k:Int, _arg_2:String, _arg_3:String):BitmapData
        {
            var _local_5:BitmapData = null;
            var _local_4= this._SafeStr_18579.avatarRenderManager._Str_718(_arg_2);
            switch (k)
            {
                case 1:
                    _local_4._Str_830("ch", 20000, [1]);
                    
                case 2:
                    _local_4._Str_830("ch", 20001, [1]);
                    
                default:
                    _local_4._Str_830("ch", 20000, [1]);
            }
            var _local_6= this._SafeStr_18579.avatarRenderManager.createAvatarImage(_local_4.getFigureString(), AvatarScaleType.SMALL, _arg_3, this);
            if (_local_6 != null)
            {
                _local_6.setDirection(AvatarSetType.FULL, ASCompat.toInt(this._SafeStr_18896(k)));
return _local_6.getCroppedImage(AvatarSetType.FULL);
            }
            return _local_5;
        }

        function findChildByName(k:IWindowContainer, _arg_2:String):IWindow
        {
            return (k != null) ? k.findChildByName(_arg_2) : null;
        }

        function _SafeStr_12987(k:String):BitmapData
        {
            var _local_2= this._SafeStr_18579.assets.getAssetByName(k);
            if (_local_2 != null)
            {
                return ASCompat.dynamicAs(_local_2.content , BitmapData);
            }
            return null;
        }

        public function avatarImageReady(k:String)
        {
        }

        public function rematchPlayer(id:Int)
        {
            var _local_6:SnowWarAnimatedWindowElement = null;
            var _local_2= Std.downcast(this._SafeStr_9274.findChildByName(("player" + Std.string(id))) , IItemListWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3:Game2TeamPlayerData = this._SafeStr_13149[id];
            if (_local_3 == null)
            {
                return;
            }
            _local_3._SafeStr_18910 = true;
            var _local_4= Std.downcast(_local_2.getListItemByName("playerScoreContainer") , IWindowContainer);
            var _local_5= Std.downcast(this.findChildByName(_local_4, "playerScoreGlow") , IBitmapWrapperWindow);
            if (!this._SafeStr_18882.hasKey(_local_5))
            {
                _local_6 = new SnowWarAnimatedWindowElement(this._SafeStr_18579.assets, _local_5, "rematch_", 6, 100, true);
                this._SafeStr_18882.add(_local_5, _local_6);
            }
        }

        public function _SafeStr_13267(k:Bool)
        {
            var _local_3:Game2TeamPlayerData = null;
            var _local_4 = 0;
            var _local_5:IItemListWindow = null;
            var _local_6:IItemListWindow = null;
            var _local_7:IWindowContainer = null;
            var _local_8:IWindowContainer = null;
            if (!k)
            {
                return this._SafeStr_18897();
            }
            this._SafeStr_5998 = _SafeStr_18876;
            this._SafeStr_18900();
            var _local_2:Array<ASAny> = [];
            final _iter_ = this._SafeStr_13149; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_5 = Std.downcast(this._SafeStr_9274.findChildByName((("team" + Std.string(_local_3.__as3_final)) + "PlayersList")) , IItemListWindow);
                _local_6 = Std.downcast(this._SafeStr_9274.findChildByName(("player" + Std.string(_local_3.userId))) , IItemListWindow);
                if (_local_6 == null)
                {
                    return;
                }
                if (!_local_3._SafeStr_18910)
                {
                    _local_5.removeListItem(_local_6);
                    _local_2.push(_local_3.userId);
                }
                else
                {
                    _local_7 = Std.downcast(_local_6.getListItemByName("playerDataContainer") , IWindowContainer);
                    _local_8 = Std.downcast(_local_6.getListItemByName("playerScoreContainer") , IWindowContainer);
                    _local_7.findChildByName("playerStats").visible = false;
                    WindowUtils._Str_4180(this.findChildByName(_local_7, "playerName"), _local_3.userName);
                    WindowUtils._Str_26294(_local_8, "playerScore");
                }
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_4  = ASCompat.toInt(_tmp_);
                this._SafeStr_13149.remove(_local_4);
            }
            WindowUtils._Str_26294(this._SafeStr_9274, "buttonsContainer");
            WindowUtils._Str_26294(this._SafeStr_9274, "mostKillsContainer");
            WindowUtils._Str_26294(this._SafeStr_9274, "mostHitsContainer");
            WindowUtils._Str_26294(this._SafeStr_9274, "team1Score");
            WindowUtils._Str_26294(this._SafeStr_9274, "team2Score");
            WindowUtils._Str_4180(this.findChildByName(this._SafeStr_9274, "endingInformation"), "${snowwar.lobby_waiting_for_more_players}");
        }

        function _SafeStr_18897()
        {
            var _local_2:SnowWarAnimatedWindowElement = null;
            this._SafeStr_5998 = _SafeStr_18879;
            if (this._SafeStr_18882 != null)
            {
                final _iter_ = this._SafeStr_18882; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_2  = _tmp_;
                    _local_2.dispose();
                }
                this._SafeStr_18882.reset();
            }
            this._SafeStr_18904();
            if (this._SafeStr_18579._SafeStr_13224 == 0)
            {
                return;
            }
            this._SafeStr_9274.findChildByName("button_rematch").visible = false;
            this._SafeStr_9274.findChildByName("button_play_again").visible = true;
            var k= this._SafeStr_9274.findChildByName("button_play_again");
            k.enable();
            k.color = 0x55CC00;
        }

        function _SafeStr_18592()
        {
            if (this._SafeStr_5041)
            {
                return;
            }
            var k= Std.downcast(this._SafeStr_9274.findChildByName("endingInformation") , ITextWindow);
            var _local_2= Std.downcast(this._SafeStr_9274.findChildByName("endingInformation_stroke") , ITextWindow);
            k.fontSize = 28;
            _local_2.fontSize = 28;
            if (this._SafeStr_18579._SafeStr_13224 == 0)
            {
                WindowUtils._Str_4180(this.findChildByName(this._SafeStr_9274, "button_rematch"), "${catalog.vip.buy.title}");
            }
            else
            {
                if (this._SafeStr_5998 == _SafeStr_18874)
                {
                    this._SafeStr_18579.localization.registerParameter("snowwar.rematch", "seconds", Std.string(this._SafeStr_5217));
                    WindowUtils._Str_4180(this.findChildByName(this._SafeStr_9274, "button_rematch"), "${snowwar.rematch}");
                }
                else
                {
                    if (this._SafeStr_5998 == _SafeStr_18875)
                    {
                        this._SafeStr_18579.localization.registerParameter("snowwar.please_wait", "seconds", Std.string(this._SafeStr_5217));
                        WindowUtils._Str_4180(this.findChildByName(this._SafeStr_9274, "button_rematch"), "${snowwar.please_wait}");
                    }
                    else
                    {
                        if (this._SafeStr_5998 == _SafeStr_18877)
                        {
                            this._SafeStr_18579.localization.registerParameter("snowwar.lobby_game_start_countdown", "seconds", Std.string(this._SafeStr_5217));
                            WindowUtils._Str_4180(this.findChildByName(this._SafeStr_9274, "endingInformation"), "${snowwar.lobby_game_start_countdown}");
                            k.fontSize = 22;
                            _local_2.fontSize = 22;
                        }
                        else
                        {
                            if (this._SafeStr_5998 == _SafeStr_18876)
                            {
                                WindowUtils._Str_4180(this.findChildByName(this._SafeStr_9274, "endingInformation"), "${snowwar.lobby_waiting_for_more_players}");
                                k.fontSize = 22;
                                _local_2.fontSize = 22;
                            }
                        }
                    }
                }
            }
        }

        function _SafeStr_18898(k:Int)
        {
            this._SafeStr_18885();
            this._SafeStr_18584 = new Timer(1000, k);
            this._SafeStr_18584.addEventListener(TimerEvent.TIMER, (this._SafeStr_18589 : ASAny));
            this._SafeStr_18584.start();
            this._SafeStr_5217 = k;
        }

        function _SafeStr_18589(k:TimerEvent)
        {
            if (((this._SafeStr_5217 != 0) && (this._SafeStr_5217 > 0)))
            {
                this._SafeStr_5217--;
                HabboGamesCom.log([("On results window tick " + Std.string(this._SafeStr_5217))]);
                this._SafeStr_18592();
            }
        }

        function _SafeStr_18899(k:Int)
        {
            this._SafeStr_18898(k);
            this._SafeStr_18592();
        }

        function _SafeStr_18900()
        {
            this._SafeStr_18885();
            this._SafeStr_18592();
        }

        public function _SafeStr_13268(k:Int)
        {
            this._SafeStr_5998 = _SafeStr_18877;
            this._SafeStr_18898(k);
            this._SafeStr_18592();
        }

        public function _SafeStr_18901()
        {
            this._SafeStr_18885();
            this._SafeStr_18592();
        }

        public function _SafeStr_13271(k:_SafeStr_4018)
        {
            var _local_3:Game2TeamPlayerData = null;
            var _local_4 = 0;
            var _local_5:IItemListWindow = null;
            var _local_6:IItemListWindow = null;
            this._SafeStr_5998 = _SafeStr_18877;
            this._SafeStr_18881 = new Map();
            var _local_2:Array<ASAny> = [];
            final _iter_ = this._SafeStr_13149; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_5 = Std.downcast(this._SafeStr_9274.findChildByName((("team" + Std.string(_local_3.__as3_final)) + "PlayersList")) , IItemListWindow);
                _local_6 = Std.downcast(this._SafeStr_9274.findChildByName(("player" + Std.string(_local_3.userId))) , IItemListWindow);
                if (_local_6 == null)
                {
                    return;
                }
                _local_5.removeListItem(_local_6);
                _local_2.push(_local_3.userId);
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_4  = ASCompat.toInt(_tmp_);
                this._SafeStr_13149.remove(_local_4);
            }
            this._SafeStr_9274.findChildByName("loadingContainer").visible = true;
            WindowUtils._Str_26294(Std.downcast(this._SafeStr_9274.findChildByName("loadingContainer") , IWindowContainer), "loadingText");
            WindowUtils._Str_4180(this._SafeStr_9274.findChildByName("arenaName"), this._SafeStr_18579.gameArenaName(k));
            WindowUtils._Str_26442(this.findChildByName(this._SafeStr_9274, "headerContainer"), this._SafeStr_18895(1));
            WindowUtils.setElementImage(this._SafeStr_9274.findChildByName("arenaPreview"), this._SafeStr_12987((("arena_" + Std.string(k.fieldName)) + "_preview")));
        }

        public function _SafeStr_13272(k:_SafeStr_4032)
        {
            if (k != null)
            {
                this._SafeStr_18881.add(k.userId, k);
                this._SafeStr_18902();
            }
        }

        public function _SafeStr_13276(k:Int)
        {
            var _local_2:_SafeStr_4032 = this._SafeStr_18881.getValue(k);
            if (_local_2 != null)
            {
                this._SafeStr_18881.remove(k);
            }
            this._SafeStr_18902();
        }

        function _SafeStr_18902()
        {
            var _local_2:_SafeStr_4032 = null;
            this._SafeStr_18797();
            var k= this._SafeStr_18881.getValues();
            if (((!(this._SafeStr_5998 == _SafeStr_18874)) && (!(this._SafeStr_5998 == _SafeStr_18875))))
            {
                ASCompat.ASArray.sort(k, _SafeStr_4032._SafeStr_18802);
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this._SafeStr_18903(_local_2);
            }
        }

        function _SafeStr_18797()
        {
            var _local_2:IItemListWindow = null;
            var k= 1;
            while ((_local_2 = Std.downcast(this._SafeStr_9274.findChildByName((("team" + Std.string(k++)) + "PlayersList")) , IItemListWindow)) != null)
            {
                _local_2.destroyListItems();
            }
        }

        function _SafeStr_18903(k:_SafeStr_4032)
        {
            HabboGamesCom.log([("Add Lobby Player: " + ASCompat.toString([k.name, k.userId, k.__as3_final]))]);
            var _local_2= ASCompat.toInt((this._SafeStr_18881.getKeys().indexOf(k.userId) % _SafeStr_18873) + 1);
            var _local_3= Std.downcast(this._SafeStr_9274.findChildByName((("team" + Std.string(_local_2)) + "PlayersList")) , IItemListWindow);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= Std.downcast(WindowUtils.createWindow(("snowwar_lobby_player_team_" + Std.string(_local_2))) , IItemListWindow);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= Std.downcast(_local_4.getListItemByName("playerImageContainer") , IWindowContainer);
            var _local_6= Std.downcast(_local_4.getListItemByName("playerDataContainer") , IWindowContainer);
            var _local_7= Std.downcast(_local_4.getListItemByName("playerScoreContainer") , IWindowContainer);
            WindowUtils.setElementImage(this.findChildByName(_local_5, "playerImage"), this._SafeStr_18801(_local_2, k.figure, k.gender));
            WindowUtils._Str_4180(this.findChildByName(_local_6, "playerName"), k.name);
            WindowUtils._Str_26294(_local_6, "playerStats");
            WindowUtils._Str_26294(_local_7, "playerScore");
            WindowUtils._Str_26294(_local_6, "playerTotalStats");
            var _local_8= Std.downcast(_local_6.findChildByName("skillLevel") , IBitmapWrapperWindow);
            if (_local_8.bitmap != null)
            {
                _local_8.bitmap.dispose();
            }
            _local_8.bitmap = this._SafeStr_18799(k.skillLevel, _local_2);
            var _local_9= Std.downcast(_local_6.findChildByName("scoreTooltip") , IRegionWindow);
            _local_9.toolTipCaption = ((Std.string(k._SafeStr_17897) + "/") + Std.string(k._SafeStr_18803));
            _local_9.visible = true;
            _local_3.addListItem(_local_4);
        }

        function _SafeStr_18799(k:Int, _arg_2:Int):BitmapData
        {
            var _local_8:BitmapData = null;
            var _local_11:Point = null;
            k = Std.int(Math.min(k, 30));
            var _local_3= ASCompat.dynamicAs(this._SafeStr_18579.assets.getAssetByName("star_empty").content , BitmapData);
            var _local_4= ASCompat.dynamicAs(this._SafeStr_18579.assets.getAssetByName("star_filled_bronze").content , BitmapData);
            var _local_5= ASCompat.dynamicAs(this._SafeStr_18579.assets.getAssetByName("star_filled_silver").content , BitmapData);
            var _local_6= ASCompat.dynamicAs(this._SafeStr_18579.assets.getAssetByName("star_filled_gold").content , BitmapData);
            var _local_7= ((k > 0) ? (((k - 1) % 10) + 1) : 0);
            var _local_9= new BitmapData(150, 13, true, 0);
            var _local_10 = 0;
            while (_local_10 < 10)
            {
                _local_11 = ((_arg_2 == 1) ? new Point((_local_10 * 15), 0) : new Point(((9 - _local_10) * 15), 0));
                _local_8 = ((k > 20) ? ((_local_7-- > 0) ? _local_6 : _local_3) : ((k > 10) ? ((_local_7-- > 0) ? _local_5 : _local_3) : ((_local_7-- > 0) ? _local_4 : _local_3)));
                _local_9.copyPixels(_local_8, _local_8.rect, _local_11);
                _local_10++;
            }
            return _local_9;
        }

        public function _SafeStr_13277()
        {
            var _local_3:ITextWindow = null;
            var _local_4:IWindow = null;
            var k= Std.downcast(this._SafeStr_9274.findChildByName("buttonsContainer") , IWindowContainer);
            var _local_2= Std.downcast(this._SafeStr_9274.findChildByName("statusContainer") , IWindowContainer);
            if (((_local_2 != null) && (k != null)))
            {
                k.visible = true;
                WindowUtils._Str_4180(_local_2.findChildByName("games_left"), Std.string(this._SafeStr_18579._SafeStr_13224));
                _local_3 = Std.downcast(_local_2.findChildByName("games_left_stroke") , ITextWindow);
                _local_4 = this._SafeStr_9274.findChildByName("button_rematch");
                this._SafeStr_18772();
                if (this._SafeStr_18579._SafeStr_13223)
                {
                    _local_4.enable();
                    _local_4.color = 0x55CC00;
                    _local_2.visible = false;
                    return;
                }
                switch (this._SafeStr_18579._SafeStr_13224)
                {
                    case -1:
                        _local_4.enable();
                        _local_4.color = 0x55CC00;
                        _local_2.visible = false;
                        return;
                    case 0:
                        _local_3.textColor = 0xFF0000;
                        _local_4.enable();
                        _local_4.color = 0x55CC00;
                        return;
                    default:
                        _local_3.textColor = 1079212;
                        _local_4.enable();
                        _local_4.color = 0x55CC00;
                }
            }
        }

        function _SafeStr_18770(k:WindowMouseEvent)
        {
            switch (this._SafeStr_18761)
            {
                case _SafeStr_18752:
                    this._SafeStr_18579._SafeStr_13226("gameFramework.buyTokens.clicked.rematchView");
                    return;
                case _SafeStr_18753:
                    if (!this._SafeStr_18579._SafeStr_13227("gameFramework.videoOffer.clicked.rematchView"))
                    {
                        this._SafeStr_18761 = _SafeStr_18751;
                        this._SafeStr_18772();
                    }
                    return;
                default:
                    this._SafeStr_9859(true);
                    this._SafeStr_18579._SafeStr_7664("gameFramework.getVip.clicked.rematchView");
            }
        }

        function _SafeStr_18904()
        {
            this._SafeStr_18579.roomUI.hideWidget(RoomWidgetEnum.CHAT_INPUT_WIDGET);
        }

        public function offersAvailable(k:Int)
        {
            this._SafeStr_18762 = k;
            if (this._SafeStr_18762 < 1)
            {
                this._SafeStr_18761 = _SafeStr_18751;
            }
            if (this._SafeStr_9274 != null)
            {
                this._SafeStr_18772();
            }
        }
    }



























































































































































