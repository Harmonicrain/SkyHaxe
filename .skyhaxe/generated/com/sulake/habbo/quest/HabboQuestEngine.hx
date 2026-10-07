package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.navigator.IHabboNewNavigator;
    import com.sulake.habbo.notifications.IHabboNotifications;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDHabboNotifications;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.iid.IIDHabboNewNavigator;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IID;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.outgoing.quest.GetSeasonalQuestsOnlyMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.quest.GetQuestsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.quest.ActivateQuestMessageComposer;
    import com.sulake.habbo.quest.rewardtrack.RewardTrackController;

     class HabboQuestEngine extends Component implements IHabboQuestEngine implements  IUpdateReceiver implements  ILinkEventTracker 
    {
        static inline final _Str_16631= 5;
        static inline final _Str_18373= 800;
        static inline final _Str_16236= 15;
        static inline final _Str_16080= 300;
        static final _Str_18303:Array<ASAny> = ["MOVEITEM", "ENTEROTHERSROOM", "CHANGEFIGURE", "FINDLIFEGUARDTOWER", "SCRATCHAPET"];

        var _windowManager:IHabboWindowManager;
        var _communication:IHabboCommunicationManager;
        var _localization:IHabboLocalizationManager;
        var _configuration:IHabboConfigurationManager;
        var _incomingMessages:IncomingMessages;
        var _questController:QuestController;
        var _achievementController:AchievementController;
        var _roomCompetitionController:RoomCompetitionController;
        var _toolbar:IHabboToolbar;
        var _catalog:IHabboCatalog;
        var _navigator:IHabboNewNavigator;
        var _notifications:IHabboNotifications;
        var _sessionDataManager:ISessionDataManager;
        var _habboHelp:IHabboHelp;
        var _tracking:IHabboTracking;
        var _twinkleImages:TwinkleImages;
        var _currentlyInRoom:Bool = false;
        var _roomEngine:IRoomEngine;
        var _isFirstLoginOfDay:Bool = false;
        var _achievementsResolutionController:AchievementsResolutionController;
        var _rewardTrackController:RewardTrackController;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._questController = new QuestController(this);
            this._achievementController = new AchievementController(this);
            this._achievementsResolutionController = new AchievementsResolutionController(this);
            this._roomCompetitionController = new RoomCompetitionController(this);
            this._rewardTrackController = new RewardTrackController(this);
            k.addLinkEventTracker(this._rewardTrackController);
            queueInterface(new IIDHabboCommunicationManager(), this.onCommunicationManagerReady);
            queueInterface(new IIDHabboWindowManager(), this.onWindowManagerReady);
            queueInterface(new IIDHabboLocalizationManager(), this.onLocalizationManagerReady);
            queueInterface(new IIDHabboConfigurationManager(), this.onConfigurationManagerReady);
            queueInterface(new IIDHabboToolbar(), this.onToolbarReady);
            queueInterface(new IIDHabboCatalog(), this.onCatalogReady);
            queueInterface(new IIDHabboNotifications(), this.onNotificationsReady);
            queueInterface(new IIDHabboHelp(), this.onHelpReady);
            queueInterface(new IIDHabboNewNavigator(), this.onNavigatorReady);
            queueInterface(new IIDSessionDataManager(), this.onSessionDataManagerReady);
            queueInterface(new IIDRoomEngine(), this.onRoomEngineReady);
            queueInterface(new IIDHabboTracking(), this.onTrackingReady);
            k.addLinkEventTracker(this);
            registerUpdateReceiver(this, _Str_16631);
        }

        public static function _Str_5055(k:IWindowContainer, _arg_2:Array<ASAny>, _arg_3:Int, _arg_4:Int)
        {
            var childName:String = null;
            var window:IWindow = null;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
childName  = _tmp_;
                window = k.getChildByName(childName);
                if (((!(window == null)) && window.visible))
                {
                    window.x = _arg_3;
                    _arg_3 = (_arg_3 + (window.width + _arg_4));
                }
            }
        }


        override public function dispose()
        {
            removeUpdateReceiver(this);
            context.removeLinkEventTracker(this);
            if (this._toolbar != null)
            {
                this._toolbar.release(new IIDHabboToolbar());
                this._toolbar = null;
            }
            if (this._catalog != null)
            {
                this._catalog.release(new IIDHabboCatalog());
                this._catalog = null;
            }
            if (this._notifications != null)
            {
                this._notifications.release(new IIDHabboNotifications());
                this._notifications = null;
            }
            if (this._windowManager != null)
            {
                this._windowManager.release(new IIDHabboWindowManager());
                this._windowManager = null;
            }
            if (this._localization != null)
            {
                this._localization.release(new IIDHabboLocalizationManager());
                this._localization = null;
            }
            if (this._configuration != null)
            {
                this._configuration.release(new IIDHabboConfigurationManager());
                this._configuration = null;
            }
            if (this._communication != null)
            {
                this._communication.release(new IIDHabboCommunicationManager());
                this._communication = null;
            }
            if (this._sessionDataManager != null)
            {
                this._sessionDataManager.events.removeEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this._achievementController.onBadgeImageReady);
                this._sessionDataManager.release(new IIDSessionDataManager());
                this._sessionDataManager = null;
            }
            if (this._incomingMessages != null)
            {
                this._incomingMessages.dispose();
            }
            if (this._habboHelp != null)
            {
                this._habboHelp.release(new IIDHabboHelp());
                this._habboHelp = null;
            }
            if (this._navigator != null)
            {
                this._navigator.release(new IIDHabboNewNavigator());
                this._navigator = null;
            }
            if (this._tracking != null)
            {
                this._tracking.release(new IIDHabboTracking());
                this._tracking = null;
            }
            if (this._twinkleImages != null)
            {
                this._twinkleImages.dispose();
                this._twinkleImages = null;
            }
            if (this._roomEngine != null)
            {
                this._roomEngine.release(new IIDRoomEngine());
                this._roomEngine = null;
            }
            if (this._achievementsResolutionController != null)
            {
                this._achievementsResolutionController.dispose();
                this._achievementsResolutionController = null;
            }
            if (this._rewardTrackController != null)
            {
                context.removeLinkEventTracker(this._rewardTrackController);
                this._rewardTrackController.dispose();
                this._rewardTrackController = null;
            }
            super.dispose();
        }

        public function getXmlWindow(k:String, _arg_2:Int=1):IWindow
        {
            var _local_4:IAsset = null;
            var _local_5:XmlAsset = null;
            var _local_3:IWindow = null;
            try
            {
                _local_4 = assets.getAssetByName(k);
                _local_5 = cast(_local_4, XmlAsset);
                _local_3 = this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_5.content), _arg_2);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return _local_3;
        }

        function onCommunicationManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._communication = cast(_arg_2, IHabboCommunicationManager);
            this._incomingMessages = new IncomingMessages(this);
            if (this._rewardTrackController != null)
            {
                this._rewardTrackController.registerMessages();
            }
        }

        function onWindowManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._windowManager = cast(_arg_2, IHabboWindowManager);
        }

        function onLocalizationManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._localization = cast(_arg_2, IHabboLocalizationManager);
        }

        function onConfigurationManagerReady(k:IID, _arg_2:IUnknown)
        {
            if (_arg_2 == null)
            {
                return;
            }
            this._configuration = Std.downcast(_arg_2 , IHabboConfigurationManager);
        }

        function onCatalogReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._catalog = Std.downcast(_arg_2 , IHabboCatalog);
        }

        function onNotificationsReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._notifications = Std.downcast(_arg_2 , IHabboNotifications);
        }

        function onSessionDataManagerReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._sessionDataManager = Std.downcast(_arg_2 , ISessionDataManager);
            this._sessionDataManager.events.addEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this._achievementController.onBadgeImageReady);
        }

        function onHelpReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._habboHelp = Std.downcast(_arg_2 , IHabboHelp);
        }

        function onNavigatorReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._navigator = Std.downcast(_arg_2 , IHabboNewNavigator);
        }

        function onRoomEngineReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._roomEngine = Std.downcast(_arg_2 , IRoomEngine);
        }

        function onTrackingReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (disposed)
            {
                return;
            }
            this._tracking = Std.downcast(_arg_2 , IHabboTracking);
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public var habboHelp(get,never):IHabboHelp;
public function  get_habboHelp():IHabboHelp
        {
            return this._habboHelp;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public var _Str_3398(get,never):QuestController;
public function  get__Str_3398():QuestController
        {
            return this._questController;
        }

        public var _Str_8189(get,never):RoomCompetitionController;
public function  get__Str_8189():RoomCompetitionController
        {
            return this._roomCompetitionController;
        }

        public var _Str_17659(get,never):AchievementController;
public function  get__Str_17659():AchievementController
        {
            return this._achievementController;
        }

        public var _Str_10255(get,never):AchievementsResolutionController;
public function  get__Str_10255():AchievementsResolutionController
        {
            return this._achievementsResolutionController;
        }

        public var rewardTrackController(get,never):RewardTrackController;
public function  get_rewardTrackController():RewardTrackController
        {
            return this._rewardTrackController;
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public var tracking(get,never):IHabboTracking;
public function  get_tracking():IHabboTracking
        {
            return this._tracking;
        }

        public function openCatalog(k:QuestMessageData)
        {
            var _local_2= k._Str_23842;
            if (_local_2 != "")
            {
                Logger.log([("Questing->Open Catalog: " + _local_2)]);
                this._catalog.openCatalogPage(_local_2);
            }
            else
            {
                Logger.log(["Questing->Open Catalog: Quest Catalog page name not defined"]);
                this._catalog.openCatalog();
            }
        }

        public function openNavigator(k:QuestMessageData)
        {
            var _local_3:String = null;
            var _local_2= this._Str_17631((k._Str_5688() + ".searchtag"));
            if (_local_2)
            {
                _local_3 = (k._Str_5688() + ".searchtag");
            }
            else
            {
                _local_3 = (k._Str_9246() + ".searchtag");
            }
            var _local_4= this._localization.getLocalization(_local_3);
            Logger.log([("Questing->Open Navigator: " + _local_4)]);
            this._navigator.performTagSearch(_local_4);
        }

        public function hasQuestRoomsIds():Bool
        {
            var k= this.getQuestRoomIds();
            return (!(k == null)) && (!(k == ""));
        }

        function getQuestRoomIds():String
        {
            return this._localization.getLocalization((("quests." + this._Str_9628()) + ".roomids"));
        }

        public function goToQuestRooms()
        {
            if (!this.hasQuestRoomsIds())
            {
                return;
            }
            var k= this.getQuestRoomIds();
            var _local_2:Array<ASAny> = (cast k.split(","));
            if (_local_2.length == 0)
            {
                return;
            }
            var _local_3= Std.int(Math.max(0, Math.min((_local_2.length - 1), Math.ffloor((Math.random() * _local_2.length)))));
            var _local_4:String = _local_2[_local_3];
            var _local_5= ASCompat.toInt(_local_4);
            Logger.log([("Forwarding to a guest room: " + Std.string(_local_5))]);
            this._navigator.goToRoom(_local_5);
        }

        function onToolbarReady(k:IID=null, _arg_2:IUnknown=null)
        {
            this._toolbar = (cast(_arg_2, IHabboToolbar) );
            this._toolbar.events.addEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onHabboToolbarEvent);
        }

        function onHabboToolbarEvent(k:HabboToolbarEvent)
        {
            if (k.type == HabboToolbarEvent.HTE_TOOLBAR_CLICK)
            {
                if (k.iconId == HabboToolbarIconEnum.QUESTS)
                {
                    this._questController.onToolbarClick();
                }
                if (k.iconId == HabboToolbarIconEnum.ACHIEVEMENTS)
                {
                    this._achievementController.onToolbarClick();
                }
            }
        }

        public function ensureAchievementsInitialized()
        {
            if (this._achievementController != null)
            {
                this._achievementController.ensureAchievementsInitialized();
            }
        }

        public function showAchievements()
        {
            if (this._achievementController != null)
            {
                this._achievementController.show();
            }
        }

        public function showQuests()
        {
        }

        public function getAchievementLevel(k:String, _arg_2:String):Int
        {
            if (this._achievementController != null)
            {
                return this._achievementController.getAchievementLevel(k, _arg_2);
            }
            return 0;
        }

        public function reenableRoomCompetitionWindow()
        {
            this._roomCompetitionController._Str_23471 = false;
        }

        public var notifications(get,never):IHabboNotifications;
public function  get_notifications():IHabboNotifications
        {
            return this._notifications;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public function send(k:IMessageComposer)
        {
            this.communication.connection.send(k);
        }

        public function isTrackerVisible():Bool
        {
            return this._questController._Str_20198.isVisible();
        }

        public function _Str_23055(k:QuestMessageData):String
        {
            var _local_2= ((k._Str_3935 < 1) ? (k._Str_5688() + ".name") : "quests.list.questdelayed");
            return this._localization.getLocalization(_local_2, _local_2);
        }

        public function getQuestName(k:QuestMessageData):String
        {
            var _local_2:ASAny = (k._Str_5688() + ".name");
            return this._localization.getLocalization(_local_2, _local_2);
        }

        public function _Str_20120(k:QuestMessageData):String
        {
            var _local_2:ASAny = (k._Str_5688() + ".desc");
            return this._localization.getLocalization(_local_2, _local_2);
        }

        public function _Str_23561(k:QuestMessageData):String
        {
            var _local_2:ASAny = (k._Str_5688() + ".hint");
            return this._localization.getLocalization(_local_2, _local_2);
        }

        public function _Str_26148(k:Int):String
        {
            var _local_2= ("achievements.activitypoint." + Std.string(k));
            return this._localization.getLocalization(_local_2, _local_2);
        }

        public function _Str_21680(k:String):String
        {
            var _local_2:ASAny = (k + ".name");
            return this._localization.getLocalization(_local_2, _local_2);
        }

        public function _Str_15926(k:QuestMessageData):String
        {
            return this._Str_21680(k._Str_9246());
        }

        public function _Str_21442(k:String):String
        {
            var _local_2:ASAny = (("quests." + k) + ".name");
            return this._localization.getLocalization(_local_2, _local_2);
        }

        public function _Str_19955(k:IWindowContainer, _arg_2:QuestMessageData)
        {
            var _local_3= Std.downcast(k.findChildByName("quest_pic_bitmap") , IStaticBitmapWrapperWindow);
            var _local_4= ((_arg_2._Str_3935 > 0) ? "quest_timer_questionmark" : ((((_arg_2._Str_6549 + "_") + _arg_2.localizationCode) + _arg_2._Str_22072) + (this._Str_17760(_arg_2) ? "_a" : "")).toLowerCase());
            _local_3.assetUri = (("${image.library.questing.url}" + _local_4) + ".png");
        }

        public function _Str_22546(k:IWindowContainer, _arg_2:QuestMessageData, _arg_3:String)
        {
            var _local_4= Std.downcast(k.findChildByName(("prompt_pic_" + _arg_3)) , IStaticBitmapWrapperWindow);
            _local_4.assetUri = (("${image.library.questing.url}" + (((((_arg_2._Str_6549 + "_") + _arg_2.localizationCode) + _arg_2._Str_22072) + "_") + _arg_3).toLowerCase()) + ".png");
        }

        public function _Str_24530(k:IWindowContainer, _arg_2:Int)
        {
            var _local_3= k.findChildByName("currency_icon");
            _local_3.style = ActivityPointTypeEnum.getIconStyleFor(_arg_2, this, true);
        }

        public function _Str_19396(k:IWindowContainer, _arg_2:QuestMessageData, _arg_3:Bool)
        {
            var _local_4= Std.downcast(k.findChildByName("campaign_pic_bitmap") , IStaticBitmapWrapperWindow);
            if (!_arg_3)
            {
                _local_4.visible = false;
                return;
            }
            _local_4.visible = true;
            var _local_5= _arg_2._Str_6549;
            if (this._Str_7575(_arg_2))
            {
                _local_5 = (this._Str_9628() + "_campaign_icon");
            }
            _local_4.assetUri = (("${image.library.questing.url}" + _local_5) + ".png");
        }

        public function _Str_21694(k:IWindowContainer, _arg_2:AchievementCategory, _arg_3:Bool)
        {
            var _local_4= Std.downcast(k.findChildByName("category_pic_bitmap") , IStaticBitmapWrapperWindow);
            _local_4.assetUri = (("${image.library.questing.url}" + (_arg_3 ? (("achcategory_" + _arg_2.code) + ((_arg_2._Str_9594() > 0) ? "_active" : "_inactive")) : ("achicon_" + _arg_2.code))) + ".png");
        }

        public function _Str_17760(k:QuestMessageData):Bool
        {
            return _Str_18303.indexOf(k.localizationCode) > -1;
        }

        public function _Str_19816(k:Bool, _arg_2:IWindowContainer, _arg_3:Int, _arg_4:Int)
        {
            k = (((_arg_3 < 0) || (_arg_4 < 1)) ? false : k);
            var _local_5= _arg_2.findChildByName("reward_caption_txt");
            var _local_6= _arg_2.findChildByName("reward_amount_txt");
            var _local_7= _arg_2.findChildByName("currency_icon");
            _local_6.visible = k;
            _local_5.visible = k;
            _local_7.visible = k;
            if (!k)
            {
                return;
            }
            _local_6.caption = ("" + Std.string(_arg_4));
            _Str_5055(_arg_2, ["reward_caption_txt", "reward_amount_txt", "currency_icon"], _local_5.x, 3);
            this._Str_24530(_arg_2, _arg_3);
        }

        public function update(k:UInt)
        {
            this._questController.update(k);
            this._achievementController.update(k);
        }

        public function _Str_22854(k:IWindowContainer):Animation
        {
            if (this._twinkleImages == null)
            {
                this._twinkleImages = new TwinkleImages(this);
            }
            var _local_2= _Str_18373;
            var _local_3= new Animation(cast(k.findChildByName("twinkle_bitmap"), IBitmapWrapperWindow));
            var _local_4 = 0;
            while (_local_4 < _Str_16236)
            {
                _local_3.addObject(new Twinkle(this._twinkleImages, _local_2));
                _local_2 = (_local_2 + _Str_16080);
                _local_4++;
            }
            return _local_3;
        }

        
        public var _Str_6927(get,set):Bool;
public function  get__Str_6927():Bool
        {
            return this._currentlyInRoom;
        }
public function  set__Str_6927(k:Bool):Bool        {
            return this._currentlyInRoom = k;
        }

        public function _Str_19304():Bool
        {
            return this._configuration.getBoolean("seasonalQuestCalendar.enabled");
        }

        public function _Str_7575(k:QuestMessageData):Bool
        {
            var _local_2= this._Str_9628();
            return (!(_local_2 == "")) && (k._Str_6549.indexOf(_local_2) == 0);
        }

        public function _Str_9628():String
        {
            return getProperty("seasonalQuestCalendar.campaignPrefix");
        }

        public function _Str_25830(k:Bool)
        {
            this._isFirstLoginOfDay = k;
        }

        public var _Str_18128(get,never):Bool;
public function  get__Str_18128():Bool
        {
            return this._isFirstLoginOfDay;
        }

        public var configuration(get,never):IHabboConfigurationManager;
public function  get_configuration():IHabboConfigurationManager
        {
            return this._configuration;
        }

        public function _Str_17631(k:String):Bool
        {
            return !(this._localization.getLocalization(k, "") == "");
        }

        public var navigator(get,never):IHabboNewNavigator;
public function  get_navigator():IHabboNewNavigator
        {
            return this._navigator;
        }

        public function requestSeasonalQuests()
        {
            this.send(new GetSeasonalQuestsOnlyMessageComposer());
        }

        public function requestQuests()
        {
            this.send(new GetQuestsMessageComposer());
        }

        public function activateQuest(k:Int)
        {
            this.send(new ActivateQuestMessageComposer(k));
        }

        public function openRewardTrack(k:String)
        {
            if (this._rewardTrackController != null)
            {
                this._rewardTrackController.open(k);
            }
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "questengine/";
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
                case "gotorooms":
                    this.goToQuestRooms();
                    return;
                case "achievements":
                    if (_local_2.length == 3)
                    {
                        this._achievementController.show();
                        this._achievementController._Str_23567(_local_2[2]);
                    }
                    else
                    {
                        this.showAchievements();
                    }
                    return;
                case "calendar":
                    this._questController._Str_13628.onToolbarClick();
                    return;
                case "quests":
                    this._questController.onToolbarClick();
                    return;
                default:
                    Logger.log([("QuestEngine unknown link-type received: " + _local_2[1])]);
            }
        }
    }

