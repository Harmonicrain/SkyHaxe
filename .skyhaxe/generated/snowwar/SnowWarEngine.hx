package snowwar
;
	import com.sulake.habbo.game.HabboGames;
	import com.sulake.core.runtime.Component;
	import com.sulake.core.runtime.IHabboConfigurationManager;
	import com.sulake.core.runtime.IUpdateReceiver;
	import com.sulake.core.runtime.IContext;
	import com.sulake.core.runtime.IUnknown;
	import com.sulake.core.runtime.IID;
	import com.sulake.habbo.session.IRoomSessionManager;
	import com.sulake.habbo.session.ISessionDataManager;
	import com.sulake.habbo.catalog.IHabboCatalog;
	import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
	import com.sulake.habbo.toolbar.WingCodeEnum;
	import com.sulake.habbo.ui.IRoomUI;
	import com.sulake.habbo.window.IHabboWindowManager;
	import com.sulake.habbo.friendlist.IHabboFriendsList;
	import com.sulake.habbo.window.utils.IAlertDialog;
	import com.sulake.habbo.sound.IHabboSoundManager;
	import com.sulake.habbo.sound.HabboSoundTypesEnum;
	import com.sulake.habbo.help.IHabboHelp;
	import com.sulake.habbo.localization.IHabboLocalizationManager;
	import com.sulake.habbo.avatar._enum.AvatarAction;
	import com.sulake.habbo.avatar._enum.AvatarRenderEvent;
	import com.sulake.habbo.groups.IHabboGroupsManager;
	import com.sulake.habbo.game.HabboGameManager;
	import com.sulake.habbo.game.WindowUtils;
	import com.sulake.habbo.avatar.IAvatarRenderManager;
	import com.sulake.habbo.help._enum.WelcomeNotificationAlignment;
	import com.sulake.core.assets.AssetLibraryCollection;
	import com.sulake.core.assets.XmlAsset;
	import com.sulake.core.assets.IAssetLibrary;
	import com.sulake.core.utils.Map;
	import com.sulake.core.communication.messages.IMessageComposer;
	import com.sulake.core.window.events.WindowEvent;
	import com.sulake.habbo.communication.IHabboCommunicationManager;
	import snowwar._str_496.Game2GameResult;
	import snowwar._str_496.Game2SnowWarGameStats;
	import snowwar._str_496._SafeStr_4018;
	import snowwar._str_496._SafeStr_4032;
	import com.sulake.habbo.game.events.GameChatEvent;
	import com.sulake.habbo.room.events.RoomEngineEvent;
	import com.sulake.habbo.room.events.RoomObjectTileMouseEvent;
	import com.sulake.habbo.room.IRoomEngine;
	import com.sulake.iid.IIDAvatarRenderManager;
	import com.sulake.iid.IIDHabboCatalog;
	import com.sulake.iid.IIDHabboCommunicationManager;
	import com.sulake.iid.IIDHabboConfigurationManager;
	import com.sulake.iid.IIDHabboFriendList;
	import com.sulake.iid.IIDHabboGroupsManager;
	import com.sulake.iid.IIDHabboHelp;
	import com.sulake.iid.IIDHabboLocalizationManager;
	import com.sulake.iid.IIDHabboRoomSessionManager;
	import com.sulake.iid.IIDHabboRoomUI;
	import com.sulake.iid.IIDHabboSoundManager;
	import com.sulake.iid.IIDHabboWindowManager;
	import com.sulake.iid.IIDRoomEngine;
	import com.sulake.iid.IIDSessionDataManager;
	import com.sulake.habbo.catalog._enum.VideoOfferTypeEnum;
	import flash.events.Event;
	import flash.net.URLRequest;
	import snowwar._str_231.SynchronizedGameArena;
	import snowwar._str_231.SynchronizedGameStage;
	import snowwar._str_231._SafeStr_4019;
	import snowwar._str_254.Location;
	import snowwar._str_267.LeaderboardViewController;
	import snowwar._str_345._SafeStr_1434;
	import snowwar._str_373.*;
	import snowwar._str_373._SafeStr_3643;
	import snowwar._str_373._SafeStr_3918;
	import snowwar._str_39.HumanGameObject;
	import snowwar._str_39._SafeStr_4035;
	import snowwar._str_400.*;
	import snowwar._str_400._SafeStr_2507;
	import snowwar._str_400._SafeStr_2513;
	import snowwar._str_400._SafeStr_2519;
	import snowwar._str_400._SafeStr_3624;
	import snowwar._str_427._SafeStr_4021;
	import snowwar._str_496.*;
	import snowwar.outgoing._SafeStr_3806;
	import snowwar.outgoing._SafeStr_3904;
	import snowwar.outgoing._SafeStr_3908;
	import snowwar.outgoing._SafeStr_3935;
	import snowwar.outgoing._SafeStr_3969;
	import snowwar.ui.GameArenaView;
	import snowwar.ui.GameEndingViewController;
	import snowwar.ui.GameLobbyViewController;
	import snowwar.ui.GamesMainViewController;
	import snowwar.ui.GameStartingViewController;
	import com.sulake.core.runtime.ComponentDependency;

     class SnowWarEngine extends Component implements IUpdateReceiver 
    {
        static final UI_ELEMENTS:Array<ASAny> = ["add_friend_icon_blue", "add_friend_icon_green", "add_friend_icon_red", "arena_10_preview", "arena_11_preview", "arena_1_preview", "arena_8_preview", "arena_9_preview", "bg_sky", "bg_sunshine", "bg_vista_1", "bg_vista_2", "bg_vista_3", "blue_ball", "blue_ball_rematch", "blue_glove", "blue_infobox", "blue_infobox_rematch_1", "blue_infobox_rematch_2", "blue_infobox_shuffle", "blue_square", "blue_square_shuffle", "free_games_bg", "gray_ball_left", "gray_ball", "gray_ball_right", "gray_infobox", "gray_square", "green_square", "leaderboard_bg", "leaderboard_divider", "leaderboard_highlighter", "left_black", "left_blue", "load_1", "load_2", "load_3", "load_4", "load_5", "load_6", "load_7", "load_8", "quick_play_background", "quick_play_instructions", "quick_play_teaser", "red_ball", "red_ball_rematch", "red_glove", "red_infobox", "red_infobox_rematch_1", "red_infobox_rematch_2", "red_infobox_shuffle", "red_square", "red_square_shuffle", "rematch_1", "rematch_2", "rematch_3", "rematch_4", "rematch_5", "rematch_6", "right_black", "right_blue", "scroll_down_click", "scroll_down_hilite", "scroll_down_inactive", "scroll_down_normal", "scroll_left", "scroll_right", "scroll_up_click", "scroll_up_hilite", "scroll_up_inactive", "scroll_up_normal", "snowstorm_logo", "star_empty", "star_filled_bronze", "star_filled_gold", "star_filled", "star_filled_silver", "ui_ball_indicator_bg", "ui_ball", "ui_exit_down", "ui_exit_up", "ui_make_balls_down", "ui_make_balls_up", "ui_me_bg", "ui_me_health_0", "ui_me_health_1", "ui_me_health_2", "ui_me_health_3", "ui_me_health_4", "ui_me_health_5", "ui_me_minus_1", "ui_me_minus_2", "ui_me_minus_3", "ui_me_minus_4", "ui_me_plus_1", "ui_me_plus_2", "ui_me_plus_3", "ui_me_plus_4", "ui_no_balls_1", "ui_no_balls_2", "ui_no_balls_3", "ui_no_balls_4", "ui_timer_and_points", "throw_1_1", "throw_1_2", "throw_1_3", "throw_1_4", "throw_2_1", "throw_2_2", "throw_2_3", "throw_2_4", "throw_2_5", "throw_3_1", "throw_3_2", "throw_3_3", "throw_3_4", "throw_3_5", "balls_1", "balls_2", "balls_3", "balls_4", "balls_5", "move_1", "move_2", "move_3", "move_4", "pagination_ball", "pagination_ball_hilite"];
        static inline final CONST_CHECKSUM_3= 3;
        public static inline final STATUS_0= 0; //_SafeStr_13134
        public static inline final GAME_STARTED= 1; //_SafeStr_13135
        public static inline final STAGE_LOADING= 2; //_SafeStr_13136
        public static inline final STAGE_STARTED= 3; //_SafeStr_13137
        public static inline final STAGE_RUNNING= 4; //_SafeStr_13138
        public static inline final STAGE_ENDED= 5; //_SafeStr_13139
        public static inline final GAME_ENDED= 6; //_SafeStr_13140
        public static inline final STATUS_7= 7; //_SafeStr_13141
        static var soundManager:IHabboSoundManager;

        var _habboGameManager:HabboGameManager;
        var _communication:IHabboCommunicationManager;
        var _windowManager:IHabboWindowManager;
        var _config:IHabboConfigurationManager;
        var _localization:IHabboLocalizationManager;
        var _sessionDataManager:ISessionDataManager;
        var _roomSessionManager:IRoomSessionManager;
        var _avatarRenderManager:IAvatarRenderManager;
        var _groupsManager:IHabboGroupsManager;
        var _roomEngine:IRoomEngine;
        var _roomUI:IRoomUI;
        var _catalog:IHabboCatalog;
        var _messageHandler:IncomingMessages;
        var _habboHelp:IHabboHelp;
        var _friendList:IHabboFriendsList;
        var _synchronizedGameArena:SynchronizedGameArena;
        var _gameArenaView:GameArenaView;
        var _SafeStr_13145:Int = 0;
        var _gameState:Int = 0;
        var _alertWindow:IAlertDialog;
        var _gamePlayerId:Int = 0;
        var _SafeStr_13149:Map;
        var _currentSubTurn:Int = 0;
        var _maxSubTurn:Int = 0;
        var _currentTurn:Int = 0;
        var _serverChecksums:Map;
        var _SafeStr_13154:Bool = false;
        var _gameStartingViewController:GameStartingViewController;
        var _gameEndingViewController:GameEndingViewController;
        var _gameMainViewController:GamesMainViewController;
        var _leaderBoardViewController:LeaderboardViewController;
        var _ghostEnabled:Bool = false;
        var _ghostVisualizationEnabled:Bool = false;
        var _ghostImmediateEnabled:Bool = false;
        var _forceFullStatusRequest:Bool = false;
        var _time:Int = 0;
        var _SafeStr_13164:Bool = false;
        var _infiniteGames:Bool = false;
        var _gamesLeft:Int = 0;
        var _rejoinRoom:Int = -1;
        var _promotionId:Int = -1;
        var _shownPromotion:Bool = false;
        var _assetsLoaded:Bool = false;

        public function new(habboGameManager:HabboGameManager, _arg_2:IContext, _arg_3:UInt=0, _arg_4:IAssetLibrary=null)
        {
            super(_arg_2, _arg_3, _arg_4);
            this._habboGameManager = habboGameManager;
            queueInterface(new IIDHabboWindowManager(), this.onHabboWindowManagerReady);
            queueInterface(new IIDHabboCommunicationManager(), this.onCommunicationManagerReady);
            queueInterface(new IIDHabboConfigurationManager(), this.onConfigurationManagerReady);
            queueInterface(new IIDHabboLocalizationManager(), this.onLocalizationManagerReady);
            queueInterface(new IIDHabboRoomSessionManager(), this.onRoomSessionManagerReady);
            queueInterface(new IIDSessionDataManager(), this.onSessionDataManagerReady);
            queueInterface(new IIDAvatarRenderManager(), this.onAvatarRenderManagerReady);
            queueInterface(new IIDRoomEngine(), this.onRoomEngineReady);
            queueInterface(new IIDHabboSoundManager(), this.onSoundManagerReady);
            queueInterface(new IIDHabboRoomUI(), this.onRoomUIReady);
            queueInterface(new IIDHabboCatalog(), this.onCatalogReady);
            queueInterface(new IIDHabboHelp(), this.onHelpReady);
            queueInterface(new IIDHabboFriendList(), this.onFriendListReady);
            queueInterface(new IIDHabboGroupsManager(), this.onGroupsManagerReady);
			
			
            HabboGamesCom.log([("SnowWarEngine initialized: " + _arg_4)]);
            this._gameMainViewController = new GamesMainViewController(this);
        }
		
		override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([
			new ComponentDependency(new IIDHabboWindowManager(), 		  function (k:IHabboWindowManager) 	   { _windowManager = k; }), 
			new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager) { _communication = k; }), 
			new ComponentDependency(new IIDHabboConfigurationManager(), function (k:IHabboConfigurationManager) { _config = k; }),
			new ComponentDependency(new IIDHabboLocalizationManager(),  function (k:IHabboLocalizationManager)  { _localization = k; }),
			new ComponentDependency(new IIDHabboRoomSessionManager(),   function (k:IRoomSessionManager)   { _roomSessionManager = k; }),
			new ComponentDependency(new IIDSessionDataManager(), 		  function (k:ISessionDataManager) 	   { _sessionDataManager = k; }), 
			new ComponentDependency(new IIDAvatarRenderManager(), 	  function (k:IAvatarRenderManager) 	   { _avatarRenderManager = k; }),
			new ComponentDependency(new IIDRoomEngine(), 				  function (k:IRoomEngine) 		       { _roomEngine = k; }),
			new ComponentDependency(new IIDHabboSoundManager(), 		  function (k:IHabboSoundManager) 		   { soundManager = k ;}), 
			new ComponentDependency(new IIDHabboRoomUI(), 		      function (k:IRoomUI) 			   { _roomUI = k; }),
			new ComponentDependency(new IIDHabboCatalog(), 			  function (k:IHabboCatalog) 			   { _catalog = k; }),
			new ComponentDependency(new IIDHabboHelp(), 				  function (k:IHabboHelp) 				   { _habboHelp = k; }),
			new ComponentDependency(new IIDHabboFriendList(), 		  function (k:IHabboFriendsList) 		   { _friendList = k; }), 
			new ComponentDependency(new IIDHabboGroupsManager(), 		  function (k:IHabboGroupsManager) 	   { _groupsManager = k; }, false)])
			);
        }

        public static function playSound(k:String, _arg_2:Int=0) //_SafeStr_6795
        {
            if (soundManager != null)
            {
                soundManager.playSound(k, _arg_2);
            }
        }

        public static function stopSound(k:String) //_SafeStr_7041
        {
            if (soundManager != null)
            {
                soundManager.stopSound(k);
            }
        }


        public var gameCenterEnabled(get,never):Bool;
public function  get_gameCenterEnabled():Bool
        {
            return this._habboGameManager.gameCenterEnabled;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public var config(get,never):IHabboConfigurationManager;
public function  get_config():IHabboConfigurationManager
        {
            return this._config;
        }

        public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._avatarRenderManager;
        }

        public var groupsManager(get,never):IHabboGroupsManager;
public function  get_groupsManager():IHabboGroupsManager
        {
            return this._groupsManager;
        }

        public var roomUI(get,never):IRoomUI;
public function  get_roomUI():IRoomUI
        {
            return this._roomUI;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public var friendList(get,never):IHabboFriendsList;
public function  get_friendList():IHabboFriendsList
        {
            return this._friendList;
        }

        public var synchronizedGameArena(get,never):SynchronizedGameArena;
public function  get_synchronizedGameArena():SynchronizedGameArena
        {
            return this._synchronizedGameArena;
        }

        public var currentSubTurn(get,never):Int;
public function  get_currentSubTurn():Int
        {
            return this._currentSubTurn;
        }

        public var gameDuration(get,never):Int;
public function  get_gameDuration():Int
        {
            return this._time;
        }

        public var rejoinRoom(get,never):Int;
public function  get_rejoinRoom():Int
        {
            return this._rejoinRoom;
        }

        public var ghostEnabled(get,never):Bool;
public function  get_ghostEnabled():Bool
        {
            return this._ghostEnabled;
        }

        public var ghostVisualizationEnabled(get,never):Bool;
public function  get_ghostVisualizationEnabled():Bool
        {
            return this._ghostVisualizationEnabled;
        }

        public function gameArenaName(k:_SafeStr_4018):String //_SafeStr_13178
        {
            var key= ("snowwar.field.name." + Std.string(k.fieldName));
            return this._localization.getLocalization(key, key);
        }

        override public function dispose()
        {
            if (this._communication != null)
            {
                this._communication.release(new IIDHabboCommunicationManager());
                this._communication = null;
            }
            if (this._windowManager != null)
            {
                this._windowManager.release(new IIDHabboWindowManager());
                this._windowManager = null;
            }
            if (this._config != null)
            {
                this._config.release(new IIDHabboConfigurationManager());
                this._config = null;
            }
            if (this._localization != null)
            {
                this._localization.release(new IIDHabboLocalizationManager());
                this._localization = null;
            }
            if (this._roomSessionManager != null)
            {
                this._roomSessionManager.release(new IIDHabboRoomSessionManager());
                this._roomSessionManager = null;
            }
            if (this._sessionDataManager != null)
            {
                this._sessionDataManager.release(new IIDSessionDataManager());
                this._sessionDataManager = null;
            }
            if (this._roomEngine != null)
            {
                this._roomEngine.events.removeEventListener(RoomEngineEvent.OBJECTS_INITIALIZED, this.onGameObjectsInitialized);
                this._roomEngine.release(new IIDRoomEngine());
                this._roomEngine = null;
            }
            if (soundManager != null)
            {
                soundManager.release(new IIDHabboSoundManager());
                soundManager = null;
            }
            if (this._habboHelp != null)
            {
                this._habboHelp.release(new IIDHabboHelp());
                this._habboHelp = null;
            }
            if (this._avatarRenderManager != null)
            {
                this._avatarRenderManager.release(new IIDAvatarRenderManager());
                this._avatarRenderManager = null;
            }
            if (this._groupsManager != null)
            {
                this._groupsManager.release(new IIDHabboGroupsManager());
                this._groupsManager = null;
            }
            if (this._roomUI != null)
            {
                this._roomUI.release(new IIDHabboRoomUI());
                this._roomUI = null;
            }
            if (this._catalog != null)
            {
                this._catalog.release(new IIDHabboCatalog());
                this._catalog = null;
            }
            if (this._friendList != null)
            {
                this._friendList.release(new IIDHabboFriendList());
                this._friendList = null;
            }
            if (this._alertWindow != null)
            {
                this._alertWindow.dispose();
                this._alertWindow = null;
            }
            if (this._gameEndingViewController != null)
            {
                this._gameEndingViewController.dispose();
                this._gameEndingViewController = null;
            }
            this.disposeGameStartingViewController();
            if (this._synchronizedGameArena != null)
            {
                this._synchronizedGameArena.dispose();
                this._synchronizedGameArena = null;
            }
            if (this._gameArenaView != null)
            {
                this._gameArenaView.dispose();
                this._gameArenaView = null;
            }
            if (this._gameMainViewController != null)
            {
                this._gameMainViewController.dispose();
                this._gameMainViewController = null;
            }
            if (this._messageHandler != null)
            {
                this._messageHandler.dispose();
                this._messageHandler = null;
            }
            if (this._leaderBoardViewController != null)
            {
                this._leaderBoardViewController.dispose();
                this._leaderBoardViewController = null;
            }
            super.dispose();
        }

        function onHabboWindowManagerReady(k:IID, _arg_2:IUnknown)
        {
            this._windowManager = Std.downcast(_arg_2 , IHabboWindowManager);
            WindowUtils.init(assets, this._windowManager);
        }

        function onCommunicationManagerReady(k:IID, _arg_2:IUnknown)
        {
            this._communication = Std.downcast(_arg_2 , IHabboCommunicationManager);
            this._messageHandler = new IncomingMessages(this);
        }

        function onConfigurationManagerReady(k:IID, _arg_2:IUnknown)
        {
            this._config = Std.downcast(_arg_2 , IHabboConfigurationManager);
            this._ghostEnabled = this._config.getBoolean("snowwar.ghost.enabled");
            if (this._ghostEnabled)
            {
                this._ghostVisualizationEnabled = this._config.getBoolean("snowwar.ghost.visualization.enabled");
                this._ghostImmediateEnabled = this._config.getBoolean("snowwar.ghost.immediate.enabled");
            }
            HabboGamesCom.logEnabled = this._config.getBoolean("snowwar.log.enabled");
        }

        function onLocalizationManagerReady(k:IID, _arg_2:IUnknown)
        {
            this._localization = Std.downcast(_arg_2 , IHabboLocalizationManager);
        }

        function onSessionDataManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._sessionDataManager = Std.downcast(_arg_2 , ISessionDataManager);
        }

        function onRoomSessionManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._roomSessionManager = Std.downcast(_arg_2 , IRoomSessionManager);
        }

        function onAvatarRenderManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._avatarRenderManager = Std.downcast(_arg_2 , IAvatarRenderManager);
            this._avatarRenderManager.events.addEventListener(AvatarRenderEvent.AVATAR_RENDER_READY, this.onAvatarRenderReady);
        }

        function onGroupsManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._groupsManager = Std.downcast(_arg_2 , IHabboGroupsManager);
        }

        function onAvatarRenderReady(event:Event)
        {
var asset:XmlAsset  = null;            if (!Std.downcast(this.context.assets , AssetLibraryCollection).hasAssetLibrary(assets.name))
            {
                HabboGamesCom.log([assets.manifest]);
                Std.downcast(context.assets , AssetLibraryCollection).addAssetLibrary(assets);
asset= Std.downcast(assets.getAssetByName("figure") , XmlAsset);
                this._avatarRenderManager._Str_882(((asset.content : com.sulake.core.utils.xml.XML) ));
                this._avatarRenderManager.resetAssetManager();
            }
        }

        function onRoomEngineReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._roomEngine = Std.downcast(_arg_2 , IRoomEngine);
            this._roomEngine.events.addEventListener(RoomEngineEvent.OBJECTS_INITIALIZED, this.onGameObjectsInitialized);
        }

        function onGameObjectsInitialized(k:RoomEngineEvent) //_SafeStr_13179
        {
            if (this._synchronizedGameArena != null)
            {
                this.send(new _SafeStr_3918(100));
            }
        }

        public function send(k:IMessageComposer)
        {
            if (this._communication != null)
            {
                this._communication.connection.send(k);
            }
        }

        function onSoundManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            soundManager = cast(_arg_2, IHabboSoundManager);
        }

        function onRoomUIReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._roomUI = Std.downcast(_arg_2 , IRoomUI);
        }

        function onCatalogReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._catalog = Std.downcast(_arg_2 , IHabboCatalog);
        }

        public function _SafeStr_13181()
        {
            this._gameMainViewController._SafeStr_7703();
        }

        function onHelpReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._habboHelp = Std.downcast(_arg_2 , IHabboHelp);
        }

        function onFriendListReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._friendList = Std.downcast(_arg_2 , IHabboFriendsList);
        }

        public function _SafeStr_13182(k:Bool)
        {
            if (k)
            {
                this._SafeStr_13181();
            }
        }

        public function initializeGameArena(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Array<ASAny>)
        {
            if (this._synchronizedGameArena == null)
            {
                this._synchronizedGameArena = new SynchronizedGameArena();
                this._synchronizedGameArena.registerExtension(new _SafeStr_4034());
                this._synchronizedGameArena.initialize(this, _arg_3);
                this._gameArenaView = new GameArenaView(this);
                this._roomSessionManager.disposeSession(-1, false);
                this._roomSessionManager.startGameSession();
                registerUpdateReceiver(this, 1);
                this._SafeStr_13145 = 0;
                this._currentSubTurn = 0;
                this._maxSubTurn = 0;
            }
        }

		//Seems unused
        public function _SafeStr_13184(k:String)
        {
            this.initGameDirectoryConnection();
            this.send(new _SafeStr_2507(k));
        }

        public function initGameDirectoryConnection()
        {
            this.send(new _SafeStr_2519());
        }

        public function _SafeStr_13185()
        {
            this.send(new _SafeStr_2513());
        }

        function synchronizedGameStage():SnowWarGameStage
        {
            if (this._synchronizedGameArena == null)
            {
                return null;
            }
            var k= Std.downcast(this._synchronizedGameArena.synchronizedGameStage() , SnowWarGameStage);
            return k;
        }

        public function _SafeStr_13187():HumanGameObject
        {
            return this.getHumanGameObject(this._gamePlayerId);
        }

        public function getHumanGameObject(k:Int):HumanGameObject
        {
            var gameStage:SynchronizedGameStage = this.synchronizedGameStage();
            if (gameStage == null)
            {
                return null;
            }
            return Std.downcast(gameStage.getGameObject(k) , HumanGameObject);
        }

        public function _SafeStr_7622(k:RoomObjectTileMouseEvent)
        {
            if (this._gameState != STAGE_RUNNING)
            {
                return;
            }
            var _local_2= _SafeStr_4031._SafeStr_13233(k.altKey, k.shiftKey);
            if (_local_2 == _SafeStr_4031._SafeStr_13234)
            {
                this._SafeStr_13189(k.tileXAsInt, k.tileYAsInt);
            }
            else
            {
                this._SafeStr_13192(k.tileXAsInt, k.tileYAsInt, this._SafeStr_13193(_local_2));
            }
        }

        public function _SafeStr_7623(k:Int, _arg_2:Bool, _arg_3:Bool)
        {
            var _local_5:HumanGameObject = null;
            var _local_6:HumanGameObject = null;
            var _local_7 = 0;
            if (this._gameState != STAGE_RUNNING)
            {
                return;
            }
            var _local_4= this._SafeStr_13190();
            if (((k == this._gamePlayerId) || ((this._ghostEnabled && (_local_4 != null)) && (k == _local_4._SafeStr_13236))))
            {
                if ((this._SafeStr_13194() && (this._gameArenaView != null)))
                {
                    this._gameArenaView._SafeStr_13237();
                }
            }
            else
            {
                _local_5 = this._SafeStr_13187();
                _local_6 = this.getHumanGameObject(k);
                if ((((_local_5 != null) && (_local_6 != null)) && (!(_local_5.team == _local_6.team))))
                {
                    _local_7 = _SafeStr_4031._SafeStr_13235(_arg_2, _arg_3);
                    this._SafeStr_13191(k, this._SafeStr_13193(_local_7));
                }
            }
        }

        public function _SafeStr_7625(k:Int, _arg_2:Bool, _arg_3:Bool)
        {
            var _local_5:UInt = 0; //If colors do not work properly for username, try changing this back to int.
            var _local_6 = 0;
            var playerObject= this.getHumanGameObject(k);
            if (playerObject == null)
            {
                return;
            }
            if (this._config.getBoolean("snowstorm.settings.show_user_names"))
            {
                _local_5 = ((playerObject.team == 1) ? 0xFF2F9EC9 : 0xFFC34B48);
                _local_6 = 500;
                this._roomUI.showGamePlayerName(playerObject._SafeStr_13236, playerObject.name, _local_5, _local_6);
            }
            if (this._gameState == STAGE_RUNNING)
            {
                this._gameArenaView._SafeStr_13238(playerObject.team);
            }
        }

        public function _SafeStr_13189(x:Int, y:Int)
        {
            var targetX = 0;
            var targetY = 0;
            var gameStage:SnowWarGameStage = null;
            if (this._gameState != STAGE_RUNNING)
            {
                return;
            }
            var _local_3= this._SafeStr_13187();
            if (_local_3 != null)
            {
                targetX = (x * Tile.COST);
                targetY = (y * Tile.COST);
                gameStage = this.synchronizedGameStage();
                if (gameStage != null)
                {
                    this.send(new _SafeStr_3806(targetX, targetY, this._synchronizedGameArena.getTurn(), this._synchronizedGameArena.subturn));
                    this._SafeStr_13195(_local_3, targetX, targetY);
                }
            }
        }

        public function _SafeStr_13190():HumanGameObject
        {
            var k= this._SafeStr_13187();
            if (k != null)
            {
                return this.getHumanGameObject(k._SafeStr_13241);
            }
            return null;
        }

        function _SafeStr_13191(k:Int, _arg_2:Int)
        {
            var _local_3= this._SafeStr_13187();
            if (((_local_3 != null) && _local_3._SafeStr_13242()))
            {
                this.send(new _SafeStr_3904(k, _arg_2, this._synchronizedGameArena.getTurn(), this._synchronizedGameArena.subturn));
                this._SafeStr_13196();
            }
        }

        function _SafeStr_13192(k:Int, _arg_2:Int, _arg_3:Int)
        {
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_4= this._SafeStr_13187();
            if (((_local_4 != null) && _local_4._SafeStr_13242()))
            {
                _local_5 = (k * Tile.COST);
                _local_6 = (_arg_2 * Tile.COST);
                this.send(new _SafeStr_3908(_local_5, _local_6, _arg_3, this._synchronizedGameArena.getTurn(), this._synchronizedGameArena.subturn));
                this._SafeStr_13196();
            }
        }

        function _SafeStr_13193(k:Int):Int
        {
            var _local_2 = 0;
            switch (k)
            {
                case _SafeStr_4031._SafeStr_13244:
                    _local_2 = _SafeStr_4035._SafeStr_13243;
                    
                case _SafeStr_4031._SafeStr_13246:
                    _local_2 = _SafeStr_4035._SafeStr_13245;
                    
                case _SafeStr_4031._SafeStr_13248:
                    _local_2 = _SafeStr_4035._SafeStr_13247;
                    
                default:
                    _local_2 = _SafeStr_4035._SafeStr_13249;
            }
            return _local_2;
        }

        public function _SafeStr_13194():Bool
        {
            if (this._gameState != STAGE_RUNNING)
            {
                return false;
            }
            var k= this._SafeStr_13187();
            if (((k != null) && k._SafeStr_13250()))
            {
                this.send(new _SafeStr_3969(this._synchronizedGameArena.getTurn(), this._synchronizedGameArena.subturn));
                this._SafeStr_13196();
                return true;
            }
            return false;
        }

        function _SafeStr_13195(k:HumanGameObject, _arg_2:Int, _arg_3:Int)
        {
            var _local_4 = false;
            var _local_5:HumanGameObject = null;
            var _local_6:_SafeStr_4019 = null;
            if (this._ghostEnabled)
            {
                _local_4 = (((k != null) && (!(k.posture == AvatarAction.SNOWWAR_DIE_BACK))) && (!(k.posture == AvatarAction.SNOWWAR_DIE_FRONT)));
                _local_5 = this._SafeStr_13190();
                if (((_local_5 != null) && _local_4))
                {
                    _local_6 = new _SafeStr_4021(_local_5, _arg_2, _arg_3);
                    if (this._ghostImmediateEnabled)
                    {
                        _local_6.apply(this._synchronizedGameArena.synchronizedGameStage());
                    }
                    else
                    {
                        this._synchronizedGameArena.addGameEvent(this._synchronizedGameArena.getTurn(), this._synchronizedGameArena.subturn, _local_6);
                    }
                }
            }
        }

        function _SafeStr_13196()
        {
            var k:HumanGameObject = null;
            if (this._ghostEnabled)
            {
                k = this._SafeStr_13190();
                if (k != null)
                {
                    k._SafeStr_13252();
                }
            }
        }

        public function update(k:UInt)
        {
var checksumDiff = 0, previousTurn = 0, clientChecksum = 0, serverChecksum = 0, checksumBehind = false, checksumMismatch = false, errorStatus = 0, checksumIndicatorColor:UInt = 0, _local_2 = 0;			try
			{
checksumDiff;
previousTurn;
clientChecksum;
serverChecksum;
checksumBehind;
checksumMismatch;
errorStatus;
checksumIndicatorColor;
            if ((((!(this._synchronizedGameArena != null)) || (ASCompat.toNumber((!(this._gameState != 0)) )== STAGE_RUNNING)) || (ASCompat.toNumber((!(this._gameState != 0)) )== STAGE_STARTED)))
            {
                return;
            }
            if (((this._gameArenaView != null) && (this._gameState == STAGE_STARTED)))
            {
                this._gameArenaView.update(k, (this._synchronizedGameArena.subturn == 0));
            }
            this._SafeStr_13145 = ASCompat.toInt(this._SafeStr_13145 + k);
_local_2= Std.downcast(this._synchronizedGameArena.getExtension() , _SafeStr_4034)._SafeStr_13253(); //Returns 50
            if ((((!this._SafeStr_13154) && (this._SafeStr_13145 > _local_2)) && (this._currentSubTurn < this._maxSubTurn)))
            {
                this._synchronizedGameArena.handleTurn();
                this._SafeStr_13145 = (this._SafeStr_13145 - _local_2);
                this._currentSubTurn++;
                if (this._SafeStr_13145 > _local_2)
                {
                    this._SafeStr_13145 = 0;
                }
                checksumDiff = (this._maxSubTurn - this.currentSubTurn);
                while (checksumDiff-- > 3)
                {
                    this._synchronizedGameArena.handleTurn();
                    this._currentSubTurn++;
                }
                if (((this._gameArenaView != null) && (this._gameState == STAGE_RUNNING)))
                {
                    this._gameArenaView.update(k, (this._synchronizedGameArena.subturn == 0));
                }
                if ((this._currentSubTurn % this._synchronizedGameArena.maxSubTurns()) == 0)
                {
                    previousTurn = (this._synchronizedGameArena.getTurn() - 1);
                    clientChecksum = this._synchronizedGameArena._SafeStr_13254(previousTurn);
                    serverChecksum = this._serverChecksums.getValue(previousTurn);
                    this._SafeStr_13197(previousTurn);
                    /*checksumBehind = (previousTurn < (this._currentTurn - 3));
                    checksumMismatch = (!(serverChecksum == clientChecksum));
                    if ((((checksumBehind) || (checksumMismatch)) || (this._forceFullStatusRequest)))
                    {
                        HabboGamesCom.log(((((((((("Turn: " + [previousTurn, this._currentTurn]) + " currentSubTurn:") + this._currentSubTurn) + " maxSubTurn:") + this._maxSubTurn) + " serverChecksum:") + serverChecksum) + " clientChecksum:") + clientChecksum));
                        if (checksumBehind)
                        {
                            errorStatus = 0;
                            checksumIndicatorColor = 0xFF00FF;
                            HabboGamesCom.log("CLIENT TOO MUCH BEHIND, requesting full status!");
                        }
                        else
                        {
                            if (checksumMismatch)
                            {
                                errorStatus = 1;
                                checksumIndicatorColor = 0xFF0000;
                                HabboGamesCom.log("CHECKSUM MISMATCH, requesting full status!");
                            }
                            else
                            {
                                errorStatus = -1;
                                checksumIndicatorColor = 0xFF;
                                HabboGamesCom.log("ERROR WAS GENERATED! Requesting full status!");
                            }
                        }
                        this._gameArenaView.setChecksumIndicatorColor(checksumIndicatorColor);
                        this.requestFullGameStatus(errorStatus);
                        this._forceFullStatusRequest = false;
                        this._SafeStr_13154 = true;
                    };*/
                }
            }
			}
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught); 			{
				HabboGamesCom.log([e.getStackTrace()]);
				HabboGamesCom.log([e.message]);
				Habbo.trackLoginStep(e.getStackTrace());
				Habbo.trackLoginStep(e.message);
			}
 }        }

        function _SafeStr_13197(checksumTurn:Int)
        {
            var playerObject:HumanGameObject = null;
            var currentLocation:Location = null;
            var humanGameObject:HumanGameObject = null;
            var _local_5 = false;
            var _local_6 = 0;
            if (this._ghostEnabled)
            {
                playerObject = this._SafeStr_13187();
                currentLocation = playerObject.currentLocation;
                humanGameObject = this._SafeStr_13190();
                _local_5 = false;
                _local_6 = -CONST_CHECKSUM_3;
                while (_local_6 < CONST_CHECKSUM_3) //-3 -> 3
                {
                    _local_5 = humanGameObject._SafeStr_13259((checksumTurn + _local_6), currentLocation);
                    if (_local_5)
                    {
                        break;
                    }
                    _local_6++;
                }
                humanGameObject._SafeStr_13260((checksumTurn - CONST_CHECKSUM_3));
                if (((!_local_5) && (checksumTurn > CONST_CHECKSUM_3)))
                {
                    HabboGamesCom.log([((("GHOST CHECKSUM MISMATCH, checksumTurn:" + Std.string(checksumTurn)) + " currentLocation:") + currentLocation)]);
                    humanGameObject._SafeStr_13261(playerObject);
                    humanGameObject._SafeStr_13262(checksumTurn);
                    this._gameArenaView.setChecksumIndicatorColor(0xFF00);
                }
            }
        }

        public function _SafeStr_13198(turn:Int, checksum:Int, nextTurn:Bool=false)
        {
            this._currentTurn = turn;
            this._serverChecksums.setProperty(this._currentTurn, checksum);
            this._maxSubTurn = ((turn + 1) * this._synchronizedGameArena.maxSubTurns());
            if (nextTurn)
            {
                this._currentSubTurn = (this._maxSubTurn - this._synchronizedGameArena.maxSubTurns());
                this._SafeStr_13145 = Std.downcast(this._synchronizedGameArena.getExtension() , _SafeStr_4034)._SafeStr_13253();
                this._SafeStr_13154 = false;
                if (this._ghostEnabled)
                {
                    this._SafeStr_13190()._SafeStr_13262(this._currentTurn);
                }
            }
        }

        public function requestFullGameStatus(errorStatus:Int)
        {
            this.send(new _SafeStr_3935(errorStatus));
        }

        public function alert(message:String)
        {
            this.disposeAlertWindow();
            if (this._alertWindow == null)
            {
                this._alertWindow = this._windowManager.alert("SnowWar Alert", message, 0, this._SafeStr_8319);
            }
            else
            {
                this._alertWindow.summary = message;
            }
            HabboGamesCom.log([("[HabboGameManager.alert] " + message)]);
        }

        public function disposeGameStartingViewController()
        {
            if (this._gameStartingViewController != null)
            {
                this._gameStartingViewController.dispose();
                this._gameStartingViewController = null;
            }
        }

        public function disposeAlertWindow()
        {
            if (this._alertWindow != null)
            {
                this._alertWindow.dispose();
                this._alertWindow = null;
            }
        }

        public function _SafeStr_7624()
        {
            if (this._gameState != STAGE_RUNNING)
            {
                return;
            }
            this._forceFullStatusRequest = true;
        }

        function _SafeStr_8319(k:IAlertDialog, _arg_2:WindowEvent)
        {
            this.disposeAlertWindow();
        }

        
        public var gamePlayerId(get,set):Int;
public function  set_gamePlayerId(k:Int):Int        {
            return this._gamePlayerId = k;
        }
public function  get_gamePlayerId():Int
        {
            return this._gamePlayerId;
        }

        public function initializeGameArenaView()
        {
            if (this._gameArenaView != null)
            {
				HabboGamesCom.log(["SnowWarEngine: Intializing _gameArenaView"]);
                this._gameArenaView.init();
            }
			else
			{
				HabboGamesCom.log(["SnowWarEngine: Tried to initialize _gameArenaView but is null"]);
			};
        }

        public var gameMainViewController(get,never):GamesMainViewController;
public function  get_gameMainViewController():GamesMainViewController
        {
            return this._gameMainViewController;
        }

        public var gameLobbyViewController(get,never):GameLobbyViewController;
public function  get_gameLobbyViewController():GameLobbyViewController
        {
            if (this._gameMainViewController != null)
            {
                return this._gameMainViewController.gameLobbyViewController;
            }
            return null;
        }

        public function playersInitialized(k:Int, players:Array<ASAny>)
        {
            if (this._gameStartingViewController != null)
            {
                this._gameState = STAGE_LOADING;
                this._gameStartingViewController.playersInitialized(players);
            }
        }

        public function onStageStart(k:Int) //_SafeStr_13206
        {
            if (this._gameArenaView != null)
            {
                this._roomUI.visible = true;
                this.disposeGameStartingViewController();
                playSound(HabboSoundTypesEnum.GAMES_IG_COUNTDOWN);
                this._gameArenaView._SafeStr_13264(k);
                this._gameState = STAGE_STARTED;
            }
        }

        public function onStageRunning(time:Int) //_SafeStr_13207
        {
            if (time > 0)
            {
                this._time = time;
                this._gameState = STAGE_RUNNING;
            }
            else
            {
                this._gameState = STAGE_ENDED;
            }
            this._currentSubTurn = 0;
            this._maxSubTurn = 0;
        }

        public function onStageEnding() //_SafeStr_13208
        {
            this._roomEngine.setIsSelectedObjectInValidPosition = false;
            this._gameState = STAGE_ENDED;
            removeUpdateReceiver(this);
            if (this._synchronizedGameArena != null)
            {
                this._synchronizedGameArena.dispose();
                this._synchronizedGameArena = null;
            }
            stopSound(HabboSoundTypesEnum.GAMES_SW_WALK);
            this.send(new _SafeStr_3624(HabboGames._SafeStr_7697));
        }

        public function _SafeStr_13209()
        {
            this._roomSessionManager.disposeGameSession();
            if (this._gameArenaView != null)
            {
                this._gameArenaView.dispose();
                this._gameArenaView = null;
            }
        }

        public function onGameEnding(k:Int, _arg_2:Array<ASAny>, _arg_3:Game2SnowWarGameStats, _arg_4:Game2GameResult) //_SafeStr_13210
        {
            this._gameState = GAME_ENDED;
            this._gameMainViewController.close(false);
            if (this._gameEndingViewController != null)
            {
                this._gameEndingViewController.dispose();
                this._gameEndingViewController = null;
            }
            if (this._gameArenaView != null)
            {
                this._gameArenaView.disposeUI();
            }
            this._gameEndingViewController = new GameEndingViewController(this, _arg_2, _arg_3, _arg_4, k);
        }

        public function onGameStart(k:_SafeStr_4018) //_SafeStr_13211
        {
            var _local_2:_SafeStr_4032 = null;
            this._gameState = GAME_STARTED;
            this._SafeStr_13164 = false;
            this._SafeStr_13149 = new Map();
            this._serverChecksums = new Map();
            final _iter_ = k._SafeStr_13266; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._SafeStr_13149.add(_local_2.userId, _local_2);
            }
            if (this._gameEndingViewController != null)
            {
                this._gameEndingViewController.dispose();
                this._gameEndingViewController = null;
            }
            if (this._gameStartingViewController == null)
            {
                this._gameStartingViewController = new GameStartingViewController(this);
            }
            this._gameStartingViewController.show(k);
        }

        public function setRejoinRoom(id:Int)
        {
            this._gameState = (this._SafeStr_13164 ? STATUS_7 : GAME_ENDED);
            this._rejoinRoom = id;
            if (this._gameEndingViewController != null)
            {
                this._gameEndingViewController._SafeStr_13267(this._SafeStr_13164);
                this._SafeStr_13164 = false;
            }
        }

        public function rematchPlayer(id:Int)
        {
            if (this._gameEndingViewController != null)
            {
                this._gameEndingViewController.rematchPlayer(id);
            }
        }

        public function onStartLobbyCounter(time:Int) //_SafeStr_13214
        {
            if (((this._gameState == STATUS_7) && (!(this._gameEndingViewController == null))))
            {
                this._gameEndingViewController._SafeStr_13268(time);
            }
            else
            {
                if (this.gameLobbyViewController != null)
                {
                    this.gameLobbyViewController._SafeStr_13269(time);
                }
            }
        }

        public function _SafeStr_13215()
        {
            this._SafeStr_13164 = true;
            this.send(new _SafeStr_3643());
        }

        public function _SafeStr_13216(k:Int, _arg_2:String, _arg_3:Bool=false)
        {
            var _local_4:_SafeStr_4032 = this._SafeStr_13149.getValue(k);
            var _local_5= ((_local_4.__as3_final == 1) ? -300 : 300);
            var _local_6:UInt = ((_local_4.__as3_final == 1) ? 0xFF : 0xFF0000);
            this._habboGameManager.events.dispatchEvent(new GameChatEvent(GameChatEvent.GCE_GAME_CHAT, k, _arg_2, _local_5, _local_6, _local_4.figure, _local_4.gender, _local_4.name, _arg_3));
        }

        public function _SafeStr_13217()
        {
            if (((this._gameState == STATUS_7) && (!(this._gameEndingViewController == null))))
            {
                this._SafeStr_13164 = true;
                this._gameEndingViewController._SafeStr_13267(this._SafeStr_13164);
            }
            else
            {
                if (this.gameLobbyViewController != null)
                {
                    this.gameLobbyViewController._SafeStr_13270();
                }
            }
        }

        public function onLongDataReceived(k:_SafeStr_4018)
        {
            var _local_2:_SafeStr_4032 = null;
            if (this._gameState == GAME_ENDED)
            {
                this._SafeStr_13164 = true;
            }
            if (((!(this._gameEndingViewController == null)) && (!(this._gameState == STATUS_7))))
            {
                this._gameEndingViewController._SafeStr_13267(this._SafeStr_13164);
                this._gameState = STATUS_7;
                this._SafeStr_13164 = false;
            }
            if (((this._gameState == STATUS_7) && (!(this._gameEndingViewController == null))))
            {
                this._gameEndingViewController._SafeStr_13271(k);
                final _iter_ = k._SafeStr_13266; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    this._gameEndingViewController._SafeStr_13272(_local_2);
                }
            }
            else
            {
                this._gameState = STATUS_0;
                this.gameMainViewController._SafeStr_13273(this.gameArenaName(k), k._SafeStr_13274, k._SafeStr_13275);
                final _iter_ = k._SafeStr_13266; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    this.gameLobbyViewController._SafeStr_13272(_local_2);
                }
            }
        }

        public function _SafeStr_13219(k:_SafeStr_4032)
        {
            if (((this._gameState == STATUS_7) && (!(this._gameEndingViewController == null))))
            {
                this._gameEndingViewController._SafeStr_13272(k);
            }
            else
            {
                this._gameState = STATUS_0;
                if (this.gameLobbyViewController != null)
                {
                    this.gameLobbyViewController._SafeStr_13272(k);
                }
            }
        }

        public function _SafeStr_13220(k:Int)
        {
            if (((this._gameState == STATUS_7) && (!(this._gameEndingViewController == null))))
            {
                this._gameEndingViewController._SafeStr_13276(k);
            }
            else
            {
                this._gameState = STATUS_0;
                if (this.gameLobbyViewController != null)
                {
                    this.gameLobbyViewController._SafeStr_13276(k);
                }
            }
        }

        public function _SafeStr_13221(k:Int, infiniteGames:Bool, gamesLeft:Int)
        {
            if (k == HabboGames._SafeStr_7697)
            {
                this._infiniteGames = infiniteGames;
                this._gamesLeft = gamesLeft;
                if (this._gameEndingViewController != null)
                {
                    this._gameEndingViewController._SafeStr_13277();
                }
                if (this._gameMainViewController != null)
                {
                    this._gameMainViewController._SafeStr_13278();
                }
            }
        }

        public var _SafeStr_7687(get,never):Bool;
public function  get__SafeStr_7687():Bool
        {
            return (this._gameState == GAME_STARTED) || (this._gameState == STATUS_7);
        }

        public function _SafeStr_7688()
        {
            this.onStageEnding();
            this._SafeStr_13209();
            if (this._gameEndingViewController != null)
            {
                this._gameEndingViewController.dispose();
                this._gameEndingViewController = null;
            }
            if (this._gameMainViewController != null)
            {
                this._gameMainViewController.createAndVisible(false);
            }
        }

        public function _SafeStr_13222(k:Bool)
        {
            this._SafeStr_7688();
            if (k)
            {
                this._habboGameManager._SafeStr_7621();
            }
        }

        public var _SafeStr_13223(get,never):Bool;
public function  get__SafeStr_13223():Bool
        {
            return this._infiniteGames;
        }

        public var _SafeStr_13224(get,never):Int;
public function  get__SafeStr_13224():Int
        {
            return this._gamesLeft;
        }

        public function _SafeStr_13225(k:Int)
        {
            if (((!(this._gameArenaView == null)) && (k == this._gamePlayerId)))
            {
                this._gameArenaView._SafeStr_13225();
            }
        }

        public function _SafeStr_13226(k:String)
        {
            //this._catalog.buySnowWarTokensOffer(); //TODO: Purchasing game tokens.
            this._SafeStr_7665(k);
        }

        public function _SafeStr_13227(k:String):Bool
        {
            var _local_2= this._catalog.videoOffers.launch(VideoOfferTypeEnum._SafeStr_7697);
            this._SafeStr_7665(k);
            return _local_2;
        }

        public function _SafeStr_7664(k:String)
        {
            this._catalog.openClubCenter(); //_SafeStr_2308.ANY, "HabboGameManager");
            this._SafeStr_7665(k);
        }

        function _SafeStr_7665(k:String)
        {
            this.send(new _SafeStr_1434("GameFramework", "SnowStorm", k, "", this._SafeStr_13224));
        }

        public function _SafeStr_13228(k:HumanGameObject, _arg_2:HumanGameObject)
        {
            if (this._gamePlayerId == k._SafeStr_13236)
            {
                this._gameArenaView._SafeStr_13280(false);
            }
            else
            {
                if (this._gamePlayerId == _arg_2._SafeStr_13236)
                {
                    this._gameArenaView._SafeStr_13280(true);
                }
            }
        }

        public var _SafeStr_13229(never,set):Int;
public function  set__SafeStr_13229(k:Int):Int        {
            return this._promotionId = k;
        }

        public function _SafeStr_7663()
        {
            if ((this._shownPromotion || (!(this._promotionId == 0))))
            {
                return;
            }
            this._shownPromotion = true;
            var newIdentityEnabled= this.config.getBoolean("new.identity");
            var _local_2= this.config.getProperty("new.user.wing");
            if ((newIdentityEnabled && (!(_local_2 == WingCodeEnum.GAME))))
            {
                return;
            }
            this._habboHelp.showWelcomeScreen(HabboToolbarIconEnum.GAMES, "snowwar.promotion", WelcomeNotificationAlignment.LEFT, "GAMES");
        }

        public function showLeaderboard()
        {
            this.leaderboard._SafeStr_13281 = HabboGames._SafeStr_7697;
            this.leaderboard._SafeStr_13282();
        }

        public var leaderboard(get,never):LeaderboardViewController;
public function  get_leaderboard():LeaderboardViewController
        {
            if (!(this._leaderBoardViewController != null) && this.gameCenterEnabled)
            {
                this._leaderBoardViewController = new LeaderboardViewController(this);
            }
            return this._leaderBoardViewController;
        }

        public var leaderboardReady(get,never):Bool;
public function  get_leaderboardReady():Bool
        {
            return this._leaderBoardViewController != null;
        }

        public function loadUIElements()
        {
            var k:String = null;
            var _local_2:String = null;
            if (!this._assetsLoaded)
            {
                final _iter_ = UI_ELEMENTS; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    if (!assets.hasAsset(k))
                    {
                        _local_2 = this.config.interpolate((("${image.library.url}snowstorm_client/" + k) + ".png"));
                        assets.loadAssetFromFile(k, new URLRequest(_local_2));
                    }
                }
                this._assetsLoaded = true;
            }
        }

        public function _SafeStr_7702():Bool
        {
            var k:String = null;
            final _iter_ = SnowWarEngine.UI_ELEMENTS; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (!assets.hasAsset(k))
                {
                    return false;
                }
            }
            return true;
        }
    }

