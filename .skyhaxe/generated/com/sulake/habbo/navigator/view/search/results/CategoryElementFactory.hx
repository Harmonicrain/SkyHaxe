package com.sulake.habbo.navigator.view.search.results
;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultList;
    import com.sulake.habbo.navigator.view.search.ViewMode;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;

     class CategoryElementFactory 
    {
        static inline final _Str_14513= 13;

        var _navigator:HabboNewNavigator;
        var _blockResultsView:BlockResultsView;
        var _roomEntryElementFactory:RoomEntryElementFactory;
        var _categoryTemplate:IWindowContainer;
        var _collapsedCategoryTemplate:IWindowContainer;
        var _noResultsTemplate:IWindowContainer;

        public function new(k:HabboNewNavigator, _arg_2:RoomEntryElementFactory)
        {
            this._navigator = k;
            this._roomEntryElementFactory = _arg_2;
        }

        public var _Str_23184(never,set):BlockResultsView;
public function  set__Str_23184(k:BlockResultsView):BlockResultsView        {
            return this._blockResultsView = k;
        }

        public var _Str_25135(never,set):IWindowContainer;
public function  set__Str_25135(k:IWindowContainer):IWindowContainer        {
            return this._categoryTemplate = k;
        }

        public var _Str_23119(never,set):IWindowContainer;
public function  set__Str_23119(k:IWindowContainer):IWindowContainer        {
            return this._collapsedCategoryTemplate = k;
        }

        public var _Str_24754(never,set):IWindowContainer;
public function  set__Str_24754(k:IWindowContainer):IWindowContainer        {
            return this._noResultsTemplate = k;
        }

        public function _Str_22713(guestRooms:Vector<GuestRoomData>, title:String, showMoreId:Int=-1, actionAllowed:Int=0, resultMode:Int=-1):IWindowContainer
        {
            var guestRoom:GuestRoomData = null;
            var alternatingColor = 0;
            var container= cast(this._categoryTemplate.clone(), IWindowContainer);
            container.width = (this._blockResultsView._Str_20093 - _Str_14513);
            container.height = (16 + (this._roomEntryElementFactory._Str_19124 * (guestRooms.length + 1)));
            container.findChildByName("category_name").caption = title;
            container.findChildByName("category_back").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_23002);
            container.findChildByName("category_back").visible = (actionAllowed == SearchResultList._Str_15183);
            container.findChildByName("category_collapse").visible = (!(actionAllowed == SearchResultList._Str_15183));
            container.findChildByName("category_collapse").id = showMoreId;
            container.findChildByName("category_collapse").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_19418);
            container.findChildByName("category_name_region").id = showMoreId;
            container.findChildByName("category_name_region").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_19418);
            container.findChildByName("category_show_more").id = showMoreId;
            container.findChildByName("category_show_more").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_19195);
            container.findChildByName("category_show_more").visible = (actionAllowed == SearchResultList._Str_14200);
            container.findChildByName("category_add_quick_link").id = showMoreId;
            container.findChildByName("category_add_quick_link").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_21650);
            container.findChildByName("category_content_background").background = true;
            container.findChildByName("category_content_background").height = (12 + (this._roomEntryElementFactory._Str_19124 * (guestRooms.length + 1)));
            container.findChildByName("category_add_quick_link").visible = (this._navigator._Str_3440.searchCodeOriginal.indexOf(ViewMode.OFFICIAL_VIEW) == -1);
            var headerControls= cast(container.findChildByName("category_controls_itemlist"), IItemListWindow);
            if (this._navigator.sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_ROOM_THUMBNAIL_CAMERA))
            {
                headerControls.getListItemByName("category_toggle_tiles").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_20474);
                headerControls.getListItemByName("category_toggle_tiles").id = showMoreId;
                headerControls.getListItemByName("category_toggle_tiles").visible = (resultMode == ResultsModeEnum._Str_6023);
                headerControls.getListItemByName("category_toggle_rows").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_20474);
                headerControls.getListItemByName("category_toggle_rows").id = showMoreId;
                headerControls.getListItemByName("category_toggle_rows").visible = (resultMode == ResultsModeEnum._Str_13822);
            }
            else
            {
                headerControls.removeListItem(headerControls.getListItemByName("category_toggle_tiles"));
                headerControls.removeListItem(headerControls.getListItemByName("category_toggle_rows"));
            }
            headerControls.arrangeListItems();
            var roomList= cast(container.findChildByName("category_content"), IItemListWindow);
            if (resultMode == ResultsModeEnum._Str_6023)
            {
                roomList.spacing = 0;
            }
            var colorMod:UInt = 9412607;
            var color= -1;
            var colorModAccumulator= 1;
            var currentTileContainer:IItemListWindow = null;
            if (checkNullIteratee(guestRooms)) for (_tmp_ in guestRooms)
            {
guestRoom  = _tmp_;
                alternatingColor = ASCompat.toInt(((colorModAccumulator % 2) == 0) ? color : ASCompat.toInt(colorMod));
                if (resultMode == ResultsModeEnum._Str_6023)
                {
                    roomList.addListItem(this._roomEntryElementFactory._Str_24858(guestRoom, alternatingColor));
                    colorModAccumulator = (colorModAccumulator + 1);
                }
                else
                {
                    if (currentTileContainer == null)
                    {
                        currentTileContainer = this._roomEntryElementFactory._Str_25258();
                        roomList.addListItem(currentTileContainer);
                    }
                    currentTileContainer.addEventListener(WindowMouseEvent.WHEEL, function (k:WindowMouseEvent)
                    {
                        _blockResultsView.itemList.scrollWithWheel(k.delta, false);
                    });
                    currentTileContainer.addListItem(this._roomEntryElementFactory._Str_22789(guestRoom, alternatingColor));
                    if (currentTileContainer.numListItems >= RoomEntryElementFactory._Str_17291)
                    {
                        currentTileContainer = null;
                        colorModAccumulator = (colorModAccumulator + 1);
                    }
                }
            }
            roomList.arrangeListItems();
            return container;
        }

        public function _Str_24067(k:String, _arg_2:Int=-1, _arg_3:Int=0):IWindowContainer
        {
            var _local_4= cast(this._collapsedCategoryTemplate.clone(), IWindowContainer);
            _local_4.findChildByName("category_name").caption = k;
            _local_4.findChildByName("category_show_more").id = _arg_2;
            _local_4.findChildByName("category_show_more").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_19195);
            _local_4.findChildByName("category_show_more").visible = (_arg_3 == SearchResultList._Str_14200);
            _local_4.findChildByName("category_expand").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_21896);
            _local_4.findChildByName("category_expand").id = _arg_2;
            _local_4.findChildByName("category_name_region").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_21896);
            _local_4.findChildByName("category_name_region").id = _arg_2;
            _local_4.findChildByName("category_add_quick_link").addEventListener(WindowMouseEvent.CLICK, this._blockResultsView._Str_21650);
            _local_4.findChildByName("category_add_quick_link").id = _arg_2;
            _local_4.findChildByName("category_add_quick_link").visible = (this._navigator._Str_3440.searchCodeOriginal.indexOf(ViewMode.OFFICIAL_VIEW) == -1);
            _local_4.width = (this._blockResultsView._Str_20093 - _Str_14513);
            cast(_local_4.findChildByName("category_controls_itemlist"), IItemListWindow).arrangeListItems();
            return _local_4;
        }

        public function _Str_24646():IWindowContainer
        {
            return cast(this._noResultsTemplate.clone(), IWindowContainer);
        }
    }

