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
    import com.sulake.habbo.utils.BuildersClubTools;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;

     class FurniChooserView
    {
        public static inline final COLUMN_FURNI_NAME= "name";
        public static inline final COLUMN_FURNI_OWNER= "owner";
        public static inline final COLUMN_ID= "id";
        static inline final BUILDERS_CLUB_OWNER= "Builders Club";

        var _widget:FurniChooserWidget;
        var _window:IFrameWindow;
        var _tableView:TableView;
        var _ignoreListeners:Bool = false;
        var _owners:Array<ASAny>;

        public function new(widget:FurniChooserWidget)
        {
            this._widget = widget;
            this._owners = [];
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
            this.constructOwners();
            this.populateWithFilters();
        }

        function createWindow()
        {
            var asset= (cast(this._widget.assets.getAssetByName("new_furni_chooser_view"), XmlAsset));
            if (asset == null)
            {
                return;
            }
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((asset.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            this._window.caption = "${widget.chooser.furni.title}";
            this.createTable();
            this.closeButton.addEventListener(WindowMouseEvent.CLICK, this.onClose);
            this.searchTextInput.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.onSearchChanged);
            this.usernameDropDown.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onUsernameChanged);
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
                new TableColumn(COLUMN_FURNI_NAME, this.localize("new_furni_chooser.col.name"), 0.5, "left"),
                new TableColumn(COLUMN_FURNI_OWNER, this.localize("new_furni_chooser.col.owner"), 0.25, "left"),
                new TableColumn(COLUMN_ID, this.localize("new_furni_chooser.col.id"), 0.25, "left")
            ];
            this._tableView.initialize(Vector.ofArray(((cast cols) : Array<TableColumn>)), true, true);
            this._tableView.onRowClickedCallback = this.onListItemClicked;
        }

        function constructOwners()
        {
var ownerKey:String  = null;            var owners:Array<ASAny> = [];
            var seen:ASObject = {};
            var item:_Str_3405 = null;

            this._ignoreListeners = true;
            this._owners = [];
            owners.push(this.localize("new_furni_chooser.owner_selector.default"));
            if (this._widget.items != null)
            {
                final _iter_ = this._widget.items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
item  = _tmp_;
ownerKey= this.resolveOwnerKey(item);
                    if ((ownerKey == null) || (ownerKey.length == 0))
                    {
                        continue;
                    }
                    if (ASCompat.getDynamicProperty(seen, ownerKey))
                    {
                        continue;
                    }
                    this._owners.push(ownerKey);
                    owners.push(ownerKey);
ASCompat.setDynamicProperty(                    seen, ownerKey, true);
                }
            }

            this.usernameDropDown.populate(owners);
            this.usernameDropDown.selection = 0;
            if (owners.length <= 1)
            {
                this.usernameDropDown.disable();
                this.usernameDropDown.blend = 0.5;
            }
            else
            {
                this.usernameDropDown.enable();
                this.usernameDropDown.blend = 1;
            }
            this._ignoreListeners = false;
        }

        function populateWithFilters()
        {
var matches = false;            var terms:Array<ASAny> = null;
            var selectedOwner:String = null;
            var filtered:Array<ASAny> = null;
            var item:_Str_3405 = null;
            var term:String = null;
            var objects:Vector<ITableObject> = null;

            if (this._window == null)
            {
                return;
            }
            terms = (cast this.searchTextInput.text.toLowerCase().split(" "));
            if (this.usernameDropDown.selection > 0)
            {
                selectedOwner = this._owners[(this.usernameDropDown.selection - 1)];
            }
            else
            {
                selectedOwner = null;
            }
            filtered = [];

            final _iter_ = this._widget.items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
matches= true;
                if (checkNullIteratee(terms)) for (_tmp_ in terms)
                {
term  = _tmp_;
                    if (item.lowerCaseName.indexOf(term) == -1)
                    {
                        matches = false;
                        break;
                    }
                }
                if (!matches) continue;
                if (((selectedOwner != null) && (!(this.resolveOwnerKey(item) == selectedOwner))))
                {
                    continue;
                }
                filtered.push(item);
            }

            objects = new Vector<ITableObject>();
            if (checkNullIteratee(filtered)) for (_tmp_ in filtered)
            {
item  = _tmp_;
                objects.push(new FurniChooserTableObject(item));
            }
            this._tableView.setObjects(objects);
            this.amountIndicator.text = this._widget.localizations.getLocalizationWithParams("new_furni_chooser.amount_indicator", "", ["amount", filtered.length]);
        }

        function onListItemClicked(row:FurniChooserTableObject)
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

        function onUsernameChanged(k:WindowEvent)
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

        function resolveOwnerKey(item:_Str_3405):String
        {
            if (item == null)
            {
                return "";
            }
            if (BuildersClubTools.isBuildersClubFurniture(item.id))
            {
                return BUILDERS_CLUB_OWNER;
            }
            return ((item.owner != null) ? item.owner : "");
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

        var usernameDropDown(get,never):IDropMenuWindow;
function  get_usernameDropDown():IDropMenuWindow
        {
            return Std.downcast(this._window.findChildByName("username_dropdown") , IDropMenuWindow);
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

