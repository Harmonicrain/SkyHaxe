package com.sulake.habbo.roomevents
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.notifications.IHabboNotifications;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.WiredClickUserMessageComposer;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboNotifications;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.habbo.room.IRoomEngineServices;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.communication._enum.HabboCommunicationEvent;
    import flash.display.BitmapData;
    import flash.events.Event;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.NewVariablePickerHelper;
    import com.sulake.habbo.roomevents.wired_menu.WiredMenuController;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.roomevents.wired_trading.reward_notification.RewardNotificationController;
    import com.sulake.habbo.roomevents.wired_trading.transactions.WiredTransactionDetailsController;
    import com.sulake.habbo.roomevents.wired_trading.transactions.WiredTransactionLogsController;

     class HabboUserDefinedRoomEvents extends Component implements IHabboUserDefinedRoomEvents 
    {
        var _windowManager:IHabboWindowManager;
        var _communication:IHabboCommunicationManager;
        var _localization:IHabboLocalizationManager;
        var _notifications:IHabboNotifications;
        var _userDefinedRoomEventsCtrl:UserDefinedRoomEventsCtrl;
        var _incomingMessages:IncomingMessages;
        var _wiredCapabilities:WiredCapabilities;
        var _variablesSynchronizer:WiredVariablesSynchronizer;
        var _wiredEnvironment:WiredEnvironment;
        var _wiredMenu:WiredMenuController;
        var _wiredChestController:WiredChestController;
        var _wiredContractController:WiredContractController;
        var _rewardNotificationController:RewardNotificationController;
        var _transactionLogsController:WiredTransactionLogsController;
        var _transactionDetailsController:WiredTransactionDetailsController;
        var _variablePickerHelper:NewVariablePickerHelper;
        var _roomEngine:IRoomEngine;
        var _roomSessionManager:IRoomSessionManager;
        var _roomSession:IRoomSession;
        var _sessionDataManager:ISessionDataManager;
        var _toolbar:IHabboToolbar;
        var _catalog:IHabboCatalog;
        var _userName:String;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._userDefinedRoomEventsCtrl = new UserDefinedRoomEventsCtrl(this);
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communication;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboNotifications(), function (k:IHabboNotifications)
            {
                _notifications = k;
            }), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }, false, [{
                "type":RoomSessionEvent.CREATED,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionEvent.STARTED,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionEvent.ROOM_DATA,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionEvent.ENDED,
                "callback":this.roomSessionStateEventHandler
            }]), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
                refreshWiredUiConsumers();
            }, false, [{
                "type":HabboToolbarEvent.HTE_TOOLBAR_CLICK,
                "callback":this.onHabboToolbarEvent
            }]), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            })]));
        }

        override function initComponent()
        {
            this._variablePickerHelper = new NewVariablePickerHelper(this);
            this._wiredCapabilities = new WiredCapabilities(this);
            this._variablesSynchronizer = new WiredVariablesSynchronizer(this);
            this._wiredEnvironment = new WiredEnvironment(this);
            this._wiredMenu = new WiredMenuController(this);
            context.addLinkEventTracker(this._wiredMenu);
            this._wiredChestController = new WiredChestController(this);
            this._wiredContractController = new WiredContractController(this);
            this._rewardNotificationController =
                new RewardNotificationController(this);
            context.addLinkEventTracker(this._rewardNotificationController);
            this._transactionLogsController =
                new WiredTransactionLogsController(this);
            this._transactionDetailsController =
                new WiredTransactionDetailsController(this);
            this._incomingMessages = new IncomingMessages(this);
            context.events.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_ESTABLISHED, this.onConnectionEvent);
            context.events.addEventListener(HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED, this.onConnectionEvent);
            // This component can be created after the room session has already started.
            // Do not wait for a future room transition to negotiate its room capabilities.
            this.synchronizeCurrentRoomSession();
        }

        public function showWiredNotification(localizationKey:String)
        {
            if (this._notifications == null) { return; }
            var extraData:ASObject = {};
ASCompat.setDynamicProperty(            extraData, "time_display", 2500);
            this._notifications.addItem(this._localization.getLocalization(localizationKey, localizationKey), "wired", null, null, extraData);
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            var componentContext= context;
            if (this._incomingMessages != null)
            {
                this._incomingMessages.dispose();
                this._incomingMessages = null;
            }
            if (this._wiredEnvironment != null)
            {
                this._wiredEnvironment.dispose();
                this._wiredEnvironment = null;
            }
            if (this._wiredMenu != null)
            {
                if (componentContext != null)
                {
                    componentContext.removeLinkEventTracker(this._wiredMenu);
                }
                this._wiredMenu.dispose();
                this._wiredMenu = null;
            }
            if (this._wiredChestController != null)
            {
                this._wiredChestController.dispose();
                this._wiredChestController = null;
            }
            if (this._wiredContractController != null)
            {
                this._wiredContractController.dispose();
                this._wiredContractController = null;
            }
            if (this._rewardNotificationController != null)
            {
                if (componentContext != null)
                {
                    componentContext.removeLinkEventTracker(
                        this._rewardNotificationController);
                }
                this._rewardNotificationController.dispose();
                this._rewardNotificationController = null;
            }
            if (this._transactionLogsController != null)
            {
                this._transactionLogsController.dispose();
                this._transactionLogsController = null;
            }
            if (this._transactionDetailsController != null)
            {
                this._transactionDetailsController.dispose();
                this._transactionDetailsController = null;
            }
            if (componentContext != null && componentContext.events != null)
            {
                componentContext.events.removeEventListener(
                    HabboCommunicationEvent.HABBO_CONNECTION_EVENT_ESTABLISHED,
                    this.onConnectionEvent);
                componentContext.events.removeEventListener(
                    HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED,
                    this.onConnectionEvent);
            }
            if (this._wiredCapabilities != null)
            {
                this._wiredCapabilities.dispose();
                this._wiredCapabilities = null;
            }
            if (this._variablesSynchronizer != null)
            {
                this._variablesSynchronizer.dispose();
                this._variablesSynchronizer = null;
            }
            if (this._variablePickerHelper != null)
            {
                this._variablePickerHelper.dispose();
                this._variablePickerHelper = null;
            }
            super.dispose();
        }

        function onConnectionEvent(k:Event)
        {
            if (this._wiredCapabilities == null)
            {
                return;
            }
            this._wiredCapabilities.resetConnection();
            if (this._variablesSynchronizer != null)
            {
                this._variablesSynchronizer.clear();
            }
            if (k.type == HabboCommunicationEvent.HABBO_CONNECTION_EVENT_AUTHENTICATED)
            {
                this.synchronizeCurrentRoomSession();
                this._wiredCapabilities.request(this.roomId);
            }
        }

        public function _Str_15677(k:Int, _arg_2:String)
        {
            var _local_3= ASCompat.reinterpretAs(this._roomEngine , IRoomEngineServices).getPlacedObjectData(this.roomId);
            if (((_local_3 != null) && (_local_3.id == -k)))
            {
                ASCompat.reinterpretAs(this._roomEngine , IRoomEngineServices).setPlacedObjectData(this.roomId, null);
                return;
            }
            this._userDefinedRoomEventsCtrl._Str_15677(k, _arg_2);
        }

        public function send(k:IMessageComposer, _arg_2:Bool=false)
        {
            this._communication.connection.send(k);
        }

        public function userSelected(k:Int)
        {
            if (this._wiredMenu != null)
            {
                this._wiredMenu.inspectUser(k);
            }
            if (this.hasClickUserWired())
            {
                this.send(new WiredClickUserMessageComposer(
                    k, com.sulake.habbo.room.RoomObjectEventHandler.wiredHeldTicks));
            }
        }

        public function furnitureSelected(k:Int)
        {
            if (this._wiredMenu != null)
            {
                this._wiredMenu.inspectFurni(k);
            }
        }

        public function showInspectButton():Bool
        {
            return this._wiredMenu != null
                && this.isWiredFeatureEnabled(WiredCapabilityCodes.WIRED_MENU)
                && this._wiredMenu.hasReadPermission
                && this._wiredMenu.wiredInspectButton;
        }

        public function showToolbarMenuButton():Bool
        {
            return this._wiredMenu != null
                && this.isWiredFeatureEnabled(WiredCapabilityCodes.WIRED_MENU)
                && this._wiredMenu.hasReadPermission
                && this._wiredMenu.wiredMenuButton;
        }

        public function inspectObject(type:Int, id:Int)
        {
            if (this._wiredMenu != null && this.showInspectButton())
            {
                this._wiredMenu.linkReceived(
                    "wiredmenu/open/inspection/" + Std.string(type) + "/" + Std.string(id));
            }
        }

        public function refreshWiredUiConsumers()
        {
            if (this._toolbar != null)
            {
                this._toolbar.setIconVisibility(
                    HabboToolbarIconEnum.WIRED_MENU,
                    this.showToolbarMenuButton());
            }
            if (this._wiredChestController != null)
            {
                this._wiredChestController.onPermissionsChanged();
            }
        }

        function onHabboToolbarEvent(k:HabboToolbarEvent)
        {
            if (k.iconId == HabboToolbarIconEnum.WIRED_MENU &&
                this.showToolbarMenuButton())
            {
                this.openWiredMenu();
            }
        }

        public var achievementsInRoom(get,never):Vector<String>;
public function  get_achievementsInRoom():Vector<String>
        {
            return this._wiredEnvironment != null
                ? this._wiredEnvironment.achievements
                : new Vector<String>();
        }

        public function resetWiredRoomState()
        {
            if (this._wiredMenu != null)
            {
                this._wiredMenu.resetRoom();
            }
            if (this._wiredChestController != null)
            {
                this._wiredChestController.resetRoom();
            }
            if (this._wiredContractController != null)
            {
                this._wiredContractController.clear();
            }
            if (this._rewardNotificationController != null)
            {
                this._rewardNotificationController.closeAllViews();
            }
            if (this._transactionLogsController != null)
            {
                this._transactionLogsController.resetRoom();
            }
            if (this._transactionDetailsController != null)
            {
                this._transactionDetailsController.resetRoom();
            }
            if (this._wiredEnvironment != null)
            {
                this._wiredEnvironment.leaveRoom();
            }
            if (this._wiredCapabilities != null)
            {
                this._wiredCapabilities.resetRoom();
            }
            if (this._variablesSynchronizer != null)
            {
                this._variablesSynchronizer.clear();
            }
        }

        public function hasClickUserWired():Bool
        {
            return this._wiredEnvironment != null
                && this._wiredEnvironment.hasClickUserWired;
        }

        /** July's user click option 1 makes the active room use game-mode click routing. */
        public var isGameMode(get,never):Bool;
public function  get_isGameMode():Bool
        {
            return this._wiredEnvironment != null
                && this._wiredEnvironment.clickUserOption == WiredEnvironment.CLICK_USER_WALK_BEHIND;
        }

        public var notifications(get,never):IHabboNotifications;
public function  get_notifications():IHabboNotifications
        {
            return this._notifications;
        }

        public function openWiredMenu(tab:String = "monitor")
        {
            if (this._wiredMenu != null)
            {
                this._wiredMenu.show(tab);
            }
        }

        /**
         * July bases the persistent notification toggle on Wired Menu write
         * permission. Until the menu snapshot arrives, existing room rights
         * are the conservative equivalent.
         */
        public var hasWiredMenuWritePermission(get,never):Bool;
public function  get_hasWiredMenuWritePermission():Bool
        {
            if (this._roomSession == null)
            {
                return false;
            }
            return this._roomSession.isRoomOwner
                || this._roomSession.roomControllerLevel > 0
                || (this._sessionDataManager != null
                    && this._sessionDataManager.isAnyRoomController);
        }

        public function isWiredFeatureEnabled(k:Int):Bool
        {
            if (this._wiredCapabilities == null)
            {
                return false;
            }
            if (k == WiredCapabilityCodes.PROTOCOL)
            {
                return this._wiredCapabilities.isConnectionSupported(k);
            }
            return this._wiredCapabilities.isRoomEnabled(k, this.roomId);
        }

        public function getXmlWindow(k:String):IWindow
        {
            var _local_3:IAsset = null;
            var _local_4:XmlAsset = null;
            var _local_2:IWindow = null;
            try
            {
                _local_3 = assets.getAssetByName((k + "_xml"));
                _local_4 = cast(_local_3, XmlAsset);
                _local_2 = this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_4.content));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return _local_2;
        }

        public function refreshButton(k:IWindowContainer, _arg_2:String, _arg_3:Bool, _arg_4:ASFunction, _arg_5:Int, _arg_6:String=null)
        {
            if (!ASCompat.stringAsBool(_arg_6))
            {
                _arg_6 = _arg_2;
            }
            var _local_7= Std.downcast(k.findChildByName(_arg_2) , IBitmapWrapperWindow);
            if (!_arg_3)
            {
                _local_7.visible = false;
            }
            else
            {
                this._Str_11416(_local_7, _arg_6, _arg_4, _arg_5);
                _local_7.visible = true;
            }
        }

        function _Str_11416(k:IBitmapWrapperWindow, _arg_2:String, _arg_3:ASFunction, _arg_4:Int)
        {
            k.id = _arg_4;
            k.procedure = _arg_3;
            if (k.bitmap != null)
            {
                return;
            }
            k.bitmap = this.getButtonImage(_arg_2);
            k.width = k.bitmap.width;
            k.height = k.bitmap.height;
        }

        public function getButtonImage(k:String, _arg_2:String="_png"):BitmapData
        {
            var _local_3= (k + _arg_2);
            var _local_4= assets.getAssetByName(_local_3);
            var _local_5= cast(_local_4, BitmapDataAsset);
            var _local_6= cast(_local_5.content, BitmapData);
            return _local_6.clone();
        }

        public var _Str_7247(get,never):UserDefinedRoomEventsCtrl;
public function  get__Str_7247():UserDefinedRoomEventsCtrl
        {
            return this._userDefinedRoomEventsCtrl;
        }

        public var wiredCtrl(get,never):UserDefinedRoomEventsCtrl;
public function  get_wiredCtrl():UserDefinedRoomEventsCtrl
        {
            return this._userDefinedRoomEventsCtrl;
        }

        public var variablesSynchronizer(get,never):WiredVariablesSynchronizer;
public function  get_variablesSynchronizer():WiredVariablesSynchronizer
        {
            return this._variablesSynchronizer;
        }

        public var variablePickerHelper(get,never):NewVariablePickerHelper;
public function  get_variablePickerHelper():NewVariablePickerHelper
        {
            return this._variablePickerHelper;
        }

        public var wiredMenu(get,never):WiredMenuController;
public function  get_wiredMenu():WiredMenuController
        {
            return this._wiredMenu;
        }

        public var wiredChestController(get,never):WiredChestController;
public function  get_wiredChestController():WiredChestController
        {
            return this._wiredChestController;
        }

        public var wiredContractController(get,never):WiredContractController;
public function  get_wiredContractController():WiredContractController
        {
            return this._wiredContractController;
        }

        public var rewardNotificationController(get,never):RewardNotificationController;
public function  get_rewardNotificationController():RewardNotificationController
        {
            return this._rewardNotificationController;
        }

        public var transactionLogsController(get,never):WiredTransactionLogsController;
public function  get_transactionLogsController():WiredTransactionLogsController
        {
            return this._transactionLogsController;
        }

        public var transactionDetailsController(get,never):WiredTransactionDetailsController;
public function  get_transactionDetailsController():WiredTransactionDetailsController
        {
            return this._transactionDetailsController;
        }

        public var roomSession(get,never):IRoomSession;
public function  get_roomSession():IRoomSession
        {
            return this._roomSession;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }

        function roomSessionStateEventHandler(k:RoomSessionEvent)
        {
            if (this._roomEngine == null)
            {
                return;
            }
            switch (k.type)
            {
                case RoomSessionEvent.CREATED:
                    this.resetWiredRoomState();
                    this._roomSession = k.session;
                    return;
                case RoomSessionEvent.STARTED:
                    this.resetWiredRoomState();
                    this._roomSession = k.session;
                    if (this._wiredMenu != null)
                    {
                        this._wiredMenu.applyRoomSessionPreferences();
                    }
                    if (this._wiredCapabilities != null)
                    {
                        this._wiredCapabilities.request(this.roomId);
                    }
                    return;
                case RoomSessionEvent.ROOM_DATA:
                    this._roomSession = k.session;
                    if (this._wiredMenu != null)
                    {
                        this._wiredMenu.applyRoomSessionPreferences();
                    }
                    if (this._wiredCapabilities != null)
                    {
                        // ROOM_DATA arrives after the server has completed room entry. Retrying
                        // here closes the STARTED/current-room ordering race without reloading.
                        this._wiredCapabilities.request(this.roomId);
                    }
                    return;
                case RoomSessionEvent.ENDED:
                    this.resetWiredRoomState();
                    this._roomSession = k.session;
                    return;
            }
        }

        function synchronizeCurrentRoomSession()
        {
            if (((this._roomSessionManager == null) || (this._roomEngine == null)))
            {
                return;
            }
            var k= this._roomSessionManager.getSession(this._roomEngine.activeRoomId);
            if (k == null)
            {
                return;
            }
            if (this._roomSession != k)
            {
                this.resetWiredRoomState();
                this._roomSession = k;
            }
            if (this._wiredCapabilities != null)
            {
                this._wiredCapabilities.request(k.roomId);
            }
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return (this._roomSession != null) ? this._roomSession.roomId : 0;
        }

        
        public var userName(get,set):String;
public function  get_userName():String
        {
            return this._userName;
        }
public function  set_userName(k:String):String        {
            return this._userName = k;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }
    }

