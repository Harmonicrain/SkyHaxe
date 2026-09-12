package com.sulake.habbo.help
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.help.cfh.registry.chat.ChatEventHandler;
    import com.sulake.habbo.help.cfh.registry.instantmessage.InstantMessageEventHandler;
    import com.sulake.habbo.help.cfh.registry.user.UserRegistry;
    import com.sulake.habbo.help.cfh.registry.chat.ChatRegistry;
    import com.sulake.habbo.help.cfh.registry.instantmessage.InstantMessageRegistry;
    import com.sulake.habbo.help.namechange.NameChangeController;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpCategoryData;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.help._enum._Str_2849;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.iid.IIDHabboSoundManager;
    import com.sulake.iid.IIDHabboFriendList;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UsersEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomReadyMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.GetGuestRoomResultEvent;
    import com.sulake.habbo.communication.messages.incoming.help.CallForHelpPendingCallsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.CallForHelpPendingCallsDeletedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.CallForHelpDisabledNotifyMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideReportingStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CfhTopicsInitEvent;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.SanctionStatusEvent;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.habbo.communication.messages.outgoing.help.GetPendingCallsForHelpMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.talent.GuideAdvertisementReadMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.GetGuideReportingStatusMessageComposer;
    import com.sulake.habbo.communication.messages.parser.help.GuideReportingStatusMessageParser;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.RemoveFriendMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.IgnoreUserIdMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserMessageData;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.communication.messages.outgoing.help.GetCfhStatusMessageComposer;
    import com.sulake.habbo.utils.StringUtil;
    import flash.net.URLRequest;

     class HabboHelp extends Component implements IHabboHelp implements  ILinkEventTracker 
    {
        public static inline final REPORT_TYPE_EMERGENCY= 1;
        public static inline final REPORT_TYPE_GUIDE= 2;
        public static inline final REPORT_TYPE_IM= 3;
        public static inline final REPORT_TYPE_ROOM= 4;
        public static inline final REPORT_TYPE_BULLY= 6;
        public static inline final REPORT_TYPE_THREAD= 7;
        public static inline final REPORT_TYPE_MESSAGE= 8;
        public static inline final REPORT_TYPE_PHOTO= 9;

        var _toolbar:IHabboToolbar;
        var _windowManager:IHabboWindowManager;
        var _communicationManager:IHabboCommunicationManager;
        var _localizationManager:IHabboLocalizationManager;
        var _roomSessionManager:IRoomSessionManager;
        var _sessionDataManager:ISessionDataManager;
        var _navigator:IHabboNavigator;
        var _tracking:IHabboTracking;
        var _soundManager:IHabboSoundManager;
        var _friendList:IHabboFriendsList;
        var _messageEvents:Vector<IMessageEvent>;
        var _chatEventHandler:ChatEventHandler;
        var _instantMessageEventHandler:InstantMessageEventHandler;
        var _guideHelpManager:GuideHelpManager;
        var _userRegistry:UserRegistry;
        var _chatRegistry:ChatRegistry;
        var _instantMessageRegistry:InstantMessageRegistry;
        var _nameChangeController:NameChangeController;
        var _callForHelpManager:CallForHelpManager;
        var _welcomeScreenController:WelcomeScreenController;
        var _habboWayController:HabboWayController;
        var _habboWayQuizController:HabboWayQuizController;
        var _safetyBookletController:SafetyBookletController;
        var _outsideRoom:Bool = false;
        var _reportType:Int = 0;
        var _reportMessage:IMessageComposer;
        var _requestType:Int = -1;
        var _currentRoomId:Int = 0;
        var _callForHelpCategories:Vector<CallForHelpCategoryData>;
        var _topicsFlowHelpController:TopicsFlowHelpController;
        var _sanctionInfo:SanctionInfo;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._userRegistry = new UserRegistry();
            this._chatRegistry = new ChatRegistry();
            this._instantMessageRegistry = new InstantMessageRegistry();
            super(k, _arg_2, _arg_3);
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localizationManager;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }

        public var roomSessionManager(get,never):IRoomSessionManager;
public function  get_roomSessionManager():IRoomSessionManager
        {
            return this._roomSessionManager;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var communicationManager(get,never):IHabboCommunicationManager;
public function  get_communicationManager():IHabboCommunicationManager
        {
            return this._communicationManager;
        }

        public var navigator(get,never):IHabboNavigator;
public function  get_navigator():IHabboNavigator
        {
            return this._navigator;
        }

        public var tracking(get,never):IHabboTracking;
public function  get_tracking():IHabboTracking
        {
            return this._tracking;
        }

        public var soundManager(get,never):IHabboSoundManager;
public function  get_soundManager():IHabboSoundManager
        {
            return this._soundManager;
        }

        public var _Str_19829(get,never):Bool;
public function  get__Str_19829():Bool
        {
            return getBoolean("guide.help.new.user.tour.enabled");
        }

        public var newIdentity(get,never):Bool;
public function  get_newIdentity():Bool
        {
            return getInteger("new.identity", 0) > 0;
        }

        public var _Str_9968(get,never):Bool;
public function  get__Str_9968():Bool
        {
            return getBoolean("talent.track.citizenship.enabled");
        }

        public var _Str_19563(get,never):Bool;
public function  get__Str_19563():Bool
        {
            return getBoolean("safety_quiz.disabled");
        }

        public function requestGuide()
        {
            this._guideHelpManager.createHelpRequest(_Str_2849._Str_4268);
        }

        public function reportBully(k:Int)
        {
            if (this._callForHelpManager != null)
            {
                this._callForHelpManager.reportBully(k, this._currentRoomId);
            }
        }

        public function startPhotoReportingInNewCfhFlow(k:Int, _arg_2:String, _arg_3:String, _arg_4:Int)
        {
            if (this._callForHelpManager != null)
            {
                this._callForHelpManager._Str_3469 = this._currentRoomId;
                this._callForHelpManager.reportedUserId = k;
                this._callForHelpManager.reportedUserName = _arg_2;
                this._callForHelpManager._Str_10658 = _arg_4;
                this._callForHelpManager._Str_11455 = _arg_3;
                this._topicsFlowHelpController._Str_15173(HabboHelp.REPORT_TYPE_PHOTO);
            }
        }

        public function reportUser(k:Int, _arg_2:Int, _arg_3:String)
        {
            this._callForHelpManager.reportedUserId = k;
            this._topicsFlowHelpController._Str_25197();
        }

        public function reportUserName(k:Int, _arg_2:String)
        {
            this._callForHelpManager.reportedUserId = k;
            this._callForHelpManager.reportedUserName = _arg_2;
            this._callForHelpManager._Str_3469 = -1;
            this._topicsFlowHelpController._Str_24232();
        }

        public function reportUserFromIM(k:Int)
        {
            if (this._callForHelpManager != null)
            {
                this._callForHelpManager.reportedUserId = k;
                this._topicsFlowHelpController._Str_23015();
            }
        }

        public function reportRoom(k:Int, _arg_2:String, _arg_3:String)
        {
            if (this._callForHelpManager != null)
            {
                this._callForHelpManager._Str_3469 = k;
                this._callForHelpManager._Str_16366 = _arg_2;
                this._callForHelpManager.reportedUserId = -1;
                this._callForHelpManager.reportedUserName = "";
                this._topicsFlowHelpController._Str_15173(REPORT_TYPE_ROOM);
            }
        }

        public function reportThread(k:Int, _arg_2:Int)
        {
            if (this._callForHelpManager != null)
            {
                this._callForHelpManager._Str_11420 = k;
                this._callForHelpManager._Str_10392 = _arg_2;
                this._topicsFlowHelpController._Str_15173(HabboHelp.REPORT_TYPE_THREAD);
            }
        }

        public function reportSelfie(k:String, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Int):Bool
        {
            if (this._callForHelpManager != null)
            {
                if (_arg_2.length < getInteger("help.cfh.length.minimum", 15))
                {
                    this.windowManager.alert("${generic.alert.title}", "${help.cfh.error.msgtooshort}", 0, null);
                    return false;
                }
                this._callForHelpManager.reportSelfie(k, _arg_2, _arg_3, _arg_4, _arg_5);
                return true;
            }
            return false;
        }

        public function reportPhoto(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int):Bool
        {
            if (this._callForHelpManager != null)
            {
                if (_arg_2 == 0)
                {
                    this.windowManager.alert("${generic.alert.title}", "${help.cfh.error.notopic}", 0, null);
                    return false;
                }
                this._callForHelpManager.reportPhoto(k, _arg_2, _arg_3, _arg_4, _arg_5);
                return true;
            }
            return false;
        }

        public function reportMessage(k:Int, _arg_2:Int, _arg_3:Int)
        {
            if (this._callForHelpManager != null)
            {
                this._callForHelpManager._Str_11420 = k;
                this._callForHelpManager._Str_10392 = _arg_2;
                this._callForHelpManager._Str_16155 = _arg_3;
                this._topicsFlowHelpController._Str_15173(HabboHelp.REPORT_TYPE_MESSAGE);
            }
        }

        public function startNameChange()
        {
            if (this._nameChangeController != null)
            {
                this._nameChangeController.showView();
            }
        }

        public function _Str_22356()
        {
            if (this._callForHelpManager != null)
            {
                this._callForHelpManager.openEmergencyHelpRequest();
            }
        }

        public function showWelcomeScreen(k:String, _arg_2:String, _arg_3:Int, _arg_4:String=null)
        {
            if (((this._welcomeScreenController == null) || this._welcomeScreenController.disposed))
            {
                this._welcomeScreenController = new WelcomeScreenController(this);
            }
            this._welcomeScreenController.showWelcomeScreen(k, _arg_2, _arg_3, _arg_4);
        }

        public function showHabboWay()
        {
            if (this._habboWayController == null)
            {
                this._habboWayController = new HabboWayController(this);
            }
            this._habboWayController.showHabboWay();
        }

        public function _Str_24844()
        {
            if (this._habboWayController != null)
            {
                this._habboWayController.closeWindow();
            }
        }

        public function showSafetyBooklet()
        {
            if (this._safetyBookletController == null)
            {
                this._safetyBookletController = new SafetyBookletController(this);
            }
            this._safetyBookletController._Str_24968();
        }

        public function _Str_21195()
        {
            if (this._safetyBookletController != null)
            {
                this._safetyBookletController.closeWindow();
            }
        }

        public function showHabboWayQuiz()
        {
            if (((this._habboWayQuizController == null) || this._habboWayQuizController.disposed))
            {
                this._habboWayQuizController = new HabboWayQuizController(this);
            }
            this._habboWayQuizController.showHabboWayQuiz();
        }

        public function showSafetyQuiz()
        {
            if (((this._habboWayQuizController == null) || this._habboWayQuizController.disposed))
            {
                this._habboWayQuizController = new HabboWayQuizController(this);
            }
            this._habboWayQuizController.showSafetyQuiz();
        }

        public function showTourPopup()
        {
            this._guideHelpManager.openTourPopup();
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }, false), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }, true, [{
                "type":HabboToolbarEvent.HTE_TOOLBAR_CLICK,
                "callback":this.onHabboToolbarEvent
            }, {
                "type":HabboToolbarEvent.HTE_GROUP_ROOM_INFO_CLICK,
                "callback":this.onHabboToolbarEvent
            }, {
                "type":HabboToolbarEvent.HTE_RESIZED,
                "callback":this.onHabboToolbarEvent
            }]), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }, true), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _navigator = k;
            }, false), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _tracking = k;
            }, false), new ComponentDependency(new IIDHabboSoundManager(), function (k:IHabboSoundManager)
            {
                _soundManager = k;
            }, false), new ComponentDependency(new IIDHabboFriendList(), function (k:IHabboFriendsList)
            {
                _friendList = k;
            }, false)]));
        }

        override function initComponent()
        {
            this._messageEvents = new Vector<IMessageEvent>(0);
            this.addMessageEvent(new UsersEvent(this.onUsers));
            this.addMessageEvent(new RoomReadyMessageEvent(this.onRoomReady));
            this.addMessageEvent(new GetGuestRoomResultEvent(this.onGuestRoomResult));
            this.addMessageEvent(new CallForHelpPendingCallsMessageEvent(this.onPendingCallsForHelp));
            this.addMessageEvent(new CallForHelpPendingCallsDeletedMessageEvent(this.onPendingCallsForHelpDeleted));
            this.addMessageEvent(new CallForHelpDisabledNotifyMessageEvent(this.onCallForHelpDisabledNotify));
            this.addMessageEvent(new GuideReportingStatusMessageEvent(this.onGuideReportingStatus));
            this.addMessageEvent(new RoomEntryInfoMessageEvent(this.onRoomEnter));
            this.addMessageEvent(new CfhTopicsInitEvent(this.onCfhTopics));
            this.addMessageEvent(new SanctionStatusEvent(this.onSanctionStatusEvent));
            this._chatEventHandler = new ChatEventHandler(this);
            this._guideHelpManager = new GuideHelpManager(this);
            this._callForHelpManager = new CallForHelpManager(this);
            this._nameChangeController = new NameChangeController(this);
            this._instantMessageEventHandler = new InstantMessageEventHandler(this);
            this._topicsFlowHelpController = new TopicsFlowHelpController(this);
            this._sanctionInfo = new SanctionInfo(this);
            context.addLinkEventTracker(this);
            if ((getBoolean("show.sanction.info.on.login") && (Math.random() < 0.2)))
            {
                this.requestSanctionInfo(true);
            }
        }

        public function addMessageEvent(k:IMessageEvent)
        {
            this._messageEvents.push(this._communicationManager.addHabboConnectionMessageEvent(k));
        }

        override public function dispose()
        {
            var k:IMessageEvent = null;
            if (disposed)
            {
                return;
            }
            if (((!(this._messageEvents == null)) && (!(this._communicationManager == null))))
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._communicationManager.removeHabboConnectionMessageEvent(k);
                }
            }
            if (this._safetyBookletController != null)
            {
                this._safetyBookletController.dispose();
                this._safetyBookletController = null;
            }
            if (this._habboWayController != null)
            {
                this._habboWayController.dispose();
                this._habboWayController = null;
            }
            if (this._welcomeScreenController != null)
            {
                this._welcomeScreenController.dispose();
                this._welcomeScreenController = null;
            }
            if (this._nameChangeController != null)
            {
                this._nameChangeController.dispose();
                this._nameChangeController = null;
            }
            if (this._guideHelpManager != null)
            {
                this._guideHelpManager.dispose();
                this._guideHelpManager = null;
            }
            if (this._callForHelpManager != null)
            {
                this._callForHelpManager.dispose();
                this._callForHelpManager = null;
            }
            if (this._habboWayQuizController != null)
            {
                this._habboWayQuizController.dispose();
                this._habboWayQuizController = null;
            }
            if (this._topicsFlowHelpController != null)
            {
                this._topicsFlowHelpController.dispose();
                this._topicsFlowHelpController = null;
            }
            if (this._sanctionInfo != null)
            {
                this._sanctionInfo.dispose();
                this._sanctionInfo = null;
            }
            super.dispose();
        }

        public function getXmlWindow(name:String, layer:UInt=1):IWindow
        {
            var asset:IAsset = null;
            var xmlAsset:XmlAsset = null;
            var window:IWindow = null;
            try
            {
                asset = assets.getAssetByName((name + "_xml"));
                xmlAsset = cast(asset, XmlAsset);
                window = this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(xmlAsset.content), layer);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("HabboNavigator", (((((("Failed to build window " + name) + "_xml, ") + asset) + ", ") + _windowManager) + "!"));
                throw e;
            }
 }            return window;
        }

        public function getModalXmlWindow(name:String):IModalDialog
        {
            var asset:IAsset = null;
            var xmlAsset:XmlAsset = null;
            var dialog:IModalDialog = null;
            try
            {
                asset = assets.getAssetByName((name + "_xml"));
                xmlAsset = cast(asset, XmlAsset);
                dialog = this._windowManager.buildModalDialogFromXML(new com.sulake.core.utils.xml.XML(xmlAsset.content));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("HabboNavigator", (((((("Failed to build window " + name) + "_xml, ") + asset) + ", ") + _windowManager) + "!"));
                throw e;
            }
 }            return dialog;
        }

        public function trackGoogle(k:String, _arg_2:String, _arg_3:Int=-1)
        {
            if (this._tracking != null)
            {
                this._tracking.trackGoogle(k, _arg_2, _arg_3);
            }
        }

        public function setReportMessage(k:IMessageComposer)
        {
            this._reportMessage = k;
        }

        public function sendMessage(k:IMessageComposer)
        {
            if (((!(this._communicationManager == null)) && (!(k == null))))
            {
                this._communicationManager.connection.send(k);
            }
        }

        public var _Str_16805(get,never):String;
public function  get__Str_16805():String
        {
            return this._nameChangeController._Str_16805;
        }

        public var _Str_6240(get,never):Int;
public function  get__Str_6240():Int
        {
            return this._nameChangeController._Str_6240;
        }

        
        public var outsideRoom(get,set):Bool;
public function  get_outsideRoom():Bool
        {
            return this._outsideRoom;
        }
public function  set_outsideRoom(k:Bool):Bool        {
            return this._outsideRoom = k;
        }

        public function queryForPendingCallsForHelp(k:Int)
        {
            this._reportType = k;
            this.sendMessage(new GetPendingCallsForHelpMessageComposer());
        }

        public function queryForGuideReportingStatus(k:Int)
        {
            this._requestType = k;
            this.sendMessage(new GuideAdvertisementReadMessageComposer());
            this.sendMessage(new GetGuideReportingStatusMessageComposer());
        }

        function onPendingCallsForHelp(k:IMessageEvent)
        {
            var _local_3:String = null;
            var _local_4 = 0;
            var _local_2= cast(k, CallForHelpPendingCallsMessageEvent).getParser();
            if (((_local_2.count == 0) || ((this._reportType == REPORT_TYPE_PHOTO) && (_local_2.count < 3))))
            {
                this.proceedWithReporting();
            }
            else
            {
                _local_3 = "";
                _local_4 = 0;
                while (((_local_4 < _local_2.pendingCalls.length) && (_local_4 < 10)))
                {
                    _local_3 = (_local_3 + _local_2.pendingCalls[_local_4].message);
                    if (((_local_4 < (_local_2.pendingCalls.length - 1)) && (_local_4 < 9)))
                    {
                        _local_3 = (_local_3 + "\n");
                    }
                    _local_4++;
                }
                this._callForHelpManager.showPendingRequest(_local_3);
            }
        }

        function onPendingCallsForHelpDeleted(k:IMessageEvent)
        {
            this._topicsFlowHelpController.submitCallForHelp(false);
        }

        function onGuideReportingStatus(k:GuideReportingStatusMessageEvent)
        {
            var _local_2= k.getParser();
            switch (_local_2.statusCode)
            {
                case GuideReportingStatusMessageParser.GUIDE_REPORTING_STATUS_OK:
                    this.toggleNewHelpWindow();
                    return;
                case GuideReportingStatusMessageParser.GUIDE_REPORTING_STATUS_PENDING_TICKET:
                    this._guideHelpManager.showPendingTicket(_local_2.pendingTicket);
                    return;
                default:
                    this._guideHelpManager.showFeedback(_local_2.localizationCode);
            }
        }

        function proceedWithReporting()
        {
            switch (this._reportType)
            {
                case REPORT_TYPE_EMERGENCY
                   | REPORT_TYPE_IM
                   | REPORT_TYPE_ROOM
                   | REPORT_TYPE_THREAD
                   | REPORT_TYPE_MESSAGE:
                    this._callForHelpManager.showEmergencyHelpRequest(this._reportType);
                    
                case REPORT_TYPE_GUIDE:
                    this._guideHelpManager.openReportWindow();
                    
                case REPORT_TYPE_PHOTO:
                    if (this._reportMessage != null)
                    {
                        this.sendMessage(this._reportMessage);
                        this._reportMessage = null;
                    }
                    
            }
            this._reportType = 0;
        }

        function onCallForHelpDisabledNotify(k:CallForHelpDisabledNotifyMessageEvent)
        {
            this._windowManager.simpleAlert("${help.emergency.global_mute.caption}", "${help.emergency.global_mute.subtitle}", "${help.emergency.global_mute.message}", "${help.emergency.global_mute.link}", k.getParser()._Str_23798);
        }

        public var friendList(get,never):IHabboFriendsList;
public function  get_friendList():IHabboFriendsList
        {
            return this._friendList;
        }

        public function ignoreAndUnfriendReportedUser()
        {
            var k:RemoveFriendMessageComposer = null;
            if (this._callForHelpManager.reportedUserId > 0)
            {
                this.sendMessage(new IgnoreUserIdMessageComposer(this._callForHelpManager.reportedUserId));
                if (this._friendList.getFriend(this._callForHelpManager.reportedUserId) != null)
                {
                    k = new RemoveFriendMessageComposer();
                    k.addRemovedFriend(this._callForHelpManager.reportedUserId);
                    this.sendMessage(k);
                }
            }
        }

        function onUsers(k:IMessageEvent)
        {
            var _local_4:UserMessageData = null;
            var _local_2= cast(k, UsersEvent).getParser();
            var _local_3 = 0;
            while (_local_3 < _local_2.getUserCount())
            {
                _local_4 = _local_2.getUser(_local_3);
                if (((!(_local_4.id == this._Str_6240)) && (_local_4.userType == RoomObjectTypeEnum.HABBO)))
                {
                    this._userRegistry._Str_23385(_local_4.id, _local_4.name, _local_4.figure);
                }
                _local_3++;
            }
        }

        function onRoomReady(k:IMessageEvent)
        {
            var _local_2= cast(k, RoomReadyMessageEvent).getParser();
            this._userRegistry._Str_19528(_local_2.roomId, "");
        }

        function onGuestRoomResult(k:IMessageEvent)
        {
            var _local_2= cast(k, GetGuestRoomResultEvent).getParser();
            this._userRegistry._Str_19528(_local_2.data.flatId, _local_2.data.roomName);
        }

        public var userRegistry(get,never):UserRegistry;
public function  get_userRegistry():UserRegistry
        {
            return this._userRegistry;
        }

        public var chatRegistry(get,never):ChatRegistry;
public function  get_chatRegistry():ChatRegistry
        {
            return this._chatRegistry;
        }

        public var instantMessageRegistry(get,never):InstantMessageRegistry;
public function  get_instantMessageRegistry():InstantMessageRegistry
        {
            return this._instantMessageRegistry;
        }

        function onRoomEnter(k:RoomEntryInfoMessageEvent)
        {
            var _local_2= k.getParser();
            this._currentRoomId = _local_2.guestRoomId;
        }

        function onCfhTopics(k:CfhTopicsInitEvent)
        {
            var _local_2= k.getParser();
            this._callForHelpCategories = _local_2.callForHelpCategories;
        }

        public var callForHelpCategories(get,never):Vector<CallForHelpCategoryData>;
public function  get_callForHelpCategories():Vector<CallForHelpCategoryData>
        {
            return this._callForHelpCategories;
        }

        public var _Str_16486(get,never):Bool;
public function  get__Str_16486():Bool
        {
            return getBoolean("guardians.enabled");
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "help/";
        }

        
        public var reportedUserId(get,set):Int;
public function  get_reportedUserId():Int
        {
            return this._callForHelpManager.reportedUserId;
        }

        public var reportedUserName(get,never):String;
public function  get_reportedUserName():String
        {
            return this._callForHelpManager.reportedUserName;
        }

        
        public var _Str_3469(get,set):Int;
public function  get__Str_3469():Int
        {
            return this._callForHelpManager._Str_3469;
        }

        public var _Str_11455(get,never):String;
public function  get__Str_11455():String
        {
            return this._callForHelpManager._Str_11455;
        }

        public var _Str_10658(get,never):Int;
public function  get__Str_10658():Int
        {
            return this._callForHelpManager._Str_10658;
        }
public function  set_reportedUserId(k:Int):Int        {
            return this._callForHelpManager.reportedUserId = k;
        }
public function  set__Str_3469(k:Int):Int        {
            return this._callForHelpManager._Str_3469 = k;
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:ASAny = null;
            var _local_4:ASAny = null;
            if (k == "help/tour")
            {
                this.requestGuide();
            }
            if (k.indexOf("help/report/room/") == 0)
            {
                _local_2 = (cast k.split("/"));
                if (_local_2.length >= 5)
                {
                    _local_3 = ASCompat.parseInt(_local_2[3]);
                    _local_4 = ASCompat.unescape(ASCompat.arraySpliceAll(_local_2, 4).join("/"));
                    this.reportRoom(ASCompat.toInt(_local_3), _local_4, "");
                }
            }
        }

        function onHabboToolbarEvent(k:HabboToolbarEvent)
        {
            if (this._welcomeScreenController != null)
            {
                this._welcomeScreenController.onHabboToolbarEvent(k);
            }
            if (this._guideHelpManager != null)
            {
                this._guideHelpManager.onHabboToolbarEvent(k);
            }
        }

        public var callForHelpManager(get,never):CallForHelpManager;
public function  get_callForHelpManager():CallForHelpManager
        {
            return this._callForHelpManager;
        }

        public function toggleNewHelpWindow()
        {
            this._topicsFlowHelpController.toggleWindow();
        }

        public function requestSanctionInfo(k:Bool)
        {
            this.sendMessage(new GetCfhStatusMessageComposer(k));
        }

        function onSanctionStatusEvent(k:SanctionStatusEvent)
        {
            this._sanctionInfo.openWindow(k);
        }

        public function openCfhFaq()
        {
            var k= context.configuration.getProperty("cfh.faq.url");
            if (!StringUtil.isEmpty(k))
            {
                flash.Lib.getURL(new URLRequest(k));
            }
        }

        public var _Str_21711(get,never):GuideHelpManager;
public function  get__Str_21711():GuideHelpManager
        {
            return this._guideHelpManager;
        }
    }

