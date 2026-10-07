package com.sulake.habbo.navigator.mainview.tabpagedecorators
;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.navigator.CanCreateRoomMessageComposer;
    import com.sulake.core.window.events.*;

     class MyRoomsTabPageDecorator implements ITabPageDecorator 
    {
        final _Str_8929:Array<ASAny> = [([Tabs.SEARCHTYPE_MY_ROOMS, "navigator.navisel.myrooms"] : Array<Dynamic>), ([Tabs.SEARCHTYPE_ROOMS_WHERE_MY_FRIENDS_ARE, "navigator.navisel.wherearemyfriends"] : Array<Dynamic>), ([Tabs.SEARCHTYPE_MY_FRIENDS_ROOMS, "navigator.navisel.myfriendsrooms"] : Array<Dynamic>), ([Tabs.SEARCHTYPE_ROOMS_WITH_RIGHTS, "navigator.navisel.roomswithrights"] : Array<Dynamic>), ([Tabs.SEARCHTYPE_MY_GUILD_BASES, "navigator.navisel.mygroups"] : Array<Dynamic>), ([Tabs.SEARCHTYPE_MY_FAVOURITES, "navigator.navisel.myfavourites"] : Array<Dynamic>), ([Tabs.SEARCHTYPE_MY_HISTORY, "navigator.navisel.visitedrooms"] : Array<Dynamic>), ([Tabs.SEARCHTYPE_FREQUENT_HISTORY, ""] : Array<Dynamic>)];

        var _navigator:HabboNavigator;
        var _filter:IDropMenuWindow;

        public function new(k:HabboNavigator)
        {
            this._navigator = k;
        }

        public function refreshCustomContent(k:IWindowContainer)
        {
            var _local_2= "me_header";
            var _local_3= Std.downcast(k.getChildByName(_local_2) , IWindowContainer);
            if (((this._filter == null) || this._filter.disposed))
            {
                this._filter = cast(_local_3.findChildByName("meSubNavi"), IDropMenuWindow);
                this._Str_22831();
                this._filter.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onFilterSelected);
            }
            _local_3.visible = true;
        }

        public function tabSelected()
        {
            if (((!(this._filter == null)) && (!this._filter.disposed)))
            {
                this._filter.removeEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onFilterSelected);
                this._filter.selection = 0;
                this._filter.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onFilterSelected);
            }
        }

        public function refreshFooter(k:IWindowContainer)
        {
            var _local_2= Std.downcast(k.getChildByName("me_footer") , IWindowContainer);
            var _local_3= _local_2.findChildByName("create_room_but");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onCreateRoomClick);
            }
            this._navigator.refreshButton(_local_2, "create_room", true, null, 0);
            _local_2.visible = true;
        }

        public function navigatorOpenedWhileInTab()
        {
            this.startSearch();
        }

        function onCreateRoomClick(k:WindowEvent)
        {
            this._navigator.send(new CanCreateRoomMessageComposer());
        }

        function _Str_22831()
        {
            var _local_2:Array<ASAny> = null;
            if (((this._filter == null) || this._filter.disposed))
            {
                return;
            }
            var k:Array<ASAny> = [];
            final _iter_ = this._Str_8929; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.push(this._navigator.getText(_local_2[1]));
            }
            this._filter.populate(k);
            this._filter.selection = 0;
        }

        function onFilterSelected(k:WindowEvent)
        {
            this.startSearch();
            var _local_2= k.target;
            if (Std.is(_local_2 , IDropMenuWindow))
            {
                this._navigator.trackNavigationDataPoint(cast(_local_2, IDropMenuWindow).items()[cast(_local_2, IDropMenuWindow).selection], "category.view");
            }
        }

        function startSearch()
        {
            var k= (((this._filter == null) || this._filter.disposed) ? 0 : this._filter.selection);
            this._navigator.mainViewCtrl.startSearch(Tabs.TAB_ME, this._Str_24302(k));
        }

        function _Str_24302(k:Int):Int
        {
            if (k <= this._Str_8929.length)
            {
                return ASCompat.toInt(this._Str_8929[k][0]);
            }
            return ASCompat.toInt(this._Str_8929[0][0]);
        }

        public var filterCategory(get,never):String;
public function  get_filterCategory():String
        {
            return ((this._filter != null) && (!this._filter.disposed)) ? this._filter.items()[this._filter.selection] : null;
        }

        public function setSubSelection(k:Int)
        {
            var _local_4:Array<ASAny> = null;
            if (((!(this._filter != null)) || this._filter.disposed))
            {
                return;
            }
            var _local_2= this._filter.numMenuItems;
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = this._Str_8929[_local_3];
                if (_local_4[0] == k)
                {
                    this._filter.selection = _local_3;
                    return;
                }
                _local_3++;
            }
            this._filter.selection = 0;
        }

        public function processSearchParam(k:String):String
        {
            return k;
        }
    }

