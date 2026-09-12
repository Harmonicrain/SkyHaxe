package com.sulake.habbo.friendbar.data
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.messenger.IHabboMessenger;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboFriendList;
    import com.sulake.iid.IIDHabboMessenger;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendRequestsEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FindFriendsProcessResultEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.RoomInviteEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListFragmentMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.game.lobby.GameInviteMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.MessengerInitEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.NewFriendRequestEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendNotificationEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.NewConsoleMessageEvent;
    import com.sulake.habbo.friendlist.events._Str_2948;
    import com.sulake.habbo.friendbar.events.FriendBarUpdateEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileByNameMessageComposer;
    import com.sulake.habbo.friendbar.events.FriendRequestUpdateEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.VisitUserMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.friendbar.events.NewMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.FindNewFriendsMessageComposer;
    import com.sulake.habbo.friendlist._Str_2777;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.utils._Str_3942;
    import com.sulake.habbo.messenger.events.ActiveConversationEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendParser;
    import com.sulake.habbo.friendbar.events.FindFriendsNotificationEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendRequestData;
    import com.sulake.habbo.friendbar.events.ActiveConversationsCountEvent;
    import com.sulake.habbo.gamecenter.GameConfigurations;
    import com.sulake.habbo.friendbar.events.NotificationEvent;

     class HabboFriendBarData extends Component implements IHabboFriendBarData 
    {
        static inline final SHOW_OFFLINE_FRIENDS= false;
        static inline final SORT_ALPHABETICALLY= false;
        static inline final TRACKING_EVENT_CATEGORY= "Navigation";
        static inline final TRACKING_EVENT_TYPE= "Friend Bar";
        static inline final TRACKING_EVENT_ACTION_VISIT= "go.friendbar";
        static inline final TRACKING_EVENT_ACTION_CHAT= "chat_btn_click";
        static inline final TRACKING_EVENT_ACTION_FIND_FRIENDS= "find_friends_btn_click";
		
        public static inline final PLAY_SNOWSTORM_TAB_CLICK= "play_snowstorm_tab_click";
        public static inline final PLAY_SNOWSTORM_BTN_CLICK= "play_snowstorm_btn_click";
		
        static inline final LEGACY_TRACKING_EVENT_CATEGORY= "Toolbar";
        static inline final LEGACY_TRACKING_EVENT_ACTION_OPEN= "open";
        static inline final LEGACY_TRACKING_EVENT_ACTION_CLOSE= "close";
        static inline final LEGACY_TRACKING_EVENT_TYPE_FRIENDLIST= "FRIENDLIST";
        static inline final LEGACY_TRACKING_EVENT_TYPE_MESSENGER= "MESSENGER";

        var _habboCommunicationManager:IHabboCommunicationManager;
        var _habboFriendListComponent:IHabboFriendsList;
        var _habboMessengerComponent:IHabboMessenger;
        var _tracking:IHabboTracking;
        var _friendEntityList:Array<ASAny>;
        var _friendMappedByID:Map;
        var _friendRequests:Array<ASAny>;
        var _lastMessageSenderId:Int = 0;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._friendEntityList = [];
            this._friendMappedByID = new Map();
            this._friendRequests = [];
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboConfigurationManager(), null), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _habboCommunicationManager = k;
            }), new ComponentDependency(new IIDHabboFriendList(), function (k:IHabboFriendsList)
            {
                _habboFriendListComponent = k;
            }), new ComponentDependency(new IIDHabboMessenger(), function (k:IHabboMessenger)
            {
                _habboMessengerComponent = k;
            }), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _tracking = k;
            })]));
        }

        override function initComponent()
        {
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new FriendListUpdateEvent(this.onFriendListUpdate));
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new FriendRequestsEvent(this._Str_22480));
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new FindFriendsProcessResultEvent(this._Str_24044));
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new RoomInviteEvent(this.onRoomInvite));
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new FriendListFragmentMessageEvent(this.onFriendsListFragment));
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new GameInviteMessageEvent(this.onGameInvite));
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new MessengerInitEvent(this._Str_24730));
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new NewFriendRequestEvent(this._Str_16886));
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new FriendNotificationEvent(this.onFriendNotification));
            this._habboCommunicationManager.addHabboConnectionMessageEvent(new NewConsoleMessageEvent(this.onNewConsoleMessage));
            this._habboFriendListComponent.events.addEventListener(_Str_2948.FRE_ACCEPTED, this._Str_14893);
            this._habboFriendListComponent.events.addEventListener(_Str_2948.FRE_DECLINED, this._Str_14893);
        }

        override public function dispose()
        {
            if (!disposed)
            {
                if (((!(this._habboFriendListComponent == null)) && (!this._habboFriendListComponent.disposed)))
                {
                    this._habboFriendListComponent.events.removeEventListener(_Str_2948.FRE_ACCEPTED, this._Str_14893);
                    this._habboFriendListComponent.events.removeEventListener(_Str_2948.FRE_DECLINED, this._Str_14893);
                }
                this._friendEntityList = null;
                this._friendMappedByID.dispose();
                this._friendMappedByID = null;
                this._friendRequests = null;
                super.dispose();
            }
        }

        public var numFriends(get,never):Int;
public function  get_numFriends():Int
        {
            return this._friendEntityList.length;
        }

        public function getFriendAt(k:Int):IFriendEntity
        {
            return this._friendEntityList[k];
        }

        public function getFriendByID(k:Int):IFriendEntity
        {
            return this._friendMappedByID.getValue(k);
        }

        public function getFriendByName(k:String):IFriendEntity
        {
            var _local_2:FriendEntity = null;
            final _iter_ = this._friendEntityList; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.name == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function setFriendAt(k:IFriendEntity, _arg_2:Int)
        {
            var _local_3= this._friendEntityList.indexOf(k);
            if (((_local_3 > -1) && (!(_local_3 == _arg_2))))
            {
                this._friendEntityList.splice(_local_3, 1);
                this._friendEntityList.insert(_arg_2, k);
                events.dispatchEvent(new FriendBarUpdateEvent());
            }
        }

        public var numFriendRequests(get,never):Int;
public function  get_numFriendRequests():Int
        {
            return (this._friendRequests != null) ? this._friendRequests.length : 0;
        }

        public function getFriendRequestAt(k:Int):IFriendRequest
        {
            return (this._friendRequests != null) ? this._friendRequests[k] : null;
        }

        public function getFriendRequestByID(k:Int):IFriendRequest
        {
            var _local_2:IFriendRequest = null;
            if (this._friendRequests != null)
            {
                final _iter_ = this._friendRequests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.id == k)
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }

        public function getFriendRequestByName(k:String):IFriendRequest
        {
            var _local_2:IFriendRequest = null;
            if (this._friendRequests != null)
            {
                final _iter_ = this._friendRequests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.name == k)
                    {
                        return _local_2;
                    }
                }
            }
            return null;
        }

        public function getFriendRequestList():Array<ASAny>
        {
            return this._friendRequests;
        }

        public function acceptFriendRequest(k:Int)
        {
            this._Str_15774(k);
            if (this._habboFriendListComponent != null)
            {
                if (!this._habboFriendListComponent.disposed)
                {
                    this._habboFriendListComponent.acceptFriendRequest(k);
                }
            }
        }

        public function showProfile(k:Int)
        {
            if (this._habboCommunicationManager != null)
            {
                if (k > 0)
                {
                    this._habboCommunicationManager.connection.send(new GetExtendedProfileMessageComposer(k));
                }
                else
                {
                    this._habboCommunicationManager.connection.send(new GetHabboGroupDetailsMessageComposer(Std.int(Math.abs(k)), true));
                }
            }
        }

        public function showProfileByName(k:String)
        {
            if (this._habboCommunicationManager != null)
            {
                this._habboCommunicationManager.connection.send(new GetExtendedProfileByNameMessageComposer(k));
            }
        }

        public function acceptAllFriendRequests()
        {
            this._friendRequests = [];
            this._habboFriendListComponent.acceptAllFriendRequests();
            events.dispatchEvent(new FriendRequestUpdateEvent());
        }

        public function declineFriendRequest(k:Int)
        {
            this._Str_15774(k);
            if (this._habboFriendListComponent != null)
            {
                if (!this._habboFriendListComponent.disposed)
                {
                    this._habboFriendListComponent.declineFriendRequest(k);
                }
            }
        }

        public function declineAllFriendRequests()
        {
            this._friendRequests = [];
            this._habboFriendListComponent.declineAllFriendRequests();
            events.dispatchEvent(new FriendRequestUpdateEvent());
        }

        function _Str_15774(k:Int)
        {
            var _local_2:FriendRequest = null;
            if (this._friendRequests != null)
            {
                final _iter_ = this._friendRequests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.id == k)
                    {
                        this._friendRequests.splice(this._friendRequests.indexOf(_local_2), 1);
                        events.dispatchEvent(new FriendRequestUpdateEvent());
                        return;
                    }
                }
            }
        }

        public function followToRoom(k:Int)
        {
            if (this._habboCommunicationManager != null)
            {
                this._habboCommunicationManager.connection.send(new VisitUserMessageComposer(k));
                this._habboCommunicationManager.connection.send(new EventLogMessageComposer(TRACKING_EVENT_CATEGORY, TRACKING_EVENT_TYPE, TRACKING_EVENT_ACTION_VISIT));
            }
        }

        public function startConversation(k:Int)
        {
            if (this._habboMessengerComponent != null)
            {
                this._habboMessengerComponent.startConversation(k);
                events.dispatchEvent(new NewMessageEvent(false, k));
                if (this._habboCommunicationManager != null)
                {
                    this._habboCommunicationManager.connection.send(new EventLogMessageComposer(TRACKING_EVENT_CATEGORY, TRACKING_EVENT_TYPE, TRACKING_EVENT_ACTION_CHAT));
                }
            }
        }

        public function findNewFriends()
        {
            if (this._habboCommunicationManager != null)
            {
                this._habboCommunicationManager.connection.send(new FindNewFriendsMessageComposer());
                this._habboCommunicationManager.connection.send(new EventLogMessageComposer(TRACKING_EVENT_CATEGORY, TRACKING_EVENT_TYPE, TRACKING_EVENT_ACTION_FIND_FRIENDS));
            }
        }
		
		public function sendGameTabTracking(k:String)
        {
            this.gameTabEvent(PLAY_SNOWSTORM_TAB_CLICK, k);
        }

        public function sendGameButtonTracking(k:String)
        {
            this.gameTabEvent(PLAY_SNOWSTORM_BTN_CLICK, k);
        }
		
		function gameTabEvent(k:String, _arg_2:String)
        {
            if (this._habboCommunicationManager != null)
            {
                this._habboCommunicationManager.connection.send(new EventLogMessageComposer(TRACKING_EVENT_CATEGORY, TRACKING_EVENT_TYPE, k, _arg_2, this.numFriends));
            }
        }

        public function openUserTextSearch()
        {
            if (this._habboFriendListComponent.currentTabId() != _Str_2777._Str_5722)
            {
                this._habboFriendListComponent.openFriendSearch();
            }
            else
            {
                this._habboFriendListComponent.close();
            }
        }

        function _Str_26269(k:String, _arg_2:String)
        {
            if (this._habboCommunicationManager != null)
            {
                this._habboCommunicationManager.connection.send(new EventLogMessageComposer(TRACKING_EVENT_CATEGORY, TRACKING_EVENT_TYPE, k, _arg_2, this.numFriends));
            }
        }

        public function toggleFriendList()
        {
            var _local_1:IWindowContainer = null;
            if (this._habboFriendListComponent != null)
            {
                if (!this._habboFriendListComponent.disposed)
                {
                    if (!this._habboFriendListComponent.isOpen())
                    {
                        if (this._friendRequests.length > 0)
                        {
                            this._habboFriendListComponent.openFriendRequests();
                        }
                        else
                        {
                            this._habboFriendListComponent.openFriendList();
                        }
                    }
                    else
                    {
                        _local_1 = this._habboFriendListComponent.mainWindow;
                        if (((!(_local_1 == null)) && _Str_3942._Str_9211(_local_1)))
                        {
                            _local_1.activate();
                            return;
                        }
                        this._habboFriendListComponent.close();
                    }
                    if (this._habboCommunicationManager != null)
                    {
                        this._habboCommunicationManager.connection.send(new EventLogMessageComposer(LEGACY_TRACKING_EVENT_CATEGORY, LEGACY_TRACKING_EVENT_TYPE_FRIENDLIST, (this._habboFriendListComponent.isOpen() ? LEGACY_TRACKING_EVENT_ACTION_OPEN : LEGACY_TRACKING_EVENT_ACTION_CLOSE)));
                    }
                }
            }
        }

        public function toggleMessenger()
        {
            if (this._habboMessengerComponent != null)
            {
                if (!this._habboMessengerComponent.disposed)
                {
                    this._habboMessengerComponent.toggleMessenger();
                    if (this._habboCommunicationManager != null)
                    {
                        this._habboCommunicationManager.connection.send(new EventLogMessageComposer(LEGACY_TRACKING_EVENT_CATEGORY, LEGACY_TRACKING_EVENT_TYPE_MESSENGER, (this._habboMessengerComponent.isOpen() ? LEGACY_TRACKING_EVENT_ACTION_OPEN : LEGACY_TRACKING_EVENT_ACTION_CLOSE)));
                    }
                }
            }
        }

        function _Str_24730(k:IMessageEvent)
        {
            if (this._habboMessengerComponent != null)
            {
                this._habboMessengerComponent.events.addEventListener(ActiveConversationEvent.ACCE_CHANGED, this._Str_24647);
            }
        }

        function onFriendsListFragment(k:IMessageEvent)
        {
            this._Str_25150(cast(k, FriendListFragmentMessageEvent).getParser().friendFragment);
        }

        function onFriendListUpdate(k:IMessageEvent)
        {
            var _local_3:FriendEntity = null;
            var _local_4:FriendParser = null;
            var _local_8 = 0;
            var _local_2= cast(k, FriendListUpdateEvent).getParser();
            var _local_5= _local_2.removedFriendIds;
            var _local_6= _local_2.updatedFriends;
            var _local_7= _local_2.addedFriends;
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_8  = ASCompat.toInt(_tmp_);
                _local_3 = this._friendMappedByID.getValue(_local_8);
                if (_local_3 != null)
                {
                    this._friendMappedByID.remove(_local_8);
                    this._friendEntityList.splice(this._friendEntityList.indexOf(_local_3), 1);
                    this._habboMessengerComponent.closeConversation(_local_8);
                }
            }
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_4  = _tmp_;
                _local_3 = this._friendMappedByID.getValue(_local_4.id);
                if (_local_3 != null)
                {
                    if ((_local_4.online || SHOW_OFFLINE_FRIENDS))
                    {
                        _local_3.name = _local_4.name;
                        _local_3.realName = _local_4.realName;
                        _local_3.motto = _local_4.motto;
                        _local_3.gender = _local_4.gender;
                        _local_3.online = _local_4.online;
                        _local_3.allowFollow = _local_4.followingAllowed;
                        _local_3.figure = _local_4.figure;
                        _local_3.categoryId = _local_4.categoryId;
                        _local_3.lastAccess = _local_4.lastAccess;
                    }
                    else
                    {
                        this._friendMappedByID.remove(_local_4.id);
                        this._friendEntityList.splice(this._friendEntityList.indexOf(_local_3), 1);
                    }
                }
                else
                {
                    if ((_local_4.online || SHOW_OFFLINE_FRIENDS))
                    {
                        _local_3 = new FriendEntity(_local_4.id, _local_4.name, _local_4.realName, _local_4.motto, _local_4.gender, _local_4.online, _local_4.followingAllowed, _local_4.figure, _local_4.categoryId, _local_4.lastAccess);
                        this._friendEntityList.insert(0, _local_3);
                        this._friendMappedByID.add(_local_3.id, _local_3);
                    }
                }
            }
            if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
            {
_local_4  = _tmp_;
                if ((_local_4.online || SHOW_OFFLINE_FRIENDS))
                {
                    if (this._friendMappedByID.getValue(_local_4.id) == null)
                    {
                        _local_3 = new FriendEntity(_local_4.id, _local_4.name, _local_4.realName, _local_4.motto, _local_4.gender, _local_4.online, _local_4.followingAllowed, _local_4.figure, _local_4.categoryId, _local_4.lastAccess);
                        this._friendEntityList.push(_local_3);
                        this._friendMappedByID.add(_local_3.id, _local_3);
                    }
                }
                this._Str_15774(_local_4.id);
            }
            if (((_local_7.length > 0) || (_local_6.length > 0)))
            {
                this._friendEntityList = (SHOW_OFFLINE_FRIENDS ? this._Str_19624(this._friendEntityList) : this._Str_21818(this._friendEntityList));
            }
            events.dispatchEvent(new FriendBarUpdateEvent());
        }

        function _Str_24044(k:FindFriendsProcessResultEvent)
        {
            events.dispatchEvent(new FindFriendsNotificationEvent(k.success));
        }

        function _Str_16886(k:NewFriendRequestEvent)
        {
            var _local_2:FriendRequestData = null;
            if (this.showFriendRequests)
            {
                _local_2 = k.getParser().req;
                this._friendRequests.push(new FriendRequest(_local_2.requestId, _local_2.requesterName, _local_2.figureString));
                events.dispatchEvent(new FriendRequestUpdateEvent());
            }
        }

        function _Str_22480(k:FriendRequestsEvent)
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:FriendRequestData = null;
            if (this.showFriendRequests)
            {
                _local_2 = k.getParser()._Str_17539;
                if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                {
_local_3  = _tmp_;
                    this._friendRequests.push(new FriendRequest(_local_3.requestId, _local_3.requesterName, _local_3.figureString));
                }
                events.dispatchEvent(new FriendRequestUpdateEvent());
            }
        }

        function _Str_14893(k:_Str_2948)
        {
            this._Str_15774(k.requestId);
        }

        function onNewConsoleMessage(k:NewConsoleMessageEvent)
        {
            var _local_2= k.getParser();
            this._lastMessageSenderId = _local_2.senderId;
            var _local_3= true;
            if (this._habboMessengerComponent != null)
            {
                if (this._habboMessengerComponent.isOpen())
                {
                    _local_3 = false;
                }
            }
            if (this._habboFriendListComponent.hasfriendsListInitialized)
            {
                events.dispatchEvent(new NewMessageEvent(_local_3, this._lastMessageSenderId));
            }
            if (_local_3)
            {
                this.makeNotification(Std.string(this._lastMessageSenderId), FriendNotification.TYPE_MESSENGER, null, false, false);
            }
        }

        function _Str_24647(k:ActiveConversationEvent)
        {
            events.dispatchEvent(new ActiveConversationsCountEvent(k._Str_18689));
        }

        function onRoomInvite(k:RoomInviteEvent)
        {
            var _local_2= k.getParser();
            this._lastMessageSenderId = _local_2.senderId;
            if (((this._habboMessengerComponent != null) && (!this._habboMessengerComponent.isOpen())))
            {
                events.dispatchEvent(new NewMessageEvent(true, this._lastMessageSenderId));
                this.makeNotification(Std.string(this._lastMessageSenderId), FriendNotification.TYPE_MESSENGER, null, true, false);
            }
        }

        function onGameInvite(k:GameInviteMessageEvent)
        {
            var _local_2= k.getParser();
            var _local_3= GameConfigurations.getNameId(_local_2.gameTypeId);
            if (ASCompat.stringAsBool(_local_3))
            {
                this.makeNotification(Std.string(_local_2.inviterId), FriendNotification.TYPE_GAME_INVITE, _local_3, false, true);
            }
        }

        function onFriendNotification(k:FriendNotificationEvent)
        {
            var _local_2= k.getParser();
            var _local_3:ASAny = (!(_local_2.typeCode == FriendNotification.TYPE_PLAYING_GAME));
            var _local_4:ASAny = (!(_local_2.typeCode == FriendNotification.TYPE_FINISHED_GAME));
            var _local_5:ASAny = (!(_local_2.typeCode == FriendNotification.TYPE_PLAYING_GAME));
            this.makeNotification(_local_2.avatarId, _local_2.typeCode, _local_2.message, _local_3, _local_4, _local_5);
        }

        function makeNotification(k:String, _arg_2:Int, _arg_3:String, _arg_4:Bool, _arg_5:Bool, _arg_6:Bool=true)
        {
            var _local_7:IFriendEntity = null;
            var _local_8:FriendNotification = null;
            var _local_9:Vector<IFriendNotification> = null;
            if (this.showFriendNotifications)
            {
                _local_7 = this.getFriendByID(ASCompat.parseInt(k));
                if (_local_7 != null)
                {
                    _local_9 = _local_7.notifications;
                    if (checkNullIteratee(_local_9)) for (_tmp_ in _local_9)
                    {
_local_8  = cast(_tmp_, FriendNotification);
                        if (_local_8.typeCode == _arg_2)
                        {
                            _local_8.message = _arg_3;
                            _local_8.viewOnce = _arg_4;
                            break;
                        }
                        _local_8 = null;
                    }
                    if (_local_8 == null)
                    {
                        _local_8 = new FriendNotification(_arg_2, _arg_3, _arg_4);
                        _local_9.push(_local_8);
                    }
                    else
                    {
                        if (!_arg_6)
                        {
                            return;
                        }
                    }
                    events.dispatchEvent(new NotificationEvent(_local_7.id, _local_8));
                    if (_arg_5)
                    {
                        this.setFriendAt(_local_7, 0);
                    }
                    if (_local_7.logEventId < 0)
                    {
                        _local_7.logEventId = _local_7.getNextLogEventId();
                    }
                    if (this._tracking != null)
                    {
                        this._tracking.trackEventLog("FriendBar", FriendNotification.typeCodeToString(_arg_2), "notified", "", ((_local_7.logEventId > 0) ? _local_7.logEventId : 0));
                    }
                }
            }
        }

        function _Str_25150(k:Array<ASAny>)
        {
            var _local_2:FriendParser = null;
            var _local_3:FriendEntity = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                if ((_local_2.online || SHOW_OFFLINE_FRIENDS))
                {
                    _local_3 = new FriendEntity(_local_2.id, _local_2.name, _local_2.realName, _local_2.motto, _local_2.gender, _local_2.online, _local_2.followingAllowed, _local_2.figure, _local_2.categoryId, _local_2.lastAccess);
                    this._friendEntityList.push(_local_3);
                    this._friendMappedByID.add(_local_3.id, _local_3);
                }
            }
            this._friendEntityList = (SHOW_OFFLINE_FRIENDS ? this._Str_19624(this._friendEntityList) : this._Str_21818(this._friendEntityList));
            events.dispatchEvent(new FriendBarUpdateEvent());
        }

        function _Str_21818(k:Array<ASAny>):Array<ASAny>
        {
            if (SORT_ALPHABETICALLY)
            {
                ASCompat.ASArray.sortOn(k, "name", [ASCompat.ASArray.CASEINSENSITIVE]);
            }
            return k;
        }

        function _Str_19624(k:Array<ASAny>):Array<ASAny>
        {
            var _local_4:FriendEntity = null;
            var _local_2:Array<ASAny> = [];
            var _local_3:Array<ASAny> = [];
            var _local_5= k.length;
            while (_local_5-- > 0)
            {
                _local_4 = k[_local_5];
                if (_local_4.online)
                {
                    _local_2.push(_local_4);
                }
                else
                {
                    _local_3.push(_local_4);
                }
            }
            if (SORT_ALPHABETICALLY)
            {
                ASCompat.ASArray.sortOn(_local_2, "name", [ASCompat.ASArray.CASEINSENSITIVE]);
                ASCompat.ASArray.sortOn(_local_3, "name", [(ASCompat.toInt(ASCompat.ASArray.CASEINSENSITIVE )| ASCompat.toInt(ASCompat.ASArray.DESCENDING))]);
            }
            _local_5 = _local_3.length;
            while (_local_5-- > 0)
            {
                _local_2.push(_local_3.pop());
            }
            return _local_2;
        }

        public var showFriendNotifications(get,never):Bool;
public function  get_showFriendNotifications():Bool
        {
            return getBoolean("friendbar.notifications.enabled");
        }

        public var showFriendRequests(get,never):Bool;
public function  get_showFriendRequests():Bool
        {
            return getBoolean("friendbar.requests.enabled");
        }
    }

