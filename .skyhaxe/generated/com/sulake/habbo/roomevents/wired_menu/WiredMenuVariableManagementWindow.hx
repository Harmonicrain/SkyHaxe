package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;
    import flash.ui.Keyboard;

    /**
     * Dedicated July-style management flow for persisted user variables.
     * The parent controller remains responsible for sending packet composers.
     */
     final class WiredMenuVariableManagementWindow implements IDisposable
    {
        static inline final PAGE_SIZE= 50;
        static final USER_FILTERS:Array<ASAny> = [-1, 1, 2, 4];

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _requestPageCallback:ASFunction;
        var _requestDetailsCallback:ASFunction;
        var _mutationCallback:ASFunction;
        var _overview:IFrameWindow;
        var _detail:IFrameWindow;
        var _overviewTable:TableView;
        var _detailTable:TableView;
        var _detailPreviewer:WiredMenuPermanentVariablePreviewer;
        var _createPicker:IDropMenuWindow;
        var _creatableVariables:Array<ASAny> = [];
        var _availableCreateVariables:Array<ASAny> = [];
        var _selectedDetail:WiredMenuTableObject;
        var _variableId:String;
        var _variableName:String;
        var _page:Int = 1;
        var _total:Int = 0;
        var _detailType:Int = 0;
        var _detailId:Int = 0;
        var _detailEntries:Array<ASAny> = [];
        var _canModify:Bool = false;
        var _disposed:Bool = false;

        public function new(
            roomEvents:HabboUserDefinedRoomEvents,
            requestPageCallback:ASFunction,
            requestDetailsCallback:ASFunction,
            mutationCallback:ASFunction)
        {
            this._roomEvents = roomEvents;
            this._requestPageCallback = requestPageCallback;
            this._requestDetailsCallback = requestDetailsCallback;
            this._mutationCallback = mutationCallback;
        }

        public function setCreatableVariables(variables:Array<ASAny>)
        {
            this._creatableVariables = variables == null ? [] : variables.copy();
            this.populateCreatePicker();
        }

        public function setCanModify(value:Bool)
        {
            this._canModify = value;
            this.updateDetailButtons();
        }

        public function show(variableId:String, variableName:String=null)
        {
            this.ensureOverview();
            if (this._overview == null)
            {
                return;
            }
            this._variableId = variableId == null ? "" : variableId;
            this._variableName =
                variableName == null || variableName.length == 0
                    ? this._variableId : variableName;
            var label=
                Std.downcast(this._overview.findChildByName("variable_name_value") , ITextWindow);
            if (label != null)
            {
                label.text = this._variableName;
            }
            this._overview.visible = true;
            this._overview.activate();
            this.requestPage(1);
        }

        public function applyPage(parser:ASObject)
        {
            if (parser == null || ASCompat.toString(parser.variableId) != this._variableId)
            {
                return;
            }
            this.ensureOverview();
            this._total = Std.int(Math.max(0, ASCompat.toInt(parser.total)));
            this._page = Std.int(Math.max(1, ASCompat.toInt(parser.page)));
            var rows= new Vector<ITableObject>();
            var entry:ASObject = null;
            var index = 0;
            final _iter_:ASAny = parser.entries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry  = _tmp_;
                rows.push(new WiredMenuTableObject(
                    "holder_" + entry.type + "_" + entry.id + "_" + Std.string(index++), {
                        "name": entry.name,
                        "usertype": this.loc("wiredmenu.variable_management.usertype." +
                            entry.type, ASCompat.toString(entry.type)),
                        "value": entry.value,
                        "creation_time": entry.createdText,
                        "last_update_time": entry.updatedText,
                        "manage": this.loc(
                            "wiredmenu.variable_management.manage", "Manage")
                    }, entry));
            }
            if (this._overviewTable != null)
            {
                this._overviewTable.setObjects(rows, true);
            }
            this.applyResponseFilters(parser);
            this.updatePagination();
        }

        public function applyDetails(parser:ASObject)
        {
var editable:TableCell  = null;            if (parser == null)
            {
                return;
            }
            this.ensureDetail();
            this._detailType = ASCompat.toInt(parser.type);
            this._detailId = ASCompat.toInt(parser.id);
            this._detailEntries =
                parser.entries == null ? [] : parser.entries.concat();
            this._selectedDetail = null;
            this.renderDetailInfo(parser);
            this.renderDetailPreview(parser);
            var rows= new Vector<ITableObject>();
            var entry:ASObject = null;
            final _iter_ = this._detailEntries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry  = _tmp_;
editable= new TableCell(TableCell.TYPE_TEXT,
                    ASCompat.toString(entry.value), this._canModify, false,
                    ASCompat.toString(entry.value));
                rows.push(new WiredMenuTableObject("value_" + entry.variableId, {
                    "variable": entry.variableId,
                    "value": editable,
                    "created": entry.createdText,
                    "updated": entry.updatedText
                }, entry));
            }
            if (this._detailTable != null)
            {
                this._detailTable.setObjects(rows, true);
            }
            this.populateCreatePicker();
            this.updateDetailButtons();
            this._detail.visible = true;
            this._detail.activate();
        }

        public function onMutationResult(success:Bool)
        {
            if (success && this._requestDetailsCallback != null &&
                this._detail != null && this._detail.visible)
            {
                this._requestDetailsCallback(this._detailType, this._detailId);
            }
        }

        public function close()
        {
            if (this._overview != null) this._overview.visible = false;
            if (this._detail != null) this._detail.visible = false;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._overviewTable != null)
            {
                this._overviewTable.dispose();
                this._overviewTable = null;
            }
            if (this._detailTable != null)
            {
                this._detailTable.dispose();
                this._detailTable = null;
            }
            if (this._detailPreviewer != null)
            {
                this._detailPreviewer.dispose();
                this._detailPreviewer = null;
            }
            if (this._overview != null)
            {
                this._overview.dispose();
                this._overview = null;
            }
            if (this._detail != null)
            {
                this._detail.dispose();
                this._detail = null;
            }
            this._roomEvents = null;
            this._requestPageCallback = null;
            this._requestDetailsCallback = null;
            this._mutationCallback = null;
            this._creatableVariables = null;
            this._availableCreateVariables = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function ensureOverview()
        {
            if (this._overview != null || this._disposed)
            {
                return;
            }
            this._overview = Std.downcast(this._roomEvents.getXmlWindow(
                "wired_menu_variables_management_overview") , IFrameWindow);
            if (this._overview == null)
            {
                return;
            }
            this._roomEvents.windowManager.getDesktop(1).addChild(this._overview);
            this._overview.center();
            this.bindClose(this._overview, this.onOverviewClose);
            this.bindClick(this._overview, "refresh_btn", this.onRefresh);
            this.bindClick(this._overview, "first_page_btn", this.onFirstPage);
            this.bindClick(this._overview, "prev_page_btn", this.onPreviousPage);
            this.bindClick(this._overview, "next_page_btn", this.onNextPage);
            this.bindClick(this._overview, "last_page_btn", this.onLastPage);
            var userType=
                Std.downcast(this._overview.findChildByName("user_type_menu") , IDropMenuWindow);
            var sortType=
                Std.downcast(this._overview.findChildByName("sort_type_menu") , IDropMenuWindow);
            if (userType != null)
            {
                userType.selection = 0;
                userType.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onOverviewFilterChanged);
            }
            if (sortType != null)
            {
                sortType.selection = 0;
                sortType.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onOverviewFilterChanged);
            }
            var pageInput=
                Std.downcast(this._overview.findChildByName("pagina_number_input") , ITextFieldWindow);
            if (pageInput != null)
            {
                pageInput.restrict = "0-9";
                pageInput.maxChars = 6;
                pageInput.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN,
                    this.onPageKey);
            }
            this._overviewTable = this.createTable(this._overview, "table_view",
                Vector.ofArray([
                    new TableColumn("usertype", this.loc(
                        "wiredmenu.variable_management.col.usertype", "User type"), 0.10, "left"),
                    new TableColumn("name", this.loc(
                        "wiredmenu.variable_management.col.name", "Name"), 0.18, "left"),
                    new TableColumn("creation_time", this.loc(
                        "wiredmenu.variable_management.col.creation_time",
                        "Creation time"), 0.21, "left"),
                    new TableColumn("last_update_time", this.loc(
                        "wiredmenu.variable_management.col.last_update_time",
                        "Last update time"), 0.21, "left"),
                    new TableColumn("value", this.loc(
                        "wiredmenu.variable_management.col.value", "Value"), 0.18, "right"),
                    new TableColumn("manage", this.loc(
                        "wiredmenu.variable_management.col.manage", "Manage"), 0.12, "left")
                ]), true);
            if (this._overviewTable != null)
            {
                this._overviewTable.onRowClickedCallback = this.onOverviewRowClicked;
            }
        }

        function ensureDetail()
        {
            if (this._detail != null || this._disposed)
            {
                return;
            }
            this._detail = Std.downcast(this._roomEvents.getXmlWindow(
                "wired_menu_variables_management_detail") , IFrameWindow);
            if (this._detail == null)
            {
                return;
            }
            this._roomEvents.windowManager.getDesktop(1).addChild(this._detail);
            this._detail.center();
            var preview=
                Std.downcast(this._detail.findChildByName("preview") , IWindowContainer);
            if (preview != null)
            {
                this._detailPreviewer =
                    new WiredMenuPermanentVariablePreviewer(
                        preview, this._roomEvents);
            }
            this.bindClose(this._detail, this.onDetailClose);
            this.bindClick(this._detail, "refresh_btn", this.onDetailRefresh);
            this.bindClick(this._detail, "add_var_btn", this.onAdd);
            this.bindClick(this._detail, "delete_var_btn", this.onDelete);
            this.bindClick(this._detail, "create_var_btn", this.onCreate);
            this._detailTable = this.createTable(this._detail,
                "variable_values_table_container", Vector.ofArray([
                    new TableColumn("variable", this.loc(
                        "wiredmenu.inspection.variables.variable", "Variable"), 0.34, "left"),
                    new TableColumn("value", this.loc(
                        "wiredmenu.inspection.variables.value", "Value"), 0.16, "right"),
                    new TableColumn("created", this.loc(
                        "wiredmenu.variable_management.col.creation_time",
                        "Creation time"), 0.25, "left"),
                    new TableColumn("updated", this.loc(
                        "wiredmenu.variable_management.col.last_update_time",
                        "Last update time"), 0.25, "left")
                ]), true);
            if (this._detailTable != null)
            {
                this._detailTable.onRowSelectedCallback = this.onDetailRowSelected;
                this._detailTable.onCellEditCallback = this.onDetailCellEdited;
            }
            var input=
                Std.downcast(this._detail.findChildByName("value_input") , ITextFieldWindow);
            if (input != null)
            {
                input.restrict = "0-9\\-";
                input.maxChars = 11;
            }
            this.createVariablePicker();
            this.setBubbleVisible(false);
        }

        function createTable(window:IFrameWindow, containerName:String,
                                     columns:Vector<TableColumn>,
                                     selectable:Bool):TableView
        {
            var parent=
                Std.downcast(window.findChildByName(containerName) , IWindowContainer);
            var asset=
                Std.downcast(this._roomEvents.assets.getAssetByName("table_view_xml") , XmlAsset);
            if (parent == null || asset == null)
            {
                return null;
            }
            var table= new TableView(this._roomEvents.windowManager,
                parent, true, false, asset);
            table.initialize(columns, true, selectable);
            return table;
        }

        function createVariablePicker()
        {
            if (this._createPicker != null || this._overview == null ||
                this._detail == null)
            {
                return;
            }
            var template=
                Std.downcast(this._overview.findChildByName("user_type_menu") , IDropMenuWindow);
            var parent=
                Std.downcast(this._detail.findChildByName("var_picker_container") , IWindowContainer);
            if (template == null || parent == null)
            {
                return;
            }
            this._createPicker = Std.downcast(template.clone() , IDropMenuWindow);
            this._createPicker.name = "create_variable_picker";
            this._createPicker.x = 0;
            this._createPicker.y = 0;
            this._createPicker.width = parent.width;
            parent.addChild(this._createPicker);
        }

        function populateCreatePicker()
        {
var id:String  = null;            if (this._detail == null)
            {
                return;
            }
            this.createVariablePicker();
            if (this._createPicker == null)
            {
                return;
            }
            var existing:ASObject = {};
            var entry:ASObject = null;
            final _iter_ = this._detailEntries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry  = _tmp_;
ASCompat.setDynamicProperty(                existing, ASCompat.toString(entry.variableId), true);
            }
            this._availableCreateVariables = [];
            var labels:Array<ASAny> = [];
            var variable:ASObject = null;
            final _iter_ = this._creatableVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
variable  = _tmp_;
id= ASCompat.toString(variable.id);
                if (!ASCompat.getDynamicProperty(existing, id))
                {
                    this._availableCreateVariables.push(variable);
                    labels.push(variable.name == null ? id : ASCompat.toString(variable.name));
                }
            }
            this._createPicker.populate(labels);
            this._createPicker.selection = labels.length == 0 ? -1 : 0;
            this.updateDetailButtons();
        }

        function renderDetailInfo(parser:ASObject)
        {
var key:String = null;            var info=
                Std.downcast(this._detail.findChildByName("info_box_text") , ITextFieldWindow);
            if (info != null)
            {
key;
                if (ASCompat.toInt(parser.type) == 1)
                {
                    key = "wiredmenu.variable_management_detail.info.user";
                    info.text = this._roomEvents.localization
                        .getLocalizationWithParams(key, "",
                            ["name", ASCompat.toString(parser.name),
                            "id", ASCompat.toString(parser.id)]);
                }
                else
                {
                    key = ASCompat.toInt(parser.type) == 2
                        ? "wiredmenu.variable_management_detail.info.pet"
                        : "wiredmenu.variable_management_detail.info.bot";
                    info.text = this._roomEvents.localization
                        .getLocalizationWithParams(key, "",
                            ["name", ASCompat.toString(parser.name),
                            "id", ASCompat.toString(parser.id),
                            "owner_name", ASCompat.toString(parser.ownerName),
                            "owner_id", ASCompat.toString(parser.ownerId)]);
                }
            }
        }

        function renderDetailPreview(parser:ASObject)
        {
            if (this._detailPreviewer == null)
            {
                return;
            }
            if (ASCompat.toInt(parser.type) == 2)
            {
                this._detailPreviewer.showPet(ASCompat.toString(parser.figure));
            }
            else
            {
                this._detailPreviewer.showUser(
                    ASCompat.toString(parser.figure), ASCompat.toInt(parser.id));
            }
        }

        function requestPage(page:Int)
        {
            if (this._requestPageCallback == null || this._overview == null)
            {
                return;
            }
            var userType=
                Std.downcast(this._overview.findChildByName("user_type_menu") , IDropMenuWindow);
            var sortType=
                Std.downcast(this._overview.findChildByName("sort_type_menu") , IDropMenuWindow);
            var userSelection= Std.int(userType == null ? 0 :
                Std.int(Math.max(0, Math.min(USER_FILTERS.length - 1, userType.selection))));
            this._requestPageCallback(this._variableId, Math.max(1, page),
                PAGE_SIZE,
                sortType == null ? 0 : Math.max(0, sortType.selection),
                USER_FILTERS[userSelection]);
        }

        function applyResponseFilters(parser:ASObject)
        {
            var userType=
                Std.downcast(this._overview.findChildByName("user_type_menu") , IDropMenuWindow);
            var sortType=
                Std.downcast(this._overview.findChildByName("sort_type_menu") , IDropMenuWindow);
            var userIndex= USER_FILTERS.indexOf(ASCompat.toInt(parser.userFilter));
            if (userType != null) userType.selection = Std.int(Math.max(0, userIndex));
            if (sortType != null) sortType.selection = Std.int(Math.max(0, ASCompat.toInt(parser.sortFilter)));
        }

        function updatePagination()
        {
            var pages= Std.int(Math.max(1, Math.fceil(this._total / PAGE_SIZE)));
            this._page = Std.int(Math.min(Math.max(1, this._page), pages));
            var start=
                Std.downcast(this._overview.findChildByName("pagina_text_start") , ITextWindow);
            var end=
                Std.downcast(this._overview.findChildByName("pagina_text_end") , ITextWindow);
            var input=
                Std.downcast(this._overview.findChildByName("pagina_number_input") , ITextFieldWindow);
            if (start != null)
                start.text = Std.string(this._total) + " users found. Showing page";
            if (input != null) input.text = Std.string(this._page);
            if (end != null) end.text = "of " + Std.string(pages);
            this.setEnabled(this._overview, "first_page_btn", this._page > 1);
            this.setEnabled(this._overview, "prev_page_btn", this._page > 1);
            this.setEnabled(this._overview, "next_page_btn", this._page < pages);
            this.setEnabled(this._overview, "last_page_btn", this._page < pages);
        }

        function updateDetailButtons()
        {
            if (this._detail == null)
            {
                return;
            }
            this.setEnabled(this._detail, "delete_var_btn",
                this._canModify && this._selectedDetail != null);
            this.setEnabled(this._detail, "add_var_btn",
                this._canModify && this._availableCreateVariables.length > 0);
            this.setEnabled(this._detail, "create_var_btn",
                this._canModify && this._availableCreateVariables.length > 0);
        }

        function mutate(variableId:String, value:Int, operation:Int)
        {
            if (this._canModify && this._mutationCallback != null &&
                variableId != null &&
                variableId.length > 0)
            {
                this._mutationCallback(this._detailType, this._detailId,
                    variableId, value, operation);
            }
        }

        function parseInt32(value:String):Float
        {
            if (value == null || !new compat.RegExp("^-?\\d+$").test(value))
            {
                return Math.NaN;
            }
            var number= ASCompat.toNumber(value);
            if (Math.isNaN(number) || number < -2147483648
                || number > 2147483647)
            {
                return Math.NaN;
            }
            return number;
        }

        function bindClose(window:IFrameWindow,
                                   callback:ASFunction)
        {
            var close= window.findChildByTag("close");
            if (close != null)
            {
                close.addEventListener(WindowMouseEvent.CLICK, callback);
            }
        }

        function bindClick(window:IFrameWindow, name:String,
                                   callback:ASFunction)
        {
            var child= window.findChildByName(name);
            if (child != null)
            {
                child.addEventListener(WindowMouseEvent.CLICK, callback);
            }
        }

        function setEnabled(window:IFrameWindow, name:String,
                                    enabled:Bool)
        {
            var child= window.findChildByName(name);
            if (child != null)
            {
                if (enabled) child.enable(); else child.disable();
            }
        }

        function setBubbleVisible(visible:Bool)
        {
            var bubble=
                this._detail.findChildByName("create_var_bubble");
            if (bubble != null)
            {
                bubble.visible = visible;
            }
        }

        function loc(key:String, fallback:String):String
        {
            return this._roomEvents.localization.getLocalization(key, fallback);
        }

        function onOverviewClose(event:WindowMouseEvent)
        {
            this._overview.visible = false;
        }
        function onDetailClose(event:WindowMouseEvent)
        {
            this._detail.visible = false;
        }
        function onRefresh(event:WindowMouseEvent)
        {
            this.requestPage(this._page);
        }
        function onFirstPage(event:WindowMouseEvent) { this.requestPage(1); }
        function onPreviousPage(event:WindowMouseEvent)
        {
            this.requestPage(Std.int(Math.max(1, this._page - 1)));
        }
        function onNextPage(event:WindowMouseEvent)
        {
            this.requestPage(this._page + 1);
        }
        function onLastPage(event:WindowMouseEvent)
        {
            this.requestPage(Std.int(Math.max(1, Math.fceil(this._total / PAGE_SIZE))));
        }
        function onOverviewFilterChanged(event:WindowEvent)
        {
            this.requestPage(1);
        }
        function onPageKey(event:WindowKeyboardEvent)
        {
            if (event.charCode == Keyboard.ENTER)
            {
                this.requestPage(Std.int(Math.max(1,
                    ASCompat.toInt(cast(event.window, ITextFieldWindow).text))));
            }
        }
        function onOverviewRowClicked(object:ITableObject)
        {
            var row= Std.downcast(object , WiredMenuTableObject);
            if (row != null && row.data != null &&
                this._requestDetailsCallback != null)
            {
                this._requestDetailsCallback(ASCompat.toInt(row.data.type), ASCompat.toInt(row.data.id));
            }
        }
        function onDetailRefresh(event:WindowMouseEvent)
        {
            if (this._requestDetailsCallback != null)
            {
                this._requestDetailsCallback(this._detailType, this._detailId);
            }
        }
        function onDetailRowSelected(object:ITableObject)
        {
            this._selectedDetail = Std.downcast(object , WiredMenuTableObject);
            this.updateDetailButtons();
        }
        function onDetailCellEdited(object:ITableObject, columnId:String,
                                            value:String)
        {
            var row= Std.downcast(object , WiredMenuTableObject);
            if (row == null || row.data == null || columnId != "value")
            {
                return;
            }
            var parsed= this.parseInt32(value);
            if (!Math.isNaN(parsed))
            {
                this.mutate(ASCompat.toString(row.data.variableId), Std.int(parsed), 0);
            }
        }
        function onAdd(event:WindowMouseEvent)
        {
            if (!this._canModify
                || this._availableCreateVariables.length == 0)
            {
                return;
            }
            this.populateCreatePicker();
            this.setBubbleVisible(true);
        }
        function onDelete(event:WindowMouseEvent)
        {
            if (this._selectedDetail != null &&
                this._selectedDetail.data != null)
            {
                this.mutate(ASCompat.toString(this._selectedDetail.data.variableId), 0, 2);
            }
        }
        function onCreate(event:WindowMouseEvent)
        {
            if (this._createPicker == null ||
                this._createPicker.selection < 0 ||
                this._createPicker.selection >=
                    this._availableCreateVariables.length)
            {
                return;
            }
            var input=
                Std.downcast(this._detail.findChildByName("value_input") , ITextFieldWindow);
            var variable:ASObject =
                this._availableCreateVariables[this._createPicker.selection];
            var parsed= this.parseInt32(
                input == null ? "0" : input.text);
            if (Math.isNaN(parsed))
            {
                return;
            }
            this.mutate(ASCompat.toString(variable.id), Std.int(parsed), 1);
            this.setBubbleVisible(false);
        }
    }

