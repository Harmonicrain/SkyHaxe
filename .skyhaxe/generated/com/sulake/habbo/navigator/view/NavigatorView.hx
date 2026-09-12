package com.sulake.habbo.navigator.view
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.habbo.navigator.view.search.SearchView;
    import com.sulake.habbo.navigator.view.search.results.BlockResultsView;
    import com.sulake.habbo.navigator.view.search.results.RoomEntryElementFactory;
    import com.sulake.habbo.navigator.view.search.results.CategoryElementFactory;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import flash.geom.Rectangle;
    import com.sulake.habbo.navigator.view.search.ViewMode;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SavedSearch;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultContainer;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.habbo.navigator.view.search.results.ResultsModeEnum;

     class NavigatorView implements IUpdateReceiver 
    {
        static inline final _Str_16404:UInt = 4000;
        static inline final _Str_6985= 578;
        static inline final _Str_15385= 115;
        static inline final _Str_18101= 7;
        static inline final _Str_17599= 7;

        var _habboNewNavigator:HabboNewNavigator;
        var _liftView:LiftView;
        var _Str_8068:QuickLinksView;
        var _Str_9680:SearchView;
        var _Str_3208:BlockResultsView;
        var _Str_4128:RoomEntryElementFactory;
        var _Str_4787:CategoryElementFactory;
        var _Str_4000:TopViewSelector;
        var _roomInfoPopup:RoomInfoPopup;
        var _Str_24732:IBorderWindow;
        var _Str_25144:IBorderWindow;
        var _Str_25621:IBorderWindow;
        var _window:IWindowContainer;
        var _Str_16928:Bool = false;
        var _Str_13838:UInt = 0;
        var _Str_4451:Int = -1;
        var _Str_4599:Int = -1;
        var _lastWindowWidth:Int = -1;
        var _lastWindowHeight:Int = -1;
        var _Str_11769:Bool = false;
        var _Str_16641:Int = -1;
        var _Str_13354:Int = 4000;
        var _Str_23677:Bool = false;
        var _Str_8802:Int = 0;
        var _Str_17392:Int = 0;
        var _Str_3380:IWindow;
        var _Str_20831:Int = 0;
        var _Str_16596:Rectangle;

        public function new(k:HabboNewNavigator)
        {
            this._Str_13838 = flash.Lib.getTimer();
            this._Str_16596 = new Rectangle();
            this._habboNewNavigator = k;
        }

        
        public var visible(get,set):Bool;
public function  set_visible(k:Bool):Bool        {
            if ((k && this._habboNewNavigator.isReady))
            {
                if (this._Str_4128 == null)
                {
                    this._Str_4128 = new RoomEntryElementFactory(this._habboNewNavigator);
                }
                if (this._Str_4787 == null)
                {
                    this._Str_4787 = new CategoryElementFactory(this._habboNewNavigator, this._Str_4128);
                }
                this.onGroupDetails();
                if (this._window == null)
                {
                    this.createMainWindow();
                    this._habboNewNavigator.registerUpdateReceiver(this, 1000);
                    this._Str_8068._Str_22170(this._habboNewNavigator._Str_7014._Str_8597);
                }
                if (this._habboNewNavigator._Str_3440 != null)
                {
                    this._Str_18091(this._habboNewNavigator._Str_3440);
                }
                else
                {
                    if (!this._Str_16928)
                    {
                        this._habboNewNavigator.performSearch(ViewMode.OFFICIAL_VIEW);
                    }
                }
                this._window.activate();
            }
            else
            {
                if (this._roomInfoPopup != null)
                {
                    this._roomInfoPopup.show(false);
                }
            }
            if (this._window != null)
            {
                this._window.visible = k;
            }
return k;
        }
public function  get_visible():Bool
        {
            if (this._window != null)
            {
                return this._window.visible;
            }
            return false;
        }

        public function _Str_23074(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Bool, _arg_5:Int)
        {
            if (this._window != null)
            {
                this.setLeftPaneVisibility((!_arg_4));
                this._window.x = k;
                this._window.y = _arg_2;
                this._window.height = _arg_3;
            }
            else
            {
                this._Str_4451 = k;
                this._Str_4599 = _arg_2;
                this._lastWindowHeight = _arg_3;
                this._Str_11769 = !_arg_4;
            }
        }

        public function onSavedSearches(k:Vector<SavedSearch>)
        {
            if (this._Str_8068 != null)
            {
                this._Str_8068._Str_22170(k);
            }
        }

        function onGroupDetails()
        {
            if (this._Str_3208 == null)
            {
                this._Str_3208 = new BlockResultsView(this._habboNewNavigator);
                this._Str_3208._Str_24528 = this._Str_4787;
                this._Str_4787._Str_23184 = this._Str_3208;
            }
            if (this._Str_9680 == null)
            {
                this._Str_9680 = new SearchView(this._habboNewNavigator);
            }
            if (this._Str_8068 == null)
            {
                this._Str_8068 = new QuickLinksView(this._habboNewNavigator);
            }
            if (this._liftView == null)
            {
            }
            if (this._Str_4000 == null)
            {
                this._Str_4000 = new TopViewSelector(this._habboNewNavigator);
            }
        }

        public function _Str_18091(k:SearchResultContainer, _arg_2:String="")
        {
            var _local_3 = 0;
            if (this._habboNewNavigator.newResultsRendered)
            {
                return;
            }
            if (((!(this._Str_4128 != null)) || (!(this._Str_3208 != null))))
            {
                return;
            }
            this._Str_4128.viewMode = ViewMode._Str_20005(k.searchCodeOriginal);
            this._Str_3208._Str_22947();
            if (this._habboNewNavigator._Str_7014._Str_23059(k.searchCodeOriginal))
            {
                _local_3 = this._habboNewNavigator._Str_7014._Str_9965().indexOf(k.searchCodeOriginal);
                if (_local_3 != -1)
                {
                    this._Str_4000._Str_12925(_local_3);
                }
            }
            this._window.findChildByName("create_room").procedure = this._Str_25038;
            this._window.findChildByName("random_room_border").visible = false;
            this._window.findChildByName("promote_room_border").visible = false;
            if (((k.searchCodeOriginal == ViewMode.ROOMADS_VIEW) || (k.searchCodeOriginal == ViewMode.MYWORLD_VIEW)))
            {
                this._window.findChildByName("promote_room_border").visible = true;
                this._window.findChildByName("promote_room").procedure = this._Str_23064;
            }
            else
            {
                this._window.findChildByName("random_room_border").visible = true;
                this._window.findChildByName("random_room").procedure = this._Str_22366;
            }
            this._Str_9680._Str_22850(k.filteringData, _arg_2);
            this._habboNewNavigator.newResultsRendered = true;
            this.isBusy = false;
            if (this._roomInfoPopup != null)
            {
                this._roomInfoPopup.show(false);
            }
        }

        public function _Str_24940():String
        {
            if (this._Str_9680 != null)
            {
                return this._Str_9680._Str_25291;
            }
            return null;
        }

        public function refreshLiftedRooms()
        {
            if (this._liftView != null)
            {
                this._liftView.refresh();
            }
        }

        public function _Str_15353(k:GuestRoomData, _arg_2:Int, _arg_3:Int, _arg_4:Bool=false)
        {
            this._Str_23677 = true;
            if (this._window == null)
            {
                return;
            }
            if (this._roomInfoPopup == null)
            {
                this._roomInfoPopup = new RoomInfoPopup(this._habboNewNavigator);
            }
            if ((this._roomInfoPopup.visible && (!_arg_4)))
            {
                this._roomInfoPopup.show(false);
            }
            else
            {
                this._roomInfoPopup._Str_5479(k);
                if (((!(k.habboGroupId == 0)) && (this._habboNewNavigator._Str_20693(k.habboGroupId) == null)))
                {
                    this._habboNewNavigator.getGuildInfo(k.habboGroupId, false);
                    this._Str_16641 = k.habboGroupId;
                }
                this._roomInfoPopup._Str_23392(true, _arg_2, _arg_3);
                this._habboNewNavigator.trackEventLog("browse.openroominfo", "Results", k.roomName, k.flatId);
                this._Str_13354 = ASCompat.toInt(_Str_16404);
            }
        }

        public var mainWindow(get,never):IFrameWindow;
public function  get_mainWindow():IFrameWindow
        {
            return Std.downcast(this._window , IFrameWindow);
        }

        
        public var isBusy(get,set):Bool;
public function  set_isBusy(k:Bool):Bool        {
            if (this._window != null)
            {
                this._window.caption = (k ? "${navigator.title.is.busy}" : "${navigator.title}");
                this._window.findChildByName("search_waiting_for_results_mask").visible = k;
            }
            return this._Str_16928 = k;
        }
public function  get_isBusy():Bool
        {
            return this._Str_16928;
        }

        function createMainWindow()
        {
            var k= cast(this._habboNewNavigator.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(this._habboNewNavigator.assets.getAssetByName("navigator_frame_2_xml").content)), IWindowContainer);
            cast(k.findChildByName("block_results"), IScrollableListWindow).autoHideScrollBar = false;
            var _local_2= cast(k.findChildByName("navigator_entry_row_container"), IWindowContainer);
            this._Str_4128._Str_23915 = cast(_local_2.clone(), IWindowContainer);
            _local_2.destroy();
            var _local_3= cast(k.findChildByName("navigator_entry_tile_container").clone(), IItemListWindow);
            var _local_4= cast(_local_3.getListItemByName("navigator_entry_tile").clone(), IWindowContainer);
            this._Str_4128._Str_24632 = _local_4;
            _local_3.destroyListItems();
            this._Str_4128._Str_25029 = _local_3;
            cast(k.findChildByName("category_content"), IItemListWindow).destroyListItems();
            var _local_5= cast(k.findChildByName("category_container"), IWindowContainer);
            this._Str_4787._Str_25135 = cast(_local_5.clone(), IWindowContainer);
            cast(k.findChildByName("block_results"), IItemListWindow).removeListItemAt(0);
            _local_5.destroy();
            var _local_6= cast(k.findChildByName("category_container_collapsed"), IWindowContainer);
            this._Str_4787._Str_23119 = cast(_local_6.clone(), IWindowContainer);
            cast(k.findChildByName("block_results"), IItemListWindow).removeListItemAt(0);
            _local_6.destroy();
            var _local_7= cast(k.findChildByName("no_results_container"), IWindowContainer);
            this._Str_4787._Str_24754 = cast(_local_7.clone(), IWindowContainer);
            cast(k.findChildByName("block_results"), IItemListWindow).removeListItemAt(0);
            _local_7.destroy();
            this._Str_3208.itemList = cast(k.findChildByName("block_results"), IItemListWindow);
            this._Str_9680.container = cast(k.findChildByName("search_tools"), IWindowContainer);
            var _local_8= cast(k.findChildByName("quick_link"), IRegionWindow);
            _local_8.findChildByName("quick_link_text").caption = "";
            this._Str_8068.template = cast(_local_8.clone(), IRegionWindow);
            this._Str_8068.itemList = cast(k.findChildByName("quicklinks_list"), IItemListWindow);
            cast(k.findChildByName("quicklinks_list"), IItemListWindow).removeListItems();
            _local_8.destroy();
            var _local_9= cast(k.findChildByName("top_view_select_tab_context"), ITabContextWindow);
            var _local_10= cast(_local_9.getTabButtonAt(0).clone(), ITabButtonWindow);
            this._Str_4000.template = _local_10;
            this._Str_4000._Str_23159 = _local_9;
            _local_9._Str_5897(_local_10);
            this._Str_4000.refresh();
            this._Str_24732 = cast(k.findChildByName("create_room_border").clone(), IBorderWindow);
            cast(k.findChildByName("left_pane"), IItemListWindow).removeListItem(k.findChildByName("create_room_border"));
            this._Str_25144 = cast(k.findChildByName("promote_room_border").clone(), IBorderWindow);
            cast(k.findChildByName("left_pane"), IItemListWindow).removeListItem(k.findChildByName("promote_room_border"));
            this._Str_25621 = cast(k.findChildByName("random_room_border").clone(), IBorderWindow);
            cast(k.findChildByName("left_pane"), IItemListWindow).removeListItem(k.findChildByName("random_room_border"));
            this._Str_20831 = k.findChildByName("left_pane").x;
            k.findChildByName("refreshButton").procedure = this._Str_22805;
            k.findChildByName("header_button_close").procedure = this._Str_25010;
            this._Str_8802 = _Str_18101;
            k.findChildByName("temp_back").procedure = this._Str_25734;
            this._Str_3380 = k.findChildByName("right_pane");
            this._Str_17392 = this._Str_3380.x;
            this._window = k;
            this.setLeftPaneVisibility(false);
            if (((this._Str_4451 == -1) && (this._Str_4599 == -1)))
            {
                this._Str_4451 = this._window.x;
                this._Str_4599 = this._window.y;
                this._lastWindowWidth = this._window.width;
                this._lastWindowHeight = this._window.height;
            }
            else
            {
                if (this._Str_11769)
                {
                    this.setLeftPaneVisibility(true);
                }
                this._window.x = this._Str_4451;
                this._window.y = this._Str_4599;
                this._window.height = this._lastWindowHeight;
            }
            this._Str_13838 = flash.Lib.getTimer();
        }

        function _Str_22805(k:WindowEvent, _arg_2:IWindow)
        {
            if (((k.type == WindowMouseEvent.CLICK) && (_arg_2.name == "refreshButton")))
            {
                this._habboNewNavigator._Str_20175();
            }
        }

        function _Str_25010(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "header_button_close")
                {
                    this.visible = false;
                }
            }
        }

        function _Str_25038(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._habboNewNavigator.createRoom();
                if (this._roomInfoPopup != null)
                {
                    this._roomInfoPopup.show(false);
                }
            }
        }

        function _Str_23064(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._habboNewNavigator.context.createLinkEvent("catalog/open/room_ad");
                if (this._roomInfoPopup != null)
                {
                    this._roomInfoPopup.show(false);
                }
            }
        }

        function _Str_22366(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._habboNewNavigator.context.createLinkEvent("navigator/goto/random_friending_room");
                if (this._roomInfoPopup != null)
                {
                    this._roomInfoPopup.show(false);
                }
                this.visible = false;
            }
        }

        function _Str_25734(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:IWindow = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._window.findChildByName("left_pane");
                this.setLeftPaneVisibility((!_local_3.visible));
                if (this._roomInfoPopup != null)
                {
                    this._roomInfoPopup.show(false);
                }
            }
        }

        public function setLeftPaneVisibility(k:Bool)
        {
            var _local_5 = 0;
            var _local_2= this._window.findChildByName("left_pane");
            var _local_3= ((this._Str_17392 - this._Str_20831) + _Str_17599);
            this._Str_3380.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_FIXED, true);
            this._Str_3380.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_STRETCH, false);
            if (!k)
            {
                _local_2.visible = false;
                this._Str_3380.x = this._Str_8802;
                this._window.limits.minWidth = ((this._window.width - _local_3) + this._Str_8802);
                this._window.limits.maxWidth = ((this._window.width - _local_3) + this._Str_8802);
                this._window.width = ((this._window.width - _local_3) + this._Str_8802);
            }
            else
            {
                _local_2.visible = true;
                this._Str_3380.x = this._Str_17392;
                _local_5 = ((this._window.width + _local_3) - this._Str_8802);
                this._window.limits.minWidth = ((_local_5 > _Str_6985) ? _Str_6985 : _local_5);
                this._window.limits.maxWidth = ((_local_5 > _Str_6985) ? _Str_6985 : _local_5);
                this._window.width = ((_local_5 > _Str_6985) ? _Str_6985 : _local_5);
            }
            this._Str_3380.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_FIXED, false);
            this._Str_3380.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_STRETCH, true);
            this._window.findChildByName("left_hide_container").visible = k;
            this._window.findChildByName("left_show_container").visible = (!k);
            var _local_4= Std.int(k ? _Str_15385 : Std.int(_Str_15385 - (_local_3 / 2)));
            this._window.findChildByName("top_view_select_tab_context").x = _local_4;
        }

        function _Str_24575()
        {
            this._window.x = Std.int(Math.max(0, this._window.x));
            this._window.y = Std.int(Math.max(0, this._window.y));
            if (this._window.desktop != null)
            {
                this._window.x = Std.int(Math.min((this._window.desktop.width - this._window.width), this._window.x));
                this._window.y = Std.int(Math.min((this._window.desktop.height - this._window.height), this._window.y));
            }
        }

        function sendWindowPreferences()
        {
            this._Str_4451 = this._window.x;
            this._Str_4599 = this._window.y;
            this._lastWindowWidth = this._window.width;
            this._lastWindowHeight = this._window.height;
            this._Str_11769 = this._window.findChildByName("left_pane").visible;
            this._Str_13838 = flash.Lib.getTimer();
            this._habboNewNavigator.sendWindowPreferences(this._Str_4451, this._Str_4599, this._lastWindowWidth, this._lastWindowHeight, this._Str_11769, ResultsModeEnum._Str_6023);
            this._habboNewNavigator.trackEventLog("windowsettings", "Interface", ((Std.string(this._window.width) + " x ") + Std.string(this._window.height)));
        }

        var _Str_25319(get,never):Bool;
function  get__Str_25319():Bool
        {
            if (this._Str_11769 != this._window.findChildByName("left_pane").visible)
            {
                return true;
            }
            if (this._Str_4451 != this._window.x)
            {
                return true;
            }
            if (this._Str_4599 != this._window.y)
            {
                return true;
            }
            if (this._lastWindowHeight != this._window.height)
            {
                return true;
            }
            return false;
        }

        public function update(k:UInt)
        {
            var _local_2:UInt = flash.Lib.getTimer();
            if ((this._Str_25319 && ((_local_2 - this._Str_13838) > 5000)))
            {
                this.sendWindowPreferences();
            }
            this._Str_24575();
            this._Str_13354 = ASCompat.toInt(this._Str_13354 - k);
            if ((this._Str_15872 && (this._Str_13354 < 0)))
            {
                this._roomInfoPopup.getGlobalRectangle(this._Str_16596);
                if (!this._Str_16596.contains(this._window.desktop.mouseX, this._window.desktop.mouseY))
                {
                    this._roomInfoPopup.show(false);
                }
            }
        }

        public function dispose()
        {
            this._habboNewNavigator.removeUpdateReceiver(this);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }

        public function _Str_24313(k:Int)
        {
            if (this._Str_16641 == k)
            {
                this._Str_16641 = -1;
            }
        }

        public var _Str_15872(get,never):Bool;
public function  get__Str_15872():Bool
        {
            if (this._roomInfoPopup != null)
            {
                return this._roomInfoPopup.visible;
            }
            return false;
        }
    }

