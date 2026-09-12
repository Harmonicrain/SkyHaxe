package com.sulake.habbo.tracking
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.room.IRoomEngine;
    import flash.utils.Timer;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.utils.ErrorReportStorage;
    import flash.external.ExternalInterface;
    import flash.system.Capabilities;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import flash.events.Event;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.habbo.window._enum._Str_5209;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.habbo.navigator.events.HabboNavigatorTrackingEvent;
    import com.sulake.habbo.navigator.events.HabboRoomSettingsTrackingEvent;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.habbo.catalog.navigation.events.CatalogPageOpenedEvent;
    import com.sulake.habbo.catalog._enum.HabboCatalogTrackingEvent;
    import com.sulake.habbo.catalog.navigation.events.CatalogFurniPurchaseEvent;
    import com.sulake.iid.IIDHabboInventory;
    import com.sulake.habbo.inventory.events.HabboInventoryTrackingEvent;
    import com.sulake.iid.IIDHabboFriendList;
    import com.sulake.habbo.friendlist.events._Str_3797;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.habbo.help._enum.HabboHelpTrackingEvent;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.habbo.room.events.RoomObjectRoomAdEvent;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.iid.IIDHabboAdManager;
    import com.sulake.habbo.advertisement.events.AdEvent;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.communication.messages.incoming.handshake.AuthenticationOKMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.HabboAchievementNotificationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.tracking.LatencyPingResponseMessageEvent;
    import com.sulake.habbo.communication._enum.HabboCommunicationEvent;
    import com.sulake.habbo.communication._enum.HabboHotelViewEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.runtime.events.ErrorEvent;
    import com.sulake.core.runtime.exceptions.Exception;
    import flash.system.System;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.iid.*;

     class HabboTracking extends Component implements IHabboTracking implements  IUpdateReceiver 
    {
        static inline final ERROR_DATA_FLAG_COUNT:UInt = 11;
        static var _Str_1229:HabboTracking;

        var _communication:IHabboCommunicationManager;
        var _errorContextFlags:Array<ASAny>;
        var _crashed:Bool = false;
        var _messageEvents:Vector<IMessageEvent>;
        var _performanceTracker:PerformanceTracker = null;
        var _framerateTracker:FramerateTracker = null;
        var _latencyTracker:LatencyTracker = null;
        var _lagWarningLogger:LagWarningLogger = null;
        var _toolbarClickTracker:ToolbarClickTracker = null;
        var _roomEngine:IRoomEngine = null;
        var _anyRoomsVisited:Bool = false;
        var _currentTime:Int = -1;
        var _invalidTimeCount:Int = 0;
        var _timeLeapCount:Int = 0;
        var _fpsTrackingTimer:Timer;
        var _fpsTrackingCount:Int = 0;
        var _fpsTrackingRoomId:Int = -1;
        var _instance:Vector<String>;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._instance = new Vector<String>(0);
            if (_Str_1229 == null)
            {
                _Str_1229 = this;
            }
            this._errorContextFlags = ASCompat.allocArray(ERROR_DATA_FLAG_COUNT);
            var _local_4:UInt = 0;
            while (_local_4 < ERROR_DATA_FLAG_COUNT)
            {
                this._errorContextFlags[ASCompat.toInt(_local_4)] = 0;
                _local_4++;
            }
            super(k, _arg_2, _arg_3);
            var _local_5= k.root;
            if (_local_5 != null)
            {
                _local_5.events.addEventListener(Component.COMPONENT_EVENT_ERROR, this.onError);
                ErrorReportStorage.setParameter(HabboErrorVariableEnum.START_TIME, Std.string(Date.now().getTime()));
                ErrorReportStorage.setParameter(HabboErrorVariableEnum.AGENT, (ExternalInterface.available ? ExternalInterface.call("window.navigator.userAgent.toString") : "unknown"));
                ErrorReportStorage.setParameter(HabboErrorVariableEnum.SYSTEM, Capabilities.serverString);
                ErrorReportStorage.setParameter(HabboErrorVariableEnum.IN_ROOM, ASCompat.toString(false));
                ErrorReportStorage.setParameter(HabboErrorVariableEnum.LAST_ROOM, Std.string(0));
            }
            registerUpdateReceiver(this, 1);
        }

        public static function getInstance():HabboTracking
        {
            return _Str_1229;
        }


        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }), new ComponentDependency(new IIDHabboConfigurationManager(), function (k:com.sulake.core.runtime.IHabboConfigurationManager)
            {
                if (k != null)
                {
                    setErrorContextFlag(1, 0);
                }
            }, false, [{
                "type":Event.COMPLETE,
                "callback":this.onConfigurationComplete
            }]), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:com.sulake.habbo.localization.IHabboLocalizationManager)
            {
                if (k != null)
                {
                    setErrorContextFlag(1, 1);
                }
            }, false), new ComponentDependency(new IIDHabboWindowManager(), null, false, [{
                "type":_Str_5209.HABBO_WINDOW_TRACKING_EVENT_INPUT,
                "callback":this.onWindowTrackingEvent
            }, {
                "type":_Str_5209.HABBO_WINDOW_TRACKING_EVENT_RENDER,
                "callback":this.onWindowTrackingEvent
            }, {
                "type":_Str_5209.HABBO_WINDOW_TRACKING_EVENT_SLEEP,
                "callback":this.onWindowTrackingEvent
            }]), new ComponentDependency(new IIDHabboNavigator(), null, false, [{
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_CLOSED,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_EVENTS,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_ROOMS,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_ME,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCH,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_OFFICIAL,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_FAVOURITES,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_FRIENDS_ROOMS,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_HISTORY,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_ROOMS,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_OFFICIALROOMS,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_POPULAR_ROOMS,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_ROOMS_WHERE_MY_FRIENDS_ARE,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_ROOMS_WITH_HIGHEST_SCORE,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_TAG_SEARCH,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_TEXT_SEARCH,
                "callback":this.onNavigatorTrackingEvent
            }, {
                "type":HabboRoomSettingsTrackingEvent.HABBO_ROOM_SETTINGS_TRACKING_EVENT_CLOSED,
                "callback":this.onRoomSettingsTrackingEvent
            }, {
                "type":HabboRoomSettingsTrackingEvent.HABBO_ROOM_SETTINGS_TRACKING_EVENT_DEFAULT,
                "callback":this.onRoomSettingsTrackingEvent
            }, {
                "type":HabboRoomSettingsTrackingEvent.HABBO_ROOM_SETTINGS_TRACKING_EVENT_ADVANCED,
                "callback":this.onRoomSettingsTrackingEvent
            }, {
                "type":HabboRoomSettingsTrackingEvent.HABBO_ROOM_SETTINGS_TRACKING_EVENT_THUMBS,
                "callback":this.onRoomSettingsTrackingEvent
            }, {
                "type":HabboToolbarEvent.HTIE_ICON_ZOOM,
                "callback":this.onZoomToggle
            }]), new ComponentDependency(new IIDHabboCatalog(), null, false, [{
                "type":CatalogPageOpenedEvent.CATALOG_PAGE_OPENED,
                "callback":this.onCatalogPageOpened
            }, {
                "type":HabboCatalogTrackingEvent.HABBO_CATALOG_TRACKING_EVENT_OPEN,
                "callback":this.onCatalogTrackingEvent
            }, {
                "type":HabboCatalogTrackingEvent.HABBO_CATALOG_TRACKING_EVENT_CLOSE,
                "callback":this.onCatalogTrackingEvent
            }, {
                "type":CatalogFurniPurchaseEvent.CATALOG_FURNI_PURCHASE,
                "callback":this.onCatalogTrackingEvent
            }]), new ComponentDependency(new IIDHabboInventory(), null, false, [{
                "type":HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_CLOSED,
                "callback":this.onInventoryTrackingEvent
            }, {
                "type":HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_FURNI,
                "callback":this.onInventoryTrackingEvent
            }, {
                "type":HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_POSTERS,
                "callback":this.onInventoryTrackingEvent
            }, {
                "type":HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_BADGES,
                "callback":this.onInventoryTrackingEvent
            }, {
                "type":HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_ACHIEVEMENTS,
                "callback":this.onInventoryTrackingEvent
            }, {
                "type":HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_TRADING,
                "callback":this.onInventoryTrackingEvent
            }]), new ComponentDependency(new IIDHabboFriendList(), null, false, [{
                "type":_Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_CLOSED,
                "callback":this.onFriendlistTrackingEvent
            }, {
                "type":_Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_FRIENDS,
                "callback":this.onFriendlistTrackingEvent
            }, {
                "type":_Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_SEARCH,
                "callback":this.onFriendlistTrackingEvent
            }, {
                "type":_Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_REQUEST,
                "callback":this.onFriendlistTrackingEvent
            }, {
                "type":_Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_MINIMZED,
                "callback":this.onFriendlistTrackingEvent
            }]), new ComponentDependency(new IIDHabboHelp(), null, false, [{
                "type":HabboHelpTrackingEvent.HABBO_HELP_TRACKING_EVENT_CLOSED,
                "callback":this.onHelpTrackingEvent
            }, {
                "type":HabboHelpTrackingEvent.HABBO_HELP_TRACKING_EVENT_DEFAULT,
                "callback":this.onHelpTrackingEvent
            }]), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            }, false, [{
                "type":RoomObjectRoomAdEvent.RORAE_ROOM_AD_FURNI_CLICK,
                "callback":this.onRoomAdClick
            }, {
                "type":RoomEngineEvent.INITIALIZED,
                "callback":this.onRoomAction
            }, {
                "type":RoomEngineEvent.DISPOSED,
                "callback":this.onRoomAction
            }]), new ComponentDependency(new IIDHabboAdManager(), null, false, [{
                "type":AdEvent.ROOM_AD_SHOW,
                "callback":this.onRoomAdLoad
            }]), new ComponentDependency(new IIDHabboToolbar(), null, false, [{
                "type":HabboToolbarEvent.HTE_TOOLBAR_CLICK,
                "callback":this.onToolbarClick
            }])]));
        }

        override function initComponent()
        {
            this._latencyTracker = new LatencyTracker(this);
            this._performanceTracker = new PerformanceTracker(this);
            this._framerateTracker = new FramerateTracker(this);
            this._lagWarningLogger = new LagWarningLogger(this);
            this._toolbarClickTracker = new ToolbarClickTracker(this);
            this._messageEvents = new Vector<IMessageEvent>(0);
            this.addMessageEvent(new AuthenticationOKMessageEvent(this.onAuthOK));
            this.addMessageEvent(new RoomEntryInfoMessageEvent(this.onRoomEnter));
            this.addMessageEvent(new HabboAchievementNotificationMessageEvent(this._Str_25489));
            this.addMessageEvent(new LatencyPingResponseMessageEvent(this._Str_17172));
            var k= cast(context, Component).events;
            k.addEventListener(HabboCommunicationEvent.INIT, this.onConnectionEvent);
            k.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_ESTABLISHED, this.onConnectionEvent);
            k.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_HANDSHAKING, this.onConnectionEvent);
            k.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_HANDSHAKED, this.onConnectionEvent);
            k.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_HANDSHAKE_FAIL, this.onConnectionEvent);
            k.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED, this.onConnectionEvent);
            k.addEventListener(HabboHotelViewEvent.HHVE_START_LOAD, this.onHotelViewEvent);
            k.addEventListener(HabboHotelViewEvent.ERROR, this.onHotelViewEvent);
            k.addEventListener(HabboHotelViewEvent.HHVE_LOADED, this.onHotelViewEvent);
        }

        function addMessageEvent(k:IMessageEvent)
        {
            this._messageEvents.push(this._communication.addHabboConnectionMessageEvent(k));
        }

        override public function dispose()
        {
            var k:IMessageEvent = null;
            if (disposed)
            {
                return;
            }
            if (_Str_1229 == this)
            {
                _Str_1229 = null;
            }
            removeUpdateReceiver(this);
            if (((!(this._messageEvents == null)) && (!(this._communication == null))))
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._communication.removeHabboConnectionMessageEvent(k);
                }
            }
            this._performanceTracker = null;
            this._framerateTracker = null;
            this._toolbarClickTracker = null;
            if (this._latencyTracker != null)
            {
                this._latencyTracker.dispose();
                this._latencyTracker = null;
            }
            if (this._fpsTrackingTimer != null)
            {
                this._fpsTrackingTimer.stop();
                this._fpsTrackingTimer.removeEventListener(TimerEvent.TIMER, (this.onRoomActionTimerEvent : ASAny));
                this._fpsTrackingTimer = null;
            }
            super.dispose();
        }

        function setErrorContextFlag(k:UInt, _arg_2:UInt)
        {
            this._errorContextFlags[ASCompat.toInt(_arg_2)] = k;
        }

        function onHotelViewEvent(k:Event)
        {
            switch (k.type)
            {
                case HabboHotelViewEvent.HHVE_START_LOAD:
                    this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_HOTELVIEW_START);
                    return;
                case HabboHotelViewEvent.HHVE_LOADED:
                    this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_HOTELVIEW_OK);
                    return;
                case HabboHotelViewEvent.ERROR:
                    this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_HOTELVIEW_FAIL);
                    return;
            }
        }

        function onConnectionEvent(k:Event)
        {
            switch (k.type)
            {
                case HabboCommunicationEvent.INIT:
                    this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_SOCKET_INIT);
                    
                case HabboCommunicationEvent.HABBO_CONNECTION_EVENT_ESTABLISHED:
                    this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_SOCKET_OK, Std.string(this._communication.port));
                    
                case HabboCommunicationEvent.HABBO_CONNECTION_EVENT_HANDSHAKING:
                    this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_HANDSHAKE_START);
                    
                case HabboCommunicationEvent.HABBO_CONNECTION_EVENT_HANDSHAKE_FAIL:
                    this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_HANDSHAKE_FAIL);
                    
                case HabboCommunicationEvent.HABBO_CONNECTION_EVENT_HANDSHAKED:
                    this.setErrorContextFlag(2, 0);
                    this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_HANDSHAKE_OK);
                    
                case HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED:
                    this.setErrorContextFlag(3, 0);
                    this.loadConversionTrackingFrame();
                    this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_AUTH_OK);
                    
            }
            cast(context, Component).events.removeEventListener(k.type, this.onConnectionEvent);
        }

        function onWindowTrackingEvent(k:Event)
        {
            switch (k.type)
            {
                case _Str_5209.HABBO_WINDOW_TRACKING_EVENT_SLEEP:
                    this.setErrorContextFlag(0, 3);
                    return;
                case _Str_5209.HABBO_WINDOW_TRACKING_EVENT_RENDER:
                    this.setErrorContextFlag(1, 3);
                    return;
                case _Str_5209.HABBO_WINDOW_TRACKING_EVENT_INPUT:
                    this.setErrorContextFlag(2, 3);
                    return;
            }
        }

        function onError(k:ErrorEvent)
        {
            this.storeErrorDetails(k);
            if (k.critical)
            {
                this._crashed = true;
            }
            this.logError(context.root.getLastErrorMessage());
        }

        function storeErrorDetails(k:ErrorEvent)
        {
            var _local_3:UInt = 0;
            var _local_4:String = null;
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.ERROR_VARIABLE_IS_FATAL, Std.string(k.critical));
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.ERROR_VARIABLE_CLIENT_CRASH_TIME, Std.string(Date.now().getTime()));
            var _local_2= "";
            final _iter_ = this._errorContextFlags; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = ASCompat.toUInt(_tmp_);
                _local_2 = (_local_2 + Std.string(_local_3));
            }
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.ERROR_VARIABLE_CONTEXT, _local_2);
            if (this._performanceTracker != null)
            {
                ErrorReportStorage.setParameter(HabboErrorVariableEnum.ERROR_VARIABLE_FLASH_VERSION, this._performanceTracker.flashVersion);
                ErrorReportStorage.setParameter(HabboErrorVariableEnum.ERROR_VARIABLE_AVERAGE_UPDATE_INTERVAL, Std.string(this._performanceTracker.averageUpdateInterval));
            }
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.ERROR_DESC, k.message);
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.ERROR_CAT, Std.string(k.category));
            if (k.error != null)
            {
                _local_4 = Exception.getChainedStackTrace(k.error);
                if (_local_4 != null)
                {
                    ErrorReportStorage.setParameter(HabboErrorVariableEnum.ERROR_DATA, _local_4);
                }
            }
            this._communication.setMessageQueueErrorDebugData();
            ErrorReportStorage.addDebugData("Flash memory usage", (("Memory usage: " + Std.string(Math.fround((System.totalMemory / (0x0400 * 0x0400))))) + " MB"));
        }

        function onNavigatorTrackingEvent(k:Event)
        {
            switch (k.type)
            {
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_CLOSED:
                    this.setErrorContextFlag(0, 4);
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_EVENTS:
                    this.setErrorContextFlag(1, 4);
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_ROOMS:
                    this.setErrorContextFlag(2, 4);
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_ME:
                    this.setErrorContextFlag(3, 4);
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_OFFICIAL:
                    this.setErrorContextFlag(4, 4);
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCH:
                    this.setErrorContextFlag(5, 4);
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_FAVOURITES:
                    this.legacyTrackGoogle("navigator", "my_favorites");
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_FRIENDS_ROOMS:
                    this.legacyTrackGoogle("navigator", "my_friends_rooms");
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_HISTORY:
                    this.legacyTrackGoogle("navigator", "my_history");
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_ROOMS:
                    this.legacyTrackGoogle("navigator", "my_rooms");
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_OFFICIALROOMS:
                    this.legacyTrackGoogle("navigator", "official_rooms");
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_POPULAR_ROOMS:
                    this.legacyTrackGoogle("navigator", "popular_rooms");
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_ROOMS_WHERE_MY_FRIENDS_ARE:
                    this.legacyTrackGoogle("navigator", "rooms_where_my_friends_are");
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_ROOMS_WITH_HIGHEST_SCORE:
                    this.legacyTrackGoogle("navigator", "highest_score");
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_TAG_SEARCH:
                    this.legacyTrackGoogle("navigator", "tag_search");
                    return;
                case HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_TEXT_SEARCH:
                    this.legacyTrackGoogle("navigator", "text_search");
                    return;
            }
        }

        function onRoomSettingsTrackingEvent(k:Event)
        {
            switch (k.type)
            {
                case HabboRoomSettingsTrackingEvent.HABBO_ROOM_SETTINGS_TRACKING_EVENT_CLOSED:
                    this.setErrorContextFlag(0, 7);
                    return;
                case HabboRoomSettingsTrackingEvent.HABBO_ROOM_SETTINGS_TRACKING_EVENT_DEFAULT:
                    this.setErrorContextFlag(1, 7);
                    return;
                case HabboRoomSettingsTrackingEvent.HABBO_ROOM_SETTINGS_TRACKING_EVENT_ADVANCED:
                    this.setErrorContextFlag(2, 7);
                    return;
            }
        }

        function onInventoryTrackingEvent(k:Event)
        {
            switch (k.type)
            {
                case HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_CLOSED:
                    this.setErrorContextFlag(0, 5);
                    return;
                case HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_FURNI:
                    this.setErrorContextFlag(1, 5);
                    return;
                case HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_POSTERS:
                    this.setErrorContextFlag(2, 5);
                    return;
                case HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_BADGES:
                    this.setErrorContextFlag(3, 5);
                    return;
                case HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_ACHIEVEMENTS:
                    this.setErrorContextFlag(4, 5);
                    return;
                case HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_TRADING:
                    this.setErrorContextFlag(5, 5);
                    return;
            }
        }

        function _Str_25489(k:HabboAchievementNotificationMessageEvent)
        {
            var _local_2= k.getParser();
            this.legacyTrackGoogle("achievement", "achievement", [_local_2.data.badgeCode]);
        }

        function onCatalogPageOpened(k:CatalogPageOpenedEvent)
        {
            this.legacyTrackGoogle("catalogue", "page", [k.pageLocalization]);
        }

        function onCatalogTrackingEvent(k:Event)
        {
            switch (k.type)
            {
                case HabboCatalogTrackingEvent.HABBO_CATALOG_TRACKING_EVENT_OPEN:
                    this.setErrorContextFlag(1, 9);
                    return;
                case HabboCatalogTrackingEvent.HABBO_CATALOG_TRACKING_EVENT_CLOSE:
                    this.setErrorContextFlag(0, 9);
                    return;
            }
        }

        function onFriendlistTrackingEvent(k:Event)
        {
            switch (k.type)
            {
                case _Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_CLOSED:
                    this.setErrorContextFlag(0, 6);
                    return;
                case _Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_FRIENDS:
                    this.setErrorContextFlag(1, 6);
                    return;
                case _Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_SEARCH:
                    this.setErrorContextFlag(2, 6);
                    return;
                case _Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_REQUEST:
                    this.setErrorContextFlag(3, 6);
                    return;
                case _Str_3797.HABBO_FRIENDLIST_TRACKING_EVENT_MINIMZED:
                    this.setErrorContextFlag(4, 6);
                    return;
            }
        }

        function onHelpTrackingEvent(k:Event)
        {
            switch (k.type)
            {
                case HabboHelpTrackingEvent.HABBO_HELP_TRACKING_EVENT_CLOSED:
                    this.setErrorContextFlag(0, 10);
                    return;
                case HabboHelpTrackingEvent.HABBO_HELP_TRACKING_EVENT_DEFAULT:
                    this.setErrorContextFlag(1, 10);
                    return;
            }
        }

        function onAuthOK(k:IMessageEvent)
        {
            this.legacyTrackGoogle("authentication", "authok");
        }

        function _Str_17172(k:LatencyPingResponseMessageEvent)
        {
            if (this._latencyTracker != null)
            {
                this._latencyTracker._Str_17172(k);
            }
        }

        function onRoomEnter(k:IMessageEvent)
        {
            if (!this._anyRoomsVisited)
            {
                this.trackLoginStep(HabboLoginTrackingStep.CLIENT_INIT_ROOM_ENTER);
                this._anyRoomsVisited = true;
            }
            var _local_2= cast(k, RoomEntryInfoMessageEvent).getParser();
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.LAST_ROOM, Std.string(_local_2.guestRoomId));
            ErrorReportStorage.setParameter(HabboErrorVariableEnum.IN_ROOM, ASCompat.toString(true));
            this.legacyTrackGoogle("navigator", "private", [_local_2.guestRoomId]);
        }

        function onConfigurationComplete(k:Event)
        {
            if (this._latencyTracker != null)
            {
                this._latencyTracker.init();
            }
        }

        function onRoomAdLoad(k:AdEvent)
        {
            this.legacyTrackGoogle("room_ad", "show", [this.getAliasFromAdTechUrl(k.clickUrl)]);
        }

        function onRoomAdClick(k:RoomObjectRoomAdEvent)
        {
            this.legacyTrackGoogle("room_ad", "click", [this.getAliasFromAdTechUrl(k.clickUrl)]);
        }

        function getAliasFromAdTechUrl(k:String):String
        {
            var _local_2:Array<ASAny> = (cast ASCompat.stringMatch(k, new compat.RegExp(";alias=([^;]+)")));
            if (((!(_local_2 == null)) && (_local_2.length > 1)))
            {
                return _local_2[1];
            }
            return "unknown";
        }

        function onRoomAction(k:RoomEngineEvent)
        {
            if (k.type == RoomEngineEvent.INITIALIZED)
            {
                if (this._fpsTrackingTimer == null)
                {
                    this._fpsTrackingRoomId = k.roomId;
                    this._fpsTrackingTimer = new Timer((60 * 1000), 1);
                    this._fpsTrackingTimer.addEventListener(TimerEvent.TIMER, (this.onRoomActionTimerEvent : ASAny));
                    this._fpsTrackingTimer.start();
                }
            }
            else
            {
                if (k.type == RoomEngineEvent.DISPOSED)
                {
                    if (this._fpsTrackingTimer != null)
                    {
                        this._fpsTrackingTimer.removeEventListener(TimerEvent.TIMER, (this.onRoomActionTimerEvent : ASAny));
                        this._fpsTrackingTimer.stop();
                        this._fpsTrackingTimer = null;
                        this._fpsTrackingRoomId = -1;
                    }
                }
            }
        }

        function onRoomActionTimerEvent(k:TimerEvent)
        {
            var _local_2:String = null;
            var _local_3 = 0;
            var _local_4 = 0;
            if (((((!disposed) && (!this._crashed)) && (!(this._communication == null))) && (this._framerateTracker != null)))
            {
                _local_2 = null;
                if (this._roomEngine != null)
                {
                    _local_3 = this._roomEngine.getRoomObjectCount(this._roomEngine.activeRoomId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                    _local_4 = (this._roomEngine.getRoomObjectCount(this._roomEngine.activeRoomId, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE) + this._roomEngine.getRoomObjectCount(this._roomEngine.activeRoomId, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM));
                    _local_2 = ((("Avatars: " + Std.string(_local_3)) + ", Objects: ") + Std.string(_local_4));
                }
                this.trackEventLog("ClientPerformance", Std.string(this._framerateTracker.frameRate), "fps", _local_2, this._fpsTrackingRoomId);
                this._fpsTrackingCount++;
            }
        }

        function onToolbarClick(k:HabboToolbarEvent)
        {
            if (this._toolbarClickTracker != null)
            {
                this._toolbarClickTracker.track(k.iconName);
            }
        }

        function onZoomToggle(k:HabboToolbarEvent)
        {
            if (this._toolbarClickTracker != null)
            {
                this._toolbarClickTracker.track(k.type);
            }
        }

        public function legacyTrackGoogle(k:String, _arg_2:String, _arg_3:Array<ASAny>=null)
        {
            Logger.log([(((((("legacyTrackGoogle(" + k) + ", ") + _arg_2) + ", ") + ASCompat.toString(_arg_3)) + ")")]);
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.legacyTrack", [k, _arg_2, ((_arg_3 == null) ? ([] : Array<Dynamic>) : _arg_3)]);
                }
                else
                {
                    Logger.log(["ExternalInterface is not available, tracking is disabled"]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        public function trackGoogle(k:String, _arg_2:String, _arg_3:Int=-1)
        {
            Logger.log([(((((("trackGoogle(" + k) + ", ") + _arg_2) + ", ") + Std.string(_arg_3)) + ")")]);
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.track", [k, _arg_2, _arg_3]);
                }
                else
                {
                    Logger.log(["ExternalInterface is not available, tracking is disabled"]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        function loadConversionTrackingFrame()
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.loadConversionTrackingFrame");
                }
                else
                {
                    Logger.log(["ExternalInterface is not available!"]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        public function trackLoginStep(k:String, _arg_2:String=null)
        {
            Logger.log([("* Track Login Step: " + k)]);
            if (!getBoolean("processlog.enabled"))
            {
                return;
            }
            try
            {
                if (ExternalInterface.available)
                {
                    if (_arg_2 != null)
                    {
                        ExternalInterface.call("FlashExternalInterface.logLoginStep", [k, _arg_2]);
                    }
                    else
                    {
                        ExternalInterface.call("FlashExternalInterface.logLoginStep", [k]);
                    }
                }
                else
                {
                    Logger.log(["ExternalInterface is not available, tracking is disabled"]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        public function trackEventLog(k:String, _arg_2:String, _arg_3:String, _arg_4:String="", _arg_5:Int=0)
        {
            if ((((!(this._communication == null)) && (!(this._communication.connection == null))) && this._communication.connection.connected))
            {
                this._communication.connection.send(new EventLogMessageComposer(k, _arg_2, _arg_3, _arg_4, _arg_5));
            }
        }

        public function trackEventLogOncePerSession(k:String, _arg_2:String, _arg_3:String, _arg_4:String="", _arg_5:Int=0)
        {
            var _local_6= ((k + _arg_2) + _arg_3);
            var _local_7 = false;
            var _local_8:UInt = 0;
            while (_local_8 < (this._instance.length : UInt))
            {
                if (this._instance[ASCompat.toInt(_local_8)] == _local_6)
                {
                    _local_7 = true;
                    break;
                }
                _local_8++;
            }
            if (!_local_7)
            {
                this.trackEventLog(k, _arg_2, _arg_3, _arg_4, _arg_5);
                this._instance.push(_local_6);
            }
        }

        public function trackTalentTrackOpen(k:String, _arg_2:String)
        {
            this.trackEventLog("Talent", k, "talent.open", _arg_2);
        }

        public function logError(k:String)
        {
            Logger.log([(("logError(" + k) + ")")]);
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.logError", [k]);
                }
                else
                {
                    Logger.log(["ExternalInterface is not available, tracking is disabled"]);
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        public function chatLagDetected(k:Int)
        {
            this._lagWarningLogger.chatLagDetected(k);
        }

        public function update(k:UInt)
        {
            var _local_2= flash.Lib.getTimer();
            if (((this._currentTime > -1) && (_local_2 < this._currentTime)))
            {
                this._invalidTimeCount++;
                ErrorReportStorage.addDebugData("Invalid time counter", ("Invalid times: " + Std.string(this._invalidTimeCount)));
            }
            if (((this._currentTime > -1) && ((_local_2 - this._currentTime) > (15 * 1000))))
            {
                this._timeLeapCount++;
                ErrorReportStorage.addDebugData("Time leap counter", ("Time leaps: " + Std.string(this._timeLeapCount)));
            }
            this._currentTime = _local_2;
            if (this._performanceTracker != null)
            {
                this._performanceTracker.update(k, this._currentTime);
            }
            if (this._latencyTracker != null)
            {
                this._latencyTracker.update(k, this._currentTime);
            }
            if (this._framerateTracker != null)
            {
                this._framerateTracker.trackUpdate(k, this._currentTime);
            }
            if (this._lagWarningLogger != null)
            {
                this._lagWarningLogger.update(this._currentTime);
            }
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public function send(k:IMessageComposer)
        {
            if ((((!(this._communication == null)) && (!(this._communication.connection == null))) && this._communication.connection.connected))
            {
                this._communication.connection.send(k);
            }
        }
    }

