package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITabButtonWindow;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.ObjectIdAndValuePair;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableColumn;
    import com.sulake.habbo.window.utils.tableview.TableView;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu.*;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionInfo;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogPage;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.preferences.AccountPreferencesEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu.*;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.SetChestRoomLocksMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions.RequestRoomTransactionLogsMessageComposer;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.*;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * July 2026 Wired Menu shell.  The menu is room-scoped and only opens after
     * the server advertises the Wired Menu capability. Creator Tools are a
     * separate product and are intentionally not exposed here.
     */
     final class WiredMenuController implements IDisposable implements  ILinkEventTracker
    {
        static inline final COLOR_RED= "ff5733";
        static inline final COLOR_ORANGE= "BD7800";
        static inline final COLOR_GREEN= "008000";

        public static inline final MONITOR= "monitor";
        public static inline final OVERVIEW= "variable_overview";
        public static inline final INSPECTION= "inspection";
        public static inline final CHESTS= "chests";
        public static inline final SETTINGS= "settings";
        public static inline final INFO= "info";

        static final TABS:Array<ASAny> =
            [MONITOR, OVERVIEW, INSPECTION, CHESTS, SETTINGS];

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _window:IFrameWindow;
        var _activeTab:String;
        var _messageEvents:Array<ASAny> = [];
        var _modifyMask:Int = 8;
        var _readMask:Int = 15;
        var _timezone:String = "UTC";
        var _writePermission:Bool = false;
        var _readPermission:Bool = true;
        var _ignoreSettings:Bool = false;
        var _menuButton:Bool = true;
        var _inspectButton:Bool = true;
        var _playtest:Bool = false;
        var _allNotifications:Bool = false;
        var _whisperDisabled:Bool = false;
        var _uiStyle:String = "";
        var _selectedVariableId:String;
        var _requestedVariableId:String;
        var _allVariables:Vector<WiredVariable> =
            new Vector();
        var _overviewTarget:Int = 0;
        var _timezoneValues:Array<ASAny> = [];
        var _wiredStyleValues:Array<ASAny> = ["", "illumina"];
        var _inspectionPickerIds:Array<ASAny> = [];
        var _inspectionExisting:ASObject = {};
        var _selectedInspectionVariableId:String;
        var _inspectionVariablePicker:IDropMenuWindow;
        var _inspectionPinned:Bool = false;
        var _monitorHeavy:Bool = false;
        var _monitorOverThreshold:Bool = false;
        var _configuredWiredIds:Array<ASAny> = [];
        var _wiredIdsHighlighted:Bool = false;
        var _variablesById:ASObject = {};
        var _inspectedType:Int = -1;
        var _inspectedId:Int = -1;
        var _inspectionReady:Bool = false;
        var _errorTable:TableView;
        var _variableListTable:TableView;
        var _propertyTable:TableView;
        var _textTable:TableView;
        var _inspectionTable:TableView;
        var _inspectionPreviewer:WiredMenuInspectionPreviewer;
        var _chestTransactionsTable:TableView;
        var _chestTransactions:WiredTransactionLogPage;
        var _holderHighlighter:WiredMenuHolderHighlighter;
        var _logsWindow:WiredMenuLogsWindow;
        var _errorInfoWindow:WiredMenuErrorInfoWindow;
        var _variableManagementWindow:
            WiredMenuVariableManagementWindow;
        var _monitorTimer:Timer;
        var _overviewTimer:Timer;
        var _inspectionTimer:Timer;
        var _chestTimer:Timer;
        var _chestLockTimer:Timer;
        var _chestLockPending:Bool = false;
        var _holderIds:Array<ASAny> = [];
        var _holdersHighlighted:Bool = false;
        var _disposed:Bool = false;

        public function new(roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._holderHighlighter =
                new WiredMenuHolderHighlighter(roomEvents);
            this._logsWindow = new WiredMenuLogsWindow(
                roomEvents, this.requestLogsPage);
            this._errorInfoWindow =
                new WiredMenuErrorInfoWindow(roomEvents);
            this._variableManagementWindow =
                new WiredMenuVariableManagementWindow(
                    roomEvents, this.requestUserVariablesPage,
                    this.requestPermanentVariables,
                    this.mutatePermanentVariable);
            this._monitorTimer = new Timer(500);
            this._monitorTimer.addEventListener(
                TimerEvent.TIMER, (this.onMonitorPoll : ASAny));
            this._overviewTimer = new Timer(500);
            this._overviewTimer.addEventListener(
                TimerEvent.TIMER, (this.onOverviewPoll : ASAny));
            this._inspectionTimer = new Timer(500);
            this._inspectionTimer.addEventListener(
                TimerEvent.TIMER, (this.onInspectionPoll : ASAny));
            this._chestTimer = new Timer(20000);
            this._chestTimer.addEventListener(
                TimerEvent.TIMER, (this.onChestPoll : ASAny));
            this._chestLockTimer = new Timer(500, 1);
            this._chestLockTimer.addEventListener(
                TimerEvent.TIMER_COMPLETE, (this.onChestLockTimeout : ASAny));
            this.addMessageEvent(new WiredMenuPermissionsEvent(this.onPermissions));
            this.addMessageEvent(new WiredMenuRoomSettingsEvent(this.onRoomSettings));
            this.addMessageEvent(new WiredMenuRoomStatsEvent(this.onRoomStats));
            this.addMessageEvent(new WiredMenuErrorsEvent(this.onErrors));
            this.addMessageEvent(new WiredMenuInspectionEvent(this.onInspection));
            this.addMessageEvent(new WiredMenuErrorEvent(this.onInspectionError));
            this.addMessageEvent(new WiredMenuMutationResultEvent(this.onMutation));
            this.addMessageEvent(new WiredMenuLogsPageEvent(this.onLogs));
            this.addMessageEvent(new WiredMenuVariableHoldersEvent(this.onVariableHolders));
            this.addMessageEvent(new WiredMenuUserVariablesPageEvent(this.onUserVariables));
            this.addMessageEvent(new WiredMenuPermanentVariablesEvent(this.onPermanentVariables));
            this.addMessageEvent(
                new WiredTransactionLogsMessageEvent(this.onChestTransactionLogs));
            this.addMessageEvent(new AccountPreferencesEvent(this.onAccountPreferences));
        }

        function addMessageEvent(event:IMessageEvent)
        {
            this._messageEvents.push(
                this._roomEvents.communication.addHabboConnectionMessageEvent(event));
        }

        public function show(tab:String = MONITOR)
        {
            if (this._roomEvents.roomId <= 0 ||
                !this._roomEvents.isWiredFeatureEnabled(WiredCapabilityCodes.WIRED_MENU))
            {
                this._roomEvents.showWiredNotification("wiredmenu.invalid_room.desc");
                return;
            }
            this.ensureWindow();
            this.selectTab(TABS.indexOf(tab) >= 0 ? tab : MONITOR);
            if (this._window.parent == null)
            {
                this._roomEvents.windowManager.getDesktop(1).addChild(this._window);
            }
            this._window.center();
            this._window.activate();
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "wiredmenu/";
        }

        public function linkReceived(link:String)
        {
var type = 0, objectId = 0;            if (link == null)
            {
                return;
            }
            var parts:Array<ASAny> = (cast link.split("/"));
            if (parts.length < 2)
            {
                return;
            }
            if (parts[1] == "logs")
            {
                this.show(MONITOR);
                if (this._logsWindow != null)
                {
                    this._logsWindow.show();
                }
                return;
            }
            if (parts[1] != "open")
            {
                return;
            }
            var tab= parts.length > 2 ? ASCompat.toString(parts[2]) : MONITOR;
            this.show(tab);
            if (tab == INSPECTION && parts.length >= 5)
            {
type= ASCompat.toInt(parts[3]);
objectId= ASCompat.toInt(parts[4]);
                if ((type == 0 && objectId != 0)
                    || (type == 1 && objectId > 0)
                    || (type == -10 && objectId == 0))
                {
                    this._roomEvents.send(
                        new InspectWiredObjectComposer(type, objectId));
                }
            }
            else if (tab == OVERVIEW && parts.length >= 4)
            {
                try
                {
                    this._selectedVariableId =
                        ASCompat.decodeURIComponent(ASCompat.toString(parts[3]));
                }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                 {
                    this._selectedVariableId = null;
                    return;
                }
 }                this._roomEvents.variablesSynchronizer.getAllVariables(
                    this.onVariablesLoaded, true);
            }
        }

        public function hide()
        {
            if (this._monitorTimer != null)
            {
                this._monitorTimer.stop();
            }
            if (this._chestTimer != null)
            {
                this._chestTimer.stop();
            }
            if (this._overviewTimer != null)
            {
                this._overviewTimer.stop();
            }
            if (this._inspectionTimer != null)
            {
                this._inspectionTimer.stop();
            }
            if (this._window != null && this._window.parent != null)
            {
                Std.downcast(this._window.parent , IWindowContainer).removeChild(this._window);
            }
        }

        public function resetRoom()
        {
            if (this._holderHighlighter != null)
            {
                this._holderHighlighter.clear();
            }
            this._holdersHighlighted = false;
            if (this._logsWindow != null)
            {
                this._logsWindow.close();
            }
            if (this._errorInfoWindow != null)
            {
                this._errorInfoWindow.hide();
            }
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.close();
            }
            this.hide();
            this._activeTab = null;
            this._inspectedType = -1;
            this._inspectedId = -1;
            this._inspectionReady = false;
            if (this._inspectionPreviewer != null)
            {
                this._inspectionPreviewer.clear();
            }
            this._chestTransactions = null;
            if (this._chestTransactionsTable != null)
            {
                this._chestTransactionsTable.clear();
            }
        }

        function ensureWindow()
        {
var id:String  = null, button:ITabButtonWindow  = null;            if (this._window != null)
            {
                return;
            }
            this._window = Std.downcast(this._roomEvents.getXmlWindow("wired_menu_view") , IFrameWindow);
            if (this._window == null)
            {
                throw new ASError("wired_menu_view_xml could not be created");
            }
            var close= this._window.findChildByTag("close");
            if (close != null)
            {
                close.addEventListener(WindowMouseEvent.CLICK, this.onClose);
            }
            var context=
                Std.downcast(this._window.findChildByName("tab_context") , ITabContextWindow);
            final _iter_ = TABS; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
id = _tmp_;
button=
                    Std.downcast(this._window.findChildByName("top_view_" + id + "_button")
, ITabButtonWindow);
                if (button != null)
                {
                    button.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                        this.onTabSelected);
                }
            }
            var chests= this._window.findChildByName("top_view_chests_button");
            if (chests != null)
            {
                chests.visible = this._roomEvents.isWiredFeatureEnabled(
                    WiredCapabilityCodes.MENU_CHESTS);
            }
            // July ships the empty Info view as a dormant, disabled tab.
            var info=
                this._window.findChildByName("top_view_" + INFO + "_button");
            if (info != null)
            {
                info.visible = false;
                info.width = 0;
            }
            var infoContainer=
                this._window.findChildByName(INFO + "_container");
            if (infoContainer != null)
            {
                infoContainer.visible = false;
            }
            this.alignVisibleTabs(context);
            this.initializeTables();
            var inspectionPreview=
                Std.downcast(this._window.findChildByName("preview_container")
, IWindowContainer);
            if (inspectionPreview != null)
            {
                this._inspectionPreviewer =
                    new WiredMenuInspectionPreviewer(
                        inspectionPreview, this._roomEvents);
                this.updateInspectionPreview();
            }
            this.bindSettingsControls();
            this.bindVariableControls();
            this.initializeTimezonePicker();
            this.initializeWiredStylePicker();
            this.initializeDiscordLink();
            this.bindChestControls();
            this.applyPreferences();
        }

        function initializeTables()
        {
            var tableAsset=
                Std.downcast(this._roomEvents.assets.getAssetByName("table_view_xml") , XmlAsset);
            if (tableAsset == null)
            {
                throw new ASError("table_view_xml is required by Wired Menu");
            }
            this._errorTable = this.createTable("log_table_container", [
                new TableColumn("name", this.loc("wiredmenu.monitor.column.type"), 0.33),
                new TableColumn("category", this.loc("wiredmenu.monitor.column.category"), 0.22),
                new TableColumn("count", this.loc("wiredmenu.monitor.column.occurrences"), 0.15),
                new TableColumn("latest", this.loc("wiredmenu.monitor.column.latest"), 0.30)
            ], tableAsset);
            if (this._errorTable != null)
            {
                this._errorTable.onRowClickedCallback =
                    this.onErrorSelected;
            }
            this._variableListTable = this.createTable("variable_list_container", [
                new TableColumn("name",
                    this.loc("wiredmenu.variable_overview.picker"), 1, "left")
            ], tableAsset);
            if (this._variableListTable != null)
            {
                this._variableListTable.onRowSelectedCallback =
                    this.onVariableSelected;
            }
            this._propertyTable =
                this.createTable("variable_properties_table_container", [
                    new TableColumn("property",
                        this.loc("wiredmenu.variable_overview.properties.column.property"),
                        0.52, "left"),
                    new TableColumn("value",
                        this.loc("wiredmenu.variable_overview.properties.column.value"),
                        0.48, "left")
                ], tableAsset);
            this._textTable =
                this.createTable("variable_texts_table_container", [
                    new TableColumn("value",
                        this.loc("wiredmenu.variable_overview.text.column.value"),
                        0.25, "left"),
                    new TableColumn("text",
                        this.loc("wiredmenu.variable_overview.text.column.text"),
                        0.75, "left")
                ], tableAsset);
            this._inspectionTable =
                this.createTable("variable_values_table_container", [
                    new TableColumn("variable",
                        this.loc("wiredmenu.inspection.variables.variable"),
                        0.65, "left"),
                    new TableColumn("value",
                        this.loc("wiredmenu.inspection.variables.value"),
                        0.35, "right")
                ], tableAsset);
            if (this._inspectionTable != null)
            {
                this._inspectionTable.onCellEditCallback =
                    this.onInspectionCellEdited;
                this._inspectionTable.onRowSelectedCallback =
                    this.onInspectionRowSelected;
            }
            this._chestTransactionsTable =
                this.createTable("logs_table_container", [
                    new TableColumn("type",
                        this.loc("wiredmenu.chests.room_logs.column.type"), 0.28),
                    new TableColumn("username",
                        this.loc("wiredmenu.chests.room_logs.column.username"), 0.24),
                    new TableColumn("withdraws",
                        this.loc("wiredmenu.chests.room_logs.column.withdraws"), 0.24),
                    new TableColumn("deposits",
                        this.loc("wiredmenu.chests.room_logs.column.deposits"), 0.24)
                ], tableAsset);
        }

        function bindChestControls()
        {
            this.bindClick("lock_own_button", this.onLockOwnChests);
            this.bindClick("unlock_own_button", this.onUnlockOwnChests);
            this.bindClick("lock_all_button", this.onLockAllChests);
            this.bindClick("view_in_detail_button", this.onViewChestLogs);
            this.updateChestButtons();
        }

        function createTable(containerName:String, columns:Array<ASAny>,
                                     asset:XmlAsset):TableView
        {
            var parent=
                Std.downcast(this._window.findChildByName(containerName) , IWindowContainer);
            if (parent == null)
            {
                return null;
            }
            var table= new TableView(this._roomEvents.windowManager,
                parent, true, false, asset);
            table.initialize(Vector.ofArray(((cast columns) : Array<TableColumn>)), true, true);
            return table;
        }

        function loc(key:String):String
        {
            return this._roomEvents.localization.getLocalization(key, key);
        }

        function alignVisibleTabs(context:ITabContextWindow)
        {
var             index = 0, item:ITabButtonWindow  = null;            if (context == null)
            {
                return;
            }
            var count= 0;
            var index = 0;
            index= 0;while ((index : UInt) < context.numTabs)
            {
                if (context.getTabButtonAt(index).visible)
                {
                    count++;
                }
index++;
            }
            if (count == 0)
            {
                return;
            }
            index= 0;while ((index : UInt) < context.numTabs)
            {
item= context.getTabButtonAt(index);
                if (item.visible)
                {
                    item.width = Std.int(item.parent.width / count);
                }
index++;
            }
        }

        function bindSettingsControls()
        {
var name:String  = null, checkbox:ICheckBoxWindow  = null;            var names:Array<ASAny> = [
                "modify_1_checkbox", "modify_2_checkbox", "modify_3_checkbox",
                "read_0_checkbox", "read_1_checkbox", "read_2_checkbox",
                "read_3_checkbox", "preference_toolbar_checkbox",
                "preference_inspect_button_checkbox",
                "preference_playtest_checkbox",
                "preference_all_notifications_checkbox"
            ];
            if (checkNullIteratee(names)) for (_tmp_ in names)
            {
name = _tmp_;
checkbox=
                    Std.downcast(this._window.findChildByName(name) , ICheckBoxWindow);
                if (checkbox != null)
                {
                    checkbox.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                        this.onSettingChanged);
                    checkbox.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED,
                        this.onSettingChanged);
                }
            }
            this.bindClick("reload_room_btn", this.onReload);
            this.bindClick("roll_back_btn", this.onRollback);
            this.bindClick("clear_log_btn", this.onClearErrors);
            this.bindClick("log_overview_btn", this.onOpenLogs);
        }

        function bindVariableControls()
        {
            var overview=
                Std.downcast(this._window.findChildByName("variable_overview_container")
, IWindowContainer);
            var inspection=
                Std.downcast(this._window.findChildByName("inspection_container")
, IWindowContainer);
            this.bindTypeButton(overview, "type_furni_button",
                this.onOverviewType);
            this.bindTypeButton(overview, "type_user_button",
                this.onOverviewType);
            this.bindTypeButton(overview, "type_global_button",
                this.onOverviewType);
            this.bindTypeButton(overview, "type_context_button",
                this.onOverviewType);
            this.bindScopedClick(overview, "manage_button",
                this.onManageVariable);
            this.bindScopedClick(overview, "highlight_holders_button",
                this.onHighlightHolders);
            this.bindTypeButton(inspection, "type_furni_button",
                this.onInspectionType);
            this.bindTypeButton(inspection, "type_user_button",
                this.onInspectionType);
            this.bindTypeButton(inspection, "type_global_button",
                this.onInspectionType);
            this.bindScopedClick(inspection, "add_var_btn",
                this.onAddVariable);
            this.bindScopedClick(inspection, "delete_var_btn",
                this.onDeleteVariable);
            this.bindScopedClick(inspection, "create_var_btn",
                this.onCreateVariable);
            this.bindScopedClick(inspection, "highlight_wired_btn",
                this.onHighlightWired);
            var pin:ICheckBoxWindow = inspection == null ? null :
                Std.downcast(inspection.findChildByName("pin_checkbox") , ICheckBoxWindow);
            if (pin != null)
            {
                pin.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                    this.onPinChanged);
                pin.addEventListener(WindowEvent.WINDOW_EVENT_UNSELECTED,
                    this.onPinChanged);
            }
            var source=
                Std.downcast(this._window.findChildByName("timezone_picker")
, IDropMenuWindow);
            var pickerContainer:IWindowContainer = inspection == null ? null :
                Std.downcast(inspection.findChildByName("var_picker_container")
, IWindowContainer);
            if (source != null && pickerContainer != null)
            {
                this._inspectionVariablePicker =
                    Std.downcast(source.clone() , IDropMenuWindow);
                this._inspectionVariablePicker.name =
                    "inspection_variable_picker";
                this._inspectionVariablePicker.x = 0;
                this._inspectionVariablePicker.y = 0;
                this._inspectionVariablePicker.width =
                    pickerContainer.width;
                pickerContainer.addChild(this._inspectionVariablePicker);
            }
            var input:ITextFieldWindow = inspection == null ? null :
                Std.downcast(inspection.findChildByName("value_input")
, ITextFieldWindow);
            if (input != null)
            {
                input.restrict = "0-9\\-";
                input.maxChars = 11;
            }
            var bubble:IWindow = inspection == null ? null :
                inspection.findChildByName("create_var_bubble");
            if (bubble != null)
            {
                bubble.visible = false;
            }
            this.setTypePickerState(overview, this._overviewTarget);
            this.setTypePickerState(inspection, 0);
            if (this._inspectedType == -1)
            {
                this._inspectedType = 0;
                this._inspectedId = -1;
                this._inspectionReady = false;
            }
            this.updateInspectionPreview();
        }

        function bindScopedClick(container:IWindowContainer,
                                         name:String,
                                         handler:ASFunction)
        {
            var window:IWindow = container == null ? null :
                container.findChildByName(name);
            if (window != null)
            {
                window.addEventListener(WindowMouseEvent.CLICK, handler);
            }
        }

        function bindTypeButton(container:IWindowContainer,
                                        name:String,
                                        handler:ASFunction)
        {
            var window:IWindow = container == null ? null :
                container.findChildByName(name);
            if (window != null)
            {
                window.addEventListener(WindowMouseEvent.UP, handler);
                window.addEventListener(WindowMouseEvent.OUT, handler);
            }
        }

        function initializeTimezonePicker()
        {
var candidate:String  = null;            var picker=
                Std.downcast(this._window.findChildByName("timezone_picker")
, IDropMenuWindow);
            if (picker == null)
            {
                return;
            }
            var raw= this._roomEvents.getProperty("wired.timezones");
            var configured:Array<ASAny> =
                raw == null || raw == "" ? ["UTC"] : (cast raw.split(","));
            this._timezoneValues = [];
            if (checkNullIteratee(configured)) for (_tmp_ in configured)
            {
candidate = _tmp_;
                candidate = candidate == null ? "" :                     new compat.RegExp("^\\s+|\\s+$", "g").replace(
candidate, "");
                if (candidate != ""
                    && this._timezoneValues.indexOf(candidate) < 0)
                {
                    this._timezoneValues.push(candidate);
                }
            }
            if (this._timezoneValues.indexOf("UTC") < 0)
            {
                this._timezoneValues.unshift("UTC");
            }
            picker.populate(this._timezoneValues);
            picker.selection = Std.int(Math.max(0,
                this._timezoneValues.indexOf(this._timezone)));
            picker.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                this.onTimezoneSelected);
        }

        function onTimezoneSelected(event:WindowEvent)
        {
            if (this._ignoreSettings)
            {
                return;
            }
            var picker= Std.downcast(event.target , IDropMenuWindow);
            if (picker == null || picker.selection < 0
                || picker.selection >= this._timezoneValues.length)
            {
                return;
            }
            this._timezone = ASCompat.toString(
                this._timezoneValues[picker.selection]);
            this._roomEvents.send(new UpdateWiredRoomSettingsComposer(
                this._modifyMask, this._readMask, this._timezone));
        }

        /**
         * July only exposes this picker when wired.ui_picker_enabled is true.
         * The clean client currently contains the Illumina editor style, so do
         * not advertise July's Volter choice until that style is ported too.
         */
        function initializeWiredStylePicker()
        {
            var border=
                this._window.findChildByName("wired_style_border");
            var picker=
                Std.downcast(this._window.findChildByName("wired_style_picker")
, IDropMenuWindow);
            var raw=
                this._roomEvents.getProperty("wired.ui_picker_enabled");
            var enabled= raw != null
                && (raw == "1" || raw.toLowerCase() == "true");
            if (border != null)
            {
                border.visible = enabled;
            }
            if (picker == null)
            {
                return;
            }
            var defaultLabel=
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.settings.preferences.wired_style.default",
                    "Default (Illumina)", ["name", "Illumina"]);
            picker.populate([defaultLabel, "Illumina"]);
            var index= this._wiredStyleValues.indexOf(this._uiStyle);
            picker.selection = index < 0 ? 0 : index;
            picker.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED,
                this.onWiredStyleSelected);
        }

        function onWiredStyleSelected(event:WindowEvent)
        {
            if (this._ignoreSettings)
            {
                return;
            }
            var picker= Std.downcast(event.target , IDropMenuWindow);
            if (picker == null || picker.selection < 0
                || picker.selection >= this._wiredStyleValues.length)
            {
                return;
            }
            this._uiStyle = ASCompat.toString(
                this._wiredStyleValues[picker.selection]);
            this.sendPreferences();
        }

        function initializeDiscordLink()
        {
            var region=
                this._window.findChildByName("discord_region");
            if (region == null)
            {
                return;
            }
            var link=
                this._roomEvents.getProperty("wired.discord.link");
            link = link == null ? "" : new compat.RegExp("^\\s+|\\s+$", "g").replace(link, "");
            region.visible = link != "";
            if (region.visible)
            {
                region.addEventListener(
                    WindowMouseEvent.CLICK, this.onDiscordClick);
            }
        }

        function onDiscordClick(event:WindowMouseEvent)
        {
            var link=
                this._roomEvents.getProperty("wired.discord.link");
            link = link == null ? "" : new compat.RegExp("^\\s+|\\s+$", "g").replace(link, "");
            if (link != "")
            {
                HabboWebTools.openWebPageAndMinimizeClient(link);
            }
        }

        function bindClick(name:String, handler:ASFunction)
        {
            var window= this._window.findChildByName(name);
            if (window != null)
            {
                window.addEventListener(WindowMouseEvent.CLICK, handler);
            }
        }

        function onTabSelected(event:WindowEvent)
        {
            var name= event.target.name;
            var prefix= "top_view_";
            var suffix= "_button";
            if (name.indexOf(prefix) != 0 ||
                name.lastIndexOf(suffix) != name.length - suffix.length)
            {
                return;
            }
            this.selectTab(name.substring(prefix.length,
                name.length - suffix.length));
        }

        function onChestTransactionLogs(event:IMessageEvent)
        {
            var page=
                Std.downcast(event , WiredTransactionLogsMessageEvent).getParser().page;
            if (page == null ||
                page.listType != WiredTransactionLogPage.LIST_ROOM ||
                page.amount != 10 || page.currentPage != 1)
            {
                return;
            }
            this._chestTransactions = page;
            this.renderChestTransactions();
        }

        function renderChestTransactions()
        {
var info:WiredTransactionInfo
 = null;            if (this._chestTransactionsTable == null ||
                this._chestTransactions == null)
            {
                return;
            }
            var rows= new Vector<ITableObject>();
            final _iter_ = this._chestTransactions.logs; if (checkNullIteratee(_iter_)) for (_tmp_                 in _iter_)
            {
info = _tmp_;
                rows.push(new WiredMenuChestTransactionTableObject(
                    this._roomEvents, info));
            }
            this._chestTransactionsTable.setObjects(rows);
        }

        function onChestPoll(event:TimerEvent)
        {
            if (this._activeTab == CHESTS)
            {
                this.requestChestPreview();
            }
        }

        function requestChestPreview()
        {
            this._roomEvents.send(
                new RequestRoomTransactionLogsMessageComposer(10, 1));
        }

        function onLockOwnChests(event:WindowMouseEvent)
        {
            this.sendChestLock(true, false);
        }

        function onUnlockOwnChests(event:WindowMouseEvent)
        {
            this.sendChestLock(false, false);
        }

        function onLockAllChests(event:WindowMouseEvent)
        {
            if (!this.isRoomOwnerOrStaff() || this._chestLockPending)
            {
                return;
            }
            this._roomEvents.windowManager.confirm(
                "${wiredmenu.chests.chest_control.lock_all.warning.title}",
                "${wiredmenu.chests.chest_control.lock_all.warning.desc}",
                0, this.onLockAllChestConfirmation);
        }

        function onLockAllChestConfirmation(
            dialog:IConfirmDialog, event:WindowEvent)
        {
            dialog.dispose();
            if (event.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this.sendChestLock(true, true);
            }
        }

        function sendChestLock(lock:Bool, all:Bool)
        {
            if (this._chestLockPending ||
                (all ? !this.isRoomOwnerOrStaff() : !this._writePermission))
            {
                return;
            }
            this._roomEvents.send(
                new SetChestRoomLocksMessageComposer(lock, all));
            this._chestLockPending = true;
            this._chestLockTimer.reset();
            this._chestLockTimer.start();
            this.updateChestButtons();
        }

        function onChestLockTimeout(event:TimerEvent)
        {
            this._chestLockPending = false;
            this.updateChestButtons();
        }

        function onViewChestLogs(event:WindowMouseEvent)
        {
            this._roomEvents.transactionLogsController.openRoomLogs();
        }

        function updateChestButtons()
        {
            if (this._window == null)
            {
                return;
            }
            var lockOwn=
                Std.downcast(this._window.findChildByName("lock_own_button") , IButtonWindow);
            var unlockOwn=
                Std.downcast(this._window.findChildByName("unlock_own_button") , IButtonWindow);
            var lockAll=
                Std.downcast(this._window.findChildByName("lock_all_button") , IButtonWindow);
            if (lockOwn != null)
            {
                Util.disableSection(lockOwn,
                    !this._writePermission || this._chestLockPending);
            }
            if (unlockOwn != null)
            {
                Util.disableSection(unlockOwn,
                    !this._writePermission || this._chestLockPending);
            }
            if (lockAll != null)
            {
                Util.disableSection(lockAll,
                    !this.isRoomOwnerOrStaff() || this._chestLockPending);
            }
        }

        function isRoomOwnerOrStaff():Bool
        {
            return this._roomEvents.roomSession != null
                && (this._roomEvents.roomSession.isRoomOwner
                    || (this._roomEvents.sessionDataManager != null
                        && this._roomEvents.sessionDataManager
                            .isAnyRoomController));
        }

        public function selectTab(id:String)
        {
var tabId:String  = null, container:IWindow  = null;            if (this._window == null || TABS.indexOf(id) < 0)
            {
                return;
            }
            if (id == CHESTS && !this._roomEvents.isWiredFeatureEnabled(
                WiredCapabilityCodes.MENU_CHESTS))
            {
                return;
            }
            final _iter_ = TABS; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
tabId = _tmp_;
container=
                    this._window.findChildByName(tabId + "_container");
                if (container != null)
                {
                    container.visible = tabId == id;
                }
            }
            this._activeTab = id;
            if (this._monitorTimer != null)
            {
                if (id == MONITOR)
                {
                    this._monitorTimer.start();
                }
                else
                {
                    this._monitorTimer.stop();
                }
            }
            if (this._overviewTimer != null)
            {
                if (id == OVERVIEW)
                {
                    this._overviewTimer.start();
                }
                else
                {
                    this._overviewTimer.stop();
                }
            }
            if (this._inspectionTimer != null)
            {
                if (id == INSPECTION)
                {
                    this._inspectionTimer.start();
                }
                else
                {
                    this._inspectionTimer.stop();
                }
            }
            if (this._chestTimer != null)
            {
                if (id == CHESTS)
                {
                    this._chestTimer.start();
                }
                else
                {
                    this._chestTimer.stop();
                }
            }
            var title=
                Std.downcast(this._window.findChildByName("header_title") , ITextWindow);
            if (title != null)
            {
                title.text = this._roomEvents.localization.getLocalization(
                    "wiredmenu." + id + ".title", id);
            }
            this.requestTabData(id);
        }

        function requestTabData(id:String)
        {
            // Packet-backed refreshes are kept at this boundary so selecting a
            // tab never trusts stale state from a previous room.
            if (id == OVERVIEW || id == INSPECTION)
            {
                this._roomEvents.variablesSynchronizer.getAllVariables(
                    this.onVariablesLoaded, true);
                if (id == INSPECTION && this._inspectedType == -10)
                {
                    this._roomEvents.send(
                        new InspectWiredObjectComposer(-10, 0));
                }
            }
            else if (id == MONITOR)
            {
                this._roomEvents.send(new RequestWiredRoomStatsComposer());
                this._roomEvents.send(new RequestWiredErrorsComposer());
            }
            else if (id == SETTINGS)
            {
                this._roomEvents.send(new RequestWiredRoomSettingsComposer());
            }
            else if (id == CHESTS)
            {
                this._chestTransactions = null;
                if (this._chestTransactionsTable != null)
                {
                    this._chestTransactionsTable.clear();
                }
                this.requestChestPreview();
            }
        }

        function onMonitorPoll(event:TimerEvent)
        {
            if (this._window != null && this._window.parent != null
                && this._activeTab == MONITOR)
            {
                this._roomEvents.send(
                    new RequestWiredRoomStatsComposer());
                this._roomEvents.send(
                    new RequestWiredErrorsComposer());
            }
        }

        function onOverviewPoll(event:TimerEvent)
        {
            if (this._window == null || this._window.parent == null
                || this._activeTab != OVERVIEW)
            {
                return;
            }
            this._roomEvents.variablesSynchronizer.getAllVariables(
                this.onVariablesLoaded, true);
            if (this._holdersHighlighted
                && this._selectedVariableId != null)
            {
                this._requestedVariableId = this._selectedVariableId;
                this._roomEvents.send(new RequestVariableHoldersComposer(
                    this._selectedVariableId));
            }
        }

        function onInspectionPoll(event:TimerEvent)
        {
            if (this._window != null && this._window.parent != null
                && this._activeTab == INSPECTION
                && this.hasValidInspectedHolder())
            {
                this._roomEvents.send(new InspectWiredObjectComposer(
                    this._inspectedType, this._inspectedId));
            }
        }

        function onVariablesLoaded(variables:ASAny)
        {
var variable:WiredVariable  = null, creatable:Array<ASAny>  = null;            if (this._window == null)
            {
                return;
            }
            this._allVariables = new Vector<WiredVariable>();
            this._variablesById = {};
            if (checkNullIteratee(variables)) for (_tmp_ in variables)
            {
variable = _tmp_;
                if (variable == null || variable.isInvisible
                    || this._allVariables.length >= 4096)
                {
                    continue;
                }
                this._allVariables.push(variable);
ASCompat.setDynamicProperty(                this._variablesById, variable.variableId, variable);
            }
            this.renderOverviewVariables();
            this.populateInspectionVariablePicker();
            if (this._variableManagementWindow != null)
            {
creatable= [];
                final _iter_ = this._allVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
variable  = _tmp_;
                    if (variable.variableTarget == 1
                        && variable.isPersisted
                        && variable.canCreateAndDelete)
                    {
                        creatable.push({id:variable.variableId,
                            name:variable.variableName});
                    }
                }
                this._variableManagementWindow.setCreatableVariables(
                    creatable);
            }
        }

        function renderOverviewVariables()
        {
var variable:WiredVariable  = null, row:WiredMenuTableObject  = null;            var rows= new Vector<ITableObject>();
            var requested= this._selectedVariableId;
            var requestedRow:ITableObject = null;
            final _iter_ = this._allVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
variable = _tmp_;
                if (variable.variableTarget != this._overviewTarget
                    || rows.length >= 500)
                {
                    continue;
                }
row=
                    new WiredMenuTableObject(variable.variableId,
                        {name:variable.variableName}, variable);
                rows.push(row);
                if (variable.variableId == requested
                    || variable.variableName == requested)
                {
                    requestedRow = row;
                }
            }
            if (this._variableListTable != null)
            {
                this._variableListTable.setObjects(rows);
                if (rows.length > 0)
                {
                    this._variableListTable.trySelect(
                        requestedRow == null ? rows[0] : requestedRow, true);
                }
                else
                {
                    this._selectedVariableId = null;
                }
            }
        }

        function onVariableSelected(row:ITableObject)
        {
            if (this._holderHighlighter != null)
            {
                this._holderHighlighter.clear();
            }
            this._holdersHighlighted = false;
            this._holderIds = [];
            var item= Std.downcast(row , WiredMenuTableObject);
            var variable:WiredVariable = item == null ? null :
                ASCompat.dynamicAs(item.data , WiredVariable);
            this._selectedVariableId = variable == null ? null :
                variable.variableId;
            if (this._selectedVariableId == null)
            {
                return;
            }
            this._requestedVariableId = this._selectedVariableId;
            this._roomEvents.send(
                new RequestVariableHoldersComposer(this._selectedVariableId));
        }

        function onOverviewType(event:WindowMouseEvent)
        {
            var type= event.target.id;
            if (event.type == WindowMouseEvent.OUT)
            {
                if (type == this._overviewTarget)
                {
                    event.preventWindowOperation();
                }
                return;
            }
            event.preventWindowOperation();
            this._overviewTarget = type;
            var container=
                Std.downcast(this._window.findChildByName("variable_overview_container")
, IWindowContainer);
            this.setTypePickerState(container, this._overviewTarget);
            this._selectedVariableId = null;
            this.renderOverviewVariables();
        }

        function onInspectionType(event:WindowMouseEvent)
        {
            var type= event.target.id;
            if (event.type == WindowMouseEvent.OUT)
            {
                if (type == this._inspectedType
                    || (this._inspectedType == -1 && type == 0))
                {
                    event.preventWindowOperation();
                }
                return;
            }
            event.preventWindowOperation();
            var container=
                Std.downcast(this._window.findChildByName("inspection_container")
, IWindowContainer);
            this.setTypePickerState(container, type);
            this._inspectedType = type;
            this._inspectedId = type == -10 ? 0 : -1;
            this._inspectionReady = false;
            this._inspectionExisting = {};
            this._selectedInspectionVariableId = null;
            if (this._inspectionTable != null)
            {
                this._inspectionTable.clear();
            }
            this.populateInspectionVariablePicker();
            if (type == -10)
            {
                this._roomEvents.send(
                    new InspectWiredObjectComposer(-10, 0));
            }
            this.updateInspectionPreview();
            this.updateInspectionButtons();
        }

        function updateInspectionPreview()
        {
            if (this._inspectionPreviewer == null)
            {
                return;
            }
            if (this._inspectedType == -10)
            {
                this._inspectionPreviewer.showGlobal();
            }
            else if (!this._inspectionReady)
            {
                if (this._inspectedType == 1)
                {
                    this._inspectionPreviewer.showUserInstruction();
                }
                else
                {
                    this._inspectionPreviewer.showFurniInstruction();
                }
            }
            else if (this._inspectedType == 1)
            {
                this._inspectionPreviewer.showUser(this._inspectedId);
            }
            else if (this._inspectedType == 0)
            {
                this._inspectionPreviewer.showFurni(this._inspectedId);
            }
            else
            {
                this._inspectionPreviewer.clear();
            }
        }

        function setTypePickerState(container:IWindowContainer,
                                            selected:Int)
        {
var name:String  = null, button:IWindow  = null;            if (container == null)
            {
                return;
            }
            var names:Array<ASAny> = ["type_furni_button", "type_user_button",
                "type_global_button", "type_context_button"];
            if (checkNullIteratee(names)) for (_tmp_ in names)
            {
name = _tmp_;
button= container.findChildByName(name);
                if (button != null)
                {
                    button.setStateFlag(16, button.id == selected);
                    if (button.id != selected)
                    {
                        button.setStateFlag(4, false);
                    }
                }
            }
        }

        function onInspectionRowSelected(row:ITableObject)
        {
            var item=
                Std.downcast(row , WiredMenuInspectionTableObject);
            this._selectedInspectionVariableId =
                item == null || item.variable == null ? null :
                item.variable.variableId;
            this.updateInspectionButtons();
        }

        function populateInspectionVariablePicker()
        {
var variable:WiredVariable  = null;            if (this._inspectionVariablePicker == null)
            {
                return;
            }
            var labels:Array<ASAny> = [];
            this._inspectionPickerIds = [];
            final _iter_ = this._allVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
variable = _tmp_;
                if (variable.variableTarget != this._inspectedType
                    || !variable.canCreateAndDelete
                    || ASCompat.toBool(ASCompat.getDynamicProperty(this._inspectionExisting, variable.variableId)))
                {
                    continue;
                }
                this._inspectionPickerIds.push(variable.variableId);
                labels.push(variable.variableName);
            }
            this._inspectionVariablePicker.populate(labels);
            this._inspectionVariablePicker.selection =
                labels.length == 0 ? -1 : 0;
        }

        function onAddVariable(event:WindowMouseEvent)
        {
            if (!this._writePermission
                || !this.hasValidInspectedHolder())
            {
                return;
            }
            this.populateInspectionVariablePicker();
            var inspection=
                Std.downcast(this._window.findChildByName("inspection_container")
, IWindowContainer);
            var bubble:IWindow = inspection == null ? null :
                inspection.findChildByName("create_var_bubble");
            if (bubble != null)
            {
                bubble.visible = true;
                bubble.activate();
            }
        }

        function onCreateVariable(event:WindowMouseEvent)
        {
            if (!this._writePermission
                || !this.hasValidInspectedHolder()
                || this._inspectionVariablePicker == null)
            {
                return;
            }
            var index= this._inspectionVariablePicker.selection;
            if (index < 0 || index >= this._inspectionPickerIds.length)
            {
                return;
            }
            var inspection=
                Std.downcast(this._window.findChildByName("inspection_container")
, IWindowContainer);
            var input:ITextFieldWindow = inspection == null ? null :
                Std.downcast(inspection.findChildByName("value_input")
, ITextFieldWindow);
            var raw= input == null ? "" : input.text;
            if (!new compat.RegExp("^-?\\d+$").test(raw))
            {
                return;
            }
            var value= ASCompat.toNumber(raw);
            if (value < -2147483648 || value > 2147483647)
            {
                return;
            }
            this._roomEvents.send(new ModifyInspectedVariableComposer(
                this._inspectedType, this._inspectedId,
                ASCompat.toString(this._inspectionPickerIds[index]), Std.int(value), 1));
            var bubble= inspection.findChildByName(
                "create_var_bubble");
            if (bubble != null)
            {
                bubble.visible = false;
            }
        }

        function onDeleteVariable(event:WindowMouseEvent)
        {
            if (!this._writePermission
                || !this.hasValidInspectedHolder()
                || this._selectedInspectionVariableId == null)
            {
                return;
            }
            var variable=
ASCompat.dynamicAs(ASCompat.getDynamicProperty(                this._variablesById, this._selectedInspectionVariableId), WiredVariable);
            if (variable == null || !variable.canCreateAndDelete)
            {
                return;
            }
            this._roomEvents.send(new ModifyInspectedVariableComposer(
                this._inspectedType, this._inspectedId,
                this._selectedInspectionVariableId, 0, 2));
        }

        function onPinChanged(event:WindowEvent)
        {
            var pin= Std.downcast(event.target , ICheckBoxWindow);
            this._inspectionPinned = pin != null && pin.Selected;
        }

        function onHighlightWired(event:WindowMouseEvent)
        {
            if (this._configuredWiredIds.length == 0)
            {
                return;
            }
            this._wiredIdsHighlighted = !this._wiredIdsHighlighted;
            if (this._wiredIdsHighlighted)
            {
                this._holderHighlighter.show(0, this._configuredWiredIds);
            }
            else
            {
                this._holderHighlighter.clear();
            }
        }

        function updateInspectionButtons()
        {
            if (this._window == null)
            {
                return;
            }
            var inspection=
                Std.downcast(this._window.findChildByName("inspection_container")
, IWindowContainer);
            if (inspection == null)
            {
                return;
            }
            var add= inspection.findChildByName("add_var_btn");
            var remove=
                inspection.findChildByName("delete_var_btn");
            var highlight=
                inspection.findChildByName("highlight_wired_btn");
            if (add != null)
            {
                if (this._writePermission
                    && this.hasValidInspectedHolder()
                    && this._inspectedType != -10)
                {
                    add.enable();
                }
                else
                {
                    add.disable();
                }
            }
            var selected=
ASCompat.dynamicAs(ASCompat.getDynamicProperty(                this._variablesById, this._selectedInspectionVariableId), WiredVariable);
            if (remove != null)
            {
                if (this._writePermission && selected != null
                    && selected.canCreateAndDelete)
                {
                    remove.enable();
                }
                else
                {
                    remove.disable();
                }
            }
            if (highlight != null)
            {
                highlight.visible = this._inspectedType == 0;
                if (highlight.visible
                    && this._configuredWiredIds.length > 0)
                {
                    highlight.enable();
                }
                else
                {
                    highlight.disable();
                }
            }
        }

        function onManageVariable(event:WindowMouseEvent)
        {
            var variable=
ASCompat.dynamicAs(ASCompat.getDynamicProperty(                this._variablesById, this._selectedVariableId), WiredVariable);
            if (variable == null || variable.variableTarget != 1
                || !variable.isPersisted)
            {
                return;
            }
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.show(
                    variable.variableId, variable.variableName);
            }
        }

        function onHighlightHolders(event:WindowMouseEvent)
        {
            var variable=
ASCompat.dynamicAs(ASCompat.getDynamicProperty(                this._variablesById, this._selectedVariableId), WiredVariable);
            if (variable == null
                || (variable.variableTarget != 0
                    && variable.variableTarget != 1))
            {
                return;
            }
            this._holdersHighlighted = !this._holdersHighlighted;
            if (this._holdersHighlighted)
            {
                if (this._holderIds.length > 200)
                {
                    this._holdersHighlighted = false;
                    this._roomEvents.showWiredNotification(
                        "wiredmenu.variable_overview.highlight.error.too_many");
                    return;
                }
                this._holderHighlighter.show(
                    variable.variableTarget, this._holderIds);
            }
            else
            {
                this._holderHighlighter.clear();
            }
            event.target.caption = this.loc(
                this._holdersHighlighted
                    ? "wiredmenu.variable_overview.unhighlight_holders"
                    : "wiredmenu.variable_overview.highlight_holders");
        }

        function hasValidInspectedHolder():Bool
        {
            return this._inspectionReady
                && ((this._inspectedType == 0 && this._inspectedId != 0)
                || (this._inspectedType == 1 && this._inspectedId > 0)
                || (this._inspectedType == -10 && this._inspectedId == 0));
        }

        function onSettingChanged(event:WindowEvent)
        {
            if (this._ignoreSettings)
            {
                return;
            }
            this._ignoreSettings = true;
            this.normalizePermissionCheckboxes();
            this._ignoreSettings = false;
            if (event.target.name.indexOf("preference_") == 0)
            {
                this.sendPreferences();
                return;
            }
            this._modifyMask = this.checkboxMask("modify", 1, 3);
            this._readMask = this.checkboxMask("read", 0, 3);
            this._roomEvents.send(new UpdateWiredRoomSettingsComposer(
                this._modifyMask, this._readMask, this._timezone));
        }

        function checkboxMask(prefix:String, start:Int, end:Int):Int
        {
var i = 0, value:ICheckBoxWindow  = null;            var mask= 0;
            for (_tmp_ in start...end + 1)
            {
i= _tmp_;
value= this.checkbox(prefix + "_" + Std.string(i) + "_checkbox");
                if (value != null && value.Selected)
                {
                    mask |= 1 << i;
                }
            }
            return mask;
        }

        function sendPreferences()
        {
            this._menuButton = this.isChecked("preference_toolbar_checkbox");
            this._inspectButton = this.isChecked("preference_inspect_button_checkbox");
            this._playtest = this.isChecked("preference_playtest_checkbox");
            this._allNotifications =
                this.isChecked("preference_all_notifications_checkbox");
            this.applyRoomSessionPreferences();
            this._roomEvents.refreshWiredUiConsumers();
            this._roomEvents.send(new UpdateWiredPreferencesComposer(
                this._menuButton,
                this._inspectButton,
                this._playtest,
                this._whisperDisabled,
                this._allNotifications,
                this._uiStyle));
        }

        function isChecked(name:String):Bool
        {
            var value= this.checkbox(name);
            return value != null && value.Selected;
        }

        function normalizePermissionCheckboxes()
        {
var i = 0, read:ICheckBoxWindow  = null, modify:ICheckBoxWindow  = null;            var modifyTwo= this.checkbox("modify_2_checkbox");
            var modifyThree= this.checkbox("modify_3_checkbox");
            var readZero= this.checkbox("read_0_checkbox");
            var readTwo= this.checkbox("read_2_checkbox");
            var readThree= this.checkbox("read_3_checkbox");
            if (modifyTwo != null && modifyTwo.Selected && modifyThree != null)
            {
                modifyThree.select();
            }
            if (readTwo != null && readTwo.Selected && readThree != null)
            {
                readThree.select();
            }
            if (readZero != null && readZero.Selected)
            {
                for (_tmp_ in 1...4)
                {
i= _tmp_;
read= this.checkbox("read_" + Std.string(i) + "_checkbox");
                    if (read != null)
                    {
                        read.select();
                    }
                }
            }
            for (_tmp_ in 1...4)
            {
i = _tmp_;
modify=
                    this.checkbox("modify_" + Std.string(i) + "_checkbox");
                read = this.checkbox("read_" + Std.string(i) + "_checkbox");
                if (modify != null && modify.Selected && read != null)
                {
                    read.select();
                }
            }
        }

        function checkbox(name:String):ICheckBoxWindow
        {
            return this._window == null ? null :
                Std.downcast(this._window.findChildByName(name) , ICheckBoxWindow);
        }

        function onReload(event:WindowMouseEvent)
        {
            if (this._writePermission)
            {
                this._roomEvents.send(new ReloadOrRollbackWiredRoomComposer(false));
            }
        }

        function onRollback(event:WindowMouseEvent)
        {
            if (this._writePermission)
            {
                this._roomEvents.windowManager.confirm(
                    "${wiredmenu.settings.room_state.roll_back}",
                    "${wiredmenu.settings.room_state.roll_back.warning}",
                    0, this.onRollbackConfirmation);
            }
        }

        function onRollbackConfirmation(dialog:IConfirmDialog,
                                                event:WindowEvent)
        {
            dialog.dispose();
            if (event.type == WindowEvent.WINDOW_EVENT_OK &&
                this._writePermission)
            {
                this._roomEvents.send(new ReloadOrRollbackWiredRoomComposer(true));
            }
        }

        function onOpenLogs(event:WindowMouseEvent)
        {
            if (this._logsWindow != null)
            {
                this._logsWindow.show();
            }
        }

        function requestLogsPage(page:Int, amount:Int,
                                         level:Int, source:Int,
                                         query:String)
        {
            this._roomEvents.send(new RequestWiredLogsComposer(
                page, amount, level, source, query));
        }

        function requestUserVariablesPage(
            variableId:String, page:Int, amount:Int,
            sortFilter:Int, userFilter:Int)
        {
            this._roomEvents.send(new RequestWiredUserVariablesComposer(
                variableId, page, amount, sortFilter, userFilter));
        }

        function requestPermanentVariables(type:Int, id:Int)
        {
            this._roomEvents.send(
                new RequestPermanentVariablesComposer(type, id));
        }

        function mutatePermanentVariable(
            type:Int, id:Int, variableId:String,
            value:Int, operation:Int)
        {
            this._roomEvents.send(new MutatePermanentVariableComposer(
                type, id, variableId, value, operation));
        }

        function onClearErrors(event:WindowMouseEvent)
        {
            if (this._writePermission)
            {
                this._roomEvents.send(new ClearWiredErrorsComposer());
            }
        }

        function onPermissions(event:IMessageEvent)
        {
            var parser=
                Std.downcast(event , WiredMenuPermissionsEvent).getParser();
            this._writePermission = parser.writePermission;
            this._readPermission = parser.readPermission;
            this._roomEvents.refreshWiredUiConsumers();
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.setCanModify(
                    this._writePermission);
            }
            if (!this._readPermission && this._window != null &&
                this._window.parent != null)
            {
                this.hide();
                this._roomEvents.showWiredNotification("wiredmenu.invalid_room.desc");
            }
            this.updateInspectionButtons();
            this.updateRoomSettingsPermission();
            this.updateChestButtons();
        }

        function onRoomSettings(event:IMessageEvent)
        {
var timezoneIndex = 0;            var parser=
                Std.downcast(event , WiredMenuRoomSettingsEvent).getParser();
            this._modifyMask = parser.modifyMask;
            this._readMask = parser.readMask;
            this._timezone = parser.timezone;
            if (this._window == null)
            {
                return;
            }
            this._ignoreSettings = true;
            this.applyMask("modify", 1, 3, this._modifyMask);
            this.applyMask("read", 0, 3, this._readMask);
            this.normalizePermissionCheckboxes();
            var picker=
                Std.downcast(this._window.findChildByName("timezone_picker")
, IDropMenuWindow);
            if (picker != null)
            {
timezoneIndex=
                    this._timezoneValues.indexOf(this._timezone);
                picker.selection = timezoneIndex < 0 ? 0 : timezoneIndex;
            }
            this._ignoreSettings = false;
        }

        function updateRoomSettingsPermission()
        {
            if (this._window == null)
            {
                return;
            }
            var settings=
                this._window.findChildByName("room_settings_container");
            var canConfigure= this._roomEvents.roomSession != null
                && (this._roomEvents.roomSession.isRoomOwner
                    || (this._roomEvents.sessionDataManager != null
                        && this._roomEvents.sessionDataManager
                            .isAnyRoomController));
            if (settings != null)
            {
                if (canConfigure)
                {
                    settings.enable();
                }
                else
                {
                    settings.disable();
                }
            }
        }

        function applyMask(prefix:String, start:Int, end:Int, mask:Int)
        {
var i = 0, value:ICheckBoxWindow  = null;            for (_tmp_ in start...end + 1)
            {
i= _tmp_;
value= this.checkbox(prefix + "_" + Std.string(i) + "_checkbox");
                if (value != null)
                {
                    if ((mask & (1 << i)) != 0) { value.select(); }
                    else { value.unselect(); }
                }
            }
        }

        function onRoomStats(event:IMessageEvent)
        {
            if (this._window == null) { return; }
            var parser=
                Std.downcast(event , WiredMenuRoomStatsEvent).getParser();
            var usageColor= this.ratioColor(
                parser.executionCost, parser.executionCap, 0.3, 0.7);
            var floorColor= this.ratioColor(
                parser.floorCount, parser.floorCap, 0.6, 0.85);
            var wallColor= this.ratioColor(
                parser.wallCount, parser.wallCap, 0.6, 0.85);
            this.setText("statistics_usage_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.usage", "",
                    ["color", usageColor,
                    "amount", ASCompat.toFixed(parser.executionCost, 0),
                    "limit", ASCompat.toFixed(parser.executionCap, 0)]));
            this.setText("statistics_heavy_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.is_heavy", "",
                    ["color", parser.heavy ? COLOR_ORANGE : COLOR_GREEN,
                    "bool", this.loc(parser.heavy
                        ? "wiredmenu.bool.yes" : "wiredmenu.bool.no")]));
            this.setText("statistics_floorfurni_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.floorfurni", "",
                    ["color", floorColor, "amount", parser.floorCount,
                    "limit", parser.floorCap]));
            this.setText("statistics_wallfurni_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.wallfurni", "",
                    ["color", wallColor, "amount", parser.wallCount,
                    "limit", parser.wallCap]));
            this.setText("statistics_perm_vars_user_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.perm_user_vars", "",
                    ["color", this.ratioColor(parser.permanentUserCount,
                        parser.permanentUserCap, 0.5, 0.8),
                    "amount", parser.permanentUserCount,
                    "limit", parser.permanentUserCap]));
            this.setText("statistics_perm_vars_furni_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.perm_furni_vars", "",
                    ["color", this.ratioColor(parser.permanentFurniCount,
                        parser.permanentFurniCap, 0.5, 0.8),
                    "amount", parser.permanentFurniCount,
                    "limit", parser.permanentFurniCap]));
            this.setText("statistics_perm_vars_global_html",
                this._roomEvents.localization.getLocalizationWithParams(
                    "wiredmenu.monitor.statistics.perm_global_vars", "",
                    ["color", this.ratioColor(parser.permanentGlobalCount,
                        parser.permanentGlobalCap, 0.5, 0.8),
                    "amount", parser.permanentGlobalCount,
                    "limit", parser.permanentGlobalCap]));
            this._monitorHeavy = parser.heavy;
            this._monitorOverThreshold =
                usageColor != COLOR_GREEN
                || floorColor != COLOR_GREEN
                || wallColor != COLOR_GREEN;
            this.updateMonitorImage(
                this._monitorHeavy, this._monitorOverThreshold);
        }

        function ratioColor(value:Float, limit:Float,
                                    lower:Float, upper:Float):String
        {
            var ratio= limit <= 0 ? 0 : value / limit;
            if (ratio < lower)
            {
                return COLOR_GREEN;
            }
            if (ratio < upper)
            {
                return COLOR_ORANGE;
            }
            return COLOR_RED;
        }

        function updateMonitorImage(heavy:Bool,
                                            overThreshold:Bool)
        {
            var panicking= heavy || overThreshold
                || (this._errorTable != null
                    && this._errorTable.rowCount > 0);
            var calm=
                this._window.findChildByName("monitor_image_1");
            var panic=
                this._window.findChildByName("monitor_image_2");
            if (calm != null)
            {
                calm.visible = !panicking;
            }
            if (panic != null)
            {
                panic.visible = panicking;
            }
        }

        function onErrors(event:IMessageEvent)
        {
var error:ASObject  = null;            if (this._window == null) { return; }
            var parser=
                Std.downcast(event , WiredMenuErrorsEvent).getParser();
            var rows= new Vector<ITableObject>();
            final _iter_ = parser.errors; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
error = _tmp_;
                rows.push(new WiredMenuErrorTableObject(
                    error, this.formatElapsed(ASCompat.toNumber(error.elapsed)),
                    this.openErrorInfo));
            }
            if (this._errorTable != null)
            {
                this._errorTable.setObjects(rows);
            }
            this.updateMonitorImage(
                this._monitorHeavy, this._monitorOverThreshold);
        }

        function onErrorSelected(row:ITableObject)
        {
            var item=
                Std.downcast(row , WiredMenuErrorTableObject);
            if (item != null)
            {
                this.openErrorInfo(item.data);
            }
        }

        function openErrorInfo(error:ASObject)
        {
            if (error != null && this._errorInfoWindow != null)
            {
                this._errorInfoWindow.show(error);
            }
        }

        function onLogs(event:IMessageEvent)
        {
            var parser=
                Std.downcast(event , WiredMenuLogsPageEvent).getParser();
            if (this._logsWindow != null)
            {
                this._logsWindow.applyPage(parser);
            }
        }

        function onVariableHolders(event:IMessageEvent)
        {
var keys:Array<ASAny>  = null, key:ASObject  = null, holder:ObjectIdAndValuePair  = null;            if (this._window == null) { return; }
            var data=
                Std.downcast(event , WiredMenuVariableHoldersEvent).getParser().data;
            if (data == null || data.variable == null
                || data.variable.variableId != this._requestedVariableId)
            {
                return;
            }
            var variable= data.variable;
            var properties= new Vector<ITableObject>();
            properties.push(this.property("name", this.loc(
                "wiredmenu.variable_overview.properties.name"),
                variable.variableName));
            properties.push(this.property("type", this.loc(
                "wiredmenu.variable_overview.properties.type"),
                this.loc("wiredfurni.params.variables.idtype."
                    + Std.string(variable.variableType))));
            properties.push(this.property("target", this.loc(
                "wiredmenu.variable_overview.properties.target"),
                this.targetName(variable.variableTarget)));
            properties.push(this.property("availability", this.loc(
                "wiredmenu.variable_overview.properties.availability"),
                this._roomEvents.localization.getLocalization(
                    "wiredfurni.params.variables.availability."
                        + Std.string(variable.availabilityType),
                    this.loc(
                        "wiredfurni.params.variables.availability.misc"))));
            this.addBooleanProperty(properties, "has_value",
                variable.hasValue);
            this.addBooleanProperty(properties, "can_write_to",
                variable.canWriteValue);
            this.addBooleanProperty(properties, "can_create_delete",
                variable.canCreateAndDelete);
            this.addBooleanProperty(properties, "can_intercept",
                variable.canInterceptChanges);
            this.addBooleanProperty(properties, "is_always_available",
                variable.alwaysAvailable);
            this.addBooleanProperty(properties, "can_read_creation_time",
                variable.canReadCreationTime);
            this.addBooleanProperty(properties, "can_read_last_update_time",
                variable.canReadLastUpdateTime);
            this.addBooleanProperty(properties, "is_text_connected",
                variable.hasTextConnector);
            if (this._propertyTable != null)
            {
                this._propertyTable.setObjects(properties, true);
            }
            var values= new Vector<ITableObject>();
            if (variable.hasTextConnector)
            {
keys= variable.textConnector.getKeys();
                if (checkNullIteratee(keys)) for (_tmp_ in keys)
                {
key = _tmp_;
                    values.push(new WiredMenuTableObject(ASCompat.toString(key), {
                        value:ASCompat.toString(key),
                        text:ASCompat.toString(variable.textConnector.getValue(key))
                    }));
                }
            }
            if (this._textTable != null)
            {
                this._textTable.setObjects(values, true);
            }
            this._holderIds = [];
            final _iter_ = data.holders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
holder = _tmp_;
                this._holderIds.push(holder.objectId);
            }
            this.updateOverviewButtons(variable);
        }

        function addBooleanProperty(
            rows:Vector<ITableObject>, id:String, value:Bool)
        {
            rows.push(this.property(id, this.loc(
                "wiredmenu.variable_overview.properties." + id),
                this.loc(value ? "wiredmenu.bool.yes" : "wiredmenu.bool.no")));
        }

        function targetName(target:Int):String
        {
            if (target == 0)
            {
                return this.loc("wiredfurni.params.sourcetype.furni");
            }
            if (target == 1)
            {
                return this.loc("wiredfurni.params.sourcetype.users");
            }
            if (target == -10)
            {
                return this.loc("wiredfurni.params.sourcetype.global");
            }
            if (target == -20)
            {
                return this.loc("wiredfurni.params.sourcetype.context");
            }
            return "";
        }

        function updateOverviewButtons(variable:WiredVariable)
        {
            var overview=
                Std.downcast(this._window.findChildByName("variable_overview_container")
, IWindowContainer);
            if (overview == null)
            {
                return;
            }
            var highlight=
                overview.findChildByName("highlight_holders_button");
            if (highlight != null)
            {
                if (variable.variableType != 1
                    && (variable.variableTarget == 0
                        || variable.variableTarget == 1))
                {
                    highlight.enable();
                }
                else
                {
                    highlight.disable();
                }
                highlight.caption = this.loc(
                    "wiredmenu.variable_overview.highlight_holders");
            }
            var manage= overview.findChildByName("manage_button");
            if (manage != null)
            {
                if (variable.variableTarget == 1 && variable.isPersisted)
                {
                    manage.enable();
                }
                else
                {
                    manage.disable();
                }
            }
        }

        function onUserVariables(event:IMessageEvent)
        {
            var parser=
                Std.downcast(event , WiredMenuUserVariablesPageEvent).getParser();
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.applyPage(parser);
            }
        }

        function onPermanentVariables(event:IMessageEvent)
        {
            var parser=
                Std.downcast(event , WiredMenuPermanentVariablesEvent).getParser();
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.applyDetails(parser);
            }
        }

        function onInspection(event:IMessageEvent)
        {
var parser:WiredMenuInspectionParser  = null, holderChanged = false, inspection:IWindowContainer  = null, rows:Vector<ITableObject>  = null, value:ASObject  = null, variable:WiredVariable  = null;            if (this._window != null && this._activeTab == INSPECTION)
            {
parser=
                    Std.downcast(event , WiredMenuInspectionEvent).getParser();
holderChanged=
                    !this._inspectionReady
                    || this._inspectedType != parser.type
                    || this._inspectedId != parser.objectId;
                this._inspectedType = parser.type;
                this._inspectedId = parser.objectId;
                this._inspectionReady = true;
                if (holderChanged && this._wiredIdsHighlighted
                    && this._holderHighlighter != null)
                {
                    this._holderHighlighter.clear();
                }
                if (holderChanged)
                {
                    this._wiredIdsHighlighted = false;
                }
                this._configuredWiredIds =
                    parser.wiredIds == null ? [] :
                    parser.wiredIds.copy();
inspection=
                    Std.downcast(this._window.findChildByName("inspection_container")
, IWindowContainer);
                this.setTypePickerState(inspection, parser.type);
rows= new Vector<ITableObject>();
                this._inspectionExisting = {};
                if (holderChanged)
                {
                    this._selectedInspectionVariableId = null;
                }
                final _iter_ = parser.values; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
value = _tmp_;
                    this._inspectionExisting[value.id] = true;
variable=
                        ASCompat.dynamicAs(this._variablesById[value.id] , WiredVariable);
                    if (variable != null)
                    {
                        rows.push(new WiredMenuInspectionTableObject(
                            variable, ASCompat.toInt(value.value),
                            this._writePermission, !holderChanged,
                            this._roomEvents));
                    }
                }
                if (this._selectedInspectionVariableId != null
                    && !ASCompat.getDynamicProperty(this._inspectionExisting,                         this._selectedInspectionVariableId))
                {
                    this._selectedInspectionVariableId = null;
                }
                if (this._inspectionTable != null)
                {
                    this._inspectionTable.setObjects(rows, holderChanged);
                }
                this.populateInspectionVariablePicker();
                this.updateInspectionPreview();
                this.updateInspectionButtons();
            }
        }

        function onInspectionCellEdited(row:ITableObject, column:String,
                                                input:String)
        {
            if (!this._writePermission || column != "value" ||
                !this.hasValidInspectedHolder() ||
                input == null || !new compat.RegExp("^-?\\d+$").test(input))
            {
                return;
            }
            var parsed= ASCompat.toNumber(input);
            if (parsed < -2147483648 || parsed > 2147483647)
            {
                return;
            }
            var item=
                Std.downcast(row , WiredMenuInspectionTableObject);
            if (item == null || item.variable == null)
            {
                return;
            }
            this._roomEvents.send(new ModifyInspectedVariableComposer(
                this._inspectedType, this._inspectedId,
                item.variable.variableId, Std.int(parsed), 0));
        }

        function property(id:String, label:String,
                                  value:String):WiredMenuTableObject
        {
            return new WiredMenuTableObject(id,
                {property:label, value:value});
        }

        function formatElapsed(milliseconds:Float):String
        {
            if (milliseconds < 0)
            {
                return "/";
            }
            if (milliseconds < 1000)
            {
                return Std.string(Std.int(milliseconds)) + "ms";
            }
            if (milliseconds < 60000)
            {
                return Std.string(Std.int(milliseconds / 1000)) + "s ago";
            }
            return Std.string(Std.int(milliseconds / 60000)) + "m ago";
        }

        function onMutation(event:IMessageEvent)
        {
            var parser=
                Std.downcast(event , WiredMenuMutationResultEvent).getParser();
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.onMutationResult(
                    parser.success);
            }
            if (!parser.success)
            {
                this._roomEvents.showWiredNotification(
                    "wiredmenu.variable_management_detail.notification.modification_failed");
            }
        }

        function onInspectionError(event:IMessageEvent)
        {
            var parser=
                Std.downcast(event , WiredMenuErrorEvent).getParser();
            if (parser.errorCode == 0)
            {
                this._inspectedId = this._inspectedType == -10 ? 0 : -1;
                this._inspectionReady = false;
                this._inspectionExisting = {};
                this._selectedInspectionVariableId = null;
                if (this._inspectionTable != null)
                {
                    this._inspectionTable.clear();
                }
                this.updateInspectionPreview();
                this.updateInspectionButtons();
            }
            else
            {
                this._roomEvents.showWiredNotification(
                    "wiredmenu.variable_management.update.error");
            }
        }

        function onAccountPreferences(event:IMessageEvent)
        {
            var parser=
                Std.downcast(event , AccountPreferencesEvent).getParser();
            this._menuButton = parser.wiredMenuButton;
            this._inspectButton = parser.wiredInspectButton;
            this._playtest = parser.playTestMode;
            this._whisperDisabled = parser.wiredWhisperDisabled;
            this._allNotifications = parser.showAllNotifications;
            this._uiStyle = parser.wiredUiStyle;
            this.applyPreferences();
            this._roomEvents.refreshWiredUiConsumers();
        }

        public var wiredMenuButton(get,never):Bool;
public function  get_wiredMenuButton():Bool
        {
            return this._menuButton;
        }

        public var wiredInspectButton(get,never):Bool;
public function  get_wiredInspectButton():Bool
        {
            return this._inspectButton;
        }

        public var hasReadPermission(get,never):Bool;
public function  get_hasReadPermission():Bool
        {
            return this._readPermission;
        }

        public var hasWritePermission(get,never):Bool;
public function  get_hasWritePermission():Bool
        {
            return this._writePermission;
        }

        function applyPreferences()
        {
var index = 0;            this.applyRoomSessionPreferences();
            if (this._window == null) { return; }
            this._ignoreSettings = true;
            this.setChecked("preference_toolbar_checkbox", this._menuButton);
            this.setChecked("preference_inspect_button_checkbox", this._inspectButton);
            this.setChecked("preference_playtest_checkbox", this._playtest);
            this.setChecked("preference_all_notifications_checkbox",
                this._allNotifications);
            var picker=
                Std.downcast(this._window.findChildByName("wired_style_picker")
, IDropMenuWindow);
            if (picker != null)
            {
index=
                    this._wiredStyleValues.indexOf(this._uiStyle);
                picker.selection = index < 0 ? 0 : index;
            }
            this._ignoreSettings = false;
        }

        public function applyRoomSessionPreferences()
        {
            if (this._roomEvents != null
                && this._roomEvents.roomSession != null)
            {
                this._roomEvents.roomSession.playTestMode =
                    this._playtest;
            }
        }

        function setChecked(name:String, selected:Bool)
        {
            var checkbox= this.checkbox(name);
            if (checkbox != null)
            {
                if (selected) { checkbox.select(); } else { checkbox.unselect(); }
            }
        }

        function setText(name:String, value:String)
        {
            var text= Std.downcast(this._window.findChildByName(name) , ITextWindow);
            if (text != null) { text.text = value; }
        }

        /**
         * July uses its newer table framework.  The clean client does not have
         * that framework, so bounded text rows are cloned from a native text
         * control. This preserves fonts/styles and avoids trusting packet text
         * as XML or HTML.
         */
        function renderLines(containerName:String, lines:Array<ASAny>,
                                     emptyKey:String)
        {
var i = 0, row:ITextWindow  = null;            var container=
                Std.downcast(this._window.findChildByName(containerName) , IWindowContainer);
            var template=
                Std.downcast(this._window.findChildByName("preview_instruction_user")
, ITextWindow);
            if (container == null || template == null) { return; }
            while (container.numChildren > 0)
            {
                container.removeChildAt(0).dispose();
            }
            if (lines.length == 0 && emptyKey != null)
            {
                lines = [this._roomEvents.localization.getLocalization(
                    emptyKey, "—")];
            }
            var maximum= Std.int(Math.min(lines.length, 100));
            for (_tmp_ in 0...maximum)
            {
i= _tmp_;
row= Std.downcast(template.clone() , ITextWindow);
                row.name = "wired_menu_row_" + Std.string(i);
                row.visible = true;
                row.x = 2;
                row.y = i * 18;
                row.width = Std.int(Math.max(20, container.width - 4));
                row.height = 18;
                row.text = ASCompat.toString(lines[i]);
                container.addChild(row);
            }
        }

        function onClose(event:WindowMouseEvent)
        {
            this.hide();
        }

        public function inspectUser(id:Int)
        {
var inspection:IWindowContainer  = null;            if (!(this._inspectionPinned && this._inspectionReady)
                && this._window != null && this._window.parent != null &&
                this._activeTab == INSPECTION
                && this._inspectedType == 1)
            {
inspection=
                    Std.downcast(this._window.findChildByName("inspection_container")
, IWindowContainer);
                this.setTypePickerState(inspection, 1);
                this._inspectedId = id;
                this._inspectionReady = false;
                this.updateInspectionPreview();
                this._roomEvents.send(new InspectWiredObjectComposer(1, id));
            }
        }

        public function inspectFurni(id:Int)
        {
var inspection:IWindowContainer  = null;            if (!(this._inspectionPinned && this._inspectionReady)
                && id != 0 && this._window != null &&
                this._window.parent != null && this._activeTab == INSPECTION
                && this._inspectedType == 0)
            {
inspection=
                    Std.downcast(this._window.findChildByName("inspection_container")
, IWindowContainer);
                this.setTypePickerState(inspection, 0);
                this._inspectedId = id;
                this._inspectionReady = false;
                this.updateInspectionPreview();
                this._roomEvents.send(new InspectWiredObjectComposer(0, id));
            }
        }

        public var activeTab(get,never):String;
public function  get_activeTab():String
        {
            return this._activeTab;
        }

        public function dispose()
        {
var event:IMessageEvent  = null;            if (this._disposed)
            {
                return;
            }
            this.hide();
            if (this._holderHighlighter != null)
            {
                this._holderHighlighter.dispose();
                this._holderHighlighter = null;
            }
            if (this._monitorTimer != null)
            {
                this._monitorTimer.stop();
                this._monitorTimer.removeEventListener(
                    TimerEvent.TIMER, (this.onMonitorPoll : ASAny));
                this._monitorTimer = null;
            }
            if (this._overviewTimer != null)
            {
                this._overviewTimer.stop();
                this._overviewTimer.removeEventListener(
                    TimerEvent.TIMER, (this.onOverviewPoll : ASAny));
                this._overviewTimer = null;
            }
            if (this._inspectionTimer != null)
            {
                this._inspectionTimer.stop();
                this._inspectionTimer.removeEventListener(
                    TimerEvent.TIMER, (this.onInspectionPoll : ASAny));
                this._inspectionTimer = null;
            }
            if (this._chestTimer != null)
            {
                this._chestTimer.stop();
                this._chestTimer.removeEventListener(
                    TimerEvent.TIMER, (this.onChestPoll : ASAny));
                this._chestTimer = null;
            }
            if (this._chestLockTimer != null)
            {
                this._chestLockTimer.stop();
                this._chestLockTimer.removeEventListener(
                    TimerEvent.TIMER_COMPLETE, (this.onChestLockTimeout : ASAny));
                this._chestLockTimer = null;
            }
            if (this._logsWindow != null)
            {
                this._logsWindow.dispose();
                this._logsWindow = null;
            }
            if (this._errorInfoWindow != null)
            {
                this._errorInfoWindow.dispose();
                this._errorInfoWindow = null;
            }
            if (this._variableManagementWindow != null)
            {
                this._variableManagementWindow.dispose();
                this._variableManagementWindow = null;
            }
            if (this._inspectionPreviewer != null)
            {
                this._inspectionPreviewer.dispose();
                this._inspectionPreviewer = null;
            }
            this.disposeTable(this._errorTable);
            this.disposeTable(this._variableListTable);
            this.disposeTable(this._propertyTable);
            this.disposeTable(this._textTable);
            this.disposeTable(this._inspectionTable);
            this.disposeTable(this._chestTransactionsTable);
            this._errorTable = null;
            this._variableListTable = null;
            this._propertyTable = null;
            this._textTable = null;
            this._inspectionTable = null;
            this._chestTransactionsTable = null;
            this._chestTransactions = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._roomEvents != null && this._roomEvents.communication != null)
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
event = _tmp_;
                    this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
                }
            }
            this._messageEvents = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        function disposeTable(table:TableView)
        {
            if (table != null && !table.disposed)
            {
                table.dispose();
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

