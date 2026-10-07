package com.sulake.habbo.navigator.mainview.tabpagedecorators
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatCategory;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.core.window.events.*;

     class RoomsTabPageDecorator implements ITabPageDecorator 
    {
        var _navigator:HabboNavigator;
        var _filter:IDropMenuWindow;
        var _personalizedRoomsEnabled:Bool = false;

        public function new(k:HabboNavigator)
        {
            this._navigator = k;
        }

        public function refreshCustomContent(k:IWindowContainer)
        {
            var _local_2= "rooms_header";
            var _local_3= Std.downcast(k.getChildByName(_local_2) , IWindowContainer);
            if (((this._filter == null) || this._filter.disposed))
            {
                this._filter = cast(_local_3.findChildByName("roomCtgFilter"), IDropMenuWindow);
                this.prepareRoomCategories();
                this._filter.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onFilterSelected);
            }
            _local_3.visible = true;
        }

        public function prepareRoomCategories()
        {
            var _local_2:FlatCategory = null;
            if (((this._filter == null) || this._filter.disposed))
            {
                return;
            }
            var k:Array<ASAny> = [this._navigator.getText("navigator.navisel.popularrooms"), this._navigator.getText("navigator.navisel.highestscore")];
            this._personalizedRoomsEnabled = this._navigator.context.configuration.getBoolean("navigator.2014.personalized.navigator");
            if (this._personalizedRoomsEnabled)
            {
                k.push(this._navigator.getText("navigator.navisel.recommendedrooms"));
            }
            final _iter_ = this._navigator.data._Str_11717; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.push(_local_2.nodeName);
            }
            this._filter.populate(k);
            this._filter.selection = this.defaultSelection;
        }

        var defaultSelection(get,never):Int;
function  get_defaultSelection():Int
        {
            return this._personalizedRoomsEnabled ? 2 : 0;
        }

        public function tabSelected()
        {
            if (((!(this._filter == null)) && (!this._filter.disposed)))
            {
                this._filter.removeEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onFilterSelected);
                this._filter.selection = this.defaultSelection;
                this._filter.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onFilterSelected);
            }
        }

        public function refreshFooter(k:IWindowContainer)
        {
            this._navigator.officialRoomEntryManager._Str_21717(k);
        }

        public function navigatorOpenedWhileInTab()
        {
            this.startSearch();
        }

        function onFilterSelected(k:WindowEvent)
        {
            this.startSearch();
        }

        function startSearch()
        {
            var _local_2 = 0;
            var _local_3:FlatCategory = null;
            var _local_4 = 0;
            var k= (((this._filter != null) && (!this._filter.disposed)) ? this._filter.selection : this.defaultSelection);
            Logger.log([("Room filter changed: " + Std.string(k))]);
            if (k == 0)
            {
                this._navigator.mainViewCtrl.startSearch(Tabs.TAB_ROOMS, Tabs.SEARCHTYPE_POPULAR_ROOMS);
            }
            else
            {
                if (k == 1)
                {
                    this._navigator.mainViewCtrl.startSearch(Tabs.TAB_ROOMS, Tabs.SEARCHTYPE_ROOMS_WITH_HIGHEST_SCORE);
                }
                else
                {
                    if (((k == 2) && this._personalizedRoomsEnabled))
                    {
                        this._navigator.mainViewCtrl.startSearch(Tabs.TAB_ROOMS, Tabs.SEARCHTYPE_RECOMMENDED_ROOMS);
                    }
                    else
                    {
                        _local_2 = 2;
                        if (this._personalizedRoomsEnabled)
                        {
                            _local_2++;
                        }
                        _local_3 = this._navigator.data._Str_11717[(k - _local_2)];
                        if (_local_3 == null)
                        {
                            Logger.log([((("No fc found: " + Std.string(k)) + ", ") + Std.string(this._navigator.data._Str_11717.length))]);
                            return;
                        }
                        _local_4 = _local_3.nodeId;
                        Logger.log([("Searching with catId: " + Std.string(_local_4))]);
                        this._navigator.mainViewCtrl.startSearch(Tabs.TAB_ROOMS, Tabs.SEARCHTYPE_POPULAR_ROOMS, ("" + Std.string(_local_4)));
                    }
                }
            }
            if (((this._filter != null) && (!this._filter.disposed)))
            {
                this._navigator.trackNavigationDataPoint(this._filter.items()[this._filter.selection], "category.view");
            }
        }

        public var filterCategory(get,never):String;
public function  get_filterCategory():String
        {
            return ((this._filter != null) && (!this._filter.disposed)) ? this._filter.items()[this._filter.selection] : null;
        }

        public function setSubSelection(k:Int)
        {
        }

        public function processSearchParam(k:String):String
        {
            return k;
        }
    }



