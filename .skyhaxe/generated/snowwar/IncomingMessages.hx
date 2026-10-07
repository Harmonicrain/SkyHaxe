package snowwar
;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.habbo.game.HabboGames;
	import com.sulake.habbo.communication.messages.incoming.users.ScrSendUserInfoEvent;
	import snowwar._str_231.SynchronizedGameArena;
	import snowwar._str_231.SynchronizedGameStage;
	import snowwar._str_231._SafeStr_4019;
	import snowwar._str_277.SnowStormGenericErrorParser2;
	import com.sulake.habbo.communication.messages.parser.game.score.Game2LeaderboardParser;
	import snowwar._str_320._SafeStr_4674;
	//import com.sulake.room.renderer.cache._SafeStr_1440; //TODO
	import com.sulake.habbo.communication.messages.incoming.game.score.Game2WeeklyFriendsLeaderboardEvent;
	import com.sulake.habbo.communication.messages.incoming.game.score.Game2WeeklyLeaderboardEvent;
	import com.sulake.habbo.communication.messages.incoming.game.score.WeeklyCompetitiveLeaderboardEvent;
	import com.sulake.habbo.communication.messages.incoming.game.score.WeeklyCompetitiveFriendsLeaderboardEvent;
	import com.sulake.habbo.catalog._enum._SafeStr_2308; //constants 2308
	import snowwar._str_336.SnowStormOnStageStartEvent;
	import snowwar._str_336.SnowStormIntializeGameArenaViewEvent;
	import snowwar._str_336.SnowStormRejoinPreviousRoomEvent;
	import snowwar._str_336._SafeStr_3669;
	import snowwar._str_336.SnowStormLevelDataEvent;
	import snowwar._str_336.SnowStormOnGameEndingEvent;
	import snowwar._str_336.SnowStormUserChatMessageEvent;
	import snowwar._str_336.SnowStormOnStageRunningEvent;
	import snowwar._str_336.SnowStormOnStageEndingEvent;
	import snowwar._str_336.SnowStormIntializedPlayersEvent;
	import snowwar._str_336.SnowStormOnPlayerExitedArenaEvent;
	import snowwar._str_336.SnowStormUserRematchedEvent;
	import snowwar._str_343.SnowStormGameStatusEvent;
	import snowwar._str_343.SnowStormFullGameStatusEvent;
	import snowwar._str_377._SafeStr_4677;
	import snowwar._str_39.HumanGameObject;
	import snowwar._str_39.TreeGameObject;
	import snowwar._str_39._SafeStr_4035;
	import snowwar._str_39._SafeStr_4671;
	import snowwar._str_39._SafeStr_4672;
	import snowwar._str_448.SnowStormGameStartedEvent;
	import snowwar._str_448.SnowStormQuePositionEvent;
	import snowwar._str_448.SnowStormStartBlockTickerEvent;
	import snowwar._str_448.StartLobbyCounterEvent;
	import snowwar._str_448.SnowStormUnusedAlertGenericEvent;
	import snowwar._str_448.SnowStormLongDataEvent;
	import snowwar._str_448.SnowStormGameEndedEvent;
	import snowwar._str_448.SnowStormGenericErrorEvent;
	import snowwar._str_448.SnowStormQuePlayerAddedEvent;
	import snowwar._str_448.SnowStormPlayAgainEvent;
	import snowwar._str_448.SnowStormGamesLeftEvent;
	import snowwar._str_448.SnowStormQuePlayerRemovedEvent;
	import snowwar._str_448.SnowStormGamesInformationEvent;
	import snowwar._str_448.SnowStormLongData2Event;
	import snowwar.friendfurni.SnowStormGenericErrorParser;
	import snowwar.friendfurni.SnowStormGamesInformationParser;
	import snowwar._str_377._SafeStr_4679;
	import snowwar._str_377._SafeStr_4680;
	import snowwar._str_377._SafeStr_4681;
	import snowwar._str_377._SafeStr_4686;
	import snowwar._str_377._SafeStr_4687;
	import snowwar._str_377._SafeStr_4688;
	import snowwar._str_377._SafeStr_4689;
	import snowwar._str_377._SafeStr_4691;
	import snowwar._str_39._SafeStr_4670;
	import snowwar._str_400._SafeStr_3624;
	import snowwar._str_427._SafeStr_4021;
	import snowwar._str_427._SafeStr_4676;
	import snowwar._str_427._SafeStr_4678;
	import snowwar._str_427._SafeStr_4682;
	import snowwar._str_427._SafeStr_4683;
	import snowwar._str_427._SafeStr_4684;
	import snowwar._str_427._SafeStr_4685;
	import snowwar._str_427._SafeStr_4693;
	import snowwar._str_496._SafeStr_3610;
	import snowwar._str_496._SafeStr_4692;
	import snowwar._str_62.SnowWarGameObjectData;
	import snowwar._str_62.HumanGameObjectData;
	import snowwar._str_62._SafeStr_3584;
	import snowwar._str_62._SafeStr_3585;
	import snowwar._str_62._SafeStr_3586;
	import snowwar._str_62._SafeStr_3587;

     class IncomingMessages implements IDisposable 
    {
        var _snowWarEngine:SnowWarEngine;
        var _disposed:Bool = false;

        public function new(k:SnowWarEngine)
        {
            this._snowWarEngine = k;
            var _local_2= this._snowWarEngine.communication;
            _local_2.addHabboConnectionMessageEvent(new WeeklyCompetitiveFriendsLeaderboardEvent(this._SafeStr_18914));
            _local_2.addHabboConnectionMessageEvent(new SnowStormIntializedPlayersEvent(this._SafeStr_18915));
            _local_2.addHabboConnectionMessageEvent(new SnowStormOnStageStartEvent(this._SafeStr_18916));
            _local_2.addHabboConnectionMessageEvent(new SnowStormLevelDataEvent(this._SafeStr_18917));
            _local_2.addHabboConnectionMessageEvent(new WeeklyCompetitiveLeaderboardEvent(this._SafeStr_18918));
            _local_2.addHabboConnectionMessageEvent(new SnowStormQuePositionEvent(this._SafeStr_18919));
            _local_2.addHabboConnectionMessageEvent(new SnowStormGameEndedEvent(this._SafeStr_18920));
            _local_2.addHabboConnectionMessageEvent(new SnowStormGamesLeftEvent(this._SafeStr_13119));
            _local_2.addHabboConnectionMessageEvent(new SnowStormOnStageRunningEvent(this._SafeStr_18921));
            _local_2.addHabboConnectionMessageEvent(new _SafeStr_3669(this._SafeStr_18922));
            _local_2.addHabboConnectionMessageEvent(new SnowStormGameStatusEvent(this._SafeStr_18518));
            _local_2.addHabboConnectionMessageEvent(new SnowStormIntializeGameArenaViewEvent(this._SafeStr_18923));
            _local_2.addHabboConnectionMessageEvent(new SnowStormGenericErrorEvent(this._SafeStr_18924));
            _local_2.addHabboConnectionMessageEvent(new SnowStormRejoinPreviousRoomEvent(this._SafeStr_18925));
            _local_2.addHabboConnectionMessageEvent(new SnowStormLongDataEvent(this._SafeStr_18926));
            _local_2.addHabboConnectionMessageEvent(new ScrSendUserInfoEvent(this._SafeStr_18927));
            _local_2.addHabboConnectionMessageEvent(new SnowStormOnStageEndingEvent(this._SafeStr_18928));
            _local_2.addHabboConnectionMessageEvent(new SnowStormOnPlayerExitedArenaEvent(this._SafeStr_18929));
            _local_2.addHabboConnectionMessageEvent(new SnowStormUnusedAlertGenericEvent(this._SafeStr_18930));
            _local_2.addHabboConnectionMessageEvent(new SnowStormGameStartedEvent(this._SafeStr_10644));
            _local_2.addHabboConnectionMessageEvent(new SnowStormPlayAgainEvent(this._SafeStr_18931));
            _local_2.addHabboConnectionMessageEvent(new SnowStormStartBlockTickerEvent(this._SafeStr_18932));
            _local_2.addHabboConnectionMessageEvent(new Game2WeeklyFriendsLeaderboardEvent(this._SafeStr_18933));
            _local_2.addHabboConnectionMessageEvent(new SnowStormUserChatMessageEvent(this._SafeStr_18934));
            _local_2.addHabboConnectionMessageEvent(new SnowStormLongData2Event(this._SafeStr_18935));
            _local_2.addHabboConnectionMessageEvent(new SnowStormGenericErrorEvent(this._SafeStr_18936));
            _local_2.addHabboConnectionMessageEvent(new SnowStormOnGameEndingEvent(this._SafeStr_18937));
            _local_2.addHabboConnectionMessageEvent(new SnowStormGamesInformationEvent(this._SafeStr_18938));
            _local_2.addHabboConnectionMessageEvent(new SnowStormQuePlayerRemovedEvent(this._SafeStr_18939));
            _local_2.addHabboConnectionMessageEvent(new StartLobbyCounterEvent(this._SafeStr_18940));
            _local_2.addHabboConnectionMessageEvent(new Game2WeeklyLeaderboardEvent(this._SafeStr_18941));
            _local_2.addHabboConnectionMessageEvent(new SnowStormUserRematchedEvent(this._SafeStr_18942));
            _local_2.addHabboConnectionMessageEvent(new SnowStormFullGameStatusEvent(this._SafeStr_18943));
            _local_2.addHabboConnectionMessageEvent(new SnowStormQuePlayerAddedEvent(this._SafeStr_18944));
            //_local_2.addHabboConnectionMessageEvent(new _SafeStr_1440(this._SafeStr_6336));
        }

        public function dispose()
        {
            this._snowWarEngine = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function _SafeStr_18917(k:SnowStormLevelDataEvent)
        {
            var _local_2= k.getParser();
            this._snowWarEngine.initializeGameArena(_local_2._SafeStr_12658, _local_2.fieldName, _local_2._SafeStr_13274, _local_2._SafeStr_13266);
            var _local_3= this._snowWarEngine.synchronizedGameArena;
            var _local_4= _local_3.synchronizedGameStage();
            _local_4.initialize(this._snowWarEngine.synchronizedGameArena, _local_2._SafeStr_18958);
            this._snowWarEngine.gameMainViewController.close(false);
        }

        function _SafeStr_18924(k:SnowStormGenericErrorEvent)
        {
            var _local_2= k.getParser();
            var _local_3= "snowwar.error.generic";
            switch (_local_2.reason)
            {
                case SnowStormGenericErrorParser2._SafeStr_18959:
                    _local_3 = "snowwar.error.game_already_started";
                    
                case SnowStormGenericErrorParser2._SafeStr_21884:
                    _local_3 = "snowwar.error.no_free_games_left";
                    
                case SnowStormGenericErrorParser2._SafeStr_21885:
                    _local_3 = "snowwar.error.dulicate_machineid";
                    
                case SnowStormGenericErrorParser2._SafeStr_21886:
                    _local_3 = "snowwar.error.has_active_instance";
                    
            }
            this._snowWarEngine.alert((("${" + _local_3) + "}"));
        }

        function _SafeStr_18922(k:_SafeStr_3669)
        {
            var _local_2= k.getParser();
            var _local_3= _local_2.player;
        }

        function _SafeStr_18923(k:SnowStormIntializeGameArenaViewEvent)
        {
            var _local_2= k.getParser();
            this._snowWarEngine.initializeGameArenaView();
        }

        function _SafeStr_18915(k:SnowStormIntializedPlayersEvent)
        {
            var _local_2= k.getParser();
            this._snowWarEngine.playersInitialized(_local_2._SafeStr_18960, _local_2._SafeStr_18961);
        }

        function _SafeStr_18916(k:SnowStormOnStageStartEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([("[HabbosnowWarEngine] On stage start: " + Std.string(_local_2._SafeStr_12659))]);
            var _local_3= _local_2._SafeStr_7508;
            this._SafeStr_18945(_local_3);
            this._snowWarEngine.onStageStart(_local_2._SafeStr_12659);
        }

        function _SafeStr_18921(k:SnowStormOnStageRunningEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([("[HabbosnowWarEngine] On stage running: " + Std.string(_local_2.time))]);
            this._snowWarEngine.onStageRunning(_local_2.time);
        }

        function _SafeStr_18928(k:SnowStormOnStageEndingEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([("[HabbosnowWarEngine] On stage ending: " + Std.string(_local_2._SafeStr_18963))]);
            if (_local_2._SafeStr_18963 == 0)
            {
                this._snowWarEngine.onStageEnding();
            }
        }

        function _SafeStr_18937(k:SnowStormOnGameEndingEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([("[HabbosnowWarEngine] On game ending: " + Std.string(_local_2._SafeStr_18963))]);
            this._snowWarEngine.onGameEnding(_local_2._SafeStr_18963, _local_2._SafeStr_18964, _local_2._SafeStr_18965, _local_2._SafeStr_18966);
        }

        function _SafeStr_18929(k:SnowStormOnPlayerExitedArenaEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([((("[HabbosnowWarEngine] On player exited arena. userId:" + Std.string(_local_2.userId)) + " gameObjectId:") + Std.string(_local_2._SafeStr_18967))]);
        }

        function _SafeStr_18925(k:SnowStormRejoinPreviousRoomEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([("Rejoin game! Room Before game: " + Std.string(_local_2.rejoinRoom))]);
            this._snowWarEngine.setRejoinRoom(_local_2.rejoinRoom);
        }

        function _SafeStr_18942(k:SnowStormUserRematchedEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([(("User " + Std.string(_local_2.userId)) + " rematches")]);
            this._snowWarEngine.rematchPlayer(_local_2.userId);
        }

        function _SafeStr_18938(k:SnowStormGamesInformationEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.status == SnowStormGamesInformationParser._SafeStr_18968)
            {
                this._snowWarEngine.gameMainViewController._SafeStr_18778(_local_2.timeTillNextGame);
                this._snowWarEngine._SafeStr_13229 = _local_2.userId;
                this._snowWarEngine._SafeStr_13182(true);
                this._snowWarEngine._SafeStr_13221(HabboGames._SafeStr_7697, _local_2.infiniteGames, _local_2.gamesLeft);
            }
            else
            {
                this._snowWarEngine._SafeStr_13182(false);
                HabboGamesCom.log([("Game directory not available, status:" + Std.string(_local_2.status))]);
            }
        }

        function _SafeStr_13119(k:SnowStormGamesLeftEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([((("FREE GAMES LEFT: " + Std.string(_local_2._SafeStr_13224)) + " OR HAS UNLIMITED GAMES: ") + Std.string(_local_2._SafeStr_13223))]);
            this._snowWarEngine._SafeStr_13221(_local_2.gameTypeId, _local_2._SafeStr_13223, _local_2._SafeStr_13224);
        }

        function _SafeStr_18926(k:SnowStormLongDataEvent)
        {
            var _local_2= k.getParser();
            var _local_3= _local_2._SafeStr_18970;
            this._snowWarEngine.onLongDataReceived(_local_3);
        }

        function _SafeStr_10644(k:SnowStormGameStartedEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log(["Game started!"]);
			try
			{
				this._snowWarEngine.onGameStart(_local_2._SafeStr_18971);
			}
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught); 			{
				HabboGamesCom.log([e.getStackTrace()]);
			}
 }        }

        function _SafeStr_18940(k:StartLobbyCounterEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log([("Start Lobby Counter: " + Std.string(_local_2._SafeStr_18972))]);
            this._snowWarEngine.onStartLobbyCounter(_local_2._SafeStr_18972);
        }

        function _SafeStr_18931(k:SnowStormPlayAgainEvent)
        {
            this._snowWarEngine._SafeStr_13217();
        }

        function _SafeStr_18920(k:SnowStormGameEndedEvent)
        {
            this._snowWarEngine._SafeStr_13222(false);
        }

        function _SafeStr_18919(k:SnowStormQuePositionEvent)
        {
            var _local_2= k.getParser();
            if (this._snowWarEngine.gameLobbyViewController != null)
            {
                this._snowWarEngine.gameLobbyViewController._SafeStr_18591 = _local_2.position;
            }
        }

        function _SafeStr_18944(k:SnowStormQuePlayerAddedEvent)
        {
            var _local_2= k.getParser();
            this._snowWarEngine._SafeStr_13219(_local_2.user);
        }

        function _SafeStr_18939(k:SnowStormQuePlayerRemovedEvent)
        {
            var _local_2= k.getParser();
            this._snowWarEngine._SafeStr_13220(_local_2.userId);
        }

        function _SafeStr_18935(k:SnowStormLongData2Event)
        {
            var _local_2= k.getParser();
            var _local_3= _local_2._SafeStr_18970;
            HabboGamesCom.log([("Long data received: " + ASCompat.toString([_local_3.fieldName, _local_3._SafeStr_13274, _local_3._SafeStr_13275]))]);
            this._snowWarEngine.onLongDataReceived(_local_3);
        }

        function _SafeStr_18936(k:SnowStormGenericErrorEvent)
        {
            var _local_2= k.getParser();
            var errorCode= "snowwar.error.generic";
            switch (_local_2.reason)
            {
                case SnowStormGenericErrorParser._SafeStr_18973
                   | SnowStormGenericErrorParser._SafeStr_18974:
                    errorCode = "snowwar.error.has_active_instance";
                    
                case SnowStormGenericErrorParser._SafeStr_18975:
                    errorCode = "snowwar.error.no_free_games_left";
                    
                case SnowStormGenericErrorParser._SafeStr_13125:
                    errorCode = "snowwar.error.duplicate_machineid";
                    
            }
            this._snowWarEngine.alert((("${" + errorCode) + "}"));
        }

        function _SafeStr_18930(k:SnowStormUnusedAlertGenericEvent)
        {
            this._snowWarEngine.alert("${snowwar.error.generic}");
        }

        function _SafeStr_18932(k:SnowStormStartBlockTickerEvent)
        {
            var _local_2= k.getParser();
            this._snowWarEngine.gameMainViewController._SafeStr_18778(_local_2._SafeStr_18976);
        }

        function _SafeStr_18943(k:SnowStormFullGameStatusEvent)
        {
            var _local_5:_SafeStr_4692 = null;
            var _local_2= k.getParser();
            var gameArena= this._snowWarEngine.synchronizedGameArena;
            HabboGamesCom.log(["On full game status: "]);
            var _local_4= _local_2._SafeStr_18977;
            Std.downcast(gameArena.synchronizedGameStage() , SnowWarGameStage).removeGameObjects();
            this._SafeStr_18945(_local_4._SafeStr_7508);
            if (gameArena != null)
            {
                _local_5 = _local_4._SafeStr_18978;
                gameArena.newTurn(_local_5.turn, _local_5.checksum);
                this._SafeStr_18946(_local_5, true);
            }
        }

        function _SafeStr_18518(k:SnowStormGameStatusEvent)
        {
            var _local_2= k.getParser();
            HabboGamesCom.log(["[HabbosnowWarEngine] On game status: "]);
            this._SafeStr_18946(_local_2.status);
        }

        function _SafeStr_18945(k:_SafeStr_3610)
        {
            var _local_3:SnowWarGameStage = null;
            var _local_4:SnowWarGameObjectData = null;
            var _local_5:HumanGameObjectData = null;
            var _local_6 = false;
            var _local_7:HumanGameObject = null;
            var _local_8:_SafeStr_3587 = null;
            var _local_9:_SafeStr_4035 = null;
            var _local_10:HumanGameObject = null;
            var _local_11:_SafeStr_3585 = null;
            var _local_12:_SafeStr_4672 = null;
            var _local_13:_SafeStr_3586 = null;
            var _local_14:_SafeStr_4671 = null;
            var _local_15:_SafeStr_3584 = null;
            var _local_16:TreeGameObject = null;
            var _local_17:HumanGameObject = null;
            var _local_2= this._snowWarEngine.synchronizedGameArena;
            if (_local_2 == null)
            {
                return;
            }
            _local_3 = Std.downcast(_local_2.synchronizedGameStage() , SnowWarGameStage);
            _local_3._SafeStr_18709();
            final _iter_ = k._SafeStr_7508; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                switch (_local_4.type)
                {
                    case SnowWarGameObjectData.OBJECT_TYPE_HUMAN:
                        _local_5 = Std.downcast(_local_4 , HumanGameObjectData);
                        _local_6 = (_local_5.name == this._snowWarEngine.sessionDataManager.userName);
                        if (_local_6)
                        {
                            this._snowWarEngine.gamePlayerId = _local_5.id;
                        }
                        _local_7 = new HumanGameObject(_local_3, _local_5, false, this._snowWarEngine);
                        _local_3.addActiveGameObject(_local_7._SafeStr_13236, _local_7);
                        _local_7._SafeStr_18745 = _SafeStr_2308.ANY;
                        if ((_local_6 && this._snowWarEngine.ghostEnabled))
                        {
                            if (this._snowWarEngine.ghostVisualizationEnabled)
                            {
                                _local_7._SafeStr_18745 = _SafeStr_4674._SafeStr_10198;
                            }
                            else
                            {
                                _local_7._SafeStr_18745 = _SafeStr_4674._SafeStr_7300;
                            }
                            if (this._snowWarEngine.synchronizedGameArena.synchronizedGameStage().getGameObject(_local_7._SafeStr_13241) == null)
                            {
                                _local_17 = new HumanGameObject(_local_3, _local_5, true, this._snowWarEngine);
                                _local_17._SafeStr_13236 = _local_7._SafeStr_13241;
                                _local_3.addActiveGameObject(_local_17._SafeStr_13236, _local_17);
                            }
                        }
                        HabboGamesCom.log([((((("human id:" + Std.string(_local_5.id)) + " x:") + Std.string(_local_5.x)) + " y:") + Std.string(_local_5.y))]);
                        
                    case SnowWarGameObjectData.OBJECT_TYPE_SNOWBALL:
                        _local_8 = Std.downcast(_local_4 , _SafeStr_3587);
                        _local_9 = new _SafeStr_4035(_local_8.id);
                        _local_10 = Std.downcast(_local_3.getGameObject(_local_8._SafeStr_18040) , HumanGameObject);
                        _local_9._SafeStr_18982(_local_8, _local_10);
                        _local_3.addActiveGameObject(_local_9._SafeStr_13236, _local_9);
                        HabboGamesCom.log([((("snowball x:" + Std.string(_local_8.x)) + " y:") + Std.string(_local_8.y))]);
                        
                    case SnowWarGameObjectData.OBJECT_TYPE_SNOWBALL_MACHINE:
                        _local_11 = Std.downcast(_local_4 , _SafeStr_3585);
                        _local_12 = new _SafeStr_4672(_local_11, _local_3);
                        _local_3.addActiveGameObject(_local_11.id, _local_12);
                        HabboGamesCom.log([("machine id:" + Std.string(_local_11.id))]);
                        
                    case SnowWarGameObjectData.OBJECT_TYPE_SNOWBALL_PILE:
                        _local_13 = Std.downcast(_local_4 , _SafeStr_3586);
                        _local_14 = new _SafeStr_4671(_local_13, _local_3);
                        _local_3.addActiveGameObject(_local_13.id, _local_14);
                        HabboGamesCom.log([("pile id:" + Std.string(_local_13.id))]);
                        
                    case SnowWarGameObjectData.OBJECT_TYPE_TREE:
                        _local_15 = Std.downcast(_local_4 , _SafeStr_3584);
                        _local_16 = new TreeGameObject(_local_15, _local_3);
                        _local_3.addActiveGameObject(_local_16._SafeStr_13236, _local_16);
                        HabboGamesCom.log([("tree id:" + Std.string(_local_16._SafeStr_13236))]);
                        
                    default:
                        HabboGamesCom.log([("Unkonwn game-object:" + Std.string(_local_4.type))]);
                }
            }
        }

        function _SafeStr_18946(status:_SafeStr_4692, _arg_2:Bool=false)
        {
            var subturn = 0;
            var _local_7 = 0;
            var eventsList:Array<ASAny> = null;
            var event:_SafeStr_4677 = null;
            var userEvent:_SafeStr_4019 = null;
            var targetEvent:_SafeStr_4019 = null;
            var events= status.events ;
            var gameArena= this._snowWarEngine.synchronizedGameArena;
            if (gameArena == null)
            {
                return;
            }
            var turn= status.turn;
            final _iter_ = events.getKeys(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
subturn  = ASCompat.toInt(_tmp_);
                eventsList = ASCompat.dynamicAs(events.getValue(subturn) , Array);
                if (checkNullIteratee(eventsList)) for (_tmp_ in eventsList)
                {
event  = _tmp_;
                    switch (event.id)
                    {
                        case _SafeStr_4677._SafeStr_18983:
                            userEvent = this._SafeStr_18952(Std.downcast(event , _SafeStr_4687));
                            
                        case _SafeStr_4677._SafeStr_18984:
                            userEvent = this._SafeStr_18947(Std.downcast(event , _SafeStr_4686));
                            
                        case _SafeStr_4677._SafeStr_18985:
                            userEvent = this._SafeStr_18951(Std.downcast(event , _SafeStr_4681));
                            targetEvent = this._SafeStr_18957(Std.downcast(event , _SafeStr_4681));
                            
                        case _SafeStr_4677._SafeStr_18986:
                            userEvent = this._SafeStr_18948(Std.downcast(event , _SafeStr_4679));
                            
                        case _SafeStr_4677._SafeStr_18987:
                            userEvent = this._SafeStr_18953(Std.downcast(event , _SafeStr_4689)); //Event 2: PlayerMoveEvent
                            
                        case _SafeStr_4677._SafeStr_18988:
                            userEvent = this._SafeStr_18950(Std.downcast(event , _SafeStr_4691)); //Event 3: ThrowBallToPlayerEvent
                            targetEvent = this._SafeStr_18956(Std.downcast(event , _SafeStr_4691)); //Event 3:
                            
                        case _SafeStr_4677._SafeStr_18989:
                            userEvent = this._SafeStr_18949(Std.downcast(event , _SafeStr_4688)); //Event 4: 
                            targetEvent = this._SafeStr_18955(Std.downcast(event , _SafeStr_4688));
                            
                        case _SafeStr_4677._SafeStr_18990:
                            userEvent = this._SafeStr_18954(Std.downcast(event , _SafeStr_4680)); //Event 1: RemovePlayerEvent
                            
                        default:
                            HabboGamesCom.log([("Unknown event id " + Std.string(event.id))]);
                    }
                    if (userEvent != null)
                    {
                        gameArena.addGameEvent((turn + 1), subturn, userEvent);
                    }
                    if (targetEvent != null)
                    {
                        gameArena.addGameEvent((turn + 1), subturn, targetEvent);
                    }
                }
            }
            _local_7 = status.checksum;
            this._snowWarEngine._SafeStr_13198(turn, _local_7, _arg_2);
        }

        function _SafeStr_18947(k:_SafeStr_4686):_SafeStr_4684
        {
            var _local_2= this._snowWarEngine.synchronizedGameArena;
            var _local_3= _local_2.synchronizedGameStage();
            var _local_4= Std.downcast(_local_3.getGameObject(k._SafeStr_18991) , HumanGameObject);
            var _local_5= Std.downcast(_local_3.getGameObject(k._SafeStr_18992) , _SafeStr_4670);
            return new _SafeStr_4684(_local_4, _local_5);
        }

        function _SafeStr_18948(k:_SafeStr_4679):_SafeStr_4682
        {
            var _local_2= this._snowWarEngine.synchronizedGameArena;
            var _local_3= _local_2.synchronizedGameStage();
            var _local_4= Std.downcast(_local_3.getGameObject(k._SafeStr_18992) , _SafeStr_4672);
            return new _SafeStr_4682(_local_4);
        }

        function _SafeStr_18949(k:_SafeStr_4688):_SafeStr_4693 //Event 4 (USER): 
        {
            var _local_2= this._snowWarEngine.synchronizedGameArena;
            var _local_3= _local_2.synchronizedGameStage();
            var _local_4= Std.downcast(_local_3.getGameObject(k._SafeStr_18991) , HumanGameObject);
            return new _SafeStr_4693(_local_4, k.targetX, k._SafeStr_16005, k._SafeStr_18038);
        }

        function _SafeStr_18950(k:_SafeStr_4691):_SafeStr_4683 //Event 3 (USER): ThrowBallToPlayerEvent
        {
            var _local_2= this._snowWarEngine.synchronizedGameArena;
            var _local_3= _local_2.synchronizedGameStage();
            var _local_4= Std.downcast(_local_3.getGameObject(k._SafeStr_18991) , HumanGameObject);
            var _local_5= Std.downcast(_local_3.getGameObject(k._SafeStr_18993) , HumanGameObject);
            return new _SafeStr_4683(_local_4, _local_5, k._SafeStr_18038);
        }

        function _SafeStr_18951(k:_SafeStr_4681):_SafeStr_4676
        {
            var _local_2= this._snowWarEngine.synchronizedGameArena;
            var _local_3= _local_2.synchronizedGameStage();
            var _local_4= Std.downcast(_local_3.getGameObject(k._SafeStr_18991) , HumanGameObject);
            return new _SafeStr_4676(_local_4);
        }

        function _SafeStr_18952(k:_SafeStr_4687):_SafeStr_4685
        {
            var _local_2= this._snowWarEngine.synchronizedGameArena;
            var _local_3= _local_2.synchronizedGameStage();
            var _local_4= Std.downcast(_local_3.getGameObject(k._SafeStr_18991) , HumanGameObject);
            return new _SafeStr_4685(k._SafeStr_18994, _local_4, k.targetX, k._SafeStr_16005, k._SafeStr_18038);
        }

        function _SafeStr_18953(k:_SafeStr_4689):_SafeStr_4021
        {
            var _local_2= this._snowWarEngine.synchronizedGameArena;
            var _local_3= _local_2.synchronizedGameStage();
            var _local_4= Std.downcast(_local_3.getGameObject(k._SafeStr_18991) , HumanGameObject);
            return new _SafeStr_4021(_local_4, k.x, k.y);
        }

        function _SafeStr_18954(k:_SafeStr_4680):_SafeStr_4678 //Event 1: RemovePlayerEvent
        {
            var _local_2= this._snowWarEngine.synchronizedGameArena;
            var _local_3= _local_2.synchronizedGameStage();
            var _local_4= Std.downcast(_local_3.getGameObject(k._SafeStr_18991) , HumanGameObject);
            return new _SafeStr_4678(_local_4);
        }

        function _SafeStr_18955(k:_SafeStr_4688):_SafeStr_4693 //Event 4: 
        {
            var _local_2:SynchronizedGameArena = null;
            var _local_3:SynchronizedGameStage = null;
            if (this._snowWarEngine.ghostEnabled)
            {
                _local_2 = this._snowWarEngine.synchronizedGameArena;
                _local_3 = _local_2.synchronizedGameStage();
                if (k._SafeStr_18991 == this._snowWarEngine.gamePlayerId)
                {
                    return new _SafeStr_4693(this._snowWarEngine._SafeStr_13190(), k.targetX, k._SafeStr_16005, k._SafeStr_18038);
                }
            }
            return null;
        }

        function _SafeStr_18956(k:_SafeStr_4691):_SafeStr_4683 //Event 3 (TARGET): ThrowBallToPlayerEvent
        {
            var _local_2:SynchronizedGameArena = null;
            var _local_3:SynchronizedGameStage = null;
            var _local_4:HumanGameObject = null;
            if (this._snowWarEngine.ghostEnabled)
            {
                _local_2 = this._snowWarEngine.synchronizedGameArena;
                _local_3 = _local_2.synchronizedGameStage();
                _local_4 = Std.downcast(_local_3.getGameObject(k._SafeStr_18993) , HumanGameObject);
                if (k._SafeStr_18991 == this._snowWarEngine.gamePlayerId)
                {
                    return new _SafeStr_4683(this._snowWarEngine._SafeStr_13190(), _local_4, k._SafeStr_18038);
                }
            }
            return null;
        }

        function _SafeStr_18957(k:_SafeStr_4681):_SafeStr_4676
        {
            var _local_2:SynchronizedGameArena = null;
            var _local_3:SynchronizedGameStage = null;
            var _local_4:HumanGameObject = null;
            if (this._snowWarEngine.ghostEnabled)
            {
                _local_2 = this._snowWarEngine.synchronizedGameArena;
                _local_3 = _local_2.synchronizedGameStage();
                _local_4 = Std.downcast(_local_3.getGameObject(k._SafeStr_18991) , HumanGameObject);
                if (k._SafeStr_18991 == this._snowWarEngine.gamePlayerId)
                {
                    return new _SafeStr_4676(this._snowWarEngine._SafeStr_13190());
                }
            }
            return null;
        }

        function _SafeStr_18934(k:SnowStormUserChatMessageEvent)
        {
            var _local_2= k.getParser();
            this._snowWarEngine._SafeStr_13216(_local_2.userId, _local_2._SafeStr_18212);
        }

        function _SafeStr_18927(k:ScrSendUserInfoEvent)
        {
            if (this._snowWarEngine != null)
            {
                this._snowWarEngine.send(new _SafeStr_3624(HabboGames._SafeStr_7697));
                if (!this._snowWarEngine.gameCenterEnabled)
                {
                    this._snowWarEngine.gameMainViewController.createAndVisible(false);
                }
            }
        }

        /* //Could not find assigned incoming message for this. Seems to have been removed.
		 * private function _SafeStr_6336(k:_SafeStr_1440):void
        {
            this._snowWarEngine._SafeStr_7663();
        }*/

        function _SafeStr_18933(k:Game2WeeklyFriendsLeaderboardEvent)
        {
            var _local_2:Game2LeaderboardParser = k.getParser();
            if (_local_2.gameTypeId != HabboGames._SafeStr_7697)
            {
                return;
            }
            if (this._snowWarEngine.leaderboardReady)
            {
                this._snowWarEngine.leaderboard._SafeStr_18636(_local_2.leaderboard, _local_2._Str_26158);
            }
        }

        function _SafeStr_18941(k:Game2WeeklyLeaderboardEvent)
        {
            var _local_2:Game2LeaderboardParser = k.getParser();
            if (_local_2.gameTypeId != HabboGames._SafeStr_7697)
            {
                return;
            }
            if (this._snowWarEngine.leaderboardReady)
            {
                this._snowWarEngine.leaderboard._SafeStr_18634(_local_2.leaderboard, _local_2._Str_26158);
            }
        }

        function _SafeStr_18918(k:WeeklyCompetitiveLeaderboardEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.gameTypeId != HabboGames._SafeStr_7697)
            {
                return;
            }
            if (this._snowWarEngine.leaderboardReady)
            {
                this._snowWarEngine.leaderboard._SafeStr_18635(_local_2.year, _local_2.week, _local_2.leaderboard, _local_2._Str_26158, _local_2.maxOffset, _local_2.minutesUntilReset);
            }
        }

        function _SafeStr_18914(k:WeeklyCompetitiveFriendsLeaderboardEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.gameTypeId != HabboGames._SafeStr_7697)
            {
                return;
            }
            if (this._snowWarEngine.leaderboardReady)
            {
                this._snowWarEngine.leaderboard._SafeStr_18637(_local_2.year, _local_2.week, _local_2.leaderboard, _local_2._Str_26158, _local_2.maxOffset, _local_2.minutesUntilReset);
            }
        }
    }

