package com.sulake.habbo.roomevents.wired_trading.chests
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.SaveChestSafetyMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.StartChestDepositMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.WithdrawAllChestFurniMessageComposer;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_trading.UbuntuPresetManager;
    import com.sulake.habbo.roomevents.wired_trading.chests.settings.ChestNotificationSettingsUI;
    import com.sulake.habbo.roomevents.wired_trading.chests.settings.ChestSettingsUI;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.IChestSubController;
    import com.sulake.habbo.roomevents.wired_trading.chests.upgrade_confirmation.WiredChestUpgradeConfirmationView;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.room.object.IRoomObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class WiredChestWrapperView implements IDisposable
    {
        var _disposed:Bool = false;
        var _controller:WiredChestController;
        var _windowManager:IHabboWindowManager;
        var _window:IFrameWindow;
        var _lockInfoBubble:IWindowContainer;
        var _upgradeView:WiredChestUpgradeConfirmationView;
        var _chestId:Int = 0;
        var _chestObject:IRoomObject;
        var _isChestOwner:Bool = false;
        var _isRoomOwner:Bool = false;
        var _subController:IChestSubController;
        var _maxCapacityCache:Int = -1;
        var _ignoreCheckboxEvents:Bool = false;
        var _ignoreCapacityEvents:Bool = false;
        var _ignoreSelectEvents:Bool = false;
        var _ignoreResizeEvents:Bool = false;
        var _lastResizableWidth:Int = -1;
        var _lastResizableHeight:Int = -1;
        var _horizontalChrome:Int = 0;
        var _verticalChrome:Int = 0;
        var _settings:ChestSettingsUI;
        var _notificationSettings:ChestNotificationSettingsUI;
        var _presets:PresetManager;

        public function new(controller:WiredChestController,
            windowManager:IHabboWindowManager)
        {
            this._controller = controller;
            this._windowManager = windowManager;
            this._window = Std.downcast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(controller.assets
                .getAssetByName("chest_generic_xml").content), 1) , IFrameWindow);
            this._horizontalChrome = this._window.width - this.chestContents.width;
            this._verticalChrome = this._window.height - this.chestContents.height
                - this.footer.height - this.header.height;
            this.closeButton.addEventListener("WME_CLICK", this.onWindowClose);
            this.lockInfoButton.addEventListener("WME_CLICK", this.onInfoClick);
            this.withdrawAllButton.addEventListener("WME_CLICK", this.onWithdrawAllClick);
            this.startDepositButton.addEventListener("WME_CLICK", this.onDepositClick);
            this.upgradeButton.addEventListener("WME_CLICK", this.onUpgradeClick);
            this.settingsButton.addEventListener("WME_CLICK", this.onSettingsClick);
            this.notificationSettingsButton.addEventListener("WME_CLICK",
                this.onNotificationSettingsClick);
            this.viewLogsButton.addEventListener("WME_CLICK", this.onViewLogsClick);
            this.lockCheckbox.addEventListener("WE_SELECT", this.onAttemptLock);
            this.lockCheckbox.addEventListener("WE_UNSELECT", this.onAttemptUnlock);
            this.lockCheckbox.addEventListener("WE_SELECTED", this.onOptionsChanged);
            this.lockCheckbox.addEventListener("WE_UNSELECTED", this.onOptionsChanged);
            this.autoLockCheckbox.addEventListener("WE_SELECTED", this.onOptionsChanged);
            this.autoLockCheckbox.addEventListener("WE_UNSELECTED", this.onOptionsChanged);
            this.capacityInput.addEventListener("WME_CLICK_AWAY", this.onOptionsChanged);
            this.capacityInput.addEventListener("WKE_KEY_DOWN", this.onCapacityKeyDown);
            this.capacityInput.addEventListener("WE_CHANGE", this.onCapacityChange);
            this._window.addEventListener("WE_RESIZED", this.onResize);
            this._lockInfoBubble = Std.downcast(this._window.findChildByName("lock_info_bubble")
, IWindowContainer);
            this._window.desktop.addChild(this._lockInfoBubble);
            this._lockInfoBubble.visible = false;
            this._lockInfoBubble.addEventListener("WE_DEACTIVATED", this.onBubbleDeactivate);
            this.setSubController(null);
            // buildFromXML attaches the frame to the desktop immediately in
            // this client generation. A chest must remain detached until the
            // server instructs us to open a concrete chest.
            this.hide();
        }
        function onResize(event:WindowEvent)
        {
            if (!this._ignoreResizeEvents)
            {
                this.chestContents.height = this._window.height - this._verticalChrome
                    - this.footer.height - this.header.height;
            }
        }
        function onSettingsClick(event:WindowMouseEvent)
        {
            var data= this.getStuffDataMap();
            if (data == null || this._chestId == 0 || this._subController == null
                || this._chestObject == null) { return; }
            this.chestSettingsUI.onEdit(this._chestId, this._subController.type,
                Std.int(this._chestObject.getModel().getNumber("furniture_type_id")),
                this.isStarterChest, data);
        }
        function onNotificationSettingsClick(event:WindowMouseEvent)
        {
            var data= this.getStuffDataMap();
            if (data == null || this._chestId == 0 || this._subController == null) { return; }
            this.chestNotificationSettingsUI.onEdit(
                this._chestId, this._subController.type, data);
        }
        function onViewLogsClick(event:WindowMouseEvent)
        {
            if (this._chestId > 0 && this.canRead)
            {
                this._controller.roomEvents.transactionLogsController
                    .openChestLogs(this._chestId);
            }
        }
        function onUpgradeClick(event:WindowMouseEvent)
        {
            if (this._chestId == 0 || this._chestObject == null) { return; }
            if (this._upgradeView == null)
            {
                this._upgradeView = new WiredChestUpgradeConfirmationView(this._controller);
            }
            this._upgradeView.initialize(this._chestId, this._subController.type,
                Std.int(this._chestObject.getModel().getNumber("furniture_type_id")),
                this.currentCapacityLevel);
            this._upgradeView.show();
        }
        function onDepositClick(event:WindowMouseEvent)
        {
            if (this._chestId != 0)
            {
                this._controller.send(new StartChestDepositMessageComposer(this._chestId));
            }
        }
        function onWithdrawAllClick(event:WindowMouseEvent)
        {
            this._windowManager.confirm("${wiredchests.withdraw_all.confirm.title}",
                "${wiredchests.withdraw_all.confirm.desc}", 0, this.onWithdrawAllConfirmed);
        }
        function onWithdrawAllConfirmed(dialog:IConfirmDialog,
            event:WindowEvent)
        {
            dialog.dispose();
            if (event.type == "WE_OK")
            {
                this._controller.send(new WithdrawAllChestFurniMessageComposer(this._chestId));
            }
        }
        function onInfoClick(event:WindowMouseEvent)
        {
            this._lockInfoBubble.visible = true;
            var rectangle= new Rectangle();
            this.lockInfoButton.getGlobalRectangle(rectangle);
            this._lockInfoBubble.position = new Point(rectangle.x + rectangle.width + 3,
                rectangle.y + 1 + rectangle.height / 2 - this._lockInfoBubble.height / 2);
            this._lockInfoBubble.activate();
        }
        function onBubbleDeactivate(event:WindowEvent)
        {
            this._lockInfoBubble.visible = false;
        }
        function onWindowClose(event:WindowEvent)
        {
            if (event.type == "WME_CLICK") { this.hide(); }
        }
        public function show(subController:IChestSubController, object:IRoomObject,
            chestId:Int, chestOwner:Bool, roomOwner:Bool)
        {
var desktop:IDesktopWindow  = null;            this._chestObject = object;
            this._chestId = chestId;
            this._isChestOwner = chestOwner;
            this._isRoomOwner = roomOwner;
            if (this._subController != null && this._subController != subController)
            {
                this._subController.clear();
                if (this._subController.allowResizing)
                {
                    this._lastResizableWidth = this.chestContents.width;
                    this._lastResizableHeight = this.chestContents.height;
                }
                if (this._settings != null) { this._settings.hide(); }
                if (this._notificationSettings != null) { this._notificationSettings.hide(); }
            }
            this._subController = subController;
            if (this._window.parent == null)
            {
desktop= this._windowManager.getDesktop(1);
                if (desktop != null) { desktop.addChild(this._window); }
            }
            this.resetCaches();
            this.setSubController(subController);
            this.updateLayout();
            this.updateUIOptions();
            this.updateUI();
            this._lockInfoBubble.visible = false;
            this._window.activate();
        }
        public function hide()
        {
var desktop:IDesktopWindow  = null;            if (this.isShowing())
            {
desktop= this._windowManager.getDesktop(1);
                if (desktop != null) { desktop.removeChild(this._window); }
            }
            this._lockInfoBubble.visible = false;
            this.setSubController(null);
            this._controller.setClosedStatus();
            this._chestId = 0;
            this._chestObject = null;
            if (this._subController != null) { this._subController.clear(); }
            this._subController = null;
            this.resetCaches();
            if (this._settings != null) { this._settings.hide(); }
            if (this._notificationSettings != null) { this._notificationSettings.hide(); }
        }
        public function isShowing():Bool
        {
            return this._window != null && this._window.parent != null;
        }
        public function viewingChestUpdated()
        {
            this.resetCaches();
            if (this.isShowing() && !this.canRead && !this.isVisibleForEveryone)
            {
                this.hide();
                return;
            }
            this.updateLayout();
            this.updateUIOptions();
            this.updateUI();
        }
        public function onPermissionsChanged()
        {
            if (this.isShowing() && !this.canRead && !this.isVisibleForEveryone)
            {
                this.hide();
                return;
            }
            if (this.isShowing())
            {
                this.updateLayout();
                this.updateUI();
            }
        }
        public function updateLayout()
        {
            this.refreshChestOwner();
            var data= this.getStuffDataMap();
            if (data == null || this._subController == null) { return; }
            var wired= data.getValue("is_wired_enabled") == "1";
            this._ignoreResizeEvents = true;
            this.settingsButton.visible = this.canRead;
            this.notificationSettingsButton.visible = this.canRead;
            this.viewLogsButton.visible = this.canRead;
            this.lockingOptions.visible = this.canRead && wired;
            this.capacityOptions.visible = this.canRead;
            this.capacityOverrideContainer.visible = this.canRead && wired;
            this.upgradeCapacityContainer.visible = this.canRead;
            this.itemCountText.visible = this.canRead && !wired;
            this.itemCountTextBottom.visible = !this.canRead;
            this.lockInfoButton.visible = this.canRead && wired;
            this.withdrawAllButton.visible = this.canRead;
            this.startDepositButton.caption = this.canRead
                ? "${wiredchests.start_deposit}" : "${wiredchests.donate}";
            this._window.height = this.mainList.height + this._verticalChrome;
            this._ignoreResizeEvents = false;
        }
        public function updateUIOptions()
        {
            var data= this.getStuffDataMap();
            if (data == null) { return; }
            this._ignoreCheckboxEvents = true;
            this._ignoreCapacityEvents = true;
            Util.select(this.lockCheckbox, data.getValue("locked") != "0");
            Util.select(this.autoLockCheckbox, data.getValue("auto_lock") != "0");
            this.capacityInput.text = data.getValue("capacity");
            this._ignoreCheckboxEvents = false;
            this._ignoreCapacityEvents = false;
            this.maxCapacityText.text = this._controller.localization
                .getLocalizationWithParams("wiredchests.max_capacity", "",
                    ["max_capacity", Std.string(this.maxCapacity)]);
        }
        public function updateUI()
        {
            this.refreshChestOwner();
            var data= this.getStuffDataMap();
            if (data == null || this._subController == null) { return; }
            var canDonate= data.getValue("everyone_can_donate") == "1";
            var name:String = data.getValue("chest_name");
            var description:String = data.getValue("chest_desc");
            if (description == null || description == "")
            {
                description = "${wiredchests.description_placeholder}";
            }
            var capacity= ASCompat.toInt(data.getValue("capacity"));
            this.itemCountText.caption = this._controller.localization
                .getLocalizationWithParams("wiredchests.space_used2", "",
                    ["count", this._subController.itemCount, "total", capacity]);
            this.itemCountTextBottom.caption = this._controller.localization
                .getLocalizationWithParams("wiredchests.space_used", "",
                    ["count", this._subController.itemCount, "total", capacity]);
            this._window.caption = name != null && name.length > 0
                ? name : this._subController.title;
            this.description.text = description;
            Util.disableSection(this.lockCheckbox,
                !this._isChestOwner && (!this._isRoomOwner || this.lockCheckbox.Selected));
            Util.disableSection(this.autoLockCheckbox, !this._isChestOwner);
            Util.disableSection(this.capacityInputBorder, !this._isChestOwner);
            Util.disableSection(this.withdrawAllButton, !this.canWithdraw);
            Util.disableSection(this.startDepositButton,
                !canDonate && (!this.canEdit
                    || (this.lockCheckbox.Selected && !this._isChestOwner)));
            // The clean client's room-object owner metadata is absent for some
            // legacy rooms. Keep these controls clickable when the user can
            // edit the room; the server remains authoritative on every save.
            Util.disableSection(this.settingsButton, !this._isChestOwner && !this.canEdit);
            Util.disableSection(this.notificationSettingsButton,
                !this._isChestOwner && !this.canEdit);
            Util.disableSection(this.viewLogsButton, !this.canRead);
            Util.disableSection(this.upgradeButton, this.isStarterChest || !this._isChestOwner);
            this.upgradeRegion.toolTipCaption = this.isStarterChest
                ? "${wiredchests.upgrade.result.error.10}"
                : !this._isChestOwner
                    ? "${wiredchests.upgrade.error.reason.not_owner}" : "";
            this._subController.updateUI();
        }
        function refreshChestOwner()
        {
            if (this._chestObject == null || this._chestObject.getModel() == null) { return; }
            var ownerId= this._chestObject.getModel()
                .getNumber(RoomObjectVariableEnum.FURNITURE_OWNER_ID);
            var ownerName= this._chestObject.getModel()
                .getString(RoomObjectVariableEnum.FURNITURE_OWNER_NAME);
            var matchesId= !Math.isNaN(ownerId) && ownerId > 0
                && Std.int(ownerId) == this._controller.sessionDataManager.userId;
            var userName= this._controller.sessionDataManager.userName;
            var matchesName= ownerName != null && userName != null
                && ownerName.toLowerCase() == userName.toLowerCase();
            if ((!Math.isNaN(ownerId) && ownerId > 0)
                || (ownerName != null && ownerName.length > 0))
            {
                this._isChestOwner = matchesId || matchesName;
            }
        }
        function onOptionsChanged(event:WindowEvent)
        {
            if (this._ignoreCheckboxEvents) { return; }
            this._controller.send(new SaveChestSafetyMessageComposer(this._chestId,
                this.lockCheckbox.Selected, this.autoLockCheckbox.Selected,
                ASCompat.toInt(this.capacityInput.text)));
        }
        function onCapacityChange(event:WindowEvent)
        {
            if (!this._ignoreCapacityEvents && ASCompat.toInt(this.capacityInput.text) > this.maxCapacity)
            {
                this._ignoreCapacityEvents = true;
                this.capacityInput.text = Std.string(this.maxCapacity);
                this._ignoreCapacityEvents = false;
            }
        }
        function onCapacityKeyDown(event:WindowKeyboardEvent)
        {
            if (event.keyCode == 13) { this.onOptionsChanged(null); }
        }
        function onAttemptLock(event:WindowEvent)
        {
            if (this._ignoreCheckboxEvents || this._ignoreSelectEvents
                || this._isChestOwner) { return; }
            event.preventWindowOperation();
            this._windowManager.confirm("${wiredchests.lock.confirm.title}",
                "${wiredchests.lock.confirm.desc}", 0, this.onConfirmLock);
        }
        function onAttemptUnlock(event:WindowEvent)
        {
            if (this._ignoreCheckboxEvents || this._ignoreSelectEvents) { return; }
            event.preventWindowOperation();
            this._windowManager.confirm("${wiredchests.unlock.confirm.title}",
                "${wiredchests.unlock.confirm.desc}", 0, this.onConfirmUnlock);
        }
        function onConfirmLock(dialog:IConfirmDialog, event:WindowEvent)
        {
            dialog.dispose();
            if (event.type == "WE_OK")
            {
                this._ignoreSelectEvents = true;
                this.lockCheckbox.select();
                this._ignoreSelectEvents = false;
            }
        }
        function onConfirmUnlock(dialog:IConfirmDialog, event:WindowEvent)
        {
            dialog.dispose();
            if (event.type == "WE_OK")
            {
                this._ignoreSelectEvents = true;
                this.lockCheckbox.unselect();
                this._ignoreSelectEvents = false;
            }
        }
        function setSubController(value:IChestSubController)
        {
var old:IWindowContainer  = null;            this._ignoreResizeEvents = true;
            var next:IWindowContainer = value == null ? null : value.view;
            if (this.chestContents.numChildren > 0)
            {
old= Std.downcast(this.chestContents.getChildAt(0) , IWindowContainer);
                if (old == next) { this._ignoreResizeEvents = false; return; }
                old.setParamFlag(128, false);
                old.setParamFlag(2048, false);
                this.chestContents.removeChild(old);
            }
            if (next != null)
            {
                next.setParamFlag(128, false);
                next.setParamFlag(2048, false);
                if (!value.allowResizing || this._lastResizableHeight < 0)
                {
                    this._window.width = next.width + this._horizontalChrome;
                    this.chestContents.height = next.height;
                }
                else
                {
                    this._window.width = this._lastResizableWidth + this._horizontalChrome;
                    this.chestContents.height = this._lastResizableHeight;
                }
                this._window.setParamFlag(65536, value.allowResizing);
                this.chestContents.addChild(next);
                if (value.allowResizing)
                {
                    next.width = this.chestContents.width;
                    next.height = this.chestContents.height;
                    next.setParamFlag(128, true);
                    next.setParamFlag(2048, true);
                }
            }
            this._ignoreResizeEvents = false;
        }
        function getStuffDataMap():Map
        {
            if (this._chestObject == null || this._chestObject.getModel() == null) { return null; }
            return this._chestObject.getModel().getStringToStringMap("furniture_data");
        }
        function resetCaches() { this._maxCapacityCache = -1; }
        var currentCapacityLevel(get,never):Int;
function  get_currentCapacityLevel():Int
        {
            var data= this.getStuffDataMap();
            return data == null ? 0 : ASCompat.toInt(data.getValue("capacity_level"));
        }
        var maxCapacity(get,never):Int;
function  get_maxCapacity():Int
        {
            if (this._maxCapacityCache >= 0) { return this._maxCapacityCache; }
            var kind= this._subController != null
                && this._subController.type == ChestType.COINS ? "coins" : "furni";
            if (this.isStarterChest)
            {
                this._maxCapacityCache = this._controller.getInteger(
                    "wired." + kind + "_chest.starter_capacity", 0);
            }
            else
            {
                this._maxCapacityCache = this._controller.getInteger(
                    "wired." + kind + "_chest.initial_capacity", 0)
                    + this._controller.getInteger(
                        "wired." + kind + "_chest.upgrade_capacity", 0)
                        * this.currentCapacityLevel;
            }
            return this._maxCapacityCache;
        }
        var isStarterChest(get,never):Bool;
function  get_isStarterChest():Bool
        {
            if (this._chestObject == null) { return false; }
            var typeId= Std.int(this._chestObject.getModel().getNumber("furniture_type_id"));
            var data= this._controller.sessionDataManager
                .getFloorItemData(typeId);
            var infix= this._controller.getProperty("wired.chests_starter_infix", "");
            return data != null && infix != "" && data.className.indexOf(infix) >= 0;
        }
        public var canWithdraw(get,never):Bool;
public function  get_canWithdraw():Bool
        {
            return this._subController != null && !this._subController.isEmpty
                && this.canEdit && (!this.lockCheckbox.Selected || this._isChestOwner);
        }
        public var canEdit(get,never):Bool;
public function  get_canEdit():Bool
        {
            return this._isChestOwner || (this._controller.roomEvents.wiredMenu != null
                && this._controller.roomEvents.wiredMenu.hasWritePermission);
        }
        public var canRead(get,never):Bool;
public function  get_canRead():Bool
        {
            return this._isChestOwner || (this._controller.roomEvents.wiredMenu != null
                && this._controller.roomEvents.wiredMenu.hasReadPermission);
        }
        public var isVisibleForEveryone(get,never):Bool;
public function  get_isVisibleForEveryone():Bool
        {
            var data= this.getStuffDataMap();
            return data != null && data.getValue("everyone_can_open") == "1";
        }
        public var viewingChestId(get,never):Int;
public function  get_viewingChestId():Int { return this._chestId; }
        public var viewingChestFurni(get,never):IRoomObject;
public function  get_viewingChestFurni():IRoomObject { return this._chestObject; }
        public var chestSettingsUI(get,never):ChestSettingsUI;
public function  get_chestSettingsUI():ChestSettingsUI
        {
            if (this._presets == null) { this._presets = new UbuntuPresetManager(
                this._controller.roomEvents); }
            if (this._settings == null)
            {
                this._settings = new ChestSettingsUI(this._controller, this._presets);
            }
            return this._settings;
        }
        public var chestNotificationSettingsUI(get,never):ChestNotificationSettingsUI;
public function  get_chestNotificationSettingsUI():ChestNotificationSettingsUI
        {
            if (this._presets == null) { this._presets = new UbuntuPresetManager(
                this._controller.roomEvents); }
            if (this._notificationSettings == null)
            {
                this._notificationSettings = new ChestNotificationSettingsUI(
                    this._controller, this._presets);
            }
            return this._notificationSettings;
        }
        public function dispose()
        {
            if (this._disposed) { return; }
            if (this._settings != null) { this._settings.dispose(); }
            if (this._notificationSettings != null) { this._notificationSettings.dispose(); }
            if (this._upgradeView != null) { this._upgradeView.dispose(); }
            this.hide();
            this._window.dispose();
            this._lockInfoBubble.dispose();
            this._window = null;
            this._lockInfoBubble = null;
            this._controller = null;
            this._windowManager = null;
            this._presets = null;
            this._disposed = true;
        }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
        var closeButton(get,never):IWindow;
function  get_closeButton():IWindow
        { return this._window.findChildByName("header_button_close"); }
        var mainList(get,never):IItemListWindow;
function  get_mainList():IItemListWindow
        { return Std.downcast(this._window.findChildByName("main_list") , IItemListWindow); }
        var chestContents(get,never):IWindowContainer;
function  get_chestContents():IWindowContainer
        { return Std.downcast(this._window.findChildByName("chest_contents") , IWindowContainer); }
        var lockInfoButton(get,never):IRegionWindow;
function  get_lockInfoButton():IRegionWindow
        { return Std.downcast(this._window.findChildByName("lock_info_button") , IRegionWindow); }
        var description(get,never):ITextWindow;
function  get_description():ITextWindow
        { return Std.downcast(this._window.findChildByName("desc") , ITextWindow); }
        var settingsButton(get,never):IWindow;
function  get_settingsButton():IWindow
        { return this._window.findChildByName("settings_button"); }
        var notificationSettingsButton(get,never):IWindow;
function  get_notificationSettingsButton():IWindow
        { return this._window.findChildByName("notification_settings_button"); }
        var viewLogsButton(get,never):IButtonWindow;
function  get_viewLogsButton():IButtonWindow
        { return Std.downcast(this._window.findChildByName("view_logs_btn") , IButtonWindow); }
        var lockingOptions(get,never):IItemListWindow;
function  get_lockingOptions():IItemListWindow
        { return Std.downcast(this._window.findChildByName("locking_options") , IItemListWindow); }
        var capacityOptions(get,never):IWindowContainer;
function  get_capacityOptions():IWindowContainer
        { return Std.downcast(this._window.findChildByName("capacity_options") , IWindowContainer); }
        var capacityOverrideContainer(get,never):IItemListWindow;
function  get_capacityOverrideContainer():IItemListWindow
        { return Std.downcast(this._window.findChildByName("capacity_override_container") , IItemListWindow); }
        var upgradeCapacityContainer(get,never):IItemListWindow;
function  get_upgradeCapacityContainer():IItemListWindow
        { return Std.downcast(this._window.findChildByName("upgrade_capacity_container") , IItemListWindow); }
        var itemCountText(get,never):ITextWindow;
function  get_itemCountText():ITextWindow
        { return Std.downcast(this._window.findChildByName("item_count_text") , ITextWindow); }
        var itemCountTextBottom(get,never):ITextWindow;
function  get_itemCountTextBottom():ITextWindow
        { return Std.downcast(this._window.findChildByName("item_count_text_bottom") , ITextWindow); }
        var header(get,never):IWindowContainer;
function  get_header():IWindowContainer
        { return Std.downcast(this._window.findChildByName("header") , IWindowContainer); }
        var footer(get,never):IWindowContainer;
function  get_footer():IWindowContainer
        { return Std.downcast(this._window.findChildByName("footer") , IWindowContainer); }
        var lockCheckbox(get,never):ICheckBoxWindow;
function  get_lockCheckbox():ICheckBoxWindow
        { return Std.downcast(this._window.findChildByName("lock_chest_cbx") , ICheckBoxWindow); }
        var autoLockCheckbox(get,never):ICheckBoxWindow;
function  get_autoLockCheckbox():ICheckBoxWindow
        { return Std.downcast(this._window.findChildByName("auto_lock_chest_cbx") , ICheckBoxWindow); }
        var capacityInput(get,never):ITextFieldWindow;
function  get_capacityInput():ITextFieldWindow
        { return Std.downcast(this._window.findChildByName("capacity_input") , ITextFieldWindow); }
        var capacityInputBorder(get,never):IBorderWindow;
function  get_capacityInputBorder():IBorderWindow
        { return Std.downcast(this._window.findChildByName("capacity_input_border") , IBorderWindow); }
        var maxCapacityText(get,never):ITextWindow;
function  get_maxCapacityText():ITextWindow
        { return Std.downcast(this._window.findChildByName("max_capacity_txt") , ITextWindow); }
        var upgradeButton(get,never):IWindow;
function  get_upgradeButton():IWindow
        { return this._window.findChildByName("upgrade_capacity_btn"); }
        var upgradeRegion(get,never):IRegionWindow;
function  get_upgradeRegion():IRegionWindow
        { return Std.downcast(this._window.findChildByName("upgrade_capacity_region") , IRegionWindow); }
        var withdrawAllButton(get,never):IButtonWindow;
function  get_withdrawAllButton():IButtonWindow
        { return Std.downcast(this._window.findChildByName("withdraw_all_btn") , IButtonWindow); }
        var startDepositButton(get,never):IButtonWindow;
function  get_startDepositButton():IButtonWindow
        { return Std.downcast(this._window.findChildByName("start_deposit_btn") , IButtonWindow); }
    }

