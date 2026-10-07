package com.sulake.habbo.ui
;
	import com.sulake.habbo.ui.IRoomWidgetFactory;
	import com.sulake.habbo.ui.IRoomWidgetHandler;
	import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
	import com.sulake.habbo.ui.widget.infobuspolls.VotePollWidgetHandler;
    import com.sulake.habbo.ui.widget.IRoomWidgetMessageListener;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.messenger.IHabboMessenger;
    import com.sulake.habbo.groups.IHabboGroupsManager;
    import com.sulake.habbo.avatar.IHabboAvatarEditor;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.advertisement.IAdManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.moderation.IHabboModeration;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.roomevents.IHabboUserDefinedRoomEvents;
    import com.sulake.habbo.game.IHabboGameManager;
    import com.sulake.habbo.quest.IHabboQuestEngine;
    import com.sulake.habbo.freeflowchat.IHabboFreeFlowChat;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.components.IToolTipWindow;
    import flash.utils.Timer;
    import flash.geom.Rectangle;
    import com.sulake.core.communication.messages.IMessageEvent;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.incoming.room.bots.BotSkillListUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.room.bots.BotForceOpenContextMenuEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.friendlist.events._Str_2948;
    import com.sulake.room.events.RoomContentLoadedEvent;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.habbo.ui.widget.IRoomWidget;
    import flash.events.TimerEvent;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.ui.widget.events._Str_5375;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRentableBotForceOpenContextMenuEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetLoadingBarUpdateEvent;
    import com.sulake.habbo.ui.handler.ChatWidgetHandler;
    import com.sulake.habbo.ui.handler.PlayListEditorWidgetHandler;
    import com.sulake.habbo.ui.handler.SpamWallPostItWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureContextMenuWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureRoomLinkHandler;
    import com.sulake.habbo.ui.handler.RoomToolsWidgetHandler;
    import com.sulake.habbo.ui.widget.events._Str_3040;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.handler.InfoStandWidgetHandler;
    import com.sulake.habbo.ui.handler.ChatInputWidgetHandler;
    import com.sulake.habbo.ui.handler.MeMenuWidgetHandler;
    import com.sulake.habbo.ui.handler.PlaceholderWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureCreditWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureStickieWidgetHandler;
    import com.sulake.habbo.ui.handler.FurniturePresentWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureTrophyWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureEcotronBoxWidgetHandler;
    import com.sulake.habbo.ui.handler.PetPackageFurniWidgetHandler;
    import com.sulake.habbo.ui.handler.DoorbellWidgetHandler;
    import com.sulake.habbo.ui.handler.RoomQueueWidgetHandler;
    import com.sulake.habbo.ui.handler.LoadingBarWidgetHandler;
    import com.sulake.habbo.ui.handler.PollWidgetHandler;
    import com.sulake.habbo.ui.handler.WordQuizWidgetHandler;
    import com.sulake.habbo.ui.handler.FurniChooserWidgetHandler;
    import com.sulake.habbo.ui.handler.UserChooserWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureDimmerWidgetHandler;
    import com.sulake.habbo.ui.handler.FriendRequestWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureClothingChangeWidgetHandler;
    import com.sulake.habbo.ui.handler.ConversionPointWidgetHandler;
    import com.sulake.habbo.ui.handler.AvatarInfoWidgetHandler;
    import com.sulake.habbo.ui.handler.WelcomeGiftWidgetHandler;
    import com.sulake.habbo.ui.handler.EffectsWidgetHandler;
    import com.sulake.habbo.ui.handler.MannequinWidgetHandler;
    import com.sulake.habbo.ui.handler.ObjectLocationRequestHandler;
    import com.sulake.habbo.ui.handler.CameraWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureBackgroundColorWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureAreaHideWidgetHandler;
    import com.sulake.habbo.room.events.RoomEngineAreaHideStateWidgetEvent;
    import com.sulake.habbo.ui.handler.CustomUserNotificationWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureAchievementResolutionEngraving;
    import com.sulake.habbo.ui.handler.FriendFurniConfirmWidgetHandler;
    import com.sulake.habbo.ui.handler.FriendFurniEngravingWidgetHandler;
    import com.sulake.habbo.ui.handler.HighScoreFurniWidgetHandler;
    import com.sulake.habbo.ui.handler.GamehallWidgetHandler;
    import com.sulake.habbo.ui.handler.LeaderboardWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureInternalLinkHandler;
    import com.sulake.habbo.ui.handler.FurnitureCustomStackHeightWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureYoutubeDisplayWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureRentableSpaceWidgetHandler;
    import com.sulake.habbo.ui.handler.FurnitureVimeoDisplayWidgetHandler;
    import com.sulake.habbo.ui.handler.ExternalImageWidgetHandler;
    import com.sulake.habbo.ui.handler.UiHelpBubbleWidgetHandler;
    import com.sulake.habbo.ui.handler.RoomThumbnailCameraWidgetHandler;
    import com.sulake.habbo.ui.handler.CraftingWidgetHandler;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.room.events.RoomEngineGamehallEvent;
    import com.sulake.habbo.room.events.RoomEngineLeaderboardEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetZoomToggleMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events._Str_9973;
    import flash.events.Event;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.room.events.RoomEngineObjectPlacedEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectPlaceEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniToWidgetMessage;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.room.object.RoomObjectOperationEnum;
    import com.sulake.habbo.room.events.RoomEngineRoomAdEvent;
    import com.sulake.habbo.room.events.RoomObjectSoundMachineEvent;
    import com.sulake.habbo.room.events.RoomEngineUseProductEvent;
    import com.sulake.room.utils.RoomId;
    import com.sulake.habbo.ui.widget.events._Str_3345;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.android.AndroidRoomGestureController;
    import com.sulake.room.utils.RoomGeometry;
    import flash.display.DisplayObject;
    import com.sulake.habbo.room.RoomVariableEnum;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.MouseEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import flash.display.Sprite;
    import flash.display.BlendMode;
    import com.sulake.room.utils.ColorConverter;
    import com.sulake.core.runtime.Component;
    import flash.filters.BlurFilter;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.filters.DisplacementMapFilterMode;
    import flash.filters.DisplacementMapFilter;
    import flash.filters.BitmapFilter;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.ui.widget.avatarinfo.AvatarInfoWidget;
    import com.sulake.habbo.ui.*;

     class RoomDesktop implements IRoomDesktop implements  IRoomWidgetMessageListener implements  IRoomWidgetHandlerContainer 
    {
        public static inline final STATE_UNDEFINED= -1;
        static inline final RESIZE_UPDATE_TIMEOUT_MS= 1000;
        static inline final SCALE_UPDATE_TIMEOUT_MS= 1000;
        static inline final ZOOM_ANIMATION_BASE_FRAME_MS= 16.666666666666668;
        static inline final ROOM_ZOOM_EPSILON= 0.001;
        static inline final ROOM_ZOOM_SCROLL_COOLDOWN_MS= 400;
        static inline final ROOM_ZOOM_SCROLL_MOUSE_DELTA_BYPASS_THRESHOLD= 2;
        static final ROOM_ZOOM_SCALES:Array<ASAny> = [0.5, 1, 2, 4, 8, 16];

        var _events:EventDispatcherWrapper;
        var _windowManager:IHabboWindowManager = null;
        var _roomEngine:IRoomEngine = null;
        var _roomWidgetFactory:IRoomWidgetFactory = null;
        var _sessionDataManager:ISessionDataManager = null;
        var _roomSessionManager:IRoomSessionManager = null;
        var _communicationManager:IHabboCommunicationManager = null;
        var _avatarRenderManager:IAvatarRenderManager = null;
        var _friendList:IHabboFriendsList = null;
        var _inventory:IHabboInventory = null;
        var _toolbar:IHabboToolbar = null;
        var _navigator:IHabboNavigator = null;
        var _messenger:IHabboMessenger = null;
        var _habboGroupsManager:IHabboGroupsManager = null;
        var _avatarEditor:IHabboAvatarEditor = null;
        var _catalog:IHabboCatalog = null;
        var _adManager:IAdManager = null;
        var _localization:IHabboLocalizationManager = null;
        var _habboHelp:IHabboHelp = null;
        var _connection:IConnection = null;
        var _moderation:IHabboModeration;
        var _config:IHabboConfigurationManager;
        var _soundManager:IHabboSoundManager;
        var _habboTracking:IHabboTracking;
        var _userDefinedRoomEvents:IHabboUserDefinedRoomEvents;
        var _gameManager:IHabboGameManager;
        var _questEngine:IHabboQuestEngine;
        var _freeFlowChat:IHabboFreeFlowChat;
        var _assets:IAssetLibrary = null;
        var _session:IRoomSession = null;
        var _canvasIDs:Array<ASAny>;
        var _widgets:Map;
        var _widgetHandlerMessageMap:Map;
        var _widgetHandlerEventMap:Map;
        var _updateListeners:Array<ASAny>;
        var _layoutManager:DesktopLayoutManager;
        var _roomCanvasWrapper:IDisplayObjectWrapper;
        var _loadingComplete:Bool = true;
        var _pendingResources:Array<ASAny>;
        var _roomAdTooltip:IToolTipWindow;
        var _roomColor:UInt = 0xFFFFFF;
        var _zoomTrackingEnabled:Bool = false;
        var _zoomChangedMillis:Int = 0;
        var _roomBackgroundColor:UInt = 0;
        var _resizeTimer:Timer;
        var _roomViewContainerRect:Rectangle;
        var _botSkillListUpdateMessageEvent:IMessageEvent;
        var _botForceOpenContextMenuMessageEvent:IMessageEvent;
        var _pivot:Point;
        var _targetRoomCanvasScale:Float = Math.NaN;
        var _scaleFactor:Float = 0;
        var _lastZoomScrollMillis:Int = 0;
        var _androidRoomGestures:AndroidRoomGestureController;

        public function new(k:IRoomSession, _arg_2:IAssetLibrary, _arg_3:IConnection)
        {
            this._canvasIDs = [];
            this._events = new EventDispatcherWrapper();
            this._session = k;
            this._assets = _arg_2;
            this._connection = _arg_3;
            this._botSkillListUpdateMessageEvent = new BotSkillListUpdateEvent(this.onBotSkillListUpdateEvent);
            this._connection.addMessageEvent(this._botSkillListUpdateMessageEvent);
            this._botForceOpenContextMenuMessageEvent = new BotForceOpenContextMenuEvent(this.onBotForceOpenContextMenuEvent);
            this._connection.addMessageEvent(this._botForceOpenContextMenuMessageEvent);
            this._widgets = new Map();
            this._widgetHandlerMessageMap = new Map();
            this._widgetHandlerEventMap = new Map();
            this._layoutManager = new DesktopLayoutManager();
            this.checkInterrupts();
        }

        public var visible(never,set):Bool;
public function  set_visible(k:Bool):Bool        {
            if (this._roomCanvasWrapper != null)
            {
                this._roomCanvasWrapper.visible = k;
            }
return k;
        }

        public var roomSession(get,never):IRoomSession;
public function  get_roomSession():IRoomSession
        {
            return this._session;
        }

        
        public var sessionDataManager(get,set):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var events(get,never):IEventDispatcher;
public function  get_events():IEventDispatcher
        {
            return this._events;
        }

        
        public var roomEngine(get,set):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }

        
        public var roomSessionManager(get,set):IRoomSessionManager;
public function  get_roomSessionManager():IRoomSessionManager
        {
            return this._roomSessionManager;
        }

        
        public var friendList(get,set):IHabboFriendsList;
public function  get_friendList():IHabboFriendsList
        {
            return this._friendList;
        }

        
        public var avatarRenderManager(get,set):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._avatarRenderManager;
        }

        
        public var inventory(get,set):IHabboInventory;
public function  get_inventory():IHabboInventory
        {
            return ((this._inventory != null) && (!this._inventory.disposed)) ? this._inventory : null;
        }

        
        public var toolbar(get,set):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }

        
        public var roomWidgetFactory(get,set):IRoomWidgetFactory;
public function  get_roomWidgetFactory():IRoomWidgetFactory
        {
            return this._roomWidgetFactory;
        }

        
        public var navigator(get,set):IHabboNavigator;
public function  get_navigator():IHabboNavigator
        {
            return this._navigator;
        }

        
        public var habboGroupsManager(get,set):IHabboGroupsManager;
public function  get_habboGroupsManager():IHabboGroupsManager
        {
            return this._habboGroupsManager;
        }

        
        public var communicationManager(get,set):IHabboCommunicationManager;
public function  get_communicationManager():IHabboCommunicationManager
        {
            return this._communicationManager;
        }

        
        public var avatarEditor(get,set):IHabboAvatarEditor;
public function  get_avatarEditor():IHabboAvatarEditor
        {
            return this._avatarEditor;
        }

        
        public var catalog(get,set):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        
        public var localization(get,set):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        
        public var habboHelp(get,set):IHabboHelp;
public function  get_habboHelp():IHabboHelp
        {
            return this._habboHelp;
        }

        
        public var config(get,set):IHabboConfigurationManager;
public function  get_config():IHabboConfigurationManager
        {
            return this._config;
        }

        
        public var soundManager(get,set):IHabboSoundManager;
public function  get_soundManager():IHabboSoundManager
        {
            return this._soundManager;
        }

        
        public var messenger(get,set):IHabboMessenger;
public function  get_messenger():IHabboMessenger
        {
            return this._messenger;
        }

        
        public var moderation(get,set):IHabboModeration;
public function  get_moderation():IHabboModeration
        {
            return this._moderation;
        }

        
        public var windowManager(get,set):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        
        public var habboTracking(get,set):IHabboTracking;
public function  get_habboTracking():IHabboTracking
        {
            return this._habboTracking;
        }

        public var session(get,never):IRoomSession;
public function  get_session():IRoomSession
        {
            return this._session;
        }

        
        public var gameManager(get,set):IHabboGameManager;
public function  get_gameManager():IHabboGameManager
        {
            return this._gameManager;
        }

        
        public var questEngine(get,set):IHabboQuestEngine;
public function  get_questEngine():IHabboQuestEngine
        {
            return this._questEngine;
        }

        
        public var freeFlowChat(get,set):IHabboFreeFlowChat;
public function  get_freeFlowChat():IHabboFreeFlowChat
        {
            return this._freeFlowChat;
        }

        public var roomBackgroundColor(get,never):UInt;
public function  get_roomBackgroundColor():UInt
        {
            return this._roomBackgroundColor;
        }
public function  set_catalog(k:IHabboCatalog):IHabboCatalog        {
            return this._catalog = k;
        }
public function  set_avatarEditor(k:IHabboAvatarEditor):IHabboAvatarEditor        {
            return this._avatarEditor = k;
        }
public function  set_roomWidgetFactory(k:IRoomWidgetFactory):IRoomWidgetFactory        {
            return this._roomWidgetFactory = k;
        }
public function  set_sessionDataManager(k:ISessionDataManager):ISessionDataManager        {
            return this._sessionDataManager = k;
        }
public function  set_roomSessionManager(k:IRoomSessionManager):IRoomSessionManager        {
            this._roomSessionManager = k;
            this.checkInterrupts();
return k;
        }
public function  set_communicationManager(k:IHabboCommunicationManager):IHabboCommunicationManager        {
            return this._communicationManager = k;
        }

        
        public var userDefinedRoomEvents(get,set):IHabboUserDefinedRoomEvents;
public function  get_userDefinedRoomEvents():IHabboUserDefinedRoomEvents
        {
            return this._userDefinedRoomEvents;
        }

        public var connection(get,never):IConnection;
public function  get_connection():IConnection
        {
            return this._connection;
        }
public function  set_friendList(k:IHabboFriendsList):IHabboFriendsList        {
            this._friendList = k;
            if (this._friendList != null)
            {
                this._friendList.events.addEventListener(_Str_2948.FRE_ACCEPTED, this.processEvent);
                this._friendList.events.addEventListener(_Str_2948.FRE_DECLINED, this.processEvent);
            }
return k;
        }
public function  set_avatarRenderManager(k:IAvatarRenderManager):IAvatarRenderManager        {
            return this._avatarRenderManager = k;
        }
public function  set_windowManager(k:IHabboWindowManager):IHabboWindowManager        {
            return this._windowManager = k;
        }
public function  set_inventory(k:IHabboInventory):IHabboInventory        {
            return this._inventory = k;
        }
public function  set_navigator(k:IHabboNavigator):IHabboNavigator        {
            return this._navigator = k;
        }

        public var adManager(never,set):IAdManager;
public function  set_adManager(k:IAdManager):IAdManager        {
            return this._adManager = k;
        }
public function  set_localization(k:IHabboLocalizationManager):IHabboLocalizationManager        {
            return this._localization = k;
        }
public function  set_habboHelp(k:IHabboHelp):IHabboHelp        {
            return this._habboHelp = k;
        }
public function  set_moderation(k:IHabboModeration):IHabboModeration        {
            return this._moderation = k;
        }
public function  set_config(k:IHabboConfigurationManager):IHabboConfigurationManager        {
            return this._config = k;
        }
public function  set_soundManager(k:IHabboSoundManager):IHabboSoundManager        {
            return this._soundManager = k;
        }
public function  set_habboTracking(k:IHabboTracking):IHabboTracking        {
            return this._habboTracking = k;
        }
public function  set_userDefinedRoomEvents(k:IHabboUserDefinedRoomEvents):IHabboUserDefinedRoomEvents        {
            return this._userDefinedRoomEvents = k;
        }
public function  set_gameManager(k:IHabboGameManager):IHabboGameManager        {
            return this._gameManager = k;
        }
public function  set_questEngine(k:IHabboQuestEngine):IHabboQuestEngine        {
            return this._questEngine = k;
        }
public function  set_freeFlowChat(k:IHabboFreeFlowChat):IHabboFreeFlowChat        {
            return this._freeFlowChat = k;
        }
public function  set_habboGroupsManager(k:IHabboGroupsManager):IHabboGroupsManager        {
            return this._habboGroupsManager = k;
        }
public function  set_roomEngine(k:IRoomEngine):IRoomEngine        {
            this._roomEngine = k;
            if (((!(this._roomEngine == null)) && (!(this._roomEngine.events == null))))
            {
                this._roomEngine.events.addEventListener(RoomContentLoadedEvent.RCLE_SUCCESS, this.onRoomContentLoaded);
                this._roomEngine.events.addEventListener(RoomContentLoadedEvent.RCLE_FAILURE, this.onRoomContentLoaded);
                this._roomEngine.events.addEventListener(RoomContentLoadedEvent.RCLE_CANCEL, this.onRoomContentLoaded);
            }
return k;
        }
public function  set_messenger(k:IHabboMessenger):IHabboMessenger        {
            return this._messenger = k;
        }
public function  set_toolbar(k:IHabboToolbar):IHabboToolbar        {
            this._toolbar = k;
            this._toolbar.events.addEventListener(HabboToolbarEvent.HTIE_ICON_ZOOM, this.onToolbarEvent);
return k;
        }

        public var layout(never,set):com.sulake.core.utils.xml.XML;
public function  set_layout(k:com.sulake.core.utils.xml.XML):com.sulake.core.utils.xml.XML        {
            this._layoutManager.setLayout(k, this._windowManager, this._config);
return k;
        }

        public function dispose()
        {
            var _local_2:IRoomGeometry = null;
            var _local_3 = 0;
            var _local_4:String = null;
            var _local_5:IRoomWidget = null;
            if (this._androidRoomGestures != null)
            {
                this._androidRoomGestures.dispose();
                this._androidRoomGestures = null;
            }
            if (((!(this._roomEngine == null)) && (!(this._session == null))))
            {
                _local_2 = this._roomEngine.getRoomCanvasGeometry(this._session.roomId, this.getFirstCanvasId());
                if (_local_2 != null)
                {
                    this.trackZooming(_local_2.isZoomedIn(), false);
                }
            }
            var k = 0;
            if (this._canvasIDs != null)
            {
                k = 0;
                while (k < this._canvasIDs.length)
                {
                    _local_3 = ASCompat.toInt(this._canvasIDs[k]);
                    _local_4 = this.getWindowName(_local_3);
                    if (this._windowManager != null)
                    {
                        this._windowManager.removeWindow(_local_4);
                    }
                    k++;
                }
            }
            this._updateListeners = null;
            if (this._widgets != null)
            {
                k = 0;
                while ((k : UInt) < this._widgets.length)
                {
                    _local_5 = ASCompat.dynamicAs(this._widgets.getWithIndex(k) , IRoomWidget);
                    if (_local_5 != null)
                    {
                        _local_5.dispose();
                    }
                    k++;
                }
                this._widgets.dispose();
                this._widgets = null;
            }
            if (this._widgetHandlerMessageMap != null)
            {
                this._widgetHandlerMessageMap.dispose();
                this._widgetHandlerMessageMap = null;
            }
            if (this._widgetHandlerEventMap != null)
            {
                this._widgetHandlerEventMap.dispose();
                this._widgetHandlerEventMap = null;
            }
            if (this._connection != null)
            {
                if (this._botSkillListUpdateMessageEvent != null)
                {
                    this._connection.removeMessageEvent(this._botSkillListUpdateMessageEvent);
                    this._botSkillListUpdateMessageEvent.dispose();
                    this._botSkillListUpdateMessageEvent = null;
                }
                if (this._botForceOpenContextMenuMessageEvent != null)
                {
                    this._connection.removeMessageEvent(this._botForceOpenContextMenuMessageEvent);
                    this._botForceOpenContextMenuMessageEvent.dispose();
                    this._botForceOpenContextMenuMessageEvent = null;
                }
                this._connection = null;
            }
            this._assets = null;
            this._avatarRenderManager = null;
            this._canvasIDs = null;
            this._events = null;
            if (((this._friendList != null) && (this._friendList.events != null)))
            {
                this._friendList.events.removeEventListener(_Str_2948.FRE_ACCEPTED, this.processEvent);
                this._friendList.events.removeEventListener(_Str_2948.FRE_DECLINED, this.processEvent);
            }
            this._friendList = null;
            this._layoutManager.dispose();
            this._layoutManager = null;
            if (((!(this._roomEngine == null)) && (!(this._roomEngine.events == null))))
            {
                this._roomEngine.events.removeEventListener(RoomContentLoadedEvent.RCLE_SUCCESS, this.onRoomContentLoaded);
                this._roomEngine.events.removeEventListener(RoomContentLoadedEvent.RCLE_FAILURE, this.onRoomContentLoaded);
                this._roomEngine.events.removeEventListener(RoomContentLoadedEvent.RCLE_CANCEL, this.onRoomContentLoaded);
            }
            this._roomEngine = null;
            this._roomSessionManager = null;
            this._roomWidgetFactory = null;
            this._session = null;
            this._sessionDataManager = null;
            this._windowManager = null;
            this._inventory = null;
            this._localization = null;
            this._config = null;
            this._soundManager = null;
            this._habboGroupsManager = null;
            if (((this._toolbar != null) && (this.toolbar.events != null)))
            {
                this._toolbar.events.removeEventListener(HabboToolbarEvent.HTIE_ICON_ZOOM, this.onToolbarEvent);
                this._toolbar = null;
            }
            this._navigator = null;
            if (this._roomAdTooltip != null)
            {
                this._roomAdTooltip.dispose();
                this._roomAdTooltip = null;
            }
            if (this._resizeTimer != null)
            {
                this._resizeTimer.reset();
                this._resizeTimer.removeEventListener(TimerEvent.TIMER, (this.onResizeTimerEvent : ASAny));
                this._resizeTimer = null;
            }
            this._roomViewContainerRect = null;
        }

        function onBotSkillListUpdateEvent(k:BotSkillListUpdateEvent)
        {
            var _local_3:RoomUserData = null;
            var _local_2= k.getParser();
            if (this._session != null)
            {
                _local_3 = this._session.userDataManager._Str_17237(_local_2.botId);
                _local_3.botSkillData = k.getParser().skillList.copy();
            }
            this.events.dispatchEvent(new _Str_5375(_local_2.botId, _local_2.skillList));
        }

        function onBotForceOpenContextMenuEvent(k:BotForceOpenContextMenuEvent)
        {
            var _local_2= k.getParser();
            this.events.dispatchEvent(new RoomWidgetRentableBotForceOpenContextMenuEvent(_local_2.botId));
        }

        public function init()
        {
            if (((!(this._roomEngine == null)) && (!(this._session == null))))
            {
                this._pendingResources = this._roomEngine.loadRoomResources(this._session.roomResources);
                if (this._pendingResources.length > 0)
                {
                    this._loadingComplete = false;
                    this.processEvent(new RoomWidgetLoadingBarUpdateEvent(RoomWidgetLoadingBarUpdateEvent.RWLBUE_SHOW_LOADING_BAR));
                }
            }
        }

        public function requestInterstitial()
        {
            if (this._adManager != null)
            {
                this._adManager.showInterstitial();
            }
        }

        function onRoomContentLoaded(k:RoomContentLoadedEvent)
        {
            if (((this._pendingResources == null) || (this._pendingResources.length == 0)))
            {
                return;
            }
            var _local_2= this._pendingResources.indexOf(k.contentType);
            if (_local_2 != -1)
            {
                this._pendingResources.splice(_local_2, 1);
            }
            if (this._pendingResources.length == 0)
            {
                this._loadingComplete = true;
                this.checkInterrupts();
            }
        }

        public function createWidget(k:String)
        {
            var _local_3 = false;
            var widgetHandler:IRoomWidgetHandler = null;
            var _local_5:ChatWidgetHandler = null;
            var _local_6:PlayListEditorWidgetHandler = null;
            var _local_7:SpamWallPostItWidgetHandler = null;
            var _local_8:FurnitureContextMenuWidgetHandler = null;
            var _local_9:FurnitureRoomLinkHandler = null;
            var _local_10:RoomToolsWidgetHandler = null;
            var _local_11:Array<ASAny> = null;
            var _local_12:Array<ASAny> = null;
            var _local_13:Array<ASAny> = null;
            var _local_14:String = null;
            var _local_15:String = null;
            var _local_16:_Str_3040 = null;
            if (this._roomWidgetFactory == null)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(this._widgets.getValue(k) , IRoomWidget);
            if (_local_2 != null)
            {
                return;
            }
            if ((this._session.isGameSession && (!this.isGameWidget(k))))
            {
                return;
            }
            switch (k)
            {
                case RoomWidgetEnum.CHAT_WIDGET:
                    _local_5 = new ChatWidgetHandler();
                    _local_5.connection = this._connection;
                    widgetHandler = _local_5;
                    _local_3 = true;
                    
                case RoomWidgetEnum.INFOSTAND:
                    widgetHandler = new InfoStandWidgetHandler(this._soundManager.musicController);
                    
                case RoomWidgetEnum.CHAT_INPUT_WIDGET:
                    _local_3 = true;
                    widgetHandler = new ChatInputWidgetHandler();
                    
                case RoomWidgetEnum.ME_MENU:
                    widgetHandler = new MeMenuWidgetHandler();
                    
                case RoomWidgetEnum.FURNI_PLACEHOLDER:
                    widgetHandler = new PlaceholderWidgetHandler();
                    
                case RoomWidgetEnum.FURNI_CREDIT_WIDGET:
                    widgetHandler = new FurnitureCreditWidgetHandler();
                    
                case RoomWidgetEnum.FURNI_STICKIE_WIDGET:
                    widgetHandler = new FurnitureStickieWidgetHandler();
                    
                case RoomWidgetEnum.FURNI_PRESENT_WIDGET:
                    widgetHandler = new FurniturePresentWidgetHandler();
                    
                case RoomWidgetEnum.FURNI_TROPHY_WIDGET:
                    widgetHandler = new FurnitureTrophyWidgetHandler();
                    
                case RoomWidgetEnum.FURNI_ECOTRONBOX_WIDGET:
                    widgetHandler = new FurnitureEcotronBoxWidgetHandler();
                    
                case RoomWidgetEnum.FURNI_PET_PACKAGE_WIDGET:
                    widgetHandler = new PetPackageFurniWidgetHandler();
                    
                case RoomWidgetEnum.DOORBELL:
                    widgetHandler = new DoorbellWidgetHandler();
                    
                case RoomWidgetEnum.ROOM_QUEUE:
                    widgetHandler = new RoomQueueWidgetHandler();
                    
                case RoomWidgetEnum.LOADINGBAR:
                    widgetHandler = new LoadingBarWidgetHandler();
                    
                case RoomWidgetEnum.ROOM_POLL:
                    widgetHandler = new PollWidgetHandler();
                    
				case RoomWidgetEnum.ROOM_VOTE:
					widgetHandler = new VotePollWidgetHandler();
					
                case RoomWidgetEnum.WORD_QUIZZ:
                    widgetHandler = new WordQuizWidgetHandler();
                    
                case RoomWidgetEnum.FURNI_CHOOSER:
                    widgetHandler = new FurniChooserWidgetHandler();
                    
                case RoomWidgetEnum.USER_CHOOSER:
                    widgetHandler = new UserChooserWidgetHandler();
                    
                case RoomWidgetEnum.ROOM_DIMMER:
                    widgetHandler = new FurnitureDimmerWidgetHandler();
                    
                case RoomWidgetEnum.FRIEND_REQUEST:
                    widgetHandler = new FriendRequestWidgetHandler();
                    
                case RoomWidgetEnum.CLOTHING_CHANGE:
                    widgetHandler = new FurnitureClothingChangeWidgetHandler();
                    
                case RoomWidgetEnum.CONVERSION_TRACKING:
                    widgetHandler = new ConversionPointWidgetHandler();
                    
                case RoomWidgetEnum.AVATAR_INFO:
                    widgetHandler = new AvatarInfoWidgetHandler();
                    
                case RoomWidgetEnum.WELCOME_GIFT:
                    widgetHandler = new WelcomeGiftWidgetHandler();
                    
                case RoomWidgetEnum.PLAYLIST_EDITOR_WIDGET:
                    _local_6 = new PlayListEditorWidgetHandler();
                    _local_6.connection = this._connection;
                    widgetHandler = _local_6 ;
                    
                case RoomWidgetEnum.SPAMWALL_POSTIT_WIDGET:
                    _local_7 = new SpamWallPostItWidgetHandler();
                    _local_7.connection = this._connection;
                    widgetHandler = _local_7 ;
                    
                case RoomWidgetEnum.EFFECTS:
                    widgetHandler = new EffectsWidgetHandler();
                    
                case RoomWidgetEnum.MANNEQUIN:
                    widgetHandler = new MannequinWidgetHandler();
                    
                case RoomWidgetEnum.FURNITURE_CONTEXT_MENU:
                    _local_8 = new FurnitureContextMenuWidgetHandler();
                    _local_8.connection = this._connection;
                    widgetHandler = _local_8 ;
                    
                case RoomWidgetEnum.LOCATION_WIDGET:
                    widgetHandler = new ObjectLocationRequestHandler();
                    
                case RoomWidgetEnum.CAMERA:
                    widgetHandler = new CameraWidgetHandler(this);
                    
                case RoomWidgetEnum.ROOM_BACKGROUND_COLOR:
                    widgetHandler = new FurnitureBackgroundColorWidgetHandler();
                    
                case RoomWidgetEnum.AREA_HIDE:
                    widgetHandler = new FurnitureAreaHideWidgetHandler();
                    
                case RoomWidgetEnum.CUSTOM_USER_NOTIFICATION:
                    widgetHandler = new CustomUserNotificationWidgetHandler();
                    
                case RoomWidgetEnum.FURNI_ACHIEVEMENT_RESOLUTION_ENGRAVING:
                    widgetHandler = new FurnitureAchievementResolutionEngraving();
                    
                case RoomWidgetEnum.FRIEND_FURNI_CONFIRM:
                    widgetHandler = new FriendFurniConfirmWidgetHandler();
                    cast(widgetHandler, FriendFurniConfirmWidgetHandler).connection = this.connection;
                    
                case RoomWidgetEnum.FRIEND_FURNI_ENGRAVING:
                    widgetHandler = new FriendFurniEngravingWidgetHandler();
                    
                case RoomWidgetEnum.HIGH_SCORE_DISPLAY:
                    widgetHandler = new HighScoreFurniWidgetHandler();
                    
                case RoomWidgetEnum.GAMEHALL_BOARD:
                    widgetHandler = new GamehallWidgetHandler();
                    
                case RoomWidgetEnum.LEADERBOARD:
                    widgetHandler = new LeaderboardWidgetHandler();
                    
                case RoomWidgetEnum.INTERNAL_LINK:
                    widgetHandler = new FurnitureInternalLinkHandler();
                    
                case RoomWidgetEnum.ROOM_LINK:
                    _local_9 = new FurnitureRoomLinkHandler();
                    _local_9.communicationManager = this._communicationManager;
                    widgetHandler = _local_9;
                    
                case RoomWidgetEnum.CUSTOM_STACK_HEIGHT:
                    widgetHandler = new FurnitureCustomStackHeightWidgetHandler();
                    
                case RoomWidgetEnum.YOUTUBE:
                    widgetHandler = new FurnitureYoutubeDisplayWidgetHandler();
                    
                case RoomWidgetEnum.RENTABLESPACE:
                    widgetHandler = new FurnitureRentableSpaceWidgetHandler();
                    
                case RoomWidgetEnum.VIMEO:
                    widgetHandler = new FurnitureVimeoDisplayWidgetHandler();
                    
                case RoomWidgetEnum.ROOM_TOOLS:
                    _local_10 = new RoomToolsWidgetHandler();
                    _local_10.communicationManager = this._communicationManager;
                    _local_10.navigator = this._navigator;
                    widgetHandler = _local_10;
                    
                case RoomWidgetEnum.EXTERNAL_IMAGE:
                    widgetHandler = new ExternalImageWidgetHandler();
                    
                case RoomWidgetEnum.UI_HELP_BUBBLE:
                    widgetHandler = new UiHelpBubbleWidgetHandler();
                    
                case RoomWidgetEnum.ROOM_THUMBNAIL_CAMERA:
                    widgetHandler = new RoomThumbnailCameraWidgetHandler(this);
                    
                case RoomWidgetEnum.CRAFTING:
                    widgetHandler = new CraftingWidgetHandler(this);
                    
            }
            if (widgetHandler != null)
            {
                widgetHandler.container = this;
                _local_11 = null;
                _local_12 = widgetHandler.getWidgetMessages();
                if (_local_12 != null)
                {
                    if (checkNullIteratee(_local_12)) for (_tmp_ in _local_12)
                    {
_local_14  = _tmp_;
                        _local_11 = this._widgetHandlerMessageMap.getValue(_local_14);
                        if (_local_11 == null)
                        {
                            _local_11 = [];
                            this._widgetHandlerMessageMap.add(_local_14, _local_11);
                        }
                        else
                        {
                            Logger.log([(("Room widget message '" + _local_14) + "' handled by more than one widget message handler, could cause problems. Be careful!")]);
                        }
                        _local_11.push(widgetHandler);
                    }
                }
                _local_13 = widgetHandler.getProcessedEvents();
                if (_local_13 != null)
                {
                    _local_13.push(RoomEngineTriggerWidgetEvent.OPEN_WIDGET);
                    _local_13.push(RoomEngineTriggerWidgetEvent.CLOSE_WIDGET);
                    if (checkNullIteratee(_local_13)) for (_tmp_ in _local_13)
                    {
_local_15  = _tmp_;
                        _local_11 = this._widgetHandlerEventMap.getValue(_local_15);
                        if (_local_11 == null)
                        {
                            _local_11 = [];
                            this._widgetHandlerEventMap.add(_local_15, _local_11);
                        }
                        _local_11.push(widgetHandler);
                    }
                }
            }
            _local_2 = this._roomWidgetFactory.createWidget(k, widgetHandler);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.messageListener = this;
            _local_2.registerUpdateEvents(this._events);
            if (!this._widgets.add(k, _local_2))
            {
                _local_2.dispose();
            }
            else
            {
                this._layoutManager.addWidgetWindow(k, _local_2.mainWindow);
            }
            if (_local_3)
            {
                k = _Str_3040.RWRVUE_ROOM_VIEW_SIZE_CHANGED;
                _local_16 = new _Str_3040(k, this._layoutManager.roomViewRect);
                this.events.dispatchEvent(_local_16);
            }
        }

        function isGameWidget(k:String):Bool
        {
            switch (k)
            {
                case RoomWidgetEnum.CHAT_INPUT_WIDGET
                   | RoomWidgetEnum.CHAT_WIDGET
                   | RoomWidgetEnum.AVATAR_INFO
                   | RoomWidgetEnum.LOCATION_WIDGET
                   | RoomWidgetEnum.GAMEHALL_BOARD
                   | RoomWidgetEnum.LEADERBOARD:
                    return true;
                default:
                    return false;
            }
        }

        public function disposeWidget(k:String)
        {
            var _local_2:IRoomWidget = null;
            if (this._widgets != null)
            {
                _local_2 = this._widgets.remove(k);
                if (_local_2 != null)
                {
                    if (this._layoutManager != null)
                    {
                        this._layoutManager.removeWidgetWindow(k, _local_2.mainWindow);
                    }
                    _local_2.dispose();
                }
            }
        }

        public function getWidget(k:String):IRoomWidget
        {
            var _local_2:IRoomWidget = null;
            if (this._widgets != null)
            {
                _local_2 = this._widgets.getValue(k);
            }
            return _local_2;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_3:IRoomWidgetHandler = null;
            var _local_4:RoomWidgetUpdateEvent = null;
            if (k == null)
            {
                return null;
            }
            if (k.type == RoomWidgetZoomToggleMessage.RWZTM_ZOOM_TOGGLE)
            {
                this.toggleZoom();
            }
            var _local_2:Array<ASAny> = this._widgetHandlerMessageMap.getValue(k.type);
            if (_local_2 != null)
            {
                if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                {
_local_3  = _tmp_;
                    _local_4 = _local_3.processWidgetMessage(k);
                    if (_local_4 != null)
                    {
                        return _local_4;
                    }
                }
            }
            return null;
        }

        public function processEvent(k:Event)
        {
            var _local_3:IRoomWidgetHandler = null;
            var _local_4 = false;
            var _local_5:RoomEngineTriggerWidgetEvent = null;
            if (((!(k != null)) || (!(this._widgetHandlerEventMap != null))))
            {
                return;
            }
            if (((this._roomCanvasWrapper != null) && (k.type == _Str_9973.RDMZEE_ENABLED)))
            {
                this.checkAndEnableMouseZoomEvent(this._roomCanvasWrapper.getDisplayObject());
            }
            var _local_2:Array<ASAny> = this._widgetHandlerEventMap.getValue(k.type);
            if (_local_2 != null)
            {
                if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                {
_local_3  = _tmp_;
                    _local_4 = true;
                    if (((k.type == RoomEngineTriggerWidgetEvent.OPEN_WIDGET) || (k.type == RoomEngineTriggerWidgetEvent.CLOSE_WIDGET)))
                    {
                        _local_5 = Std.downcast(k , RoomEngineTriggerWidgetEvent);
                        _local_4 = ((!(_local_5 == null)) && (_local_3.type == _local_5.widget));
                    }
                    if (k.type == RoomWidgetZoomToggleMessage.RWZTM_ZOOM_TOGGLE)
                    {
                        this.toggleZoom();
                    }
                    if (_local_4)
                    {
                        _local_3.processEvent(k);
                    }
                }
            }
        }

        function isFurnitureSelectionDisabled(k:RoomEngineObjectEvent):Bool
        {
            var _local_4:IRoomObjectModel = null;
            var _local_2 = false;
            var _local_3= this.roomEngine.getRoomObject(k.roomId, k.objectId, k.category);
            if (_local_3 != null)
            {
                _local_4 = _local_3.getModel();
                if (_local_4 != null)
                {
                    if (_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_SELECTION_DISABLE) == 1)
                    {
                        _local_2 = true;
                        if (this._sessionDataManager.isAnyRoomController)
                        {
                            _local_2 = false;
                        }
                    }
                }
            }
            return _local_2;
        }

        public function roomObjectEventHandler(k:RoomEngineObjectEvent)
        {
            var _local_6:String = null;
            var _local_7:IRoomObject = null;
            var _local_8:RoomUserData = null;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11 = false;
            var _local_12 = 0;
            if (k == null)
            {
                return;
            }
            var _local_2= k.objectId;
            var _local_3= k.category;
            var _local_4:RoomWidgetRoomObjectUpdateEvent = null;
            var _local_5:RoomWidgetFurniToWidgetMessage = null;
            switch (k.type)
            {
                case RoomEngineObjectEvent.SELECTED:
                    if (!this.isFurnitureSelectionDisabled(k))
                    {
                        _local_4 = new RoomWidgetRoomObjectUpdateEvent(RoomWidgetRoomObjectUpdateEvent.OBJECT_SELECTED, _local_2, _local_3, k.roomId);
                    }
                    if (((!(this._moderation == null)) && (_local_3 == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)))
                    {
                        _local_8 = this._session.userDataManager.getUserDataByIndex(_local_2);
                        if (((!(_local_8 == null)) && (_local_8.type == RoomObjectTypeEnum.HABBO)))
                        {
                            this._moderation.userSelected(_local_8.id, _local_8.name);
                        }
                    }
                    
                case RoomEngineObjectEvent.ADDED:
                    switch (_local_3)
                    {
                        case RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                           | RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM:
                            _local_6 = RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED;
                            
                        case RoomObjectCategoryEnum.OBJECT_CATEGORY_USER:
                            _local_6 = RoomWidgetRoomObjectUpdateEvent.USER_ADDED;
                            
                    }
                    if (_local_6 != null)
                    {
                        _local_4 = new RoomWidgetRoomObjectUpdateEvent(_local_6, _local_2, _local_3, k.roomId);
                    }
                    
                case RoomEngineObjectEvent.REMOVED:
                    switch (_local_3)
                    {
                        case RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                           | RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM:
                            _local_6 = RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED;
                            
                        case RoomObjectCategoryEnum.OBJECT_CATEGORY_USER:
                            _local_6 = RoomWidgetRoomObjectUpdateEvent.USER_REMOVED;
                            
                    }
                    if (_local_6 != null)
                    {
                        _local_4 = new RoomWidgetRoomObjectUpdateEvent(_local_6, _local_2, _local_3, k.roomId);
                    }
                    
                case RoomEngineObjectEvent.PLACED:
                    _local_4 = new RoomWidgetRoomObjectPlaceEvent(RoomWidgetRoomObjectPlaceEvent.OBJECT_PLACED, _local_2, _local_3, k.roomId, cast(k, RoomEngineObjectPlacedEvent)._Str_7031, cast(k, RoomEngineObjectPlacedEvent).x, cast(k, RoomEngineObjectPlacedEvent).y, cast(k, RoomEngineObjectPlacedEvent).z, cast(k, RoomEngineObjectPlacedEvent).direction, cast(k, RoomEngineObjectPlacedEvent).isPlacedInRoom, cast(k, RoomEngineObjectPlacedEvent).placedOnFloor, cast(k, RoomEngineObjectPlacedEvent).placedOnWall, cast(k, RoomEngineObjectPlacedEvent)._Str_4766, cast(k, RoomEngineObjectPlacedEvent).placementSource);
                    
                case RoomEngineObjectEvent.DESELECTED:
                    _local_4 = new RoomWidgetRoomObjectUpdateEvent(RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED, _local_2, _local_3, k.roomId);
                    
                case RoomEngineObjectEvent.MOUSE_ENTER:
                    _local_4 = new RoomWidgetRoomObjectUpdateEvent(RoomWidgetRoomObjectUpdateEvent.OBJECT_ROLL_OVER, _local_2, _local_3, k.roomId);
                    
                case RoomEngineObjectEvent.MOUSE_LEAVE:
                    _local_4 = new RoomWidgetRoomObjectUpdateEvent(RoomWidgetRoomObjectUpdateEvent.OBJECT_ROLL_OUT, _local_2, _local_3, k.roomId);
                    
                case RoomEngineObjectEvent.REQUEST_MOVE:
                    if (this.checkFurniManipulationRights(k.roomId, k.objectId, k.category))
                    {
                        this._roomEngine.modifyRoomObject(k.objectId, k.category, RoomObjectOperationEnum.OBJECT_MOVE);
                    }
                    
                case RoomEngineObjectEvent.REQUEST_ROTATE:
                    if (this.checkFurniManipulationRights(k.roomId, k.objectId, k.category))
                    {
                        this._roomEngine.modifyRoomObject(k.objectId, k.category, RoomObjectOperationEnum.OBJECT_ROTATE_POSITIVE);
                    }
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_CREDITFURNI:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_CREDITFURNI, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_STICKIE:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_STICKIE, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_PRESENT:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_PRESENT, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_TROPHY:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_TROPHY, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_TEASER:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_TEASER, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ECOTRONBOX:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_ECOTRONBOX, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_DIMMER:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_DIMMER, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_PLACEHOLDER:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_PLACEHOLDER, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineRoomAdEvent.FURNI_CLICK
                   | RoomEngineRoomAdEvent.FURNI_DOUBLE_CLICK:
                    this.handleRoomAdClick(k);
                    
                case RoomEngineRoomAdEvent.TOOLTIP_SHOW
                   | RoomEngineRoomAdEvent.TOOLTIP_HIDE:
                    this.handleRoomAdTooltip(k);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_CLOTHING_CHANGE:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_CLOTHING_CHANGE, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_PLAYLIST_EDITOR:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_PLAYLIST_EDITOR, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_BADGE_DISPLAY_ENGRAVING:
                    _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_BADGE_DISPLAY_ENGRAVING, _local_2, _local_3, k.roomId);
                    this.processWidgetMessage(_local_5);
                    
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ACHIEVEMENT_RESOLUTION_FAILED:
                    _local_7 = this._roomEngine.getRoomObject(k.roomId, k.objectId, k.category);
                    if (_local_7 != null)
                    {
                        _local_9 = Std.int(_local_7.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_OWNER_ID));
                        _local_10 = this._sessionDataManager.userId;
                        if (_local_9 == _local_10)
                        {
                            _local_5 = new RoomWidgetFurniToWidgetMessage(RoomWidgetFurniToWidgetMessage.RWFWM_WIDGET_MESSAGE_REQUEST_ACHIEVEMENT_RESOLUTION_FAILED, _local_2, _local_3, k.roomId);
                            this.processWidgetMessage(_local_5);
                        }
                    }
                    
                case RoomEngineTriggerWidgetEvent.OPEN_WIDGET
                   | RoomEngineTriggerWidgetEvent.CLOSE_WIDGET
                   | RoomEngineTriggerWidgetEvent.RETWE_OPEN_FURNI_CONTEXT_MENU
                   | RoomEngineTriggerWidgetEvent.RETWE_CLOSE_FURNI_CONTEXT_MENU
                   | RoomEngineTriggerWidgetEvent.RETWE_REMOVE_DIMMER
                   | RoomObjectSoundMachineEvent.JUKEBOX_DISPOSE
                   | RoomEngineTriggerWidgetEvent.RETWE_REQUEST_MANNEQUIN
                   | RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_INVENTORY
                   | RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_ROOM
                   | RoomEngineTriggerWidgetEvent.RETWE_REQUEST_BACKGROUND_COLOR
                   | RoomEngineTriggerWidgetEvent.RETWE_REQUEST_AREA_HIDE
                   | RoomEngineAreaHideStateWidgetEvent.UPDATE_STATE_AREA_HIDE
                   | RoomEngineTriggerWidgetEvent.RETWE_REQUEST_FRIEND_FURNITURE_ENGRAVING
                   | RoomEngineTriggerWidgetEvent.RETWE_REQUEST_HIGH_SCORE_DISPLAY
                   | RoomEngineTriggerWidgetEvent.RETWE_REQUEST_HIDE_HIGH_SCORE_DISPLAY
                   | RoomEngineGamehallEvent.OPEN
                   | RoomEngineGamehallEvent.UPDATE
                   | RoomEngineGamehallEvent.CLOSE
                   | RoomEngineLeaderboardEvent.OPEN
                   | RoomEngineTriggerWidgetEvent.RETWE_REQUEST_INTERNAL_LINK
                   | RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ROOM_LINK:
                    this.processEvent(k);
                    
            }
            if (_local_4 != null)
            {
                _local_11 = true;
                if (Std.is(_local_4 , RoomWidgetRoomObjectUpdateEvent))
                {
                    _local_12 = _local_4 .roomId;
                    _local_11 = (!RoomId.isRoomPreviewerId(_local_12));
                }
                else
                {
                    if (Std.is(_local_4 , _Str_3345))
                    {
                        _local_12 = ASCompat.reinterpretAs(_local_4 , _Str_3345).roomId;
                        _local_11 = (!RoomId.isRoomPreviewerId(_local_12));
                    }
                }
                if (_local_11)
                {
                    this.events.dispatchEvent(_local_4);
                }
            }
        }

        function checkFurniManipulationRights(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            return ((this._session.roomControllerLevel >= RoomControllerLevel.GUEST)
                || this._sessionDataManager.isAnyRoomController
                || this.isOwnerOfFurniture(
                    this._roomEngine.getRoomObject(k, _arg_2, _arg_3))
                || this._roomEngine.activeRoomHasFreeFurniMovementsMode);
        }

        public function roomEngineEventHandler(k:RoomEngineEvent)
        {
            var _local_2:RoomWidgetUpdateEvent = null;
            switch (k.type)
            {
                case RoomEngineEvent.NORMAL_MODE:
                    _local_2 = new _Str_3345(_Str_3345.RWREUE_NORMAL_MODE, k.roomId);
                    
                case RoomEngineEvent.GAME_MODE:
                    _local_2 = new _Str_3345(_Str_3345.RWREUE_GAME_MODE, k.roomId);
                    
            }
            if (_local_2 != null)
            {
                this.events.dispatchEvent(_local_2);
            }
        }

        public function createRoomView(k:Int)
        {
            var _local_14 = Math.NaN;
            var _local_15 = Math.NaN;
            var _local_16 = Math.NaN;
            var _local_17 = Math.NaN;
            var _local_18 = Math.NaN;
            var _local_19 = Math.NaN;
            var _local_20 = Math.NaN;
            var _local_21 = Math.NaN;
            var _local_22:IWindow = null;
            var _local_2= this._layoutManager.roomViewRect;
            var _local_3= Std.int(_local_2.width);
            var _local_4= Std.int(_local_2.height);
            var _local_5= Std.int(this._session.isGameSession ? Std.int(RoomGeometry.SCALE_ZOOMED_OUT ): Std.int(RoomGeometry.SCALE_ZOOMED_IN));
            if (this._canvasIDs.indexOf(k) >= 0)
            {
                return;
            }
            if ((((this._session == null) || (this._windowManager == null)) || (this._roomEngine == null)))
            {
                return;
            }
            var _local_6= this._roomEngine.createRoomCanvas(this._session.roomId, k, _local_3, _local_4, _local_5);
            if (_local_6 == null)
            {
                return;
            }
            var _local_7= Std.downcast(this._roomEngine.getRoomCanvasGeometry(this._session.roomId, k) , RoomGeometry);
            if (_local_7 != null)
            {
                _local_14 = this._roomEngine.getRoomNumberValue(this._session.roomId, RoomVariableEnum.ROOM_MIN_X);
                _local_15 = this._roomEngine.getRoomNumberValue(this._session.roomId, RoomVariableEnum.ROOM_MAX_X);
                _local_16 = this._roomEngine.getRoomNumberValue(this._session.roomId, RoomVariableEnum.ROOM_MIN_Y);
                _local_17 = this._roomEngine.getRoomNumberValue(this._session.roomId, RoomVariableEnum.ROOM_MAX_Y);
                _local_18 = ((_local_14 + _local_15) / 2);
                _local_19 = ((_local_16 + _local_17) / 2);
                _local_20 = 20;
                _local_18 = (_local_18 + (_local_20 - 1));
                _local_19 = (_local_19 + (_local_20 - 1));
                _local_21 = (Math.sqrt(((_local_20 * _local_20) + (_local_20 * _local_20))) * Math.tan(((30 / 180) * Math.PI)));
                _local_7.location = new Vector3d(_local_18, _local_19, _local_21);
            }
            var _local_8= Std.downcast(this._assets.getAssetByName("room_view_container_xml") , XmlAsset);
            if (_local_8 == null)
            {
                return;
            }
            var _local_9= Std.downcast(this._windowManager.buildFromXML(((_local_8.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (_local_9 == null)
            {
                return;
            }
            _local_9.width = _local_3;
            _local_9.height = _local_4;
            this._roomCanvasWrapper = Std.downcast(_local_9.findChildByName("room_canvas_wrapper") , IDisplayObjectWrapper);
            if (this._roomCanvasWrapper == null)
            {
                return;
            }
            this._roomCanvasWrapper.setDisplayObject(_local_6);
            if (this._session.isGameSession)
            {
                _local_6.addEventListener(MouseEvent.CLICK, (this.mouseEventHandler : ASAny));
            }
            this.checkAndEnableMouseZoomEvent(_local_6);
            this._roomCanvasWrapper.addEventListener(WindowMouseEvent.CLICK, this.canvasMouseHandler);
            this._roomCanvasWrapper.addEventListener(WindowMouseEvent.DOUBLE_CLICK, this.canvasMouseHandler);
            this._roomCanvasWrapper.addEventListener(WindowMouseEvent.MOVE, this.canvasMouseHandler);
            this._roomCanvasWrapper.addEventListener(WindowMouseEvent.DOWN, this.canvasMouseHandler);
            this._roomCanvasWrapper.addEventListener(WindowMouseEvent.UP, this.canvasMouseHandler);
            this._roomCanvasWrapper.addEventListener(WindowMouseEvent.UP_OUTSIDE, this.canvasMouseHandler);
            this._roomCanvasWrapper.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onRoomViewResized);
            var _local_10= new Sprite();
            _local_10.mouseEnabled = false;
            _local_10.blendMode = BlendMode.MULTIPLY;
            var _local_11= Std.downcast(_local_9.findChildByName("colorizer_wrapper") , IDisplayObjectWrapper);
            if (_local_11 == null)
            {
                return;
            }
            _local_11.setDisplayObject(_local_10);
            _local_11.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.resizeColorizer);
            var _local_12= new Sprite();
			_local_12.alpha = 1;
            _local_12.mouseEnabled = false;
            var _local_13= Std.downcast(_local_9.findChildByName("background_wrapper") , IDisplayObjectWrapper);
            if (_local_13 == null)
            {
                return;
            }
            _local_13.setDisplayObject(_local_12);
            _local_13.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.resizeBackgroundColorizer);
            if (this._session.isSpectatorMode)
            {
                _local_22 = this.getSpectatorModeVisualization();
                if (_local_22 != null)
                {
                    _local_22.width = _local_9.width;
                    _local_22.height = _local_9.height;
                    _local_9.addChild(_local_22);
                }
            }
            this._layoutManager.addRoomView(_local_9);
            this._androidRoomGestures = AndroidRoomGestureController.create(this._roomCanvasWrapper, this.onRoomZoomGesture);
            this._canvasIDs.push(k);
            #if html5
            skyhaxe.CmsBridge.ready();
            #end
        }

        function checkAndEnableMouseZoomEvent(k:DisplayObject)
        {
            if (k != null)
            {
                k.removeEventListener(MouseEvent.MOUSE_WHEEL, (this.mouseWheelHandler : ASAny));
            }
            if (this._roomCanvasWrapper == null)
            {
                return;
            }
            this._roomCanvasWrapper.removeEventListener(WindowMouseEvent.WHEEL, this.mouseWheelHandler);
            this._roomCanvasWrapper.addEventListener(WindowMouseEvent.WHEEL, this.mouseWheelHandler);
        }

        public function initCameraLocation(k:Int)
        {
            var _local_2= this._roomEngine.getRoomNumberValue(this._session.roomId, RoomVariableEnum.CAMERA_INIT_X);
            var _local_3= this._roomEngine.getRoomNumberValue(this._session.roomId, RoomVariableEnum.CAMERA_INIT_Y);
            var _local_4= this._roomEngine.getRoomNumberValue(this._session.roomId, RoomVariableEnum.CAMERA_INIT_Z);
            if (((!Math.isNaN(_local_2)) && (!Math.isNaN(_local_3)) && (!Math.isNaN(_local_4))))
            {
                this._roomEngine.runUpdate();
                this._roomEngine.updateRoomCamera(this._session.roomId, k, new Vector3d(_local_2, _local_3, _local_4), 1);
            }
        }

        function mouseWheelHandler(k:WindowMouseEvent)
        {
            var _local_2:Point = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = Math.NaN;
            var _local_8 = Math.NaN;
            if (((k.ctrlKey && (!k.altKey)) && (!k.shiftKey)))
            {
                if (k.delta == 0)
                {
                    return;
                }
                _local_5 = flash.Lib.getTimer();
                _local_6 = ((k.delta < 0) ? -1 : 1);
                if (!this.shouldProcessZoomScroll(k.delta, _local_5))
                {
                    k.preventDefault();
                    return;
                }
                _local_2 = new Point();
                this._roomCanvasWrapper.getGlobalPosition(_local_2);
                _local_3 = Std.int(k.stageX - _local_2.x);
                _local_4 = Std.int(k.stageY - _local_2.y);
                this._pivot = new Point(_local_3, _local_4);
                _local_7 = this.getCurrentRoomCanvasZoomScale();
                _local_8 = this.getNextZoomScale(_local_7, _local_6);
                if (Math.abs((_local_8 - _local_7)) <= ROOM_ZOOM_EPSILON)
                {
                    k.preventDefault();
                    return;
                }
                this.animateRoomCanvasScale(_local_8, this._pivot);
                this.markZoomScroll(_local_5);
                k.preventDefault();
            }
        }

        function onRoomZoomGesture(direction:Int, pivot:Point)
        {
            var currentScale = Math.NaN;
            var nextScale = Math.NaN;
            if (((this._session == null) || (this._roomEngine == null)) || (direction == 0))
            {
                return;
            }
            currentScale = this.getCurrentRoomCanvasZoomScale();
            nextScale = this.getNextZoomScale(currentScale, direction);
            if (Math.abs((nextScale - currentScale)) > ROOM_ZOOM_EPSILON)
            {
                this.animateRoomCanvasScale(nextScale, pivot);
            }
        }

        function shouldProcessZoomScroll(k:Int, _arg_2:Int):Bool
        {
            if (Math.abs(k) >= ROOM_ZOOM_SCROLL_MOUSE_DELTA_BYPASS_THRESHOLD)
            {
                return true;
            }
            return ((this._lastZoomScrollMillis <= 0) || ((_arg_2 - this._lastZoomScrollMillis) > ROOM_ZOOM_SCROLL_COOLDOWN_MS));
        }

        function markZoomScroll(k:Int)
        {
            this._lastZoomScrollMillis = k;
        }

        function resizeColorizer(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.target , IDisplayObjectWrapper);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(_local_2.getDisplayObject() , Sprite);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.graphics.clear();
            _local_3.graphics.beginFill(this._roomColor);
            _local_3.graphics.drawRect(0, 0, _local_2.width, _local_2.height);
            _local_3.graphics.endFill();
        }

        function resizeBackgroundColorizer(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.target , IDisplayObjectWrapper);
            if (_local_2 == null)
            {
                return;
            }
            this.fillBackgroundColorizer(_local_2);
        }

        function fillBackgroundColorizer(k:IDisplayObjectWrapper)
        {
            var _local_2= Std.downcast(k.getDisplayObject() , Sprite);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.graphics.clear();
            _local_2.graphics.beginFill(this._roomBackgroundColor);
            _local_2.graphics.drawRect(0, 0, k.width, k.height);
            _local_2.graphics.endFill();
        }

        public function setRoomViewColor(k:UInt, _arg_2:Int)
        {
            var _local_3= Std.downcast(this._layoutManager.getRoomView() , IWindowContainer);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= Std.downcast(_local_3.getChildByName("colorizer_wrapper") , IDisplayObjectWrapper);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= Std.downcast(_local_4.getDisplayObject() , Sprite);
            if (_local_5 == null)
            {
                return;
            }
            var _local_6= ColorConverter.rgbToHSL(ASCompat.toInt(k));
            _local_6 = ((_local_6 & 0xFFFF00) + _arg_2);
            k = ColorConverter.hslToRGB(_local_6);
            this._roomColor = k;
            _local_5.graphics.clear();
            _local_5.graphics.beginFill(k);
            _local_5.graphics.drawRect(0, 0, _local_4.width, _local_4.height);
            _local_5.graphics.endFill();
        }

        public function setRoomBackgroundColor(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._roomBackgroundColor = ColorConverter.hslToRGB(((((k & 0xFF) << 16) + ((_arg_2 & 0xFF) << 8)) + (_arg_3 & 0xFF)));
            var _local_4= Std.downcast(this._layoutManager.getRoomView() , IWindowContainer);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= Std.downcast(_local_4.getChildByName("background_wrapper") , IDisplayObjectWrapper);
            if (_local_5 == null)
            {
                return;
            }
            if ((((k == 0) && (_arg_2 == 0)) && (_arg_3 == 0)))
            {
                _local_5.visible = false;
            }
            else
            {
                _local_5.visible = true;
                this.fillBackgroundColorizer(_local_5);
            }
        }

        public function getFirstCanvasId():Int
        {
            if (this._canvasIDs != null)
            {
                if (this._canvasIDs.length > 0)
                {
                    return ASCompat.toInt(this._canvasIDs[0]);
                }
            }
            return 0;
        }

        public function getRoomViewRect():Rectangle
        {
            if (this._layoutManager == null)
            {
                return null;
            }
            return this._layoutManager.roomViewRect;
        }

        public function addListenerToStage(k:String, _arg_2:ASFunction)
        {
            if ((((!(this._roomCanvasWrapper != null)) || (!(this._roomCanvasWrapper.getDisplayObject() != null))) || (!(this._roomCanvasWrapper.getDisplayObject().stage != null))))
            {
                return;
            }
            this._roomCanvasWrapper.getDisplayObject().stage.addEventListener(k, (_arg_2 : ASAny), false, 0, true);
        }

        public function removeListenerFromStage(k:String, _arg_2:ASFunction)
        {
            if ((((!(this._roomCanvasWrapper != null)) || (!(this._roomCanvasWrapper.getDisplayObject() != null))) || (!(this._roomCanvasWrapper.getDisplayObject().stage != null))))
            {
                return;
            }
            this._roomCanvasWrapper.getDisplayObject().stage.removeEventListener(k, (_arg_2 : ASAny));
        }

        public function canvasMouseHandler(k:WindowEvent)
        {
            var _local_5:Point = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:Point = null;
            if (((this._roomEngine == null) || (this._session == null)))
            {
                return;
            }
            var _local_2= Std.downcast(k , WindowMouseEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= "";
            switch (_local_2.type)
            {
                case WindowMouseEvent.CLICK:
                    _local_3 = MouseEvent.CLICK;
                    
                case WindowMouseEvent.DOUBLE_CLICK:
                    _local_3 = MouseEvent.DOUBLE_CLICK;
                    
                case WindowMouseEvent.DOWN:
                    _local_3 = MouseEvent.MOUSE_DOWN;
                    
                case WindowMouseEvent.UP
                   | WindowMouseEvent.UP_OUTSIDE:
                    _local_3 = MouseEvent.MOUSE_UP;
                    
                case WindowMouseEvent.MOVE:
                    _local_3 = MouseEvent.MOUSE_MOVE;
                    
                default:
                    return;
            }
            var _local_4= Std.downcast(_local_2.target , IDisplayObjectWrapper);
            if ((_local_4 : ASAny) == (_local_2.target : ASAny))
            {
                _local_5 = new Point();
                _local_4.getGlobalPosition(_local_5);
                _local_6 = Std.int(_local_2.stageX - _local_5.x);
                _local_7 = Std.int(_local_2.stageY - _local_5.y);
                this._roomEngine.setActiveRoom(this._session.roomId);
                this._roomEngine.handleRoomCanvasMouseEvent(ASCompat.toInt(this._canvasIDs[0]), _local_6, _local_7, _local_3, _local_2.altKey, _local_2.ctrlKey, _local_2.shiftKey, _local_2.buttonDown);
            }
            if (((_local_3 == MouseEvent.MOUSE_MOVE) && (!(this._roomAdTooltip == null))))
            {
                _local_8 = new Point(_local_2.stageX, _local_2.stageY);
                _local_8.offset((-this._roomAdTooltip.width / 2), 15);
                this._roomAdTooltip.setGlobalPosition(_local_8);
            }
        }

        function mouseEventHandler(k:MouseEvent)
        {
            var _local_2= new Point();
            this._roomCanvasWrapper.getGlobalPosition(_local_2);
            // Raw MouseEvent coordinates are stage-space; the wrapper position is desktop-space.
            var _local_5= this._roomCanvasWrapper.desktop.getDisplayObject().globalToLocal(new Point(k.stageX, k.stageY));
            var _local_3= Std.int(_local_5.x - _local_2.x);
            var _local_4= Std.int(_local_5.y - _local_2.y);
            this._roomEngine.setActiveRoom(this._session.roomId);
            k.stopImmediatePropagation();
            this._roomEngine.handleRoomCanvasMouseEvent(ASCompat.toInt(this._canvasIDs[0]), _local_3, _local_4, k.type, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown);
        }

        function onRoomViewResized(k:WindowEvent)
        {
            var _local_2= k.window;
            this._roomViewContainerRect = _local_2.rectangle;
            this._roomEngine.modifyRoomCanvas(this._session.roomId, ASCompat.toInt(this._canvasIDs[0]), _local_2.width, _local_2.height);
            if (this._resizeTimer == null)
            {
                this._resizeTimer = new Timer(RESIZE_UPDATE_TIMEOUT_MS, 1);
                this._resizeTimer.addEventListener(TimerEvent.TIMER, (this.onResizeTimerEvent : ASAny));
            }
            else
            {
                this._resizeTimer.reset();
            }
            this._resizeTimer.start();
        }

        function onResizeTimerEvent(k:TimerEvent)
        {
            var _local_2= _Str_3040.RWRVUE_ROOM_VIEW_SIZE_CHANGED;
            this.events.dispatchEvent(new _Str_3040(_local_2, this._roomViewContainerRect));
        }

        function trackZooming(k:Bool, _arg_2:Bool)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            if (this._zoomTrackingEnabled)
            {
                _local_3 = flash.Lib.getTimer();
                _local_4 = Std.int(Math.fround(((_local_3 - this._zoomChangedMillis) / 1000)));
                if (this._habboTracking != null)
                {
                    if (k)
                    {
                        if (_arg_2)
                        {
                            this._habboTracking.trackGoogle("zoomEvent", "out");
                        }
                        this._habboTracking.trackGoogle("zoomEnded", "in", _local_4);
                    }
                    else
                    {
                        if (_arg_2)
                        {
                            this._habboTracking.trackGoogle("zoomEvent", "in");
                        }
                        this._habboTracking.trackGoogle("zoomEnded", "out", _local_4);
                    }
                }
                this._zoomChangedMillis = _local_3;
            }
        }

        function onToolbarEvent(k:HabboToolbarEvent)
        {
            if (k.type == HabboToolbarEvent.HTIE_ICON_ZOOM)
            {
                this.toggleZoom();
            }
        }

        function toggleZoom()
        {
            var k = Math.NaN;
            var _local_2 = Math.NaN;
            var _local_3:IRoomGeometry = null;
            if (this._session != null)
            {
                if (ASCompat.reinterpretAs(this._roomEngine , Component).getBoolean("zoom.enabled"))
                {
                    k = this.getCurrentRoomCanvasZoomScale();
                    _local_2 = ((k == 1) ? 0.5 : 1);
                    this.animateRoomCanvasScale(_local_2);
                }
                else
                {
                    _local_3 = this._roomEngine.getRoomCanvasGeometry(this._session.roomId, this.getFirstCanvasId());
                    if (_local_3 != null)
                    {
                        this.trackZooming(_local_3.isZoomedIn(), true);
                        _local_3.performZoom();
                    }
                }
            }
        }

        public function update(k:UInt=0)
        {
            var _local_4:IRoomWidgetHandler = null;
            var _local_5 = Math.NaN;
            var _local_6 = Math.NaN;
            var _local_7 = Math.NaN;
            var _local_8 = Math.NaN;
            var _local_9 = Math.NaN;
            if (!Math.isNaN(this._targetRoomCanvasScale))
            {
                _local_5 = this._roomEngine.getRoomCanvasScale(this._session.roomId, this.getFirstCanvasId());
                _local_6 = this.scaleToZoomAnimationValue(_local_5);
                _local_7 = this.scaleToZoomAnimationValue(this._targetRoomCanvasScale);
                _local_8 = (_local_7 - _local_6);
                if (Math.abs(_local_8) <= 0.01)
                {
                    this._roomEngine.setRoomCanvasScale(this._session.roomId, this.getFirstCanvasId(), this._targetRoomCanvasScale, this._pivot, null, false, true);
                    this._targetRoomCanvasScale = Math.NaN;
                }
                else
                {
                    _local_9 = this.getZoomAnimationStep(_local_6, _local_7, k);
                    _local_6 = (_local_6 + ((_local_8 < 0) ? -Math.min(_local_9, -_local_8) : Math.min(_local_9, _local_8)));
                    this._roomEngine.setRoomCanvasScale(this._session.roomId, this.getFirstCanvasId(), this.zoomLevelToScale(_local_6), this._pivot, null, false, true);
                }
            }
            if (this._updateListeners == null)
            {
                return;
            }
            var _local_2= this._updateListeners.length;
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = ASCompat.dynamicAs(this._updateListeners[_local_3] , IRoomWidgetHandler);
                if (_local_4 != null)
                {
                    _local_4.update();
                }
                _local_3++;
            }
        }

        public function animateRoomCanvasScale(k:Float, _arg_2:Point=null)
        {
            if (((((this._session == null) || (this._roomEngine == null)) || Math.isNaN(k)) || !ASCompat.reinterpretAs(this._roomEngine , Component).getBoolean("zoom.enabled")))
            {
                return;
            }
            this._targetRoomCanvasScale = this.clampRoomCanvasZoomScale(k);
            this._pivot = _arg_2;
        }

        public function getCurrentRoomCanvasZoomScale():Float
        {
            var k= this.getCurrentControllableRoomCanvasScale();
            return (Math.isNaN(k) ? 1 : this.getNearestZoomScale(k));
        }

        public function canZoomRoomCanvas(k:Int):Bool
        {
            var _local_2 = Math.NaN;
            if (((!this.canUseAnimatedRoomZoom()) || (k == 0)))
            {
                return false;
            }
            _local_2 = this.getCurrentRoomCanvasZoomScale();
            return Math.abs((this.getNextZoomScale(_local_2, k) - _local_2)) > ROOM_ZOOM_EPSILON;
        }

        public function zoomRoomCanvas(k:Int)
        {
            var _local_2 = Math.NaN;
            var _local_3 = Math.NaN;
            if (((!this.canUseAnimatedRoomZoom()) || (k == 0)))
            {
                return;
            }
            _local_2 = this.getCurrentRoomCanvasZoomScale();
            _local_3 = this.getNextZoomScale(_local_2, k);
            if (Math.abs((_local_3 - _local_2)) <= ROOM_ZOOM_EPSILON)
            {
                return;
            }
            this.animateRoomCanvasScale(_local_3);
        }

        function getNextZoomScale(k:Float, _arg_2:Int):Float
        {
            var _local_3 = 0;
            if ((Math.isNaN(k) || (_arg_2 == 0)))
            {
                return k;
            }
            if (_arg_2 > 0)
            {
                if (k >= (ASCompat.toNumber(ROOM_ZOOM_SCALES[(ROOM_ZOOM_SCALES.length - 1)]) - ROOM_ZOOM_EPSILON))
                {
                    return k;
                }
                _local_3 = 0;
                while (_local_3 < ROOM_ZOOM_SCALES.length)
                {
                    if (ROOM_ZOOM_SCALES[_local_3] > (k + ROOM_ZOOM_EPSILON))
                    {
                        return ASCompat.toNumber(ROOM_ZOOM_SCALES[_local_3]);
                    }
                    _local_3++;
                }
                return ASCompat.toNumber(ROOM_ZOOM_SCALES[(ROOM_ZOOM_SCALES.length - 1)]);
            }
            if (k <= (ROOM_ZOOM_SCALES[0] + ROOM_ZOOM_EPSILON))
            {
                return k;
            }
            _local_3 = (ROOM_ZOOM_SCALES.length - 1);
            while (_local_3 >= 0)
            {
                if (ROOM_ZOOM_SCALES[_local_3] < (k - ROOM_ZOOM_EPSILON))
                {
                    return ASCompat.toNumber(ROOM_ZOOM_SCALES[_local_3]);
                }
                _local_3--;
            }
            return ASCompat.toNumber(ROOM_ZOOM_SCALES[0]);
        }

        function canUseAnimatedRoomZoom():Bool
        {
            return (((!(this._session == null)) && (!(this._roomEngine == null))) && ASCompat.reinterpretAs(this._roomEngine , Component).getBoolean("zoom.enabled"));
        }

        function getCurrentControllableRoomCanvasScale():Float
        {
            if (!this.canUseAnimatedRoomZoom())
            {
                return Math.NaN;
            }
            return (!Math.isNaN(this._targetRoomCanvasScale) ? this._targetRoomCanvasScale : this._roomEngine.getRoomCanvasScale(this._session.roomId, this.getFirstCanvasId()));
        }

        function clampRoomCanvasZoomScale(k:Float):Float
        {
            return Math.max(ASCompat.toNumber(ROOM_ZOOM_SCALES[0]), Math.min(ASCompat.toNumber(ROOM_ZOOM_SCALES[(ROOM_ZOOM_SCALES.length - 1)]), k));
        }

        function getNearestZoomScale(k:Float):Float
        {
            var _local_4 = Math.NaN;
            var _local_2= ASCompat.toNumber(ROOM_ZOOM_SCALES[0]);
            var _local_3= Math.abs((k - _local_2));
            final _iter_ = ROOM_ZOOM_SCALES; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = ASCompat.toNumber(_tmp_);
                if (Math.abs((k - _local_4)) < _local_3)
                {
                    _local_2 = _local_4;
                    _local_3 = Math.abs((k - _local_4));
                }
            }
            return _local_2;
        }

        function getZoomAnimationStep(k:Float, _arg_2:Float, _arg_3:UInt):Float
        {
            var _local_4= Math.abs((_arg_2 - k));
            var _local_5= ((_arg_3 > 0) ? Math.min(_arg_3, 50) : ZOOM_ANIMATION_BASE_FRAME_MS);
            return Math.min(_local_4, ((0.14 * _local_5) / ZOOM_ANIMATION_BASE_FRAME_MS));
        }

        function scaleToZoomAnimationValue(k:Float):Float
        {
            return Math.log(k) / 0.6931471805599453;
        }

        function zoomLevelToScale(k:Float):Float
        {
            return Math.pow(2, k);
        }

        function getWindowName(k:Int):String
        {
            return "Room_Engine_Window_" + Std.string(k);
        }

        function createFilter(k:Int, _arg_2:Int):Array<ASAny>
        {
            var _local_3= new BlurFilter(2, 2);
            return [];
        }

        function getBitmapFilter(k:Int, _arg_2:Int):BitmapFilter
        {
            var _local_3= new BitmapData(k, _arg_2);
            _local_3.perlinNoise(k, _arg_2, 5, Std.int(Math.random() * 0x77359400), true, false);
            var _local_4= new Point(0, 0);
            var _local_5= BitmapDataChannel.RED;
            var _local_6= _local_5;
            var _local_7= _local_5;
            var _local_8= (k / 20);
            var _local_9= (-k / 25);
            var _local_10= DisplacementMapFilterMode.COLOR;
            var _local_11:UInt = 0;
            var _local_12:Float = 0;
            return new DisplacementMapFilter(_local_3, _local_4, _local_6, _local_7, _local_8, _local_9, _local_10, _local_11, _local_12);
        }

        function checkInterrupts():Bool
        {
            if ((((!(this._roomSessionManager == null)) && (!(this._session == null))) && this._loadingComplete))
            {
                this._roomSessionManager.startSession(this._session);
                this.processEvent(new RoomWidgetLoadingBarUpdateEvent(RoomWidgetLoadingBarUpdateEvent.RWLBUW_HIDE_LOADING_BAR));
                return true;
            }
            return false;
        }

        function handleRoomAdClick(k:RoomEngineObjectEvent)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= this._roomEngine.getRoomObject(k.roomId, k.objectId, k.category);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.getModel() ;
            var _local_4= _local_3.getString(RoomObjectVariableEnum.FURNITURE_AD_URL);
            if (((_local_4 == null) || (!(_local_4.indexOf("http") == 0))))
            {
                return;
            }
            switch (k.type)
            {
                case RoomEngineRoomAdEvent.FURNI_CLICK:
                    if (((this._session.roomControllerLevel >= RoomControllerLevel.GUEST) || this._sessionDataManager.isAnyRoomController))
                    {
                        return;
                    }
                    HabboWebTools.openWebPage(_local_4);
                    return;
                case RoomEngineRoomAdEvent.FURNI_DOUBLE_CLICK:
                    if (((ASCompat.toNumber((!(this._session.roomControllerLevel != 0)) )>= RoomControllerLevel.GUEST) && (!this._sessionDataManager.isAnyRoomController)))
                    {
                        return;
                    }
                    HabboWebTools.openWebPage(_local_4);
                    return;
            }
        }

        function handleRoomAdTooltip(k:RoomEngineObjectEvent)
        {
            var _local_2:IRoomObject = null;
            var _local_3:String = null;
            var _local_4:IRoomObjectModel = null;
            var _local_5:String = null;
            if (k == null)
            {
                return;
            }
            switch (k.type)
            {
                case RoomEngineRoomAdEvent.TOOLTIP_SHOW:
                    if (this._roomAdTooltip != null)
                    {
                        return;
                    }
                    _local_2 = this._roomEngine.getRoomObject(k.roomId, k.objectId, k.category);
                    if (_local_2 == null)
                    {
                        return;
                    }
                    _local_3 = this._localization.getLocalization((_local_2.getType() + ".tooltip"), "${ads.roomad.tooltip}");
                    if (_local_3 == null)
                    {
                        _local_4 = _local_2.getModel() ;
                        _local_5 = _local_4.getString(RoomObjectVariableEnum.FURNITURE_AD_URL);
                        if (((!(_local_5 == null)) && (_local_5.indexOf("http") == 0)))
                        {
                            _local_3 = _local_5;
                        }
                    }
                    if (_local_3 == null)
                    {
                        return;
                    }
                    this._roomAdTooltip = Std.downcast(this._windowManager.createWindow("room_ad_tooltip", _local_3, WindowType.WINDOW_TYPE_TOOLTIP, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_BOUND_TO_PARENT_RECT) , IToolTipWindow);
                    this._roomAdTooltip.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, false);
                    this._roomAdTooltip.visible = true;
                    this._roomAdTooltip.center();
                    return;
                case RoomEngineRoomAdEvent.TOOLTIP_HIDE:
                    if (this._roomAdTooltip == null)
                    {
                        return;
                    }
                    this._roomAdTooltip.dispose();
                    this._roomAdTooltip = null;
                    return;
            }
        }

        /** Builds the reusable client-side television surround used by spectator rooms. */
        public function getSpectatorModeVisualization():IWindow
        {
            var k= Std.downcast(this._assets.getAssetByName("spectator_mode_xml") , XmlAsset);
            if (k == null)
            {
                return null;
            }
            var _local_2= Std.downcast(this._windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (_local_2 == null)
            {
                return null;
            }
            this.setBitmap(_local_2.findChildByName("top_left"), "spec_top_left_png");
            this.setBitmap(_local_2.findChildByName("top_middle"), "spec_top_middle_png");
            this.setBitmap(_local_2.findChildByName("top_right"), "spec_top_right_png");
            this.setBitmap(_local_2.findChildByName("middle_left"), "spec_middle_left_png");
            this.setBitmap(_local_2.findChildByName("middle_right"), "spec_middle_right_png");
            this.setBitmap(_local_2.findChildByName("bottom_left"), "spec_bottom_left_png");
            this.setBitmap(_local_2.findChildByName("bottom_middle"), "spec_bottom_middle_png");
            this.setBitmap(_local_2.findChildByName("bottom_right"), "spec_bottom_right_png");
            return _local_2;
        }

        function setBitmap(k:IWindow, _arg_2:String)
        {
            var _local_3= Std.downcast(k , IBitmapWrapperWindow);
            if (((_local_3 == null) || (this._assets == null)))
            {
                return;
            }
            var _local_4= Std.downcast(this._assets.getAssetByName(_arg_2) , BitmapDataAsset);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= ASCompat.dynamicAs(_local_4.content , BitmapData);
            if (_local_5 == null)
            {
                return;
            }
            _local_3.bitmap = _local_5.clone();
        }

        public function initializeWidget(k:String, _arg_2:Int=0)
        {
            var _local_3:IRoomWidget = this._widgets.getValue(k);
            if (_local_3 == null)
            {
                Logger.log([("Tried to initialize an unknown widget " + k)]);
                return;
            }
            _local_3.initialize(_arg_2);
        }

        public function getWidgetState(k:String):Int
        {
            var _local_2:IRoomWidget = this._widgets.getValue(k);
            if (_local_2 == null)
            {
                Logger.log([("Requested the state of an unknown widget " + k)]);
                return STATE_UNDEFINED;
            }
            return _local_2.state;
        }

        public function addUpdateListener(k:IRoomWidgetHandler)
        {
            if (this._updateListeners == null)
            {
                this._updateListeners = new Array<ASAny>();
            }
            if (this._updateListeners.indexOf(k) == -1)
            {
                this._updateListeners.push(k);
            }
        }

        public function removeUpdateListener(k:IRoomWidgetHandler)
        {
            if (this._updateListeners == null)
            {
                return;
            }
            var _local_2= this._updateListeners.indexOf(k);
            if (_local_2 != -1)
            {
                this._updateListeners.splice(_local_2, 1);
            }
        }

        public function isOwnerOfFurniture(k:IRoomObject):Bool
        {
            var _local_2= this.sessionDataManager.userId;
            var _local_3= k.getModel();
            if (_local_3 == null)
            {
                return false;
            }
            var _local_4= _local_3.getNumber(RoomObjectVariableEnum.FURNITURE_OWNER_ID);
            return _local_4 == _local_2;
        }

        public function getFurnitureOwnerId(k:IRoomObject):Int
        {
            var _local_3 = Math.NaN;
            var _local_2= k.getModel();
            if (_local_2 != null)
            {
                _local_3 = _local_2.getNumber(RoomObjectVariableEnum.FURNITURE_OWNER_ID);
                if (!Math.isNaN(_local_3))
                {
                    return Std.int(_local_3);
                }
            }
            return -1;
        }

        public function isOwnerOfPet(k:RoomUserData):Bool
        {
            if (k == null)
            {
                return false;
            }
            var _local_2= this.sessionDataManager.userId;
            return _local_2 == k.ownerId;
        }

        public function showGamePlayerName(k:Int, _arg_2:String, _arg_3:UInt, _arg_4:Int)
        {
            var _local_5= ASCompat.dynamicAs(this._widgets.getValue(RoomWidgetEnum.AVATAR_INFO), AvatarInfoWidget);
            if (_local_5 == null)
            {
                return;
            }
            _local_5.showGamePlayerName(k, _arg_2, _arg_3, _arg_4);
        }

        public function hideAvatarInfo()
        {
            var widget= ASCompat.dynamicAs(this._widgets.getValue(RoomWidgetEnum.AVATAR_INFO), AvatarInfoWidget);
            if (widget != null) widget.hideAllAvatarInfo();
        }

        public var layoutManager(get,never):DesktopLayoutManager;
public function  get_layoutManager():DesktopLayoutManager
        {
            return this._layoutManager;
        }

        public function mouseEventPositionHasInputEventWindow(k:MouseEvent, _arg_2:Int):Bool
        {
            var _local_3= ASCompat.allocArray(0);
            var _local_4= new Point(k.stageX, k.stageY);
            this._windowManager.getDesktop(_arg_2).groupParameterFilteredChildrenUnderPoint(_local_4, _local_3, WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR);
            return _local_3.length > 1;
        }
    }

