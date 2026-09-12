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
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.navigator.transitional.LegacyNavigator;
    import com.sulake.habbo.navigator.view.NavigatorView;
    import com.sulake.habbo.navigator.context.ContextContainer;
    import com.sulake.habbo.navigator.lift.LiftDataContainer;
    import com.sulake.habbo.navigator.context.SearchContextHistoryManager;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultContainer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.navigator.NavigatorCache;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
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
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.habbo.communication.messages.outgoing.newnavigator.NewNavigatorInitComposer;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NavigatorMetaDataParser;
    import com.sulake.habbo.navigator.context.SearchContext;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultList;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultSet;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NavigatorLiftedRoomsParser;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NewNavigatorPreferencesParser;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SavedSearch;
    import com.sulake.habbo.communication.messages.parser.newnavigator.NavigatorSavedSearchesParser;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDetailsData;
    import com.sulake.habbo.communication.messages.outgoing.newnavigator.NewNavigatorSearchComposer;
    import com.sulake.habbo.communication.messages.outgoing.newnavigator.NavigatorAddSavedSearchComposer;
    import com.sulake.habbo.communication.messages.outgoing.newnavigator.NavigatorDeleteSavedSearchComposer;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.habbo.communication.messages.outgoing.navigator.ForwardToSomeRoomMessageComposer;
    import com.sulake.habbo.utils.Base64;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.outgoing.navigator.GetGuestRoomMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.navigator.domain.NavigatorData;
    import com.sulake.habbo.communication.messages.outgoing.preferences.SetNewNavigatorWindowPreferencesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.newnavigator.NavigatorAddCollapsedCategoryMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.newnavigator.NavigatorRemoveCollapsedCategoryMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.newnavigator.NavigatorSetSearchCodeViewModeMessageComposer;

     class HabboNewNavigator extends Component implements IHabboNewNavigator implements  ILinkEventTracker 
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
        var _incomingMessages:NewIncomingMessages;
        var _toolbar:IHabboToolbar;
        var _oldNavigator:HabboNavigator;
        var _legacyNavigator:LegacyNavigator;
        var _initialized:Bool = false;
        var _navigatorView:NavigatorView;
        var _contextContainer:ContextContainer;
        var _liftDataContainer:LiftDataContainer;
        var _searchContextHistoryManager:SearchContextHistoryManager;
        var _currentResults:SearchResultContainer;
        var _groupDetails:Map;
        var _currentResultRoomNameData:Map;
        var _collapsedCategories:Vector<String>;
        var _navigatorCache:NavigatorCache;
        var _lastSearchCode:String = "official_view";
        var _lastFilteringData:String = "";
        var _previousFilterInput:String = "";
        var _newResultsRendered:Bool = false;
        var _noPushToHistoryDueToNavigation:Bool = false;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._groupDetails = new Map();
            this._currentResultRoomNameData = new Map();
            this._collapsedCategories = new Vector<String>(0);
            super(k, _arg_2, _arg_3);
            this._legacyNavigator = new LegacyNavigator(this, this._oldNavigator);
        }

        public static function _Str_6560(k:String, _arg_2:String):String
        {
            return k + ((_arg_2 == "") ? "" : (":" + _arg_2));
        }


        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public var sessionData(get,never):ISessionDataManager;
public function  get_sessionData():ISessionDataManager
        {
            return this._sessionData;
        }

        public var roomSessionManager(get,never):IRoomSessionManager;
public function  get_roomSessionManager():IRoomSessionManager
        {
            return this._roomSessionManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
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
            }), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _oldNavigator = cast(k, HabboNavigator);
                if (_legacyNavigator != null)
                {
                    _legacyNavigator._Str_22899 = _oldNavigator;
                }
            }, true)]));
        }

        override function initComponent()
        {
            this._incomingMessages = new NewIncomingMessages(this);
            context.addLinkEventTracker(this);
            this._navigatorView = new NavigatorView(this);
            this._contextContainer = new ContextContainer(this);
            this._searchContextHistoryManager = new SearchContextHistoryManager(this);
            this._liftDataContainer = new LiftDataContainer(this);
            this._navigatorCache = new NavigatorCache();
            this._communication.connection.send(new NewNavigatorInitComposer());
            this._initialized = true;
        }

        function onHabboToolbarEvent(k:HabboToolbarEvent)
        {
            if (k.type == HabboToolbarEvent.HTE_TOOLBAR_CLICK)
            {
                switch (k.iconId)
                {
                    case HabboToolbarIconEnum.NAVIGATOR:
                        if (!this._sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
                        {
                            if (this._oldNavigator != null)
                            {
                                this._oldNavigator.openNavigator();
                            }
                            return;
                        }
                        this.toggle();
                        return;
                }
            }
        }

        public function initialize(k:NavigatorMetaDataParser)
        {
            this._contextContainer.initialize(k);
        }

        public function onSearchResult(k:SearchResultContainer)
        {
            this._newResultsRendered = false;
            this._currentResults = k;
            this.extractRoomNamesFromResults(k.resultSet);
            if (!this._noPushToHistoryDueToNavigation)
            {
                this._searchContextHistoryManager._Str_23951(new SearchContext(k.searchCodeOriginal, k.filteringData));
            }
            this._navigatorCache._Str_22588(((k.searchCodeOriginal + "/") + k.filteringData), k);
            this._noPushToHistoryDueToNavigation = false;
            if (this._navigatorView.visible)
            {
                this._navigatorView._Str_18091(k, this._previousFilterInput);
            }
        }

        function extractRoomNamesFromResults(k:SearchResultSet)
        {
            var _local_2:SearchResultList = null;
            var _local_3:GuestRoomData = null;
            this._currentResultRoomNameData = new Map();
            final _iter_ = k.blocks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                final _iter_ = _local_2.guestRooms; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    this._currentResultRoomNameData.add(_local_3.flatId, _local_3.roomName);
                }
            }
        }

        
        public var newResultsRendered(get,set):Bool;
public function  get_newResultsRendered():Bool
        {
            return this._newResultsRendered;
        }
public function  set_newResultsRendered(k:Bool):Bool        {
            return this._newResultsRendered = k;
        }

        public function onLiftedRooms(k:NavigatorLiftedRoomsParser)
        {
            this._liftDataContainer.setLiftedRooms(k.liftedRooms);
            this._navigatorView.refreshLiftedRooms();
        }

        public function _Str_23415(k:NewNavigatorPreferencesParser)
        {
            this._navigatorView._Str_23074(k._Str_17736, k._Str_18137, k._Str_17903, k._Str_25666, k._Str_23289);
        }

        public function onSavedSearches(k:NavigatorSavedSearchesParser)
        {
            this._contextContainer._Str_8597 = k._Str_8597.concat(new Vector<SavedSearch>(0));
            this._navigatorView.onSavedSearches(this._contextContainer._Str_8597);
        }

        public function onGroupDetails(k:HabboGroupDetailsData)
        {
            if (this._groupDetails.hasKey(k.groupId))
            {
                this._groupDetails.remove(k.groupId);
            }
            this._groupDetails.add(k.groupId, k);
            this._navigatorView._Str_24313(k.groupId);
        }

        public function _Str_18969(k:Vector<String>)
        {
            this._collapsedCategories = k.concat();
        }

        public var _Str_8273(get,never):Vector<String>;
public function  get__Str_8273():Vector<String>
        {
            return this._collapsedCategories;
        }

        public function _Str_20693(k:Int):HabboGroupDetailsData
        {
            return this._groupDetails.getValue(k);
        }

        public function _Str_25434()
        {
            if (this._searchContextHistoryManager._Str_22168)
            {
                this._noPushToHistoryDueToNavigation = true;
                this._Str_21272(this._searchContextHistoryManager._Str_24998());
            }
            this.trackEventLog("browse.back", "Results");
        }

        public function _Str_20175()
        {
            if (((!(this._lastSearchCode == null)) && (!(this._lastFilteringData == null))))
            {
                this._navigatorCache._Str_25085(((this._lastSearchCode + "/") + this._lastFilteringData));
                this.performSearch(this._lastSearchCode, this._lastFilteringData);
            }
        }

        public function performSearch(k:String, _arg_2:String="", _arg_3:String="")
        {
            this._navigatorView.isBusy = true;
            this._previousFilterInput = _arg_3;
            var _local_4= this._navigatorCache.getEntry(((k + "/") + _arg_2));
            if (_local_4 != null)
            {
                this.onSearchResult(_local_4);
            }
            else
            {
                this._lastSearchCode = k;
                this._lastFilteringData = _arg_2;
                this._communication.connection.send(new NewNavigatorSearchComposer(k, _arg_2));
                this.trackEventLog("search", "Search", _Str_6560(k, _arg_2));
            }
            this.open();
        }

        public function _Str_21272(k:SearchContext)
        {
            this.performSearch(k.searchCode, k.filtering);
        }

        public function _Str_25074(k:String, _arg_2:String)
        {
            if (this._currentResults != null)
            {
                this._communication.connection.send(new NavigatorAddSavedSearchComposer(k, _arg_2));
            }
            this.trackEventLog("savedsearch.add", "SavedSearch", _Str_6560(k, _arg_2));
            this._navigatorView.setLeftPaneVisibility(true);
        }

        public function _Str_25285(k:Int)
        {
            this._communication.connection.send(new NavigatorDeleteSavedSearchComposer(k));
            this.trackEventLog("savedsearch.delete", "SavedSearch");
        }

        function onPerksUpdated(k:PerksUpdatedEvent)
        {
            if (!this._sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                context.removeLinkEventTracker(this);
                if (this._initialized)
                {
                    this._incomingMessages.removeLegacyMessageListeners();
                    this.close();
                }
                return;
            }
            if (!this._initialized)
            {
                this.initComponent();
            }
            else
            {
                context.addLinkEventTracker(this);
                this._incomingMessages.removeLegacyMessageListeners();
                this._incomingMessages.addMessageListeners();
            }
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
                                this._legacyNavigator.goToHomeRoom();
                                
                            default:
                                _local_3 = ASCompat.toInt(_local_2[2]);
                                if (_local_3 > 0)
                                {
                                    this._legacyNavigator.goToPrivateRoom(_local_3);
                                }
                                else
                                {
                                    this.communication.connection.send(new ForwardToSomeRoomMessageComposer(_local_2[2]));
                                }
                        }
                    }
                    return;
                case "search":
                    if (_local_2.length > 2)
                    {
                        this.performSearch("hotel_view", _local_2[2]);
                    }
                    return;
                case "tag":
                    if (_local_2.length > 2)
                    {
                        this.performSearch("hotel_view", _local_2[2]);
                    }
                    return;
                case "tab":
                    if (_local_2.length > 2)
                    {
                        this.performSearch(_local_2[2]);
                    }
                    return;
                case "refresh":
                    if (((!(this._lastSearchCode == null)) && (!(this._lastFilteringData == null))))
                    {
                        this._navigatorCache._Str_25085(((this._lastSearchCode + "/") + this._lastFilteringData));
                        this.performSearch(this._lastSearchCode, this._lastFilteringData, this._previousFilterInput);
                    }
                    else
                    {
                        this.refresh();
                    }
                    return;
                case "report":
                    if (_local_2.length > 3)
                    {
                        this._legacyNavigator._Str_24971(_local_2[2], Base64.decode(_local_2[3]));
                    }
                    return;
                default:
                    Logger.log([("Navigator unknown link-type received: " + _local_2[1])]);
            }
        }

        public function showOwnRooms()
        {
        }

        public function showToolbarHover(k:Point)
        {
        }

        public function hideToolbarHover(k:Bool)
        {
        }

        public var isReady(get,never):Bool;
public function  get_isReady():Bool
        {
            return (!(this._contextContainer == null)) && this._contextContainer.isReady();
        }

        public var _Str_7014(get,never):ContextContainer;
public function  get__Str_7014():ContextContainer
        {
            return this._contextContainer;
        }

        public var _Str_26311(get,never):SearchContextHistoryManager;
public function  get__Str_26311():SearchContextHistoryManager
        {
            return this._searchContextHistoryManager;
        }

        public var _Str_7977(get,never):LiftDataContainer;
public function  get__Str_7977():LiftDataContainer
        {
            return this._liftDataContainer;
        }

        public var _Str_3440(get,never):SearchResultContainer;
public function  get__Str_3440():SearchResultContainer
        {
            return this._currentResults;
        }

        public function goToRoom(k:Int, _arg_2:String="mainview")
        {
            this.communication.connection.send(new GetGuestRoomMessageComposer(k, false, true));
            this._navigatorView.visible = false;
            var _local_3:String = this._currentResultRoomNameData.getValue(k);
            this.trackEventLog("go", _arg_2, (ASCompat.stringAsBool(_local_3) ? _local_3 : ""), k);
        }

        public function _Str_12024(k:Int)
        {
            this.communication.connection.send(new GetExtendedProfileMessageComposer(k));
        }

        public var _Str_25225(get,never):String;
public function  get__Str_25225():String
        {
            return context.configuration.getProperty("image.library.url");
        }

        public function performTagSearch(k:String)
        {
            this.performSearch("hotel_view", ("tag:" + k));
        }

        public function createRoom()
        {
            this._legacyNavigator.roomCreateViewCtrl.show();
        }

        public function open()
        {
            if (!this._sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                return;
            }
            if (this._navigatorView == null)
            {
                return;
            }
            if (!this._navigatorView.visible)
            {
                this._navigatorView.visible = true;
            }
        }

        public function close()
        {
            if (this._navigatorView.visible)
            {
                this._navigatorView.visible = false;
            }
        }

        public function toggle()
        {
            if (!this._sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                return;
            }
            if (this._navigatorView == null)
            {
                return;
            }
            this._navigatorView.visible = (!this._navigatorView.visible);
            if (this._navigatorView.visible)
            {
                this._Str_20175();
            }
        }

        public var mainWindow(get,never):IFrameWindow;
public function  get_mainWindow():IFrameWindow
        {
            return this._navigatorView.mainWindow;
        }

        public function refresh()
        {
            if (this._currentResults != null)
            {
                this._newResultsRendered = false;
                this._navigatorView._Str_18091(this._currentResults);
            }
        }

        public var legacyNavigator(get,never):IHabboNavigator;
public function  get_legacyNavigator():IHabboNavigator
        {
            return this._legacyNavigator;
        }

        public var data(get,never):NavigatorData;
public function  get_data():NavigatorData
        {
            return this._legacyNavigator.data;
        }

        public function sendWindowPreferences(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Bool, _arg_6:Int)
        {
            this._communication.connection.send(new SetNewNavigatorWindowPreferencesMessageComposer(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6));
        }

        public function getGuildInfo(k:Int, _arg_2:Bool=true)
        {
            this._communication.connection.send(new GetHabboGroupDetailsMessageComposer(k, _arg_2));
        }

        public function sendAddCollapsedCategory(k:String)
        {
            this._communication.connection.send(new NavigatorAddCollapsedCategoryMessageComposer(k));
        }

        public function sendRemoveCollapsedCategory(k:String)
        {
            this._communication.connection.send(new NavigatorRemoveCollapsedCategoryMessageComposer(k));
        }

        public function goToHomeRoom()
        {
            this.goToRoom(this._legacyNavigator.data.homeRoomId, "external");
        }

        public function trackEventLog(k:String, _arg_2:String, _arg_3:String="", _arg_4:Int=0)
        {
            if (this._tracking != null)
            {
                this._tracking.trackEventLog("NewNavigator", _arg_2, k, _arg_3, _arg_4);
            }
        }

        public var view(get,never):NavigatorView;
public function  get_view():NavigatorView
        {
            return this._navigatorView;
        }

        public function _Str_25231(k:String, _arg_2:Int)
        {
            this._communication.connection.send(new NavigatorSetSearchCodeViewModeMessageComposer(k, _arg_2));
            this.trackEventLog("browse.toggleviewmode", "ViewMode", "", _arg_2);
        }

        public var habboHelp(get,never):IHabboHelp;
public function  get_habboHelp():IHabboHelp
        {
            return this._habboHelp;
        }

        public function performTextSearch(k:String)
        {
        }

        public function performGuildBaseSearch()
        {
        }

        public function performCompetitionRoomsSearch(k:Int, _arg_2:Int)
        {
        }
    }

