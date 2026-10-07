package com.sulake.habbo.ui.widget.chooser
;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.events._Str_3405;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;

     class UserChooserView
    {
        public static inline final COLUMN_USER_NAME= "name";
        public static inline final COLUMN_TYPE= "type";

        var _widget:UserChooserWidget;
        var _title:String;
        var _tableView:TableView;
        var _window:IFrameWindow;
        var _ignoreListeners:Bool = false;

        public function new(widget:UserChooserWidget, title:String)
        {
            this._widget = widget;
            this._title = title;
        }

        public function dispose()
        {
            this.hideWindow();
            this._widget = null;
        }

        public function isOpen():Bool
        {
            return ((this._window != null) && this._window.visible);
        }

        public function onItemsChanged()
        {
            if (this._widget == null)
            {
                return;
            }
            if (this._window == null)
            {
                this.createWindow();
            }
            this.populateWithFilters();
        }

        function createWindow()
        {
            var asset= (cast(this._widget.assets.getAssetByName("new_user_chooser_view"), XmlAsset));
            if (asset == null)
            {
                return;
            }
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((asset.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            this._window.caption = this._title;
            this.createTable();
            this.closeButton.addEventListener(WindowMouseEvent.CLICK, this.onClose);
            this.searchTextInput.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.onSearchChanged);
            this.typeDropdown.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onTypeChanged);
            this.clearButton.addEventListener(WindowMouseEvent.CLICK, this.onClearClicked);
            if (this._window.parent != null)
            {
                this._window.x = ((this._window.parent.width - this._window.width) - 10);
                this._window.y = 10;
            }
        }

        function createTable()
        {
            var cols:Array<ASAny> = null;
            this._tableView = new TableView(this._widget.windowManager, this.tableViewContainer, true, true, (cast(this._widget.assets.getAssetByName("table_view_xml"), XmlAsset)));
            cols = [
                new TableColumn(COLUMN_USER_NAME, this.localize("new_user_chooser.col.name"), 0.65, "left"),
                new TableColumn(COLUMN_TYPE, this.localize("new_user_chooser.col.type"), 0.35, "left")
            ];
            this._tableView.initialize(Vector.ofArray(((cast cols) : Array<TableColumn>)), true, true);
            this._tableView.onRowClickedCallback = this.onListItemClicked;
        }

        function populateWithFilters()
        {
            var filtered:Array<ASAny> = null;
            var objects:Vector<ITableObject> = null;
            var item:_Str_3405 = null;
            var selectedType = 0;
            var searchValue:String = null;

            if ((this._window == null) || (this._widget.items == null))
            {
                return;
            }

            searchValue = this.searchTextInput.text.toLowerCase();
            selectedType = this.typeDropdown.selection;
            if (selectedType == 3)
            {
                selectedType = 4;
            }

            filtered = [];
            final _iter_ = this._widget.items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
                if (((searchValue.length > 0) && (item.lowerCaseName.indexOf(searchValue) == -1)))
                {
                    continue;
                }
                if (((selectedType > 0) && (item.type != selectedType)))
                {
                    continue;
                }
                filtered.push(item);
            }

            objects = new Vector<ITableObject>();
            if (checkNullIteratee(filtered)) for (_tmp_ in filtered)
            {
item  = _tmp_;
                objects.push(new UserChooserTableObject(item));
            }
            this._tableView.setObjects(objects);
            this.amountIndicator.text = this._widget.localizations.getLocalizationWithParams("new_user_chooser.amount_indicator", "", ["amount", filtered.length]);
        }

        function onListItemClicked(row:UserChooserTableObject)
        {
            var item:_Str_3405 = null;
            if (row == null)
            {
                return;
            }
            item = row.chooserItem;
            if (item == null)
            {
                return;
            }
            this._widget.choose(item.id, item.category);
        }

        function onSearchChanged(k:WindowEvent)
        {
            var txt:String = null;
            if (this._ignoreListeners)
            {
                return;
            }
            txt = this.searchTextInput.text;
            this.clearButton.visible = txt.length > 0;
            this.textPlaceholder.visible = txt.length == 0;
            this.populateWithFilters();
        }

        function onTypeChanged(k:WindowEvent)
        {
            if (this._ignoreListeners)
            {
                return;
            }
            this.populateWithFilters();
        }

        function onClearClicked(k:WindowMouseEvent)
        {
            if (this._ignoreListeners)
            {
                return;
            }
            this.searchTextInput.text = "";
            this.onSearchChanged(null);
        }

        function onClose(k:WindowMouseEvent)
        {
            this.hideWindow();
        }

        function hideWindow()
        {
            if (this._window != null)
            {
                if (this._tableView != null)
                {
                    this._tableView.dispose();
                    this._tableView = null;
                }
                this._window.dispose();
                this._window = null;
            }
        }

        function localize(key:String):String
        {
            return this._widget.localizations.getLocalization(key, key);
        }

        var closeButton(get,never):IWindow;
function  get_closeButton():IWindow
        {
            return this._window.findChildByTag("close");
        }

        var tableViewContainer(get,never):IWindowContainer;
function  get_tableViewContainer():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("table_container") , IWindowContainer);
        }

        var textPlaceholder(get,never):ITextWindow;
function  get_textPlaceholder():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("search_placeholder") , ITextWindow);
        }

        var searchTextInput(get,never):ITextFieldWindow;
function  get_searchTextInput():ITextFieldWindow
        {
            return Std.downcast(this._window.findChildByName("text_input") , ITextFieldWindow);
        }

        var typeDropdown(get,never):IDropMenuWindow;
function  get_typeDropdown():IDropMenuWindow
        {
            return Std.downcast(this._window.findChildByName("type_dropdown") , IDropMenuWindow);
        }

        var clearButton(get,never):IWindowContainer;
function  get_clearButton():IWindowContainer
        {
            return Std.downcast(this._window.findChildByName("clear_button") , IWindowContainer);
        }

        var amountIndicator(get,never):ITextWindow;
function  get_amountIndicator():ITextWindow
        {
            return Std.downcast(this._window.findChildByName("amount_indicator") , ITextWindow);
        }
    }

