package com.sulake.habbo.navigator.mainview
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Point;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.navigator.TextSearchInputs;
    import flash.utils.Timer;
    import com.sulake.habbo.utils._Str_3942;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.navigator.IViewCtrl;
    import com.sulake.habbo.navigator.domain.Tab;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.habbo.navigator.Util;
    import flash.events.Event;
    import com.sulake.habbo.navigator.events.HabboNavigatorTrackingEvent;
    import com.sulake.habbo.communication.messages.outgoing.navigator.RoomAdEventTabViewedComposer;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.communication.messages.outgoing.navigator.GetPopularRoomTagsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.GetOfficialRoomsMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.navigator.CompetitionRoomsData;
    import com.sulake.habbo.communication.messages.outgoing.navigator.MyFavouriteRoomsSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.MyFriendsRoomsSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.MyRoomHistorySearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.MyRoomsSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.PopularRoomsSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.RoomsWhereMyFriendsAreSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.RoomsWithHighestScoreSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.RoomTextSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.GuildBaseSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.CompetitionRoomsSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.RoomAdSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.MyRoomRightsSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.MyGuildBasesSearchMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.MyRecommendedRoomsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.MyFrequentRoomHistorySearchMessageComposer;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;

     class MainViewCtrl implements ITransitionalMainViewCtrl implements  IUpdateReceiver implements  IDisposable 
    {
        public static inline final SEARCHMSG_SEARCH= 1;
        public static inline final SEARCHMSG_POPTAGS= 2;
        public static inline final SEARCHMSG_OFFICIALROOMS= 4;
        public static inline final SEARCHMSG_CATEGORIESWITHUSERCOUNT= 5;
        static inline final _Str_15647= 1;
        static inline final _Str_10433= 2;
        static inline final _Str_14003= 3;
        static inline final _Str_17528= 4;
        static inline final _Str_4906= 22;
        static inline final _Str_15966= 60;

        final DEFAULT_VIEW_LOCATION:Point = new Point(100, 10);

        var _navigator:HabboNavigator;
        var _mainWindow:IFrameWindow;
        var _content:IWindowContainer;
        var _customContent:IWindowContainer;
        var _footer:IWindowContainer;
        var _listContent:IWindowContainer;
        var _popularTags:PopularTagsListCtrl;
        var _guestRooms:GuestRoomListCtrl;
        var _officialRooms:OfficialRoomListCtrl;
        var _roomAds:RoomAdListCtrl;
        var _categoryListCtrl:CategoryListCtrl;
        var _tabContext:ITabContextWindow;
        var _ignoreNextTabSelectEvent:Bool = false;
        var _blendingStage:Int = 0;
        var _blendCustomContent:Bool = true;
        var _loadCounter:Int = 0;
        var _loadingText:IWindow;
        var _footerHeight:Int = 0;
        var _searchInput:TextSearchInputs;
        var _resizeTimer:Timer;
        var _disposed:Bool = false;
        var _toggle:_Str_3942;
        var _phaseOneNavigator:Bool = false;

        public function new(k:HabboNavigator)        {
            this._navigator = k;
            this._phaseOneNavigator = this._navigator.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_ONE_2014);
            this._popularTags = new PopularTagsListCtrl(this._navigator);
            this._guestRooms = new GuestRoomListCtrl(this._navigator, 0, false);
            this._officialRooms = new OfficialRoomListCtrl(this._navigator);
            this._roomAds = new RoomAdListCtrl(this._navigator, 0, false);
            this._categoryListCtrl = new CategoryListCtrl(this._navigator);
            this._resizeTimer = new Timer(300, 1);
            this._resizeTimer.addEventListener(TimerEvent.TIMER, (this.onResizeTimer : ASAny));
        }

        static function _Str_9327(k:IViewCtrl, _arg_2:Bool)
        {
            var _local_3:IItemListWindow = null;
            var _local_4:IWindow = null;
            if (((k.content == null) || (!k.content.visible)))
            {
                return;
            }
            _local_3 = cast(k.content.findChildByName("item_list"), IItemListWindow);
            _local_4 = k.content.findChildByName("scroller");
            var _local_5:ASAny = (_local_3.scrollableRegion.height > _local_3.height);
            if (_local_4.visible)
            {
                if (!_local_5)
                {
                    _local_4.visible = false;
                    _local_3.width = (_local_3.width + _Str_4906);
                }
            }
            else
            {
                if (_local_5)
                {
                    _local_4.visible = true;
                    _local_3.width = (_local_3.width - _Str_4906);
                }
            }
        }

        public static function _Str_24055(k:IViewCtrl, _arg_2:IWindowContainer)
        {
            var _local_3= k.content.findChildByName("scroller");
            if (((_local_3 == null) || _local_3.visible))
            {
                return;
            }
            _arg_2.width = (_arg_2.width + _Str_4906);
        }


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function _Str_18392()
        {
            if (this._mainWindow == null)
            {
                this._Str_19017();
                return;
            }
            if (((!(this._toggle != null)) || this._toggle.disposed))
            {
                this._toggle = new _Str_3942(this._mainWindow, this._mainWindow.desktop, this._Str_19017, this.close);
            }
            this._toggle.toggle();
        }

        function _Str_19017()
        {
            var k= this._navigator.tabs.getSelected();
            k._Str_5252.navigatorOpenedWhileInTab();
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._disposed = true;
                this._navigator = null;
                if (this._mainWindow != null)
                {
                    this._mainWindow.dispose();
                    this._mainWindow = null;
                }
                if (this._toggle != null)
                {
                    this._toggle.dispose();
                    this._toggle = null;
                }
                if (this._content != null)
                {
                    this._content.dispose();
                    this._content = null;
                }
                if (this._resizeTimer != null)
                {
                    this._resizeTimer.removeEventListener(TimerEvent.TIMER, (this.onResizeTimer : ASAny));
                    this._resizeTimer.reset();
                    this._resizeTimer = null;
                }
                if (this._popularTags != null)
                {
                    this._popularTags.dispose();
                    this._popularTags = null;
                }
                if (this._guestRooms != null)
                {
                    this._guestRooms.dispose();
                    this._guestRooms = null;
                }
                if (this._officialRooms != null)
                {
                    this._officialRooms.dispose();
                    this._officialRooms = null;
                }
                if (this._roomAds != null)
                {
                    this._roomAds.dispose();
                    this._roomAds = null;
                }
                if (this._searchInput != null)
                {
                    this._searchInput.dispose();
                    this._searchInput = null;
                }
            }
        }

        public function open()
        {
            if (this._mainWindow == null)
            {
                this.prepare();
            }
            this.refresh();
            this._mainWindow.visible = true;
            this._mainWindow.y = Std.int(Math.max(this._mainWindow.y, _Str_15966));
            this._mainWindow.activate();
        }

        public function isOpen():Bool
        {
            return (!(this._mainWindow == null)) && this._mainWindow.visible;
        }

        public function close()
        {
            if (this._mainWindow != null)
            {
                if (this._searchInput != null)
                {
                    this._searchInput.dispose();
                    this._searchInput = null;
                }
                if (this._toggle != null)
                {
                    this._toggle.dispose();
                    this._toggle = null;
                }
                this._mainWindow.dispose();
                this._mainWindow = null;
                this._tabContext = null;
                this._content = null;
                this._customContent = null;
                this._listContent = null;
                this._footer = null;
                this._loadingText = null;
                this._popularTags.content = null;
                this._guestRooms.content = null;
                this._officialRooms.content = null;
                this._categoryListCtrl.content = null;
                this._roomAds.content = null;
                this._footerHeight = 0;
            }
        }

        public var mainWindow(get,never):IFrameWindow;
public function  get_mainWindow():IFrameWindow
        {
            return this._mainWindow;
        }

        function prepare()
        {
            var _local_4:Tab = null;
            var _local_5:Array<ASAny> = null;
            var _local_6:ITabButtonWindow = null;
            var _local_7:ITabButtonWindow = null;
            var k= this._navigator.getBoolean("eventinfo.enabled");
            var _local_2 = false;
            this._mainWindow = cast(this._navigator.getXmlWindow((this._phaseOneNavigator ? "grs_main_window" : "grs_main_window_new")), IFrameWindow);
            this._mainWindow.color = 4296112;
            this._tabContext = cast(this._mainWindow.findChildByName("tab_context"), ITabContextWindow);
            this._content = cast(this._mainWindow.findChildByName("tab_content"), IWindowContainer);
            this._customContent = cast(this._mainWindow.findChildByName("custom_content"), IWindowContainer);
            this._listContent = cast(this._mainWindow.findChildByName("list_content"), IWindowContainer);
            this._footer = cast(this._mainWindow.findChildByName("custom_footer"), IWindowContainer);
            this._loadingText = this._mainWindow.findChildByName("loading_text");
            var _local_3= this._mainWindow.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onWindowClose);
            }
            this._mainWindow.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_22608);
            if (((!k) || (!this._phaseOneNavigator)))
            {
                _local_5 = [];
                while (this._tabContext.numTabs > 0)
                {
                    _local_6 = this._tabContext.getTabButtonAt(0);
                    _local_5.push(_local_6);
                    this._tabContext._Str_5897(_local_6);
                }
                if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
                {
_local_6  = _tmp_;
                    if ((((_local_6.id == Tabs.TAB_EVENTS) && (!k)) || ((_local_6.id == Tabs.TAB_CATEGORIES) && (!_local_2))))
                    {
                    }
                    else
                    {
                        this._tabContext._Str_5377(_local_6);
                    }
                }
            }
            final _iter_ = this._navigator.tabs.tabs; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_7 = this._tabContext._Str_20824(_local_4.id);
                if (_local_7 != null)
                {
                    _local_7.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onTabSelected);
                    _local_4.button = _local_7;
                }
            }
            this._mainWindow.scaler.setParamFlag(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TRIGGER, false);
            this._mainWindow.scaler.setParamFlag(WindowParam.WINDOW_PARAM_VERTICAL_MOUSE_SCALING_TRIGGER, true);
            this._mainWindow.position = this.DEFAULT_VIEW_LOCATION;
            this._Str_22839();
        }

        function _Str_22839()
        {
            var _local_3:IWindowContainer = null;
            var k= "search_header";
            if (this._searchInput == null)
            {
                _local_3 = Std.downcast(this._mainWindow.findChildByName(k) , IWindowContainer);
                this._searchInput = new TextSearchInputs(this._navigator, _local_3);
            }
            var _local_2= Std.downcast(this._mainWindow.findChildByName(k) , IWindowContainer);
            _local_2.visible = true;
        }

        public function refresh()
        {
            if (this._mainWindow == null)
            {
                return;
            }
            this._Str_23841();
            this.refreshCustomContent();
            this._Str_24816(true);
            this.refreshFooter();
            this._customContent.height = Util.getLowestPoint(this._customContent);
            this._footer.height = Util.getLowestPoint(this._footer);
            var k= this._listContent.y;
            Util.moveChildrenToColumn(this._content, ["custom_content", "list_content"], this._customContent.y, 8);
            this._listContent.height = ((((this._listContent.height + k) - this._listContent.y) - this._footer.height) + this._footerHeight);
            Util.moveChildrenToColumn(this._content, ["list_content", "custom_footer"], this._listContent.y, 0);
            this._footerHeight = this._footer.height;
            this.onResizeTimer(null);
        }

        function _Str_23841()
        {
            var k= this._navigator.tabs.getSelected();
            var _local_2= this._tabContext.selector.getSelected();
            if ((k.button : ASAny) != (_local_2 : ASAny))
            {
                this._ignoreNextTabSelectEvent = true;
                this._tabContext.selector.setSelected(k.button);
            }
        }

        function refreshCustomContent()
        {
            Util.hideChildren(this._customContent);
            var k= this._navigator.tabs.getSelected();
            k._Str_5252.refreshCustomContent(this._customContent);
            if (Util._Str_13639(this._customContent))
            {
                this._customContent.visible = true;
            }
            else
            {
                this._customContent.visible = false;
                this._customContent.blend = 1;
            }
        }

        function refreshFooter()
        {
            Util.hideChildren(this._footer);
            var k= this._navigator.tabs.getSelected();
            k._Str_5252.refreshFooter(this._footer);
            this._footer.visible = Util._Str_13639(this._footer);
        }

        function _Str_24816(k:Bool)
        {
            Util.hideChildren(this._listContent);
            var _local_2= this._navigator.tabs.getSelected();
            var _local_3= (this._navigator.data.guestRoomSearchArrived && (_local_2.defaultSearchType == Tabs.SEARCHTYPE_ROOM_ADS));
            this._Str_25672(k, _local_3);
            this._Str_24977(k, (!_local_3));
            this._Str_23623(k, this._navigator.data.popularTagsArrived);
            this._Str_25576(k, this._navigator.data._Str_23411);
            this._Str_20399(k, this._navigator.data._Str_26351);
        }

        function _Str_24977(k:Bool, _arg_2:Bool)
        {
            this._Str_3836(k, _arg_2, this._guestRooms, "guest_rooms");
        }

        function _Str_23623(k:Bool, _arg_2:Bool)
        {
            this._Str_3836(k, _arg_2, this._popularTags, "popular_tags");
        }

        function _Str_25576(k:Bool, _arg_2:Bool)
        {
            this._Str_3836(k, _arg_2, this._officialRooms, "official_rooms");
        }

        function _Str_25672(k:Bool, _arg_2:Bool)
        {
            this._Str_3836(k, _arg_2, this._roomAds, "room_ads");
        }

        function _Str_20399(k:Bool, _arg_2:Bool)
        {
            this._Str_3836(k, _arg_2, this._categoryListCtrl, "categories_container");
        }

        function _Str_3836(k:Bool, _arg_2:Bool, _arg_3:IViewCtrl, _arg_4:String)
        {
            var _local_5:IWindow = null;
            if (_arg_2)
            {
                if (_arg_3.content == null)
                {
                    _local_5 = this._listContent.findChildByName(_arg_4);
                    _arg_3.content = cast(_local_5, IWindowContainer);
                }
                if (k)
                {
                    _arg_3.refresh();
                }
                _arg_3.content.visible = true;
            }
        }

        function onWindowClose(k:WindowEvent)
        {
            Logger.log(["Close navigator window"]);
            this.close();
        }

        function onTabSelected(k:WindowEvent)
        {
            var _local_2= k.target;
            var _local_3= _local_2.id;
            if (this._ignoreNextTabSelectEvent)
            {
                this._ignoreNextTabSelectEvent = false;
                return;
            }
            var _local_4= this._navigator.tabs.getTab(_local_3);
            _local_4.sendSearchRequest();
            switch (_local_4.id)
            {
                case Tabs.TAB_EVENTS:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_EVENTS));
                    this._navigator.send(new RoomAdEventTabViewedComposer());
                    return;
                case Tabs.TAB_ME:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_ME));
                    return;
                case Tabs.TAB_OFFICIAL:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_OFFICIAL));
                    return;
                case Tabs.TAB_ROOMS:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_ROOMS));
                    return;
                case Tabs.TAB_SEARCH:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCH));
                    return;
                case Tabs.TAB_CATEGORIES:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_CATEGORIES));
                    return;
            }
        }

        public function reloadRoomList(k:Int):Bool
        {
            ErrorReportStorage.addDebugData("MainViewCtrl", "Reloading RoomList");
            if (((this.isOpen() && (!(this._navigator.data.guestRoomSearchResults == null))) && (this._navigator.data.guestRoomSearchResults.searchType == k)))
            {
                this.startSearch(this._navigator.tabs.getSelected().id, k, "");
                return true;
            }
            return false;
        }

        public function startSearch(k:Int, _arg_2:Int, _arg_3:String="-1", _arg_4:Int=1)
        {
            var _local_5= this._navigator.tabs.getSelected();
            this._navigator.tabs.setSelectedTab(k);
            var _local_6= this._navigator.tabs.getSelected();
            ErrorReportStorage.addDebugData("StartSearch", ((("Start search " + Std.string(_local_5.id)) + " => ") + Std.string(_local_6.id)));
            if (this._phaseOneNavigator)
            {
                if (_arg_3.substr(0, 1) == "#")
                {
                    _arg_2 = Tabs.SEARCHTYPE_TAG_SEARCH;
                    _arg_3 = _arg_3.substr(1, (_arg_3.length - 1));
                }
            }
            this._blendCustomContent = (!(_local_5 == _local_6));
            if (_local_5 != _local_6)
            {
                _local_6._Str_5252.tabSelected();
            }
            this._navigator.data._Str_23771();
            if (_arg_4 == SEARCHMSG_SEARCH)
            {
                this._navigator.send(this._Str_23726(_arg_2, _arg_3));
            }
            else
            {
                if (_arg_4 == SEARCHMSG_POPTAGS)
                {
                    this._navigator.send(new GetPopularRoomTagsMessageComposer());
                }
                else
                {
                    if (_arg_4 != SEARCHMSG_CATEGORIESWITHUSERCOUNT)
                    {
                        this._navigator.send(new GetOfficialRoomsMessageComposer(this._navigator.data._Str_6357));
                    }
                }
            }
            if (!this.isOpen())
            {
                this.open();
                this._blendingStage = _Str_10433;
                this._listContent.blend = 0;
                if (this._customContent.visible)
                {
                    this._customContent.blend = 0;
                    this._footer.blend = 0;
                }
            }
            else
            {
                this._blendingStage = _Str_15647;
            }
            this._loadCounter = 0;
            this._navigator.registerUpdateReceiver(this, 2);
            this._Str_24170(_arg_2);
            this._navigator.data._Str_4079 = null;
            if (this._phaseOneNavigator)
            {
                if (((!(this.searchInput == null)) && (!(_arg_3 == "-1"))))
                {
                    if (_arg_2 != Tabs.SEARCHTYPE_POPULAR_ROOMS)
                    {
                        this.searchInput.setText(_arg_3, _arg_2);
                    }
                }
            }
        }

        function _Str_24170(k:Int)
        {
            switch (k)
            {
                case Tabs.SEARCHTYPE_MY_FAVOURITES:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_FAVOURITES));
                    return;
                case Tabs.SEARCHTYPE_MY_FRIENDS_ROOMS:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_FRIENDS_ROOMS));
                    return;
                case Tabs.SEARCHTYPE_MY_HISTORY:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_HISTORY));
                    return;
                case Tabs.SEARCHTYPE_MY_ROOMS:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_ROOMS));
                    return;
                case Tabs.SEARCHTYPE_OFFICIALROOMS:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_OFFICIALROOMS));
                    return;
                case Tabs.SEARCHTYPE_POPULAR_ROOMS:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_POPULAR_ROOMS));
                    return;
                case Tabs.SEARCHTYPE_ROOMS_WHERE_MY_FRIENDS_ARE:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_ROOMS_WHERE_MY_FRIENDS_ARE));
                    return;
                case Tabs.SEARCHTYPE_ROOMS_WITH_HIGHEST_SCORE:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_ROOMS_WITH_HIGHEST_SCORE));
                    return;
                case Tabs.SEARCHTYPE_TAG_SEARCH:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_TAG_SEARCH));
                    return;
                case Tabs.SEARCHTYPE_TEXT_SEARCH:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_TEXT_SEARCH));
                    return;
                case Tabs.SEARCHTYPE_FREQUENT_HISTORY:
                    this._navigator.events.dispatchEvent(new Event(HabboNavigatorTrackingEvent.HABBO_NAVIGATOR_TRACKING_EVENT_SEARCHTYPE_MY_FREQUENT_HISTORY));
                    return;
            }
        }

        function _Str_23726(k:Int, _arg_2:String):IMessageComposer
        {
            var _local_3:CompetitionRoomsData = null;
            switch (k)
            {
                case Tabs.SEARCHTYPE_MY_FAVOURITES:
                    return new MyFavouriteRoomsSearchMessageComposer();
                case Tabs.SEARCHTYPE_MY_FRIENDS_ROOMS:
                    return new MyFriendsRoomsSearchMessageComposer();
                case Tabs.SEARCHTYPE_MY_HISTORY:
                    return new MyRoomHistorySearchMessageComposer();
                case Tabs.SEARCHTYPE_MY_ROOMS:
                    return new MyRoomsSearchMessageComposer();
                case Tabs.SEARCHTYPE_POPULAR_ROOMS:
                    return new PopularRoomsSearchMessageComposer(_arg_2, this._navigator.data._Str_6357);
                case Tabs.SEARCHTYPE_ROOMS_WHERE_MY_FRIENDS_ARE:
                    return new RoomsWhereMyFriendsAreSearchMessageComposer();
                case Tabs.SEARCHTYPE_ROOMS_WITH_HIGHEST_SCORE:
                    return new RoomsWithHighestScoreSearchMessageComposer(this._navigator.data._Str_6357);
                case Tabs.SEARCHTYPE_TAG_SEARCH:
                    return new RoomTextSearchMessageComposer(("tag:" + _arg_2));
                case Tabs.SEARCHTYPE_TEXT_SEARCH:
                    return new RoomTextSearchMessageComposer(_arg_2);
                case Tabs.SEARCHTYPE_GROUP_NAME_SEARCH:
                    return new RoomTextSearchMessageComposer(("group:" + _arg_2));
                case Tabs.SEARCHTYPE_ROOM_NAME_SEARCH:
                    return new RoomTextSearchMessageComposer(("roomname:" + _arg_2));
                case Tabs.SEARCHTYPE_GUILD_BASES:
                    return new GuildBaseSearchMessageComposer(this._navigator.data._Str_6357);
                case Tabs.SEARCHTYPE_COMPETITION_ROOMS:
                    _local_3 = this._navigator.data._Str_4079;
                    return new CompetitionRoomsSearchMessageComposer(_local_3.goalId, _local_3.pageIndex);
                case Tabs.SEARCHTYPE_ROOM_ADS
                   | Tabs.SEARCHTYPE_NEW_ROOM_ADS:
                    return new RoomAdSearchMessageComposer(this._navigator.data._Str_6357, k);
                case Tabs.SEARCHTYPE_ROOMS_WITH_RIGHTS:
                    return new MyRoomRightsSearchMessageComposer();
                case Tabs.SEARCHTYPE_MY_GUILD_BASES:
                    return new MyGuildBasesSearchMessageComposer();
                case Tabs.SEARCHTYPE_BY_OWNER:
                    return new RoomTextSearchMessageComposer(("owner:" + _arg_2));
                case Tabs.SEARCHTYPE_RECOMMENDED_ROOMS:
                    return new MyRecommendedRoomsMessageComposer();
                case Tabs.SEARCHTYPE_FREQUENT_HISTORY:
                    return new MyFrequentRoomHistorySearchMessageComposer();
            }
            Logger.log([("No message for searchType: " + Std.string(k))]);
            return null;
        }

        public function update(k:UInt)
        {
            var _local_3 = Math.NaN;
            if (this._listContent == null)
            {
                return;
            }
            var _local_2= (k / 150);
            if (this._blendingStage == _Str_15647)
            {
                _local_3 = Math.min(1, Math.max(0, (this._listContent.blend - _local_2)));
                this._listContent.blend = _local_3;
                this._customContent.blend = (this._blendCustomContent ? _local_3 : 1);
                this._footer.blend = (this._blendCustomContent ? _local_3 : 1);
                if (_local_3 == 0)
                {
                    this._blendingStage = _Str_10433;
                }
            }
            else
            {
                if (this._blendingStage == _Str_10433)
                {
                    if ((this._loadCounter % 10) == 1)
                    {
                        this._loadingText.visible = (!this._loadingText.visible);
                    }
                    this._loadCounter++;
                    if (!this._navigator.data._Str_19838())
                    {
                        this._blendingStage = _Str_14003;
                    }
                }
                else
                {
                    if (this._blendingStage == _Str_14003)
                    {
                        this.refresh();
                        this._blendingStage = _Str_17528;
                    }
                    else
                    {
                        this._loadingText.visible = false;
                        _local_3 = Math.min(1, Math.max(0, (this._listContent.blend + _local_2)));
                        this._listContent.blend = _local_3;
                        this._customContent.blend = (this._blendCustomContent ? _local_3 : 1);
                        this._footer.blend = (this._blendCustomContent ? _local_3 : 1);
                        if (this._listContent.blend >= 1)
                        {
                            this._navigator.removeUpdateReceiver(this);
                        }
                    }
                }
            }
        }

        function _Str_22608(k:WindowEvent)
        {
            var _local_2= k.target;
            if ((_local_2 : ASAny) != (this._mainWindow : ASAny))
            {
                return;
            }
            if (!this._resizeTimer.running)
            {
                this._resizeTimer.reset();
                this._resizeTimer.start();
            }
        }

        function onResizeTimer(k:TimerEvent)
        {
            _Str_9327(this._popularTags, false);
            _Str_9327(this._guestRooms, false);
            _Str_9327(this._roomAds, false);
            if (this._navigator.isPerkAllowed("NAVIGATOR_PHASE_ONE_2014"))
            {
            }
        }

        public var searchInput(get,never):TextSearchInputs;
public function  get_searchInput():TextSearchInputs
        {
            return this._searchInput;
        }

        public function openAtPosition(k:Point)
        {
            this._Str_19017();
            if (k != null)
            {
                this._mainWindow.position = k;
            }
            else
            {
                if (this._mainWindow.position.x == 0)
                {
                    this._mainWindow.position = this.DEFAULT_VIEW_LOCATION;
                }
            }
        }

        public var isPhaseOneNavigator(get,never):Bool;
public function  get_isPhaseOneNavigator():Bool
        {
            return this._phaseOneNavigator;
        }
    }

