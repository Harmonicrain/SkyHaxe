package com.sulake.habbo.navigator
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.navigator.mainview.MainViewCtrl;
    import com.sulake.habbo.navigator.inroom.RoomInfoViewCtrl;
    import com.sulake.habbo.navigator.roomsettings.RoomCreateViewCtrl;
    import com.sulake.habbo.navigator.domain.NavigatorData;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.navigator.roomsettings.RoomSettingsCtrl;
    import com.sulake.habbo.navigator.mainview.OfficialRoomEntryManager;
    import com.sulake.habbo.navigator.inroom.RoomEventViewCtrl;
    import com.sulake.habbo.navigator.inroom.RoomEventInfoCtrl;
    import com.sulake.habbo.navigator.roomsettings.RoomFilterCtrl;
    import com.sulake.habbo.navigator.toolbar.ToolbarHoverCtrl;
    import com.sulake.habbo.navigator.roomsettings.EnforceCategoryCtrl;
    import com.sulake.core.assets.AssetLibraryCollection;
    import com.sulake.core.runtime.IContext;
    import com.sulake.habbo.navigator.mainview.ITransitionalMainViewCtrl;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.habbo.session.events.PerksUpdatedEvent;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import flash.external.ExternalInterface;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.communication.messages.outgoing.navigator.ConvertGlobalRoomIdMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.GetGuestRoomMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.RemoveOwnRoomRightsRoomMessageComposer;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.ErrorReportStorage;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.communication.messages.incoming.navigator.CompetitionRoomsData;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.communication.messages.outgoing.navigator.ForwardToSomeRoomMessageComposer;
    import com.sulake.habbo.navigator.inroom.*;

     class HabboNavigator extends Component implements IHabboNavigator implements  IHabboTransitionalNavigator implements  ILinkEventTracker 
    {
        var _communication:IHabboCommunicationManager;
        var _roomSessionManager:IRoomSessionManager;
        var _windowManager:IHabboWindowManager;
        var _localization:IHabboLocalizationManager;
        var _sessionData:ISessionDataManager;
        var _tracking:IHabboTracking;
        var _catalog:IHabboCatalog;
        var _habboHelp:IHabboHelp;
        var _avatarManager:IAvatarRenderManager;
        var _mainViewCtrl:MainViewCtrl;
        var _roomInfoViewCtrl:RoomInfoViewCtrl;
        var _roomCreateViewCtrl:RoomCreateViewCtrl;
        var _data:NavigatorData;
        var _tabs:Tabs;
        var _assetLibrary:IAssetLibrary;
        var _incomingMessages:IncomingMessages;
        var _toolbar:IHabboToolbar;
        var _roomSettingsCtrl:RoomSettingsCtrl;
        var _passwordInput:GuestRoomPasswordInput;
        var _doorbell:GuestRoomDoorbell;
        var _officialRoomEntryManager:OfficialRoomEntryManager;
        var _roomEventViewCtrl:RoomEventViewCtrl;
        var _roomEventInfoCtrl:RoomEventInfoCtrl;
        var _roomFilterCtrl:RoomFilterCtrl;
        var _toolbarHover:ToolbarHoverCtrl;
        var _enforceCategoryCtrl:EnforceCategoryCtrl;
        var _webRoomReport:Bool = true;
        var _webRoomReportedName:String = null;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._assetLibrary = new AssetLibraryCollection("NavigatorComponent");
            this._data = new NavigatorData(this);
            this._mainViewCtrl = new MainViewCtrl(this);
            this._roomInfoViewCtrl = new RoomInfoViewCtrl(this);
            this._roomCreateViewCtrl = new RoomCreateViewCtrl(this);
            this._passwordInput = new GuestRoomPasswordInput(this);
            this._doorbell = new GuestRoomDoorbell(this);
            this._tabs = new Tabs(this);
            this._officialRoomEntryManager = new OfficialRoomEntryManager(this);
            this._roomEventViewCtrl = new RoomEventViewCtrl(this);
            this._roomEventInfoCtrl = new RoomEventInfoCtrl(this);
            this._roomFilterCtrl = new RoomFilterCtrl(this);
            this._enforceCategoryCtrl = new EnforceCategoryCtrl(this);
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var data(get,never):NavigatorData;
public function  get_data():NavigatorData
        {
            return this._data;
        }

        public var mainViewCtrl(get,never):ITransitionalMainViewCtrl;
public function  get_mainViewCtrl():ITransitionalMainViewCtrl
        {
            return this._mainViewCtrl;
        }

        public var tabs(get,never):Tabs;
public function  get_tabs():Tabs
        {
            return this._tabs;
        }

        public var roomInfoViewCtrl(get,never):RoomInfoViewCtrl;
public function  get_roomInfoViewCtrl():RoomInfoViewCtrl
        {
            return this._roomInfoViewCtrl;
        }

        public var roomCreateViewCtrl(get,never):RoomCreateViewCtrl;
public function  get_roomCreateViewCtrl():RoomCreateViewCtrl
        {
            return this._roomCreateViewCtrl;
        }

        public var assetLibrary(get,never):IAssetLibrary;
public function  get_assetLibrary():IAssetLibrary
        {
            return this._assetLibrary;
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public var roomSettingsCtrl(get,never):RoomSettingsCtrl;
public function  get_roomSettingsCtrl():RoomSettingsCtrl
        {
            this._roomSettingsCtrl.navigator = this;
            return this._roomSettingsCtrl;
        }

        public var sessionData(get,never):ISessionDataManager;
public function  get_sessionData():ISessionDataManager
        {
            return this._sessionData;
        }

        public var passwordInput(get,never):GuestRoomPasswordInput;
public function  get_passwordInput():GuestRoomPasswordInput
        {
            return this._passwordInput;
        }

        public var doorbell(get,never):GuestRoomDoorbell;
public function  get_doorbell():GuestRoomDoorbell
        {
            return this._doorbell;
        }

        public var roomEventViewCtrl(get,never):RoomEventViewCtrl;
public function  get_roomEventViewCtrl():RoomEventViewCtrl
        {
            return this._roomEventViewCtrl;
        }

        public var officialRoomEntryManager(get,never):OfficialRoomEntryManager;
public function  get_officialRoomEntryManager():OfficialRoomEntryManager
        {
            return this._officialRoomEntryManager;
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }

        public var habboHelp(get,never):IHabboHelp;
public function  get_habboHelp():IHabboHelp
        {
            return this._habboHelp;
        }

        public var roomEventInfoCtrl(get,never):RoomEventInfoCtrl;
public function  get_roomEventInfoCtrl():RoomEventInfoCtrl
        {
            return this._roomEventInfoCtrl;
        }

        public var roomFilterCtrl(get,never):RoomFilterCtrl;
public function  get_roomFilterCtrl():RoomFilterCtrl
        {
            return this._roomFilterCtrl;
        }

        public var roomSessionManager(get,never):IRoomSessionManager;
public function  get_roomSessionManager():IRoomSessionManager
        {
            return this._roomSessionManager;
        }

        public var enforceCategoryCtrl(get,never):EnforceCategoryCtrl;
public function  get_enforceCategoryCtrl():EnforceCategoryCtrl
        {
            return this._enforceCategoryCtrl;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }, false, [{
                "type":HabboToolbarEvent.HTE_TOOLBAR_CLICK,
                "callback":this.onHabboToolbarEvent
            }]), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }, false), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionData = k;
            }, true, [{
                "type":PerksUpdatedEvent.PERKS_UPDATED,
                "callback":this.onPerksUpdated
            }]), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _tracking = k;
            }), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarManager = k;
            }), new ComponentDependency(new IIDHabboHelp(), function (k:IHabboHelp)
            {
                _habboHelp = k;
            }, false), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            })]));
        }

        override function initComponent()
        {
            this._incomingMessages = new IncomingMessages(this);
            this._roomSessionManager.events.addEventListener(RoomSessionEvent.CREATED, this._Str_19913);
            if (!this._sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                context.addLinkEventTracker(this);
            }
            var k= getProperty("navigator.default_tab");
            if (getInteger("new.identity", 0) > 0)
            {
                k = getProperty("new.identity.navigator.default_tab");
            }
            this.tabs.setSelectedTab(Tabs.tabIdFromName(k, Tabs.TAB_ROOMS));
            this._roomSettingsCtrl = new RoomSettingsCtrl(this);
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback(HabboWebTools.OPENROOM, this.enterRoomWebRequest);
            }
        }

        public function enterRoomWebRequest(k:String, _arg_2:Bool=false, _arg_3:String=null)
        {
            this._webRoomReport = _arg_2;
            this._webRoomReportedName = _arg_3;
            this.send(new ConvertGlobalRoomIdMessageComposer(k));
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._mainViewCtrl != null)
            {
                this._mainViewCtrl.dispose();
                this._mainViewCtrl = null;
            }
            if (this._roomSessionManager != null)
            {
                this._roomSessionManager.events.removeEventListener(RoomSessionEvent.CREATED, this._Str_19913);
            }
            context.removeLinkEventTracker(this);
            if (((!(this._toolbar == null)) && (!(this._toolbar.events == null))))
            {
                this._toolbar.events.removeEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onHabboToolbarEvent);
            }
            if (this._roomInfoViewCtrl != null)
            {
                this._roomInfoViewCtrl.dispose();
                this._roomInfoViewCtrl = null;
            }
            if (this._roomFilterCtrl != null)
            {
                this._roomFilterCtrl.dispose();
                this._roomFilterCtrl = null;
            }
            if (this._roomCreateViewCtrl != null)
            {
                this._roomCreateViewCtrl.dispose();
                this._roomCreateViewCtrl = null;
            }
            if (this._officialRoomEntryManager != null)
            {
                this._officialRoomEntryManager.dispose();
                this._officialRoomEntryManager = null;
            }
            if (this._roomEventViewCtrl != null)
            {
                this._roomEventViewCtrl.dispose();
                this._roomEventViewCtrl = null;
            }
            if (this._roomSettingsCtrl != null)
            {
                this._roomSettingsCtrl.dispose();
                this._roomSettingsCtrl = null;
            }
            if (this._toolbarHover != null)
            {
                this._toolbarHover.dispose();
                this._toolbarHover = null;
            }
            super.dispose();
        }

        public function startRoomCreation()
        {
            this._roomCreateViewCtrl.show();
        }

        public function goToPrivateRoom(k:Int)
        {
            this.send(new GetGuestRoomMessageComposer(k, false, true));
        }

        public function removeRoomRights(k:Int)
        {
            this.send(new RemoveOwnRoomRightsRoomMessageComposer(k));
        }

        public function hasRoomRightsButIsNotOwner(k:Int):Bool
        {
            var _local_2:IRoomSession = null;
            if (this._roomSessionManager != null)
            {
                _local_2 = this._roomSessionManager.getSession(k);
                return (_local_2.roomControllerLevel == RoomControllerLevel.GUEST) && (!_local_2.isRoomOwner);
            }
            return false;
        }

        public function goToRoomNetwork(k:Int, _arg_2:Bool)
        {
            var _local_3 = 0;
            if (this._roomSessionManager != null)
            {
                this._roomInfoViewCtrl.close();
                _local_3 = 0;
                if ((_arg_2 && (this._data.homeRoomId > 0)))
                {
                    _local_3 = this._data.homeRoomId;
                }
                this._roomSessionManager.gotoRoomNetwork(k, _local_3);
            }
        }

        public function goToRoom(k:Int, _arg_2:Bool, _arg_3:String="", _arg_4:Int=-1)
        {
            var _local_5 = 0;
            Logger.log([("GO TO ROOM: " + Std.string(k))]);
            if (this._roomSessionManager != null)
            {
                if (_arg_2)
                {
                    this._mainViewCtrl.close();
                }
                this._roomSessionManager.gotoRoom(k, _arg_3);
                if (this.tabs.getSelected() != null)
                {
                    _local_5 = ((_arg_4 > -1) ? (_arg_4 + 1) : 0);
                    switch (this.tabs.getSelected().id)
                    {
                        case Tabs.TAB_OFFICIAL:
                            this.trackNavigationDataPoint(this.tabs.getSelected()._Str_5252.filterCategory, "go.official", Std.string(k), _local_5);
                            return;
                        case Tabs.TAB_ME:
                            this.trackNavigationDataPoint(this.tabs.getSelected()._Str_5252.filterCategory, "go.me", Std.string(k), _local_5);
                            return;
                        case Tabs.TAB_ROOMS:
                            this.trackNavigationDataPoint(this.tabs.getSelected()._Str_5252.filterCategory, "go.rooms", Std.string(k), _local_5);
                            return;
                        case Tabs.TAB_EVENTS:
                            this.trackNavigationDataPoint("Events", "go.events", Std.string(k), _local_5);
                            return;
                        case Tabs.TAB_SEARCH:
                            this.trackNavigationDataPoint("Search", "go.search", Std.string(k), _local_5);
                            return;
                    }
                }
            }
        }

        public function goToHomeRoom():Bool
        {
            if (this._data.homeRoomId < 1)
            {
                Logger.log(["No home room set while attempting to go to home room"]);
                return false;
            }
            this.goToRoom(this._data.homeRoomId, true);
            return true;
        }

        public function send(k:IMessageComposer, _arg_2:Bool=false)
        {
            this._communication.connection.send(k);
        }

        public function getXmlWindow(name:String, layer:UInt=1):IWindow
        {
            var asset:IAsset = null;
            var xmlAsset:XmlAsset = null;
            var window:IWindow = null;
            try
            {
                asset = assets.getAssetByName((name + "_xml"));
                xmlAsset = cast(asset, XmlAsset);
                window = this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(xmlAsset.content), layer);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("HabboNavigator", (((((("Failed to build window " + name) + "_xml, ") + asset) + ", ") + _windowManager) + "!"));
                throw e;
            }
 }            return window;
        }

        public function getText(k:String):String
        {
            var _local_2= this._localization.getLocalization(k);
            if (((_local_2 == null) || (_local_2 == "")))
            {
                _local_2 = k;
            }
            return _local_2;
        }

        public function registerParameter(k:String, _arg_2:String, _arg_3:String):String
        {
            return this._localization.registerParameter(k, _arg_2, _arg_3);
        }

        public function getButton(k:String, _arg_2:String, _arg_3:ASFunction, _arg_4:Int=0, _arg_5:Int=0, _arg_6:Int=0):IBitmapWrapperWindow
        {
            var _local_7= this.getButtonImage(_arg_2);
            var _local_8= cast(this._windowManager.createWindow(k, "", WindowType.WINDOW_TYPE_BITMAP_WRAPPER, HabboWindowStyle.NULL, (ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )| ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)), new Rectangle(_arg_4, _arg_5, _local_7.width, _local_7.height), _arg_3, _arg_6), IBitmapWrapperWindow);
            _local_8.bitmap = _local_7;
            _local_8.disposesBitmap = false;
            return _local_8;
        }

        public function refreshButton(k:IWindowContainer, _arg_2:String, _arg_3:Bool, _arg_4:ASFunction, _arg_5:Int, _arg_6:String=null)
        {
            if (!ASCompat.stringAsBool(_arg_6))
            {
                _arg_6 = _arg_2;
            }
            var _local_7= Std.downcast(k.findChildByName(_arg_2) , IBitmapWrapperWindow);
            if (_local_7 == null)
            {
                Logger.log([("Could not locate button in navigator: " + _arg_2)]);
            }
            if (!_arg_3)
            {
                _local_7.visible = false;
            }
            else
            {
                this._Str_11416(_local_7, _arg_6, _arg_4, _arg_5);
                _local_7.visible = true;
            }
        }

        function _Str_11416(k:IBitmapWrapperWindow, _arg_2:String, _arg_3:ASFunction, _arg_4:Int)
        {
            k.id = _arg_4;
            k.procedure = _arg_3;
            if (k.bitmap != null)
            {
                return;
            }
            k.bitmap = this.getButtonImage(_arg_2);
            k.disposesBitmap = false;
            k.width = k.bitmap.width;
            k.height = k.bitmap.height;
        }

        public function getButtonImage(k:String, _arg_2:String="_png"):BitmapData
        {
            var _local_3= (k + _arg_2);
            var _local_4= assets.getAssetByName(_local_3);
            var _local_5= cast(_local_4, BitmapDataAsset);
            var _local_6= cast(_local_5.content, BitmapData);
            return _local_6;
        }

        function _Str_19913(k:RoomSessionEvent)
        {
            if (((this._roomSessionManager != null) && (this._roomInfoViewCtrl != null)))
            {
                this._roomInfoViewCtrl.close();
            }
        }

        public function openCatalogClubPage(k:String)
        {
            if (this._catalog == null)
            {
                return;
            }
            this._catalog.openClubCenter();
        }

        public function openCatalogRoomAdsPage()
        {
            if (this._catalog == null)
            {
                return;
            }
            this._catalog.openCatalogPage("room_ad");
        }

        public function openCatalogRoomAdsExtendPage(k:String, _arg_2:String, _arg_3:Date, _arg_4:Int)
        {
            if (this._catalog == null)
            {
                return;
            }
            var _local_5= this._data.enteredGuestRoom.roomName;
            this._catalog.openRoomAdCatalogPageInExtendedMode("room_ad", k, _arg_2, _local_5, _arg_3, _arg_4);
        }

        function onHabboToolbarEvent(k:HabboToolbarEvent)
        {
            if (k.type == HabboToolbarEvent.HTE_TOOLBAR_CLICK)
            {
                switch (k.iconId)
                {
                    case HabboToolbarIconEnum.ROOMINFO:
                        this.toggleRoomInfoVisibility();
                        return;
                    case HabboToolbarIconEnum.NAVIGATOR_ME_TAB:
                        this.showOwnRooms();
                        return;
                    case HabboToolbarIconEnum.GAMES:
                        if (getBoolean("game.center.enabled"))
                        {
                            this.closeNavigator();
                        }
                        return;
                    case HabboToolbarIconEnum.HOME:
                        this.goToHomeRoom();
                        return;
                }
            }
        }

        public function toggleRoomInfoVisibility()
        {
            if (this._roomCreateViewCtrl != null)
            {
                this._roomInfoViewCtrl.toggle();
            }
        }

        public function performTagSearch(k:String)
        {
            if (this._mainViewCtrl == null)
            {
                return;
            }
            if (k.indexOf(" ") != -1)
            {
                k = (('"' + k) + '"');
            }
            this._mainViewCtrl.startSearch(Tabs.TAB_SEARCH, Tabs.SEARCHTYPE_TAG_SEARCH, k);
            this.trackNavigationDataPoint("Search", "search.tag", k);
            this._mainViewCtrl.mainWindow.activate();
        }

        public function performTextSearch(k:String)
        {
            if (this._mainViewCtrl == null)
            {
                return;
            }
            this._mainViewCtrl.startSearch(Tabs.TAB_SEARCH, Tabs.SEARCHTYPE_TEXT_SEARCH, k);
            this.trackNavigationDataPoint("Search", "search", k);
            this._mainViewCtrl.mainWindow.activate();
            this._mainViewCtrl.searchInput._Str_17634.setText(k);
        }

        public function performCompetitionRoomsSearch(k:Int, _arg_2:Int)
        {
            if (((this._mainViewCtrl == null) || ((!(this._data == null)) && this._data._Str_19838())))
            {
                return;
            }
            this._data._Str_4079 = new CompetitionRoomsData(null, k, _arg_2);
            this._mainViewCtrl.startSearch(Tabs.TAB_SEARCH, Tabs.SEARCHTYPE_COMPETITION_ROOMS, "");
            this._mainViewCtrl.mainWindow.activate();
            this._mainViewCtrl.searchInput._Str_17634.setText("");
        }

        public function performGuildBaseSearch()
        {
            if (this._mainViewCtrl == null)
            {
                return;
            }
            this._mainViewCtrl.startSearch(Tabs.TAB_SEARCH, Tabs.SEARCHTYPE_GUILD_BASES, "");
            this._mainViewCtrl.mainWindow.activate();
            this._mainViewCtrl.searchInput._Str_17634.setText("");
        }

        public function showOwnRooms()
        {
            if (this._mainViewCtrl == null)
            {
                return;
            }
            this._mainViewCtrl.startSearch(Tabs.TAB_ME, Tabs.SEARCHTYPE_MY_ROOMS);
            this._tabs.getTab(Tabs.TAB_ME)._Str_5252.tabSelected();
        }

        public function showFavouriteRooms()
        {
            this._Str_18163(Tabs.SEARCHTYPE_MY_FAVOURITES);
        }

        public function showHistoryRooms()
        {
            this._Str_18163(Tabs.SEARCHTYPE_MY_HISTORY);
        }

        public function showFrequentRooms()
        {
            this._Str_18163(Tabs.SEARCHTYPE_FREQUENT_HISTORY);
        }

        function _Str_18163(k:Int)
        {
            if (this._mainViewCtrl == null)
            {
                return;
            }
            this._mainViewCtrl.startSearch(Tabs.TAB_ME, k);
            this._tabs.getTab(Tabs.TAB_ME)._Str_5252.setSubSelection(k);
        }

        public function trackNavigationDataPoint(k:String, _arg_2:String, _arg_3:String="", _arg_4:Int=0)
        {
            if (this._tracking != null)
            {
                this._tracking.trackEventLog("Navigation", k, _arg_2, _arg_3, _arg_4);
            }
        }

        public function trackGoogle(k:String, _arg_2:String, _arg_3:Int=-1)
        {
            if (this._tracking != null)
            {
                this._tracking.trackGoogle(k, _arg_2, _arg_3);
            }
        }

        public var tracking(get,never):IHabboTracking;
public function  get_tracking():IHabboTracking
        {
            return this._tracking;
        }

        public function openNavigator(k:Point=null)
        {
            if (this._mainViewCtrl == null)
            {
                return;
            }
            if (k != null)
            {
                this._mainViewCtrl.openAtPosition(k);
            }
            else
            {
                this._mainViewCtrl._Str_18392();
            }
        }

        public function closeNavigator()
        {
            this._mainViewCtrl.close();
        }

        public function goToMainView()
        {
            this._roomCreateViewCtrl.hide();
            this._roomInfoViewCtrl.close();
        }

        public var homeRoomId(get,never):Int;
public function  get_homeRoomId():Int
        {
            return (this._data != null) ? this._data.homeRoomId : -1;
        }

        public var _Str_25806(get,never):Bool;
public function  get__Str_25806():Bool
        {
            return this._webRoomReport;
        }

        public var _Str_23036(get,never):String;
public function  get__Str_23036():String
        {
            return this._webRoomReportedName;
        }

        public var enteredGuestRoomData(get,never):GuestRoomData;
public function  get_enteredGuestRoomData():GuestRoomData
        {
            if (this._data != null)
            {
                return this._data.enteredGuestRoom;
            }
            return null;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "navigator/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = null;
            var _local_3 = 0;
            _local_2 = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "goto":
                    if (_local_2.length > 2)
                    {
                        switch (_local_2[2])
                        {
                            case "home":
                                this.goToHomeRoom();
                                
                            default:
                                _local_3 = ASCompat.toInt(_local_2[2]);
                                if (_local_3 > 0)
                                {
                                    this.goToPrivateRoom(_local_3);
                                }
                                else
                                {
                                    this.send(new ForwardToSomeRoomMessageComposer(_local_2[2]));
                                }
                        }
                    }
                    return;
                case "search":
                    if (_local_2.length > 2)
                    {
                        this.performTextSearch(_local_2[2]);
                    }
                    return;
                case "tag":
                    if (_local_2.length > 2)
                    {
                        this.performTagSearch(_local_2[2]);
                    }
                    return;
                case "tab":
                    if (_local_2.length > 2)
                    {
                        this.tabs.setSelectedTab(Tabs.tabIdFromName(_local_2[2], Tabs.TAB_ROOMS));
                        this.openNavigator(null);
                    }
                    return;
                case "report":
                    if (_local_2.length > 3)
                    {
                        this.enterRoomWebRequest(_local_2[2], true, _local_2[3]);
                    }
                    return;
                default:
                    Logger.log([("Navigator unknown link-type received: " + _local_2[1])]);
            }
        }

        function onPerksUpdated(k:PerksUpdatedEvent)
        {
            if (!this._sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                if (((this._mainViewCtrl != null) && (!(this._mainViewCtrl.isPhaseOneNavigator == this.isPerkAllowed("NAVIGATOR_PHASE_ONE_2014")))))
                {
                    this._mainViewCtrl.close();
                }
                context.addLinkEventTracker(this);
            }
            else
            {
                if (this._mainViewCtrl != null)
                {
                    this._mainViewCtrl.close();
                }
                context.removeLinkEventTracker(this);
            }
        }

        public function showToolbarHover(k:Point)
        {
            if (this._toolbarHover == null)
            {
                this._toolbarHover = new ToolbarHoverCtrl(this);
            }
            this._toolbarHover.show(k);
        }

        public function hideToolbarHover(k:Bool)
        {
            if (this._toolbarHover == null)
            {
                return;
            }
            if (k)
            {
                this._toolbarHover._Str_14093();
            }
            else
            {
                this._toolbarHover.hide();
            }
        }

        public var isDoorModeOverriddenInCurrentRoom(get,never):Bool;
public function  get_isDoorModeOverriddenInCurrentRoom():Bool
        {
            return this._catalog.isDoorModeOverriddenInCurrentRoom;
        }

        public function isPerkAllowed(k:String):Bool
        {
            if (this._sessionData != null)
            {
                return this._sessionData.isPerkAllowed(k);
            }
            return false;
        }

        public function canRateRoom():Bool
        {
            if (this.data == null)
            {
                return false;
            }
            return this.data._Str_5090;
        }

        public function _Str_12281(k:Int):Bool
        {
            if (this.data == null)
            {
                return false;
            }
            return this.data._Str_20543(k);
        }

        public function _Str_8458(k:Int):Bool
        {
            if (this.data == null)
            {
                return false;
            }
            return this.data._Str_8458(k);
        }

        public var _Str_8075(get,never):Array<ASAny>;
public function  get__Str_8075():Array<ASAny>
        {
            if (this.data == null)
            {
                return [];
            }
            return this.data._Str_8075;
        }
    }

