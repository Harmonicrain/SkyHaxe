package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.itemtable.ItemTypeTableObject;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;

     class ItemTypeSelectionPreset extends WiredUIPreset
    {
        public static inline final COL_FURNI_CODE= "furni_code";
        public static inline final COL_FURNI_NAME= "furni_name";
        public static inline final COL_FURNI_TYPE= "furni_type";

        static final POSTER_IDS:Array<ASAny> = [
            1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
            21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
            41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,83,
            500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,
            515,516,517,518,520,521,522,523,1000,1001,1002,1003,1004,
            1005,1006,2000,2001,2002,2003,2004,2005,2006,2007,2008
        ];

        var _list:IItemListWindow;
        var _allFurnis:Vector<ItemTypeTableObject>;
        var _codeInput:NamedTextInputPreset;
        var _searchInput:NamedTextInputPreset;
        var _tableContainer:IWindowContainer;
        var _table:TableView;
        var _showCount:TextPreset;
        var _selectedItem:ChestItemType;
        var _ignoreListeners:Bool = false;
        var _showingAll:Bool = false;
        var _listeners:Array<ASAny> = [];

        public function new(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._list = Std.downcast(presetManager.createLayout("vertical_list_view") , IItemListWindow);
            this._list.spacing = style.genericVerticalSpacing;
            this.createAllFurnis();
            this._codeInput = presetManager.createNamedTextInput(
                new TextInputParam("", -1,
                    "${wiredcontracts.element.itemtype.furni_code.placeholder}",
                    150, null, false),
                "${wiredcontracts.element.itemtype.furni_code}");
            this._searchInput = presetManager.createNamedTextInput(
                new TextInputParam("", 220, "", 150),
                "${wiredcontracts.element.itemtype.search}");
            this._tableContainer = Std.downcast(presetManager.createLayout("container_view") , IWindowContainer);
            this._tableContainer.width = 350;
            this._tableContainer.height = 234;
            this._showCount = presetManager.createText("-", new TextParam(1));
            this._showCount.halfBlend();
            this._list.addListItem(this._codeInput.window);
            this._list.addListItem(this._searchInput.window);
            this._list.addListItem(this._tableContainer);
            this._list.addListItem(this._showCount.window);
            this._searchInput.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE,
                this.onSearchChanged);
            this.createTableView();
            this.refreshShowCount();
        }

        function refreshShowCount()
        {
            this._showCount.text = this.localizations.getLocalizationWithParams(
                "wiredcontracts.element.show_count", "", ["amount", this._table.rowCount]);
        }

        function createAllFurnis()
        {
var posterId = 0, key:String  = null;            this._allFurnis = new Vector<ItemTypeTableObject>();
            var sessionData= this._roomEvents.sessionDataManager;
            var item:IFurnitureData = null;
            var code:String = null;
            var name:String = null;
            final _iter_ = sessionData.getAllFloorItemDatas(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
                code = item.fullName;
                if (code == "") continue;
                name = item.localizedName == "" ? code : item.localizedName;
                this._allFurnis.push(new ItemTypeTableObject(
                    new ChestItemType(false, item.id, null), name, code));
            }

            var posterTypeId= -1;
            final _iter_ = sessionData.getAllWallItemDatas(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
                code = item.fullName;
                if (code == "") continue;
                if (item.className == "poster")
                {
                    posterTypeId = item.id;
                    continue;
                }
                name = item.localizedName == "" ? code : item.localizedName;
                this._allFurnis.push(new ItemTypeTableObject(
                    new ChestItemType(true, item.id, null), name, code));
            }

            if (posterTypeId != -1)
            {
                final _iter_ = POSTER_IDS; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
posterId = ASCompat.toInt(_tmp_);
                    code = "poster*" + Std.string(posterId);
key= "poster_" + Std.string(posterId) + "_name";
                    name = this._roomEvents.localization.getLocalization(key, key);
                    this._allFurnis.push(new ItemTypeTableObject(
                        new ChestItemType(true, posterTypeId, Std.string(posterId)),
                        name, code));
                }
            }
            ASCompat.ASVector.sort(this._allFurnis, function(a:ItemTypeTableObject,
                b:ItemTypeTableObject):Int
            {
                return Reflect.compare(a.localizedName, b.localizedName);
            });
        }

        function createTableView()
        {
            var tableAsset= Std.downcast(this._roomEvents.assets
                .getAssetByName("table_view_xml") , XmlAsset);
            this._table = new TableView(this._roomEvents.windowManager,
                this._tableContainer, false, false, tableAsset);
            var columns:Array<ASAny> = [
                new TableColumn(COL_FURNI_NAME,
                    "${wiredcontracts.element.itemtype.col.furni_name}", 0.5, "left"),
                new TableColumn(COL_FURNI_CODE,
                    "${wiredcontracts.element.itemtype.col.furni_code}", 0.3, "left"),
                new TableColumn(COL_FURNI_TYPE,
                    "${wiredcontracts.element.itemtype.col.furni_type}", 0.2, "left")
            ];
            this._table.initialize(Vector.ofArray(((cast columns) : Array<TableColumn>)), true, true);
            this._table.onRowClickedCallback = this.onListItemClicked;
            this._table.setObjects((cast Vector.convert(this._allFurnis) : Vector<ITableObject>));
            this._showingAll = true;
        }

        function onListItemClicked(value:ItemTypeTableObject)
        {
            if (value != null) this.selectedItem = value.chestItemType;
        }

        
        public var selectedItem(get,set):ChestItemType;
public function  get_selectedItem():ChestItemType { return this._selectedItem; }

        public var furniDataForSelectedItem(get,never):IFurnitureData;
public function  get_furniDataForSelectedItem():IFurnitureData
        {
            if (this._selectedItem == null) return null;
            var sessionData= this._roomEvents.sessionDataManager;
            return this._selectedItem.isWallItem
                ? sessionData.getWallItemData(this._selectedItem.typeId)
                : sessionData.getFloorItemData(this._selectedItem.typeId);
        }

        public function resetInteractions()
        {
            this._ignoreListeners = true;
            this._searchInput.text = "";
            this._ignoreListeners = false;
            this.updateFilters(true);
        }

        function onSearchChanged(event:WindowEvent)
        {
            if (!this._ignoreListeners) this.updateFilters(false);
        }

        function updateFilters(resetScroll:Bool)
        {
var terms:Array<ASAny>  = null, item:ItemTypeTableObject  = null, matches = false, term:String  = null;            var query= this._searchInput.text.toLowerCase();
            var objects:Vector<ItemTypeTableObject> = null;
            if (query.length < 2)
            {
                if (this._showingAll && !resetScroll) return;
                objects = this._allFurnis;
                this._showingAll = true;
            }
            else
            {
                objects = new Vector<ItemTypeTableObject>();
terms= (cast query.split(" "));
                final _iter_ = this._allFurnis; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
item = _tmp_;
matches= true;
                    if (checkNullIteratee(terms)) for (_tmp_ in terms)
                    {
term = _tmp_;
                        if (term.length > 0 && !item.matchesSubstring(term))
                        {
                            matches = false;
                            break;
                        }
                    }
                    if (matches) objects.push(item);
                }
                this._showingAll = false;
            }
            this._table.setObjects((cast Vector.convert(objects) : Vector<ITableObject>), resetScroll);
            this.refreshShowCount();
        }
public function  set_selectedItem(value:ChestItemType):ChestItemType        {
            this._selectedItem = value;
            this.notifyListeners(value);
            if (value == null)
            {
                this._codeInput.text = "";
                return value;
            }
            var data= value.isWallItem
                ? this._roomEvents.sessionDataManager.getWallItemData(value.typeId)
                : this._roomEvents.sessionDataManager.getFloorItemData(value.typeId);
            if (data == null)
            {
                this._selectedItem = null;
                this._codeInput.text = "";
                this.notifyListeners(null);
                return value;
            }
            this._codeInput.text =
                value.isWallItem && data.className == "poster"
                    ? "poster*" + value.legacyPosterId : data.fullName;
return value;
        }

        public function addListener(listener:ASFunction) { this._listeners.push(listener); }
        function notifyListeners(value:ChestItemType)
        {
var listener:ASFunction  = null;            final _iter_ = this._listeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {listener = _tmp_;
listener(value);
};
        }

        override public function  get_window():IWindow { return this._list; }
        override public function resizeToWidth(width:Int)
        {
            super.resizeToWidth(width);
            this._list.width = width;
            this._codeInput.resizeToWidth(width);
            this._searchInput.resizeToWidth(width);
            this._showCount.resizeToWidth(width);
            if (this._tableContainer.width != width)
            {
                this._tableContainer.width = width;
                this._table.resizeHorizontally();
            }
        }

        override function  get_childPresets():Array<ASAny>
        {
            return [this._codeInput, this._searchInput, this._showCount];
        }

        override public function dispose()
        {
            if (disposed) return;
            if (this._table != null) this._table.dispose();
            this._table = null;
            super.dispose();
            this._list.dispose();
            this._list = null;
            this._allFurnis = null;
            this._codeInput = null;
            this._searchInput = null;
            this._tableContainer = null;
            this._showCount = null;
            this._selectedItem = null;
            this._listeners = null;
        }
    }

