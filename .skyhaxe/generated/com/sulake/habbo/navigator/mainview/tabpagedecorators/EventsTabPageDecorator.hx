package com.sulake.habbo.navigator.mainview.tabpagedecorators
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.navigator.domain.Tabs;

     class EventsTabPageDecorator implements ITabPageDecorator 
    {
        var _navigator:HabboNavigator;
        var _filter:IDropMenuWindow;

        public function new(k:HabboNavigator)
        {
            this._navigator = k;
        }

        public function refreshCustomContent(k:IWindowContainer)
        {
            var _local_2= Std.downcast(k.getChildByName("room_ad_header") , IWindowContainer);
            if (((this._filter == null) || this._filter.disposed))
            {
                this._filter = Std.downcast(_local_2.getChildByName("roomAdFilter") , IDropMenuWindow);
                this._Str_22411();
                this._filter.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onFilterSelected);
            }
            _local_2.visible = true;
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
            var _local_2= Std.downcast(k.getChildByName("room_ads_footer") , IWindowContainer);
            var _local_3= _local_2.findChildByName("get_event_but");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_17806);
            }
            _local_2.visible = true;
        }

        public function navigatorOpenedWhileInTab()
        {
            this.startSearch();
        }

        function _Str_22411()
        {
            if (((this._filter == null) || this._filter.disposed))
            {
                return;
            }
            var k= new Array<ASAny>();
            k.push(this._navigator.getText("navigator.roomad.topads"));
            k.push(this._navigator.getText("navigator.roomad.newads"));
            this._filter.populate(k);
            this._filter.selection = 0;
        }

        function onFilterSelected(k:WindowEvent)
        {
            this.startSearch();
        }

        function _Str_17806(k:WindowEvent)
        {
            this._navigator.openCatalogRoomAdsPage();
        }

        function startSearch()
        {
            var k= Tabs.SEARCHTYPE_ROOM_ADS;
            if (((!(this._filter == null)) && (!this._filter.disposed)))
            {
                k = this._Str_22587(this._filter.selection);
            }
            this._navigator.mainViewCtrl.startSearch(Tabs.TAB_EVENTS, k);
        }

        function _Str_22587(k:Int):Int
        {
            switch (k)
            {
                case 0:
                    return Tabs.SEARCHTYPE_ROOM_ADS;
                case 1:
                    return Tabs.SEARCHTYPE_NEW_ROOM_ADS;
            }
            Logger.log([("Invalid index when searching Room ad search type: " + Std.string(k))]);
            return 0;
        }

        public var filterCategory(get,never):String;
public function  get_filterCategory():String
        {
            if (((this._filter == null) || this._filter.disposed))
            {
                return null;
            }
            return this._filter.items()[this._filter.selection];
        }

        public function setSubSelection(k:Int)
        {
        }

        public function processSearchParam(k:String):String
        {
            return k;
        }
    }

