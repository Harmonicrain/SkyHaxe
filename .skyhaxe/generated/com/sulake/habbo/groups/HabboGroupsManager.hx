package com.sulake.habbo.groups
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.navigator.IHabboNewNavigator;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.communication.messages.incoming.users.GuildEditorData;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboNewNavigator;
    import com.sulake.iid.IIDHabboFriendList;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.habbo.communication.messages.incoming.users.ExtendedProfileMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildEditFailedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.GetGuestRoomResultEvent;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupJoinFailedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GroupMembershipRequestedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMemberMgmtFailedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.RelationshipStatusInfoEvent;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDetailsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatCreatedEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildCreatedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMemberFurniCountInHQMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildCreationInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildEditorDataMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMembershipRejectedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupDeactivatedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMembersEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GroupDetailsChangedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildEditInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMembershipUpdatedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.ExtendedProfileChangedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.ScrSendUserInfoEvent;
    import com.sulake.habbo.communication.messages.incoming.users.UserBadgesEvent;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.habbo.communication.messages.parser.users.HabboGroupJoinFailedMessageParser;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.groups.events.HabboGroupsEditorData;
    import com.sulake.habbo.communication.messages.parser.users.GuildEditFailedMessageParser;
    import com.sulake.habbo.communication.messages.incoming.users.MemberData;
    import com.sulake.habbo.communication.messages.outgoing.users.KickMemberMessageComposer;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.habbo.communication.messages.outgoing.users.GetGuildEditorDataMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetMemberGuildItemCountMessageComposer;

     class HabboGroupsManager extends Component implements IHabboGroupsManager implements  ILinkEventTracker 
    {
        public static inline final HABBOGROUPS= "HabboGroups";

        var _communication:IHabboCommunicationManager;
        var _windowManager:IHabboWindowManager;
        var _localization:IHabboLocalizationManager;
        var _navigator:IHabboNavigator;
        var _newNavigator:IHabboNewNavigator;
        var _friendlist:IHabboFriendsList;
        var _catalog:IHabboCatalog;
        var _toolbar:IHabboToolbar;
        var _habboTracking:IHabboTracking;
        var _sessionDataManager:ISessionDataManager;
        var _detailsWindowCtrl:DetailsWindowCtrl;
        var _guildMembersWindowCtrl:GuildMembersWindowCtrl;
        var _guildManagementWindowCtrl:GuildManagementWindowCtrl;
        var _extendedProfileWindowCtrl:ExtendedProfileWindowCtrl;
        var _hcRequiredWindowCtrl:HcRequiredWindowCtrl;
        var _groupCreatedWindowCtrl:GroupCreatedWindowCtrl;
        var _groupRoomInfoCtrl:GroupRoomInfoCtrl;
        var _guildEditorData:GuildEditorData;
        var _avatarId:Int = 0;
        var _roomId:Int = 0;
        var _hasVip:Bool = false;
        var _kickData:GuildKickData;
        var _messageEvents:Vector<IMessageEvent>;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._detailsWindowCtrl = new DetailsWindowCtrl(this);
            this._guildMembersWindowCtrl = new GuildMembersWindowCtrl(this);
            this._guildManagementWindowCtrl = new GuildManagementWindowCtrl(this);
            this._extendedProfileWindowCtrl = new ExtendedProfileWindowCtrl(this);
            this._hcRequiredWindowCtrl = new HcRequiredWindowCtrl(this);
            this._groupCreatedWindowCtrl = new GroupCreatedWindowCtrl(this);
            this._groupRoomInfoCtrl = new GroupRoomInfoCtrl(this);
            Logger.log([("HabboGroupsManager initialized: " + _arg_3)]);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _navigator = k;
            }), new ComponentDependency(new IIDHabboNewNavigator(), function (k:IHabboNewNavigator)
            {
                _newNavigator = k;
            }), new ComponentDependency(new IIDHabboFriendList(), function (k:IHabboFriendsList)
            {
                _friendlist = k;
            }), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _habboTracking = k;
            })]));
        }

        override function initComponent()
        {
            this._messageEvents = new Vector<IMessageEvent>(0);
            this.addMessageEvent(new ExtendedProfileMessageEvent(this.onExtendedProfile));
            this.addMessageEvent(new GuildEditFailedMessageEvent(this.onGuildEditFailed));
            this.addMessageEvent(new GetGuestRoomResultEvent(this.onRoomInfo));
            this.addMessageEvent(new HabboGroupJoinFailedMessageEvent(this.onJoinFailed));
            this.addMessageEvent(new GroupMembershipRequestedMessageEvent(this._guildMembersWindowCtrl.onMembershipRequested));
            this.addMessageEvent(new GuildMemberMgmtFailedMessageEvent(this._guildMembersWindowCtrl.onGuildMemberMgmtFailed));
            this.addMessageEvent(new RelationshipStatusInfoEvent(this.onRelationshipStatusInfo));
            this.addMessageEvent(new HabboGroupDetailsMessageEvent(this.onGroupDetails));
            this.addMessageEvent(new FlatCreatedEvent(this.onFlatCreated));
            this.addMessageEvent(new RoomEntryInfoMessageEvent(this.onRoomEnter));
            this.addMessageEvent(new GuildCreatedMessageEvent(this.onGuildCreated));
            this.addMessageEvent(new GuildMemberFurniCountInHQMessageEvent(this.onKickConfirmation));
            this.addMessageEvent(new GuildCreationInfoMessageEvent(this.onGuildCreationInfo));
            this.addMessageEvent(new GuildEditorDataMessageEvent(this.onGuildEditorData));
            this.addMessageEvent(new CloseConnectionMessageEvent(this.onRoomLeave));
            this.addMessageEvent(new GuildMembershipRejectedMessageEvent(this._guildMembersWindowCtrl.onGuildMembershipRejected));
            this.addMessageEvent(new HabboGroupDeactivatedMessageEvent(this.onGroupDeactivated));
            this.addMessageEvent(new GuildMembersEvent(this._guildMembersWindowCtrl.onGuildMembers));
            this.addMessageEvent(new GroupDetailsChangedMessageEvent(this.onGroupDetailsChanged));
            this.addMessageEvent(new UserObjectEvent(this.onUserObject));
            this.addMessageEvent(new GuildEditInfoMessageEvent(this.onGuildEditInfo));
            this.addMessageEvent(new GuildMembershipUpdatedMessageEvent(this._guildMembersWindowCtrl.onGuildMembershipUpdated));
            this.addMessageEvent(new ExtendedProfileChangedMessageEvent(this.onExtendedProfileChanged));
            this.addMessageEvent(new ScrSendUserInfoEvent(this.onSubscriptionInfo));
            this.addMessageEvent(new UserBadgesEvent(this.onUserBadgesMessage));
            context.addLinkEventTracker(this);
        }

        function addMessageEvent(k:IMessageEvent)
        {
            this._messageEvents.push(this._communication.addHabboConnectionMessageEvent(k));
        }

        override public function dispose()
        {
            var k:IMessageEvent = null;
            if (disposed)
            {
                return;
            }
            if (((!(this._messageEvents == null)) && (!(this._communication == null))))
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._communication.removeHabboConnectionMessageEvent(k);
                }
                this._messageEvents = null;
            }
            if (this._detailsWindowCtrl != null)
            {
                this._detailsWindowCtrl.dispose();
                this._detailsWindowCtrl = null;
            }
            if (this._guildMembersWindowCtrl != null)
            {
                this._guildMembersWindowCtrl.dispose();
                this._guildMembersWindowCtrl = null;
            }
            if (this._guildManagementWindowCtrl != null)
            {
                this._guildManagementWindowCtrl.dispose();
                this._guildManagementWindowCtrl = null;
            }
            if (this._extendedProfileWindowCtrl != null)
            {
                this._extendedProfileWindowCtrl.dispose();
                this._extendedProfileWindowCtrl = null;
            }
            if (this._hcRequiredWindowCtrl != null)
            {
                this._hcRequiredWindowCtrl.dispose();
                this._hcRequiredWindowCtrl = null;
            }
            if (this._groupCreatedWindowCtrl != null)
            {
                this._groupCreatedWindowCtrl.dispose();
                this._groupCreatedWindowCtrl = null;
            }
            if (this._groupRoomInfoCtrl != null)
            {
                this._groupRoomInfoCtrl.dispose();
                this._groupRoomInfoCtrl = null;
            }
            super.dispose();
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "group/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length != 2)
            {
                return;
            }
            var _local_3= ASCompat.toInt(_local_2[1]);
            this.openGroupInfo(_local_3);
        }

        public function showGroupBadgeInfo(k:Bool, _arg_2:Int)
        {
            this.openGroupInfo(_arg_2);
            this.send(new EventLogMessageComposer(HABBOGROUPS, ("" + Std.string(_arg_2)), "badge clicked"));
        }

        public function openGroupInfo(k:Int)
        {
            this.send(new GetHabboGroupDetailsMessageComposer(k, true));
        }

        public function send(k:IMessageComposer)
        {
            this._communication.connection.send(k);
        }

        public function getXmlWindow(k:String):IWindow
        {
            var _local_3:IAsset = null;
            var _local_4:XmlAsset = null;
            var _local_2:IWindow = null;
            try
            {
                _local_3 = assets.getAssetByName(k);
                _local_4 = cast(_local_3, XmlAsset);
                _local_2 = this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_4.content));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return _local_2;
        }

        public function getButtonImage(k:String):BitmapData
        {
            var _local_2= k;
            var _local_3= assets.getAssetByName(_local_2);
            var _local_4= cast(_local_3, BitmapDataAsset);
            var _local_5= cast(_local_4.content, BitmapData);
            var _local_6= new BitmapData(_local_5.width, _local_5.height, true, 0);
            _local_6.draw(_local_5);
            return _local_6;
        }

        public function openGroupForum(k:Int)
        {
            context.createLinkEvent(("groupforum/" + Std.string(k)));
        }

        function onGroupDeactivated(k:IMessageEvent)
        {
            var _local_2= cast(k, HabboGroupDeactivatedMessageEvent).groupId;
            this._detailsWindowCtrl.onGroupDeactivated(_local_2);
            this._groupRoomInfoCtrl.onGroupDeactivated(_local_2);
        }

        function onGroupDetails(k:IMessageEvent)
        {
            var _local_2= cast(k, HabboGroupDetailsMessageEvent).data;
            this._detailsWindowCtrl.onGroupDetails(_local_2);
            this._extendedProfileWindowCtrl.onGroupDetails(_local_2);
            this._groupRoomInfoCtrl.onGroupDetails(_local_2);
        }

        function onExtendedProfile(k:IMessageEvent)
        {
            var _local_2= cast(k, ExtendedProfileMessageEvent).data;
            if (_local_2.openProfileWindow)
            {
                this._extendedProfileWindowCtrl._Str_12511 = true;
                this._extendedProfileWindowCtrl._Str_12870 = true;
                this._extendedProfileWindowCtrl._Str_18339(_local_2);
            }
        }

        function onExtendedProfileChanged(k:IMessageEvent)
        {
            var _local_2= cast(k, ExtendedProfileChangedMessageEvent).userId;
            this._extendedProfileWindowCtrl._Str_24312(_local_2);
        }

        function onGroupDetailsChanged(k:IMessageEvent)
        {
            var _local_2= cast(k, GroupDetailsChangedMessageEvent).groupId;
            if ((this._detailsWindowCtrl._Str_18808(_local_2) || this._groupRoomInfoCtrl._Str_18808(_local_2)))
            {
                this.send(new GetHabboGroupDetailsMessageComposer(_local_2, false));
            }
        }

        function onJoinFailed(k:IMessageEvent)
        {
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_2= cast(k, HabboGroupJoinFailedMessageEvent).reason;
            if (_local_2 == HabboGroupJoinFailedMessageParser.INSUFFICIENT_SUBSCRIPTION_LEVEL)
            {
                this._hcRequiredWindowCtrl.show(false);
            }
            else
            {
                _local_3 = ("group.joinfail." + Std.string(_local_2));
                _local_4 = this._localization.getLocalization(_local_3, _local_3);
                this._windowManager.alert("${group.joinfail.title}", _local_4, 0, this.onAlertClose);
            }
        }

        function onGuildCreationInfo(k:IMessageEvent)
        {
            var _local_2= cast(k, GuildCreationInfoMessageEvent).data;
            this._guildManagementWindowCtrl.onGuildCreationInfo(_local_2);
            this.requestGuildEditorData();
        }

        function onGuildEditInfo(k:IMessageEvent)
        {
            var _local_2= cast(k, GuildEditInfoMessageEvent).data;
            this._guildManagementWindowCtrl.onGuildEditInfo(_local_2);
            this.requestGuildEditorData();
        }

        function onRoomLeave(k:IMessageEvent)
        {
            this._detailsWindowCtrl.close();
            this._groupRoomInfoCtrl.close();
        }

        function onRoomEnter(k:IMessageEvent)
        {
            this._detailsWindowCtrl.close();
            this._groupRoomInfoCtrl.close();
            var _local_2= cast(k, RoomEntryInfoMessageEvent).getParser();
            this._roomId = _local_2.guestRoomId;
        }

        function onAlertClose(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        function onGuildEditorData(k:IMessageEvent)
        {
            this._guildEditorData = cast(k, GuildEditorDataMessageEvent).data;
            events.dispatchEvent(new HabboGroupsEditorData());
        }

        function onGuildEditFailed(k:IMessageEvent)
        {
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_2= cast(k, GuildEditFailedMessageEvent).reason;
            if (_local_2 == GuildEditFailedMessageParser.INSUFFICIENT_SUBSCRIPTION_LEVEL)
            {
                this._hcRequiredWindowCtrl.show(true);
            }
            else
            {
                _local_3 = ("group.edit.fail." + Std.string(_local_2));
                _local_4 = this._localization.getLocalization(_local_3, _local_3);
                this._windowManager.alert("${group.edit.fail.title}", _local_4, 0, this.onAlertClose);
            }
        }

        function onUserObject(k:IMessageEvent)
        {
            var _local_2= cast(k, UserObjectEvent).getParser();
            this._avatarId = _local_2.id;
        }

        function onFlatCreated(k:IMessageEvent)
        {
            var _local_2= cast(k, FlatCreatedEvent).getParser();
            this._guildManagementWindowCtrl.onFlatCreated(_local_2.flatId, _local_2._Str_18439);
        }

        function onGuildCreated(k:IMessageEvent)
        {
            var _local_2= cast(k, GuildCreatedMessageEvent);
            this._groupCreatedWindowCtrl.show(_local_2.groupId);
            this._guildManagementWindowCtrl.close();
            this._groupRoomInfoCtrl._Str_21514 = _local_2.groupId;
            if (this._roomId != _local_2.baseRoomId)
            {
                this._navigator.goToPrivateRoom(_local_2.baseRoomId);
            }
        }

        function onKickConfirmation(k:IMessageEvent)
        {
            var _local_2= cast(k, GuildMemberFurniCountInHQMessageEvent).userId();
            var _local_3= cast(k, GuildMemberFurniCountInHQMessageEvent).furniCount();
            var _local_4:MemberData = null;
            var _local_5= this._guildMembersWindowCtrl.data;
            var _local_6= (this._kickData._Str_21067 ? "group.block" : "group.kick");
            if (_local_3 > 0)
            {
                if (_local_2 == this._avatarId)
                {
                    this.localization.registerParameter("group.leaveconfirm.desc", "amount", Std.string(_local_3));
                    this._windowManager.confirm("${group.leaveconfirm.title}", "${group.leaveconfirm.desc}", 0, this.onKickConfirmationClose);
                }
                else
                {
                    _local_4 = _local_5.getUser(_local_2);
                    this.localization.registerParameter((_local_6 + "confirm.desc"), "amount", Std.string(_local_3));
                    this.localization.registerParameter((_local_6 + "confirm.desc"), "user", _local_4.userName);
                    this._windowManager.confirm((("${" + _local_6) + "confirm.title}"), (("${" + _local_6) + "confirm.desc}"), 0, this.onKickConfirmationClose);
                }
            }
            else
            {
                if (_local_2 == this._avatarId)
                {
                    this._windowManager.confirm("${group.leaveconfirm.title}", "${group.leaveconfirm_nofurni.desc}", 0, this.onKickConfirmationClose);
                }
                else
                {
                    if (_local_5 != null)
                    {
                        _local_4 = _local_5.getUser(_local_2);
                        this.localization.registerParameter((_local_6 + "confirm_nofurni.desc"), "user", _local_4.userName);
                        this._windowManager.confirm((("${" + _local_6) + "confirm.title}"), (("${" + _local_6) + "confirm_nofurni.desc}"), 0, this.onKickConfirmationClose);
                    }
                }
            }
        }

        function onKickConfirmationClose(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            if ((((k == null) || k.disposed) || (this._kickData == null)))
            {
                this._kickData = null;
                return;
            }
            k.dispose();
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this.send(new KickMemberMessageComposer(this._kickData._Str_23057, this._kickData._Str_25813, this._kickData._Str_21067));
            }
            this._kickData = null;
        }

        function onSubscriptionInfo(k:IMessageEvent)
        {
            var _local_2= cast(k, ScrSendUserInfoEvent).getParser();
            this._hasVip = (_local_2.isVIP && (_local_2.minutesUntilExpiration > 0));
            this._guildManagementWindowCtrl.onSubscriptionChange();
        }

        function onRoomInfo(k:IMessageEvent)
        {
            var _local_2= cast(k, GetGuestRoomResultEvent).getParser();
            if (_local_2._Str_15487)
            {
                this._groupRoomInfoCtrl.onRoomInfo(_local_2.data);
            }
        }

        function onRelationshipStatusInfo(k:IMessageEvent)
        {
            var _local_2= cast(k, RelationshipStatusInfoEvent);
            this._extendedProfileWindowCtrl.onRelationshipStatusInfo(_local_2.userId, _local_2.relationshipStatusMap);
        }

        function onUserBadgesMessage(k:UserBadgesEvent)
        {
            this._extendedProfileWindowCtrl.onUserBadges(k.userId, k.badges);
        }

        function requestGuildEditorData()
        {
            if (this._guildEditorData == null)
            {
                this.send(new GetGuildEditorDataMessageComposer());
            }
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var guildManagementWindowCtrl(get,never):GuildManagementWindowCtrl;
public function  get_guildManagementWindowCtrl():GuildManagementWindowCtrl
        {
            return this._guildManagementWindowCtrl;
        }

        public var groupRoomInfoCtrl(get,never):GroupRoomInfoCtrl;
public function  get_groupRoomInfoCtrl():GroupRoomInfoCtrl
        {
            return this._groupRoomInfoCtrl;
        }

        public var groupRoomInfoEnabled(get,never):Bool;
public function  get_groupRoomInfoEnabled():Bool
        {
            return getBoolean("groupRoomInfo.enabled");
        }

        public var groupDeletionEnabled(get,never):Bool;
public function  get_groupDeletionEnabled():Bool
        {
            return getBoolean("group.deletion.enabled");
        }

        public var groupRoomInfoBadgeEnabled(get,never):Bool;
public function  get_groupRoomInfoBadgeEnabled():Bool
        {
            return this.groupRoomInfoEnabled && getBoolean("groupRoomInfo.badge.enabled");
        }

        public var toolbarAttachEnabled(get,never):Bool;
public function  get_toolbarAttachEnabled():Bool
        {
            return this.groupRoomInfoEnabled && getBoolean("groupRoomInfo.attach.enabled");
        }

        public var isActivityDisplayEnabled(get,never):Bool;
public function  get_isActivityDisplayEnabled():Bool
        {
            return getBoolean("activity.point.display.enabled");
        }

        public var guildEditorData(get,never):GuildEditorData;
public function  get_guildEditorData():GuildEditorData
        {
            return this._guildEditorData;
        }

        public var avatarId(get,never):Int;
public function  get_avatarId():Int
        {
            return this._avatarId;
        }

        public var navigator(get,never):IHabboNavigator;
public function  get_navigator():IHabboNavigator
        {
            return this._newNavigator.legacyNavigator;
        }

        public var friendlist(get,never):IHabboFriendsList;
public function  get_friendlist():IHabboFriendsList
        {
            return this._friendlist;
        }

        public var guildMembersWindowCtrl(get,never):GuildMembersWindowCtrl;
public function  get_guildMembersWindowCtrl():GuildMembersWindowCtrl
        {
            return this._guildMembersWindowCtrl;
        }

        public var habboTracking(get,never):IHabboTracking;
public function  get_habboTracking():IHabboTracking
        {
            return this._habboTracking;
        }

        public function trackGoogle(k:String, _arg_2:String, _arg_3:Int=-1)
        {
            if (this._habboTracking != null)
            {
                this._habboTracking.trackGoogle(k, _arg_2, _arg_3);
            }
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }

        public function updateVisibleExtendedProfile(k:Int)
        {
            this._extendedProfileWindowCtrl.updateVisibleExtendedProfile(k);
        }

        public function showExtendedProfile(k:Int)
        {
            this.send(new GetExtendedProfileMessageComposer(k));
        }

        public function openCatalog(k:String)
        {
            this._catalog.openCatalogPage(k);
        }

        public function openVipPurchase(k:String)
        {
            this._catalog.openClubCenter();
        }

        public var hasVip(get,never):Bool;
public function  get_hasVip():Bool
        {
            return this._hasVip;
        }

        public function handleUserKick(k:Int, _arg_2:Int)
        {
            this._kickData = new GuildKickData(k, _arg_2);
            this.send(new GetMemberGuildItemCountMessageComposer(_arg_2, k));
        }

        public function handleUserBlock(k:Int, _arg_2:Int)
        {
            this._kickData = new GuildKickData(k, _arg_2, true);
            this.send(new GetMemberGuildItemCountMessageComposer(_arg_2, k));
        }

        public var newNavigator(get,never):IHabboNewNavigator;
public function  get_newNavigator():IHabboNewNavigator
        {
            return this._newNavigator;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }
    }

