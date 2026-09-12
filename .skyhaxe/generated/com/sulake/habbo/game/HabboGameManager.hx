package com.sulake.habbo.game
;
	import com.sulake.core.runtime.Component;
	import com.sulake.core.runtime.IContext;
	import com.sulake.core.runtime.IUnknown;
	import com.sulake.core.runtime.IID;
	import com.sulake.habbo.session.IRoomSessionManager;
	import com.sulake.habbo.session.ISessionDataManager;
	import com.sulake.habbo.session.SecurityLevelEnum;
	import com.sulake.habbo.navigator.IHabboNavigator;
	import com.sulake.habbo.catalog.IHabboCatalog;
	import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
	import com.sulake.habbo.toolbar.IHabboToolbar;
	import com.sulake.habbo.toolbar.HabboToolbarEnum;
	import com.sulake.habbo.sound.IHabboSoundManager;
	import com.sulake.habbo.window.IHabboWindowManager;
	import com.sulake.habbo.help.IHabboHelp;
	import com.sulake.habbo.inventory.IHabboInventory;
	import com.sulake.habbo.localization.IHabboLocalizationManager;
	import com.sulake.habbo.inventory._enum.UnseenItemCategoryEnum;
	import com.sulake.habbo.gamecenter.GameConfigurations;
	import com.sulake.habbo.gamecenter.GameCenterView;
	import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
	import com.sulake.habbo.utils.HabboWebTools;
	import com.sulake.habbo.avatar.IAvatarRenderManager;
	import com.sulake.core.runtime.events.ILinkEventTracker;
	import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
	import com.sulake.habbo.help._enum.WelcomeNotificationAlignment;
	import com.sulake.core.assets.IAssetLibrary;
	import com.sulake.habbo.communication.messages.outgoing.game.lobby.LeaveQueueMessageComposer;
	import com.sulake.habbo.communication.messages.outgoing.game.lobby.JoinQueueMessageComposer;
	import com.sulake.habbo.communication.messages.outgoing.game.lobby.AcceptGameInviteMessageComposer;
	import com.sulake.habbo.communication.messages.outgoing.game.lobby.GetGameListMessageComposer;
	import com.sulake.habbo.communication.messages.outgoing.game.lobby.GetGameAchievementsMessageComposer;
	import com.sulake.habbo.communication.messages.outgoing.game.lobby.GameUnloadedMessageComposer;
	import com.sulake.habbo.room.events.RoomObjectTileMouseEvent;
	import snowwar._str_400._SafeStr_2513;
	import com.sulake.habbo.battleball.BattleBallController;
	import com.sulake.habbo.snowstorm.SnowStormController;
	import com.sulake.habbo.tickets.HotelTicketDialog;
	import com.sulake.core.utils.PlayerVersionCheck;
	import com.sulake.core.Core;
	import com.sulake.habbo.friendbar.IHabboLandingView;
	import com.sulake.core.communication.messages.IMessageComposer;
	import com.sulake.habbo.events.js.JsMessageHandler;
	import com.sulake.habbo.communication.IHabboCommunicationManager;
	import com.sulake.habbo.communication.messages.outgoing.room.session.QuitMessageComposer;
	import com.sulake.habbo.room.IRoomEngine;
	import com.sulake.iid.IIDAvatarRenderManager;
	import com.sulake.iid.IIDHabboCatalog;
	import com.sulake.iid.IIDHabboCommunicationManager;
	import com.sulake.iid.IIDHabboConfigurationManager;
	import com.sulake.iid.IIDHabboHelp;
	import com.sulake.iid.IIDHabboInventory;
	import com.sulake.iid.IIDHabboLandingView;
	import com.sulake.iid.IIDHabboLocalizationManager;
	import com.sulake.iid.IIDHabboNavigator;
	import com.sulake.iid.IIDHabboRoomSessionManager;
	import com.sulake.iid.IIDHabboToolbar;
	import com.sulake.iid.IIDHabboSoundManager;
	import com.sulake.iid.IIDHabboWindowManager;
	import com.sulake.iid.IIDRoomEngine;
	import com.sulake.iid.IIDHabboRoomUI;
	import com.sulake.habbo.ui.IRoomUI;
	import com.sulake.iid.IIDSessionDataManager;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import Globals.flash_net_sendToURL as sendToURL;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import snowwar.SnowWarEngine;
	import snowwar._str_400._SafeStr_2507;
	import snowwar._str_400._SafeStr_2519;

     class HabboGameManager extends Component implements IHabboGameManager implements  ILinkEventTracker 
    {
        static inline final EMBEDDED= 0;
        static inline final IFRAME= 1;

        var _communicationManager:IHabboCommunicationManager;
        var _windowManager:IHabboWindowManager;
        var _localizationManager:IHabboLocalizationManager;
        var _sessionDataManager:ISessionDataManager;
        var _roomSessionManager:IRoomSessionManager;
        var _toolbar:IHabboToolbar;
        var _avatarRenderManager:IAvatarRenderManager;
        var _catalog:IHabboCatalog;
        var _roomEngine:IRoomEngine;
        var _soundManager:IHabboSoundManager;
        var _help:IHabboHelp;
        var _inventory:IHabboInventory;
        var _navigator:IHabboNavigator;
        var _incomingMessages:IncomingMessages;
        var _sharedMessageHandler:SharedMessageHandler;
		var _snowWarEngine:SnowWarEngine;
        var _jsMessageHandler:JsMessageHandler;
        var _gameCenterEnabled:Bool = false;
        var _gameCenterEnabledForStaff:Bool = false;
        var _hotelClosed:Bool = false;
        var _Str_2368:GameCenterView;
        var _landingView:IHabboLandingView;
        var _loader:Loader;
        var _Str_3852:String;
        var _Str_21150:String;
        var _Str_20873:String;
        var _Str_19202:Int = 0;
        var _Str_20663:String;
        var _Str_21692:Int = 0;
        var _Str_9452:Int = -1;
        var _Str_4091:Int = -1;
        var _Str_17758:Int = -1;
        var _Str_11302:Array<ASAny>;
        var _Str_19843:Bool = false;
        var _Str_19735:Int = 0;
        var _Str_16346:String = "";
        var _battleBall:BattleBallController;
        var _classicGameRoomUI:IRoomUI;
        var _gameConfigurationReady:Bool = false;
        var _snowStorm:SnowStormController;
        var _hotelTicketDialog:HotelTicketDialog;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            queueInterface(new IIDHabboWindowManager(), this.onHabboWindowManagerReady);
            queueInterface(new IIDHabboCommunicationManager(), this.onHabboCommunicationManagerReady);
            queueInterface(new IIDHabboConfigurationManager(), this.onHabboConfigurationManagerReady);
            queueInterface(new IIDHabboLocalizationManager(), this.onHabboLocalizationReady);
            queueInterface(new IIDSessionDataManager(), this.onSessionDataManagerReady);
            queueInterface(new IIDHabboRoomSessionManager(), this.onHabboRoomSessionManagerReady);
            queueInterface(new IIDAvatarRenderManager(), this.onAvatarRenderManagerReady);
            queueInterface(new IIDHabboToolbar(), this.onHabboToolbarReady);
            queueInterface(new IIDHabboSoundManager(), this.onHabboSoundManagerReady);
            queueInterface(new IIDHabboCatalog(), this.onHabboCatalogReady);
            queueInterface(new IIDHabboLandingView(), this.onHabboLandingViewReady);
            queueInterface(new IIDRoomEngine(), this.onRoomEngineReady);
            queueInterface(new IIDHabboRoomUI(), this.onHabboRoomUIReady);
            queueInterface(new IIDHabboHelp(), this.onHabboHelpReady);
            queueInterface(new IIDHabboInventory(), this.onHabboInventoryReady);
            queueInterface(new IIDHabboNavigator(), this.onHabboNavigatorReady);
            this._snowWarEngine = new SnowWarEngine(this, k, 0, _arg_3);
            this._jsMessageHandler = new JsMessageHandler(this, true);
            k.addLinkEventTracker(this);
            HabboGamesCom.log([("HabboGameManager initialized: " + _arg_3)]);
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
            return this._communicationManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localizationManager;
        }

        public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._avatarRenderManager;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }

        public var inventory(get,never):IHabboInventory;
public function  get_inventory():IHabboInventory
        {
            return this._inventory;
        }

        public var navigator(get,never):IHabboNavigator;
public function  get_navigator():IHabboNavigator
        {
            return this._navigator;
        }

        public var gameCenterEnabled(get,never):Bool;
public function  get_gameCenterEnabled():Bool
        {
            return this._gameCenterEnabled || (this._gameCenterEnabledForStaff && this._sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE));
        }

        public var isHotelClosed(get,never):Bool;
public function  get_isHotelClosed():Bool
        {
            return this._hotelClosed;
        }

        public var hotelClosed(never,set):Bool;
public function  set_hotelClosed(k:Bool):Bool        {
            return this._hotelClosed = k;
        }

        override public function dispose()
        {
            if (this._battleBall != null)
            {
                this._battleBall.dispose();
                this._battleBall = null;
            }
            if (this._snowStorm != null)
            {
                this._snowStorm.dispose();
                this._snowStorm = null;
            }
            if (this._hotelTicketDialog != null)
            {
                this._hotelTicketDialog.dispose();
                this._hotelTicketDialog = null;
            }
            if (this._communicationManager != null)
            {
                this._communicationManager.release(new IIDHabboCommunicationManager());
                this._communicationManager = null;
            }
            context.removeLinkEventTracker(this);
            if (this._windowManager != null)
            {
                this._windowManager.release(new IIDHabboWindowManager());
                this._windowManager = null;
            }
            if (this._localizationManager != null)
            {
                this._localizationManager.release(new IIDHabboLocalizationManager());
                this._localizationManager = null;
            }
            if (this._sessionDataManager != null)
            {
                this._sessionDataManager.release(new IIDSessionDataManager());
                this._sessionDataManager = null;
            }
            if (this._help != null)
            {
                this._help.release(new IIDHabboHelp());
                this._help = null;
            }
            if (this._toolbar != null)
            {
                if (this._toolbar.events != null)
                {
                    this._toolbar.events.removeEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onToolbarClick);
                }
                this._toolbar.release(new IIDHabboToolbar());
                this._toolbar = null;
            }
            if (this._avatarRenderManager != null)
            {
                this._avatarRenderManager.release(new IIDAvatarRenderManager());
                this._avatarRenderManager = null;
            }
            if (this._catalog != null)
            {
                this._catalog.release(new IIDHabboCatalog());
                this._catalog = null;
            }
            if (this._incomingMessages != null)
            {
                this._incomingMessages.dispose();
                this._incomingMessages = null;
            }
            if (this._landingView != null)
            {
                this._landingView.release(new IIDHabboLandingView());
                this._landingView = null;
            }
            if (this._roomEngine != null)
            {
                this._roomEngine.release(new IIDRoomEngine());
                this._roomEngine = null;
            }
            if (this._soundManager != null)
            {
                this._soundManager.release(new IIDHabboSoundManager());
                this._soundManager = null;
            }
            if (this._inventory != null)
            {
                this._inventory.release(new IIDHabboInventory());
                this._inventory = null;
            }
            if (this._navigator != null)
            {
                this._navigator.release(new IIDHabboNavigator());
                this._navigator = null;
            }
            if (this._sharedMessageHandler != null)
            {
                this._sharedMessageHandler.dispose();
                this._sharedMessageHandler = null;
            }
            if (this._jsMessageHandler != null)
            {
                this._jsMessageHandler.dispose();
                this._jsMessageHandler = null;
            }
            this._Str_4091 = -1;
            super.dispose();
        }

        function onHabboWindowManagerReady(k:IID, _arg_2:IUnknown)
        {
            this._windowManager = Std.downcast(_arg_2 , IHabboWindowManager);
            WindowUtils.init(assets, this._windowManager);
            this.ensureBattleBall();
            this.ensureSnowStorm();
        }

        function onHabboCommunicationManagerReady(k:IID, _arg_2:IUnknown)
        {
            this._communicationManager = Std.downcast(_arg_2 , IHabboCommunicationManager);
            this._incomingMessages = new IncomingMessages(this);
            this.ensureBattleBall();
            this.ensureSnowStorm();
        }

        function onHabboConfigurationManagerReady(k:IID, _arg_2:IUnknown)
        {
            this._gameCenterEnabled = getBoolean("game.center.enabled");
            this._gameCenterEnabledForStaff = getBoolean("game.center.enabled.forStaff");
            this._gameConfigurationReady = true;
            this.ensureBattleBall();
            this.ensureSnowStorm();
        }

        function onHabboLocalizationReady(k:IID, _arg_2:IUnknown)
        {
            this._localizationManager = Std.downcast(_arg_2 , IHabboLocalizationManager);
            this.ensureBattleBall();
            this.ensureSnowStorm();
        }

        function onSessionDataManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._sessionDataManager = Std.downcast(_arg_2 , ISessionDataManager);
            this.ensureBattleBall();
            this.ensureSnowStorm();
        }

        function onHabboRoomUIReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._classicGameRoomUI = Std.downcast(_arg_2 , IRoomUI);
            this.ensureBattleBall();
            this.ensureSnowStorm();
        }

        function onHabboSoundManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._soundManager = Std.downcast(_arg_2 , IHabboSoundManager);
            this.ensureBattleBall();
            this.ensureSnowStorm();
        }

        function ensureBattleBall()
        {
            if (this._battleBall != null || !this._gameConfigurationReady || this._communicationManager == null
                || this._windowManager == null || this._sessionDataManager == null || this._avatarRenderManager == null
                || this._roomEngine == null || this._classicGameRoomUI == null || this._soundManager == null
                || this._localizationManager == null)
            {
                return;
            }
            var baseUrl= getProperty("flash.client.url");
            if (baseUrl == null || baseUrl == "")
            {
                return;
            }
            this.ensureHotelTicketDialog(baseUrl);
            if (this._hotelTicketDialog == null) return;
            this._battleBall = new BattleBallController(this._communicationManager, this._windowManager,
                this._sessionDataManager, this._avatarRenderManager, this._roomEngine, this._classicGameRoomUI,
                this._soundManager, this._localizationManager, baseUrl, assets, this._hotelTicketDialog);
        }

        function ensureSnowStorm()
        {
            if (this._snowStorm != null || !this._gameConfigurationReady || this._communicationManager == null
                || this._windowManager == null || this._sessionDataManager == null
                || this._classicGameRoomUI == null || this._localizationManager == null
                || this._roomEngine == null || this._avatarRenderManager == null)
            {
                return;
            }
            var baseUrl= getProperty("flash.client.url");
            if (baseUrl == null || baseUrl == "") return;
            this.ensureHotelTicketDialog(baseUrl);
            if (this._hotelTicketDialog == null) return;
            this._snowStorm = new SnowStormController(this._communicationManager, this._windowManager,
                this._sessionDataManager, this._classicGameRoomUI, this._localizationManager,
                baseUrl, assets, this._hotelTicketDialog, this._roomEngine,
                this._avatarRenderManager);
        }

        function ensureHotelTicketDialog(baseUrl:String=null)
        {
            if (this._hotelTicketDialog != null || this._communicationManager == null
                || this._windowManager == null || this._classicGameRoomUI == null
                || this._localizationManager == null)
                return;
            if (baseUrl == null || baseUrl == "") baseUrl = getProperty("flash.client.url");
            if (baseUrl == null || baseUrl == "") return;
            this._hotelTicketDialog = new HotelTicketDialog(this._communicationManager,
                this._windowManager, this._classicGameRoomUI, this._localizationManager,
                baseUrl, assets);
        }

        public function openSnowStorm()
        {
            this.ensureSnowStorm();
            if (this._snowStorm != null) this._snowStorm.open();
        }

        public function openBattleBall()
        {
            this.ensureBattleBall();
            if (this._battleBall != null)
            {
                this._battleBall.open();
            }
        }

        function onHabboRoomSessionManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._roomSessionManager = Std.downcast(_arg_2 , IRoomSessionManager);
        }

        function onAvatarRenderManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._avatarRenderManager = Std.downcast(_arg_2 , IAvatarRenderManager);
            this.ensureBattleBall();
            this.ensureSnowStorm();
        }

        function onHabboToolbarReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._toolbar = Std.downcast(_arg_2 , IHabboToolbar);
            this._toolbar.events.addEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onToolbarClick);
        }

        function onHabboCatalogReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._catalog = Std.downcast(_arg_2 , IHabboCatalog);
        }

        function onHabboLandingViewReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._landingView = Std.downcast(_arg_2 , IHabboLandingView);
        }

        function onRoomEngineReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._roomEngine = Std.downcast(_arg_2 , IRoomEngine);
            this.ensureBattleBall();
            this.ensureSnowStorm();
        }

        function onHabboHelpReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._help = Std.downcast(_arg_2 , IHabboHelp);
        }

        function onHabboInventoryReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._inventory = Std.downcast(_arg_2 , IHabboInventory);
        }

        function onHabboNavigatorReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._navigator = Std.downcast(_arg_2 , IHabboNavigator);
        }

        public function _Str_23215(k:Int)
        {
            this._Str_19735 = k;
        }

        public function promotedGameId():Int
        {
            var k= getProperty("game.center.promoted_game");
            var _local_2= GameConfigurations.getId(k);
            return _local_2;
        }

        public function _Str_22499()
        {
            var k= GameConfigurations.getNameId(this.promotedGameId());
            if ((((!(k == null)) && (!this._Str_19843)) && (this._Str_19735 == 0)))
            {
                this._Str_19843 = true;
                this._help.showWelcomeScreen(HabboToolbarIconEnum.GAMES, (k.toLowerCase() + ".promotion"), WelcomeNotificationAlignment.LEFT, "GAMES");
            }
        }

		//START NEW FROM SNOWSTORM
        public function initGameDirectoryConnection()
        {
            this.send(new _SafeStr_2519());
        }

        public function _SafeStr_7619(k:String)
        {
            this.initGameDirectoryConnection();
            this.send(new _SafeStr_2507(k));
        }

        public function _SafeStr_7620()
        {
            this.send(new _SafeStr_2513());
        }
		
        public function _SafeStr_7621()
        {
            if (!this._snowWarEngine._SafeStr_7687)
            {
                this._snowWarEngine._SafeStr_7688();
                this._Str_9452 = -1;
                if (this.gameCenterEnabled)
                {
                    this.showGameCenter("showGameCenter.gameEnd");
                }
                else
                {
                    if (this._landingView != null)
                    {
                        this._landingView.activate();
                    }
                }
            }
        }

        public function _SafeStr_7624()
        {
            if (this._snowWarEngine != null)
            {
                this._snowWarEngine._SafeStr_7624();
            }
        }

        public function _SafeStr_7622(k:RoomObjectTileMouseEvent)
        {
            if (this._snowWarEngine != null)
            {
                this._snowWarEngine._SafeStr_7622(k);
            }
        }

        public function _SafeStr_7623(k:Int, _arg_2:Bool, _arg_3:Bool)
        {
            if (this._snowWarEngine != null)
            {
                this._snowWarEngine._SafeStr_7623(k, _arg_2, _arg_3);
            }
        }

        public function _SafeStr_7625(k:Int, _arg_2:Bool, _arg_3:Bool)
        {
            if (this._snowWarEngine != null)
            {
                this._snowWarEngine._SafeStr_7625(k, _arg_2, _arg_3);
            }
        }
		
		///EDN NEW FROM SNOWSTORM

        public function send(k:IMessageComposer)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(k);
            }
        }

        public function _Str_22538(k:String, _arg_2:String, _arg_3:Int=-1)
        {
            this._catalog.openClubCenter();
            this._Str_3777(k, _arg_2);
        }

        public function alert(k:String)
        {
            if ((this.gameCenterEnabled && (this._Str_2368 != null)))
            {
                this._Str_2368.showAlert(k);
            }
        }

        public function _Str_3777(k:String, _arg_2:String, _arg_3:String="", _arg_4:Int=0)
        {
            var _local_5= this._communicationManager.connection;
            if (((_local_5 != null) && (!(_arg_2 == ""))))
            {
                this.send(new EventLogMessageComposer("GameCenter", k, _arg_2, _arg_3, _arg_4));
            }
        }

        function onToolbarClick(k:HabboToolbarEvent)
        {
            switch (k.iconId)
            {
                case HabboToolbarIconEnum.GAMES:
                    if (this.gameCenterEnabled)
                    {
                        this.showGameCenterByGameName("showGameCenter.toolBarClick", this.defaultGameName);
                    }
                    else
                    {
                        this.initGameDirectoryConnection();
                        //this.send(new _SafeStr_2201()); //TODO: Snowstorm
                    }
                    return;
                case HabboToolbarIconEnum.STORIES:
                    Logger.log(["stories button click"]);
                    if (this.gameCenterEnabled)
                    {
                        if (getInteger("spaweb", 0) == 1)
                        {
                            HabboWebTools.openPage("/stories");
                            Logger.log(["calling openPage to stories"]);
                        }
                        else
                        {
                            this.showGameCenterByGameName("showGameCenter.toolBarClick", "elisa_habbo_stories", true);
                            Logger.log(["old game center opening of stories"]);
                        }
                    }
                    return;
                case HabboToolbarIconEnum.RECEPTION:
                    this._Str_15814();
                    return;
            }
        }

        var defaultGameName(get,never):String;
function  get_defaultGameName():String
        {
            return propertyExists("game.center.default_game") ? getProperty("game.center.default_game") : HabboGames.SNOWWAR;
        }

        public function showGameCenterByGameName(k:String, _arg_2:String, _arg_3:Bool=false)
        {
var _local_6:Array<ASAny>  = null;            var _local_4:Array<ASAny> = (cast _arg_2.split("?"));
            _arg_2 = _local_4[0];
            if (_local_4.length > 1)
            {
                this._Str_16346 = ("?" + _local_4[1]);
            }
            var _local_5= GameConfigurations.getId(_arg_2);
            if (_local_5 > -1)
            {
                this.showGameCenter(k, _local_5, _arg_3);
            }
            else
            {
                _local_5 = GameConfigurations.getId(this.defaultGameName);
                if (_local_5 == -1)
                {
_local_6= GameConfigurations.gameIds();
                    if (((_local_6 != null) && (_local_6.length > 0)))
                    {
                        _local_5 = ASCompat.toInt(_local_6[0]);
                    }
                }
                this.showGameCenter(k, _local_5);
            }
        }

        public function showGameCenter(k:String, _arg_2:Int=0, _arg_3:Bool=false)
        {
            this._Str_24183();
            if (this._Str_2368 == null)
            {
                this._Str_2368 = new GameCenterView(this);
            }
            if (((this._roomSessionManager != null) && (this._roomSessionManager.getSession(-1) != null)))
            {
                this._roomSessionManager.disposeSession(-1, false);
                this.send(new QuitMessageComposer());
            }
            this._toolbar.updateVisibility(HabboToolbarEnum.HTE_STATE_HOTEL_VIEW);
            this._Str_2368.initialize(_arg_2, _arg_3);
            this._Str_3777(GameConfigurations.getNameId(_arg_2), k);
            if (this._navigator != null)
            {
                this._navigator.closeNavigator();
            }
        }

        function _Str_24183()
        {
            GameConfigurations.initialized = false;
            this.send(new GetGameListMessageComposer());
            this.send(new GetGameAchievementsMessageComposer());
        }

        public function _Str_15814()
        {
            if (this._Str_2368 != null)
            {
                this._Str_2368.disable();
            }
        }

        public function loadGameClient(k:Int, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:ASObject)
        {
            var _local_12:LoaderContext = null;
            if (!PlayerVersionCheck.isVersionAtLeast(_arg_7, _arg_8))
            {
                this._Str_3777(GameConfigurations.getNameId(k), "versionCheckFailed");
                this.send(new GameUnloadedMessageComposer(k));
                this._localizationManager.registerParameter("gamecenter.flash_version_required", "version", ((Std.string(_arg_7) + ".") + Std.string(_arg_8)));
                this.alert("${gamecenter.flash_version_required}");
                return;
            }
            var _local_10= new Loader();
            var _local_11= new URLRequest(_arg_3);
            _local_10.addEventListener(MouseEvent.CLICK, (this._Str_5609 : ASAny));
            _local_10.addEventListener(MouseEvent.DOUBLE_CLICK, (this._Str_5609 : ASAny));
            _local_10.addEventListener(MouseEvent.MOUSE_UP, (this._Str_5609 : ASAny));
            _local_10.addEventListener(MouseEvent.MOUSE_DOWN, (this._Str_5609 : ASAny));
            _local_10.addEventListener(MouseEvent.MOUSE_OVER, (this._Str_5609 : ASAny));
            _local_10.addEventListener(MouseEvent.MOUSE_OUT, (this._Str_5609 : ASAny));
            _local_10.addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_5609 : ASAny));
            _local_10.addEventListener(MouseEvent.MOUSE_WHEEL, (this._Str_5609 : ASAny));
            _local_10.addEventListener(MouseEvent.ROLL_OVER, (this._Str_5609 : ASAny));
            _local_10.addEventListener(MouseEvent.ROLL_OUT, (this._Str_5609 : ASAny));
            _local_10.contentLoaderInfo.addEventListener(Event.COMPLETE, (this.onGameClientLoadCompleted : ASAny));
            _local_10.contentLoaderInfo.addEventListener(Event.INIT, (this.onGameClientLoadInit : ASAny));
            _local_10.contentLoaderInfo.addEventListener(Event.UNLOAD, (this.onGameClientUnload : ASAny));
            _local_10.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, (this.onGameClientLoadIOError : ASAny));
            _local_10.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.onGameClientLoadSecurityError : ASAny));
            _local_10.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, (this.onGameClientLoadProgress : ASAny));
            if (ASCompat.hasOwnProperty(_local_10.contentLoaderInfo, "uncaughtErrorEvents"))
            {
                (_local_10.contentLoaderInfo : ASAny)["uncaughtErrorEvents"].addEventListener("uncaughtError", this._Str_6861, true, ASCompat.MAX_INT);
                (_local_10.contentLoaderInfo : ASAny)["uncaughtErrorEvents"].addEventListener("uncaughtError", this._Str_6861, false, ASCompat.MAX_INT);
            }
            this._loader = _local_10;
            this._Str_3852 = _arg_2;
            if (this._sharedMessageHandler != null)
            {
                this._sharedMessageHandler.dispose();
            }
            this._sharedMessageHandler = new SharedMessageHandler(this, _local_10.contentLoaderInfo.sharedEvents);
            this._Str_21150 = _arg_4;
            this._Str_20873 = _arg_5;
            this._Str_19202 = _arg_6;
            if (((Capabilities.playerType == "StandAlone") || HabboWebTools.isAirApplication))
            {
                _local_12 = new LoaderContext(false, new ApplicationDomain());
            }
            else
            {
                _local_12 = new LoaderContext(false, new ApplicationDomain(), SecurityDomain.currentDomain);
            }
            _local_11.data = this._Str_23032(_arg_9);
            if (PlayerVersionCheck.isVersionAtLeast(10, 2))
            {
                _local_11.data = null;
                ASCompat.setLoaderParameters(_local_12, _arg_9);
            }
            _local_10.load(_local_11, _local_12);
            _local_10.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (this._Str_6861 : ASAny), true, ASCompat.MAX_INT);
            _local_10.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (this._Str_6861 : ASAny), false, ASCompat.MAX_INT);
            var _local_13= context.displayObjectContainer.stage;
            this._Str_20663 = _local_13.quality;
            this._Str_21692 = Std.int(_local_13.frameRate);
            this._Str_4091 = k;
            this._Str_17758 = EMBEDDED;
            this._Str_3777(GameConfigurations.getNameId(k), "loadGameClient");
                    this.inventory.unseenItemTracker._Str_18075(UnseenItemCategoryEnum.GAMES, [k]);
            if (this._Str_2368 != null)
            {
                this._Str_2368._Str_18594(k);
            }
        }

        public function _Str_19055(k:Int, _arg_2:String, _arg_3:String, _arg_4:String="")
        {
            if (_arg_3.indexOf("?") != -1)
            {
                ASCompat.stringReplace(_arg_4, "?", "&");
            }
            HabboWebTools.showGame((_arg_3 + this._Str_16346));
            this._Str_16346 = "";
            this._Str_4091 = k;
            this._Str_17758 = IFRAME;
            this._Str_3852 = _arg_2;
            this._Str_3777(GameConfigurations.getNameId(k), "loadGameClient");
                    this.inventory.unseenItemTracker._Str_18075(UnseenItemCategoryEnum.GAMES, [k]);
            if (this._Str_2368 != null)
            {
                this._Str_2368._Str_18594(k);
            }
        }

        function _Str_23032(k:ASObject):URLVariables
        {
var _local_3:String  = null;            var _local_3:String = null;
            var _local_2= new URLVariables();
            if (checkNullIteratee(k)) for (_tmp_ in k.___keys())
            {
_local_3 = _tmp_;
                (_local_2 : ASAny)[_local_3] = ASCompat.getDynamicProperty(k, _local_3);
            }
            return _local_2;
        }

        function onGameClientLoadInit(k:Event)
        {
            var _local_4:DisplayObject = null;
            var _local_2= context.displayObjectContainer.stage;
            _local_2.quality = this._Str_21150;
            _local_2.frameRate = this._Str_19202;
            this._Str_11302 = new Array<ASAny>();
            var _local_3= (_local_2.numChildren - 1);
            while (_local_3 >= 0)
            {
                _local_4 = _local_2.getChildAt(_local_3);
                this._Str_11302.push(_local_4);
                _local_2.removeChildAt(_local_3);
                _local_3--;
            }
            (this._Str_11302 : ASAny).reverse();
            _local_2.addEventListener(Event.RESIZE, (this._Str_1001 : ASAny));
            _local_2.addChild(this._loader);
            Core.instance.hibernate(0);
            this._Str_1001();
        }

        function onGameClientLoadCompleted(event:Event)
        {
            HabboGamesCom.log(["[HabboGameManager] external game client complete"]);
            this._Str_1001();
            this._Str_22015();
        }

        public function _Str_22015()
        {
            this._Str_3777(GameConfigurations.getNameId(this._Str_4091), "gameClientLoaded");
        }

        function _Str_1001(k:Event=null)
        {
            var _local_2:Stage = null;
            var _local_3 = Math.NaN;
            var _local_4 = Math.NaN;
            if (disposed)
            {
                return;
            }
            _local_2 = context.displayObjectContainer.stage;
            if (this._loader != null)
            {
                switch (this._Str_20873)
                {
                    case "showAll":
                        _local_3 = (this._loader.width / this._loader.height);
                        _local_4 = (_local_2.stageWidth / _local_2.stageHeight);
                        if (_local_3 > _local_4)
                        {
                            this._loader.width = _local_2.stageWidth;
                            this._loader.scaleY = this._loader.scaleX;
                        }
                        else
                        {
                            this._loader.height = _local_2.stageHeight;
                            this._loader.scaleX = this._loader.scaleY;
                        }
                        this._loader.x = ((_local_2.stageWidth - this._loader.width) / 2);
                        this._loader.y = ((_local_2.stageHeight - this._loader.height) / 2);
                        
                    case "noScale":
                        this._loader.width = _local_2.stageWidth;
                        this._loader.height = _local_2.stageHeight;
                        this._loader.scaleX = 1;
                        this._loader.scaleY = 1;
                        this._loader.x = 0;
                        this._loader.y = 0;
                        
                }
                if (((this._sharedMessageHandler != null) && (this._sharedMessageHandler._Str_20452 > -1)))
                {
                    this._sharedMessageHandler.send(this._sharedMessageHandler._Str_20452, SharedEventToGameEnum.RESIZE_UPDATE, ([_local_2.stageWidth, _local_2.stageHeight] : Array<Dynamic>));
                }
            }
        }

        function onGameClientLoadIOError(event:IOErrorEvent)
        {
            HabboGamesCom.log(["[HabboGameManager] external game client IO error"]);
            context.error(("IOError while loading game client for " + Std.string(this._Str_4091)), false);
            this.unloadGame(this._Str_4091, this._Str_3852, "loadGameClientError");
        }

        function onGameClientLoadSecurityError(event:SecurityErrorEvent)
        {
            HabboGamesCom.log(["[HabboGameManager] external game client security error"]);
            context.error(("SecurityError while loading game client for " + Std.string(this._Str_4091)), false);
            this.unloadGame(this._Str_4091, this._Str_3852, "loadGameClientError");
        }

        function onGameClientLoadProgress(event:ProgressEvent)
        {
            HabboGamesCom.log([((("[HabboGameManager] external game client progress " + Std.string(event.bytesLoaded)) + "/") + Std.string(event.bytesTotal))]);
        }

        function _Str_5609(k:Event)
        {
            k.stopImmediatePropagation();
        }

        public function joinPlayerQueue(k:Int)
        {
            this._Str_20329();
			if (k == HabboGames._SafeStr_7697)
			{
				this._SafeStr_7620();
			}
			else
			{
				this.send(new JoinQueueMessageComposer(k));
				if (this._Str_2368 != null)
				{
					this._Str_2368._Str_19498(k);
				};
			}
            this._Str_9452 = k;
            this._Str_3777(GameConfigurations.getNameId(k), "joinPlayerQueue");
        }

        function _Str_20329()
        {
            if (this._Str_9452 != -1)
            {
                this.leavePlayerQueue(this._Str_9452);
            }
        }

        public function leavePlayerQueue(k:Int)
        {
            this.send(new LeaveQueueMessageComposer(k));
            this._Str_9452 = -1;
        }

        public function acceptGameInvite(k:Int, _arg_2:Int)
        {
            this._Str_20329();
            this.send(new AcceptGameInviteMessageComposer(k, _arg_2));
            this._Str_9452 = k;
            this._Str_3777(GameConfigurations.getNameId(k), "joinPlayerQueue", "", _arg_2);
            if (this._Str_2368 != null)
            {
                this._Str_2368._Str_19498(k);
            }
        }

        public function onGameClientUnload(k:Event)
        {
            HabboGamesCom.log(["[HabboGameManager] external game client unloaded"]);
        }

        public function unloadGame(k:Int, _arg_2:String, _arg_3:String)
        {
            var _local_4:HabboToolbarEvent = null;
            this._Str_9452 = -1;
            if (this._Str_2368 != null)
            {
                this._Str_2368._Str_18594(k);
            }
            if (((this._Str_4091 > -1) && (this._Str_3852 == _arg_2)))
            {
                this._Str_3777(GameConfigurations.getNameId(this._Str_4091), _arg_3);
                this._Str_4091 = -1;
                Core.instance.resume();
                switch (this._Str_17758)
                {
                    case EMBEDDED:
                        this.unloadGameClient();
                        
                    case IFRAME:
                        this._Str_24319();
                        
                }
                if (GameConfigurations.getNameId(k) == "elisa_habbo_stories")
                {
                    if (this._landingView != null)
                    {
                        this._landingView.activate();
                    }
                    _local_4 = new HabboToolbarEvent(HabboToolbarEvent.HTE_TOOLBAR_CLICK);
                    _local_4.iconId = HabboToolbarIconEnum.RECEPTION;
                    this._toolbar.events.dispatchEvent(_local_4);
                }
                else
                {
                    if (this._Str_2368 != null)
                    {
                        this._Str_2368.activate(k, false);
                        this._Str_3777(GameConfigurations.getNameId(k), "showGameCenter.gameEnd");
                    }
                }
                this.send(new GameUnloadedMessageComposer(k));
            }
        }

        public function _Str_20515()
        {
            if (this._Str_4091 > -1)
            {
                this.unloadGame(this._Str_4091, this._Str_3852, "unloadGameClient");
            }
        }

        function unloadGameClient()
        {
            var _local_2:DisplayObject = null;
            var k= context.displayObjectContainer.stage;
            k.removeEventListener(Event.RESIZE, (this._Str_1001 : ASAny));
            if (this._loader != null)
            {
                if (k.contains(this._loader))
                {
                    k.removeChild(this._loader);
                }
                if (ASCompat.hasOwnProperty(this._loader.contentLoaderInfo, "uncaughtErrorEvents"))
                {
                    (this._loader.contentLoaderInfo : ASAny)["uncaughtErrorEvents"].removeEventListener("uncaughtError", this._Str_6861, true);
                    (this._loader.contentLoaderInfo : ASAny)["uncaughtErrorEvents"].removeEventListener("uncaughtError", this._Str_6861, false);
                }
                this._loader.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (this._Str_6861 : ASAny), true);
                this._loader.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (this._Str_6861 : ASAny), false);
                this._loader.unloadAndStop();
                this._loader = null;
            }
            final _iter_ = this._Str_11302; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.addChild(_local_2);
            }
            this._Str_11302 = null;
            k.quality = this._Str_20663;
            k.frameRate = this._Str_21692;
        }

        function _Str_24319()
        {
            HabboWebTools.hideGame();
        }

        public function _Str_22863(k:Int):String
        {
            return GameConfigurations.getNameId(k);
        }

        public function getGameId(k:String):Int
        {
            return GameConfigurations.getId(k);
        }

        public function getGameAssetURL(k:Int, _arg_2:String):String
        {
            return GameConfigurations.getAssetUrl(k, _arg_2);
        }

        function _Str_6861(k:UncaughtErrorEvent)
        {
            var _local_2:String = null;
            var _local_3:String = null;
            var _local_5:ASError = null;
            var _local_6:ErrorEvent = null;
            HabboGamesCom.log([((("[HabboGameManager] external game client crashed, eventType:" + k.type) + " errorID:") + Std.string(k.errorID))]);
            var _local_4:String = null;
            if (Std.is(k.error , ASError))
            {
                _local_5 = ASCompat.dynamicAs(k.error , ASError);
                _local_2 = Std.string(_local_5.errorID);
                _local_3 = _local_5.message;
                _local_4 = _local_5.getStackTrace();
            }
            else
            {
                if (Std.is(k.error , ErrorEvent))
                {
                    _local_6 = ASCompat.dynamicAs(k.error , ErrorEvent);
                    _local_2 = Std.string(_local_6.errorID);
                    _local_3 = _local_6.type;
                    _local_4 = _local_6.toString();
                }
                else
                {
                    _local_2 = Std.string(k.errorID);
                    _local_3 = k.type;
                    _local_4 = Std.string(k.error);
                }
            }
            this._Str_21246(_local_2, _local_3, _local_4);
            k.stopImmediatePropagation();
        }

        public function _Str_21246(k:String, _arg_2:String, _arg_3:String=null)
        {
            this._Str_24065(this._Str_4091, k, _arg_2, _arg_3);
            this.unloadGame(this._Str_4091, this._Str_3852, "gameClientCrash");
            this.alert("${gamecenter.game_crashed}");
        }

        function _Str_24065(gameTypeId:Int, errorId:String, errorMessage:String, debugData:String=null)
        {
            var url= getProperty("game.center.error.url");
            var variables= new URLVariables();
            var request= new URLRequest(url);
            (variables : ASAny)["gameTypeId"] = gameTypeId;
            (variables : ASAny)["flashVersion"] = Capabilities.version;
            (variables : ASAny)["errorId"] = errorId;
            (variables : ASAny)["errorMessage"] = errorMessage;
            if (ASCompat.stringAsBool(debugData))
            {
                (variables : ASAny)["debugData"] = debugData;
            }
            request.data = variables;
            request.method = URLRequestMethod.POST;
            if (Capabilities.playerType != "StandAlone")
            {
                try
                {
                    sendToURL(request);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log([("Error while sending error report: " + e.message)]);
                }
 }            }
        }

		//TODO: SnowStorm function. Check public calls.
		//DONE. Loads Snowstorm Assets.
		public function _SafeStr_7683()
        {
            this._snowWarEngine.loadUIElements();
        }

		//TODO: SnowStorm function. Check public calls.
		//DONE
        public function _SafeStr_7684():Bool
        {
            return this._snowWarEngine._SafeStr_7702();
        }
		
        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "games/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "open":
                    if (_local_2.length > 2)
                    {
                        this.showGameCenterByGameName("", _local_2[2]);
                    }
                    return;
                case "play":
                    if (_local_2.length > 2)
                    {
                        this.showGameCenterByGameName("", _local_2[2], true);
                    }
                    return;
                case "battleball":
                    this.openBattleBall();
                    return;
                case "snowstorm":
                    this.openSnowStorm();
                    return;
            }
        }
    }

