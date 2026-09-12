package com.sulake.habbo.friendbar.groupforums
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.notifications.IHabboNotifications;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.communication.messages.parser.groupforums.ExtendedForumData;
    import flash.utils.Timer;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.iid.IIDHabboNotifications;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboSoundManager;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.communication.messages.incoming.groupforums.ForumsListMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.groupforums.GuildForumThreadsEvent;
    import com.sulake.habbo.communication.messages.incoming.groupforums.UpdateThreadMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.groupforums.UpdateMessageMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.groupforums.ThreadMessagesMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.groupforums.ForumDataMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.groupforums.PostMessageMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.groupforums.PostThreadMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.groupforums.UnreadForumsCountMessageEvent;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.GetThreadMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.GetForumsListMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.GetForumStatsMessageComposer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.GetThreadsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.GetMessagesMessageComposer;
    import com.sulake.habbo.communication.messages.parser.groupforums.MessageData;
    import com.sulake.habbo.communication.messages.parser.groupforums.GuildForumThread;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.UpdateForumSettingsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.PostMessageMessageComposer;
    import com.sulake.habbo.communication.messages.parser.groupforums.ForumData;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.ModerateThreadMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.UpdateThreadMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.ModerateMessageMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.UpdateForumReadMarkerMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.GetUnreadForumsCountMessageComposer;

     class GroupForumController extends Component implements IGroupForumController implements  ILinkEventTracker 
    {
        public static inline final FORUMS_LIST_CODE_ACTIVE= 0;
        public static inline final FORUMS_LIST_CODE_POPULAR= 1;
        public static inline final FORUMS_LIST_CODE_MY_FORUMS= 2;
        public static inline final NO_ID= -1;

        var _configurationManager:IHabboConfigurationManager;
        var _communicationManager:IHabboCommunicationManager;
        var _windowManager:IHabboWindowManager;
        var _localizationManager:IHabboLocalizationManager;
        var _help:IHabboHelp;
        var _notifications:IHabboNotifications;
        var _soundManager:IHabboSoundManager;
        var _habboTracking:IHabboTracking;
        var _mainView:GroupForumView;
        var _composeMessageView:ComposeMessageView;
        var _forumSettingsView:GroupForumViewController;
        var _requestedForumsListCode:Int = -1;
        var _requestedGroupID:Int = -1;
        var _forumData:ExtendedForumData;
        var _currentThreadID:Int = 0;
        var _lastReadMessageId:Int = 0;
        var _forumsListData:ForumsListData;
        var _threadsListData:ThreadsListData;
        var _messagesListData:MessagesListData;
        var _lastReadMessageIndexByThread:ASDictionary<ASAny,ASAny>;
        var _goToThreadID:Int = -1;
        var _goToMessageIndex:Int = 0;
        var _lastPostTime:Int = 0;
        var _unreadForumsCount:Int = 0;
        var _unreadForumsCountUpdateTimer:Timer;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._lastReadMessageIndexByThread = new ASDictionary<ASAny,ASAny>();
            this._lastPostTime = -ComposeMessageView._Str_12067;
            super(k, _arg_2, _arg_3);
        }

        
        public var _Str_10252(get,set):ComposeMessageView;
public function  get__Str_10252():ComposeMessageView
        {
            return this._composeMessageView;
        }
public function  set__Str_10252(k:ComposeMessageView):ComposeMessageView        {
            return this._composeMessageView = k;
        }

        
        public var _Str_11338(get,set):GroupForumViewController;
public function  get__Str_11338():GroupForumViewController
        {
            return this._forumSettingsView;
        }
public function  set__Str_11338(k:GroupForumViewController):GroupForumViewController        {
            return this._forumSettingsView = k;
        }

        public var notifications(get,never):IHabboNotifications;
public function  get_notifications():IHabboNotifications
        {
            return this._notifications;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var localizationManager(get,never):IHabboLocalizationManager;
public function  get_localizationManager():IHabboLocalizationManager
        {
            return this._localizationManager;
        }

        public var _Str_25668(get,never):Int;
public function  get__Str_25668():Int
        {
            return this._lastPostTime;
        }

        public var _Str_9052(get,never):Int;
public function  get__Str_9052():Int
        {
            return this._unreadForumsCount;
        }

        public var tracking(get,never):IHabboTracking;
public function  get_tracking():IHabboTracking
        {
            return this._habboTracking;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboConfigurationManager(), function (k:IHabboConfigurationManager)
            {
                _configurationManager = k;
            }), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboHelp(), function (k:IHabboHelp)
            {
                _help = k;
            }), new ComponentDependency(new IIDHabboNotifications(), function (k:IHabboNotifications)
            {
                _notifications = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboSoundManager(), function (k:IHabboSoundManager)
            {
                _soundManager = k;
            }), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _habboTracking = k;
            }), new ComponentDependency(new IIDHabboToolbar(), null)]));
        }

        override function initComponent()
        {
            this._communicationManager.addHabboConnectionMessageEvent(new ForumsListMessageEvent(this._Str_22851));
            this._communicationManager.addHabboConnectionMessageEvent(new GuildForumThreadsEvent(this._Str_24478));
            this._communicationManager.addHabboConnectionMessageEvent(new UpdateThreadMessageEvent(this.onUpdateThread));
            this._communicationManager.addHabboConnectionMessageEvent(new UpdateMessageMessageEvent(this._parser8));
            this._communicationManager.addHabboConnectionMessageEvent(new ThreadMessagesMessageEvent(this.onThreadMessageList));
            this._communicationManager.addHabboConnectionMessageEvent(new ForumDataMessageEvent(this._Str_25702));
            this._communicationManager.addHabboConnectionMessageEvent(new PostMessageMessageEvent(this.onPostMessageMessage));
            this._communicationManager.addHabboConnectionMessageEvent(new PostThreadMessageEvent(this.onPostThreadMessage));
            this._communicationManager.addHabboConnectionMessageEvent(new UnreadForumsCountMessageEvent(this._Str_23952));
            context.addLinkEventTracker(this);
            this._Str_22401();
        }

        override public function dispose()
        {
            if (this._unreadForumsCountUpdateTimer != null)
            {
                this._unreadForumsCountUpdateTimer.stop();
                this._unreadForumsCountUpdateTimer = null;
            }
            super.dispose();
        }

        function _Str_22401()
        {
            var k= this._configurationManager.getInteger("groupforum.poll.period", (5 * 60));
            this._unreadForumsCountUpdateTimer = new Timer((k * 1000), 0);
            this._unreadForumsCountUpdateTimer.addEventListener(TimerEvent.TIMER, (this.onUnreadForumsCountUpdateTimerEvent : ASAny));
            this._unreadForumsCountUpdateTimer.start();
            this.onUnreadForumsCountUpdateTimerEvent(null);
        }

        public function openGroupForum(k:Int)
        {
            if (this._communicationManager == null)
            {
                return;
            }
            this.initForum(k);
            this.requestThreadList(k, 0);
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "groupforum/";
        }

        public function linkReceived(k:String)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            if (this._communicationManager == null)
            {
                return;
            }
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            if (_local_2[1] == "list")
            {
                if (_local_2.length == 3)
                {
                    switch (_local_2[2])
                    {
                        case "active":
                            _local_3 = FORUMS_LIST_CODE_ACTIVE;
                            
                        case "popular":
                            _local_3 = FORUMS_LIST_CODE_POPULAR;
                            
                        case "my":
                            _local_3 = FORUMS_LIST_CODE_MY_FORUMS;
                            
                        default:
                            return;
                    }
                    this._Str_12395(_local_3);
                }
            }
            else
            {
                _local_4 = ASCompat.toInt(_local_2[1]);
                if (_local_4 == 0)
                {
                    return;
                }
                this._forumsListData = null;
                if (_local_2.length == 2)
                {
                    this.openGroupForum(_local_4);
                }
                else
                {
                    _local_5 = ASCompat.toInt(_local_2[2]);
                    _local_6 = 0;
                    if (_local_2.length > 3)
                    {
                        _local_6 = ASCompat.toInt(_local_2[3]);
                    }
                    this.initForum(_local_4);
                    this._communicationManager.connection.send(new GetThreadMessageComposer(_local_4, _local_5));
                    this._Str_20033(_local_4, _local_5, _local_6);
                }
            }
        }

        public function _Str_12395(k:Int, _arg_2:Int=0)
        {
            this._Str_13365();
            this._requestedForumsListCode = k;
            this._requestedGroupID = NO_ID;
            this._communicationManager.connection.send(new GetForumsListMessageComposer(k, _arg_2, ThreadsListData.PAGE_SIZE));
        }

        function _Str_22851(k:ForumsListMessageEvent)
        {
            var _local_2= k.getParser();
            var _local_3= new ForumsListData(_local_2);
            if (((!(this._forumData == null)) && (this._lastReadMessageId > 0)))
            {
                _local_3._Str_20834(this._forumData, this._lastReadMessageId);
            }
            if (_local_3._Str_5154 == FORUMS_LIST_CODE_MY_FORUMS)
            {
                this._Str_7256(_local_3._Str_9052);
            }
            if (this._requestedForumsListCode != _local_3._Str_5154)
            {
                return;
            }
            this._forumsListData = _local_3;
            if (this._mainView == null)
            {
                this._mainView = new GroupForumView(this);
            }
            this._mainView._Str_12395(this._forumsListData);
        }

        function initForum(k:Int)
        {
            this._Str_13365();
            this._requestedForumsListCode = NO_ID;
            this._requestedGroupID = k;
            this._lastReadMessageId = 0;
            this._communicationManager.connection.send(new GetForumStatsMessageComposer(k));
        }

        function _Str_25702(k:ForumDataMessageEvent)
        {
            var _local_3:Map = null;
            var _local_4:String = null;
            var _local_2= k.getParser()._Str_22345;
            if (this._requestedGroupID != _local_2.groupId)
            {
                return;
            }
            if (!_local_2._Str_22865)
            {
                if (this._mainView != null)
                {
                    this._mainView.dispose();
                }
                this._forumData = null;
                this._requestedGroupID = 0;
                _local_3 = new Map();
                _local_4 = this.localizationManager.getLocalization("groupforum.view.error.operation_read");
                _local_3.add("message", this.localizationManager.getLocalizationWithParams(("groupforum.view.error." + _local_2._Str_24689), "", ["operation", _local_4]));
                this.notifications.showNotification("forums.error.access_denied", _local_3);
                return;
            }
            this._forumData = _local_2;
            this._lastReadMessageId = _local_2._Str_12786;
        }

        public function requestThreadList(k:Int, _arg_2:Int)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new GetThreadsMessageComposer(k, _arg_2, ThreadsListData.PAGE_SIZE));
            }
        }

        function _Str_24478(k:GuildForumThreadsEvent)
        {
            var _local_2= k.getParser();
            if (((this._forumData == null) || (!(this._forumData.groupId == _local_2.groupId))))
            {
                return;
            }
            this._threadsListData = new ThreadsListData(this._forumData._Str_18760, _local_2.startIndex, _local_2._Str_8372);
            if (this._mainView == null)
            {
                this._mainView = new GroupForumView(this);
            }
            this._mainView._Str_25219(this._forumsListData, this._forumData, this._threadsListData);
        }

        public function requestThreadMessageList(k:Int, _arg_2:Int, _arg_3:Int)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new GetMessagesMessageComposer(k, _arg_2, _arg_3, ThreadsListData.PAGE_SIZE));
            }
        }

        function onThreadMessageList(k:ThreadMessagesMessageEvent)
        {
            var _local_6:MessageData = null;
            var _local_2= k.getParser();
            if ((((this._forumData == null) || (!(this._forumData.groupId == _local_2.groupId))) || (this._threadsListData == null)))
            {
                return;
            }
            this._currentThreadID = _local_2.threadId;
            var _local_3:GuildForumThread = this._threadsListData._Str_6700[this._currentThreadID];
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_2.startIndex;
            var _local_5= _local_3.totalMessages;
            this._messagesListData = new MessagesListData(this._currentThreadID, _local_5, _local_4, _local_2.messages);
            if (this._mainView == null)
            {
                this._mainView = new GroupForumView(this);
            }
            this._mainView._Str_24648(this._forumsListData, this._forumData, this._threadsListData, this._messagesListData);
            if (_local_2.messages.length > 0)
            {
                _local_6 = cast(_local_2.messages[(_local_2.messages.length - 1)], MessageData);
                if (_local_6 != null)
                {
                    this._Str_20284(_local_6.messageId, _local_6.threadId, _local_6.messageIndex);
                }
            }
        }

        public function updateForumSettings(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new UpdateForumSettingsMessageComposer(k, _arg_2, _arg_3, _arg_4, _arg_5));
            }
        }

        public function _Str_23775(k:Int, _arg_2:String, _arg_3:String)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new PostMessageMessageComposer(k, 0, _arg_2, _arg_3));
                this._lastPostTime = flash.Lib.getTimer();
            }
        }

        function onPostThreadMessage(k:PostThreadMessageEvent)
        {
            var _local_3:ForumData = null;
            var _local_2= k.getParser();
            if (this._composeMessageView != null)
            {
                this._composeMessageView.dispose();
            }
            if (((!(this._forumData == null)) && (this._forumData.groupId == _local_2.groupId)))
            {
                this._Str_20284(_local_2.thread._Str_10610, _local_2.thread.threadId, (_local_2.thread.totalMessages - 1));
            }
            if (this._forumsListData != null)
            {
                _local_3 = this._forumsListData._Str_20077(_local_2.groupId);
                if (_local_3 != null)
                {
                    _local_3._Str_23783(_local_2.thread);
                }
            }
            if (this._mainView == null)
            {
                return;
            }
            if (((this._forumData == null) || (!(_local_2.groupId == this._forumData.groupId))))
            {
                return;
            }
            this.requestThreadList(this._forumData.groupId, 0);
        }

        public function _Str_24484(k:Int, _arg_2:Int, _arg_3:String)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new PostMessageMessageComposer(k, _arg_2, "", _arg_3));
                this._lastPostTime = flash.Lib.getTimer();
            }
        }

        function onPostMessageMessage(k:PostMessageMessageEvent)
        {
            if (this._composeMessageView != null)
            {
                this._composeMessageView.dispose();
            }
            if (this._mainView == null)
            {
                return;
            }
            var _local_2= k.getParser();
            if ((((this._forumData == null) || (!(_local_2.groupId == this._forumData.groupId))) || (!(_local_2.threadId == this._currentThreadID))))
            {
                return;
            }
            var _local_3= (_local_2.message.messageIndex - (_local_2.message.messageIndex % ThreadsListData.PAGE_SIZE));
            this.requestThreadMessageList(this._forumData.groupId, this._currentThreadID, _local_3);
        }

        public function _Str_24351(k:ExtendedForumData, _arg_2:Int)
        {
            var _local_3 = 0;
            if (this._communicationManager != null)
            {
                if (k._Str_7246)
                {
                    _local_3 = ForumModerationState._Str_5466;
                }
                if (k._Str_7449)
                {
                    _local_3 = ForumModerationState._Str_4415;
                }
                this._communicationManager.connection.send(new ModerateThreadMessageComposer(k.groupId, _arg_2, _local_3));
            }
        }

        public function unDeleteThread(k:ForumData, _arg_2:Int)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new ModerateThreadMessageComposer(k.groupId, _arg_2, 1));
            }
        }

        public function _Str_24793(k:ForumData, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new UpdateThreadMessageComposer(k.groupId, _arg_2, _arg_3, _arg_4));
            }
        }

        public function _Str_22439(k:ForumData, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new UpdateThreadMessageComposer(k.groupId, _arg_2, _arg_3, _arg_4));
            }
        }

        public function reportThread(k:ForumData, _arg_2:Int)
        {
            if (this._help != null)
            {
                this._help.reportThread(k.groupId, _arg_2);
            }
        }

        function onUpdateThread(k:UpdateThreadMessageEvent)
        {
            var _local_2= k.getParser();
            if (((this._forumData == null) || (!(this._forumData.groupId == _local_2.groupId))))
            {
                return;
            }
            var _local_3= _local_2.thread;
            if (((this._threadsListData != null) && (this._mainView != null)))
            {
                if (this._threadsListData._Str_16120(_local_3))
                {
                    this._mainView._Str_16120(_local_3);
                    return;
                }
            }
            this._threadsListData = new ThreadsListData(1, 0, [_local_3]);
        }

        public function deleteMessage(k:ExtendedForumData, _arg_2:Int, _arg_3:Int)
        {
            var _local_4 = 0;
            if (this._communicationManager != null)
            {
                _local_4 = ForumModerationState._Str_5466;
                if (k._Str_7449)
                {
                    _local_4 = ForumModerationState._Str_4415;
                }
                this._communicationManager.connection.send(new ModerateMessageMessageComposer(this._forumData.groupId, _arg_2, _arg_3, _local_4));
            }
        }

        public function unDeleteMessage(k:ForumData, _arg_2:Int, _arg_3:Int)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new ModerateMessageMessageComposer(k.groupId, _arg_2, _arg_3, 1));
            }
        }

        public function reportMessage(k:ForumData, _arg_2:Int, _arg_3:Int)
        {
            if (this._help != null)
            {
                this._help.reportMessage(k.groupId, _arg_2, _arg_3);
            }
        }

        function _parser8(k:UpdateMessageMessageEvent)
        {
            var _local_6:MessageData = null;
            var _local_2= k.getParser();
            if ((((this._forumData == null) || (!(this._forumData.groupId == _local_2.groupId))) || (!(this._currentThreadID == _local_2.threadId))))
            {
                return;
            }
            var _local_3= _local_2.message;
            var _local_4:Array<ASAny> = (this._messagesListData : ASAny)["messages"];
            var _local_5 = 0;
            while (_local_5 < _local_4.length)
            {
                _local_6 = _local_4[_local_5];
                if (_local_6.messageId == _local_3.messageId)
                {
                    _local_4[_local_5] = _local_3;
                    if (this._mainView != null)
                    {
                        this._mainView._Str_25031(_local_3);
                    }
                    return;
                }
                _local_5++;
            }
        }

        public function _Str_20033(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._goToThreadID = _arg_2;
            var _local_4= Std.int(Math.ffloor((_arg_3 / ThreadsListData.PAGE_SIZE)));
            this._goToMessageIndex = (_arg_3 % ThreadsListData.PAGE_SIZE);
            this.requestThreadMessageList(k, _arg_2, (_local_4 * ThreadsListData.PAGE_SIZE));
        }

        public function _Str_23450(k:Int)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(new GetExtendedProfileMessageComposer(k));
            }
        }

        public function _Str_24639()
        {
            this._Str_13365();
            this._mainView = null;
            this._forumData = null;
            this._requestedForumsListCode = NO_ID;
            this._requestedGroupID = NO_ID;
        }

        public function _Str_13365(k:Bool=false)
        {
            var _local_2:UpdateForumReadMarkerMessageComposer = null;
            if (((this._communicationManager != null) && (this._forumData != null)))
            {
                if ((k || (this._lastReadMessageId > this._forumData._Str_12786)))
                {
                    _local_2 = new UpdateForumReadMarkerMessageComposer();
                    if (k)
                    {
                        _local_2.add(this._forumData.groupId, Std.int(Math.max(this._forumData._Str_8598, this._lastReadMessageId)), (this._lastReadMessageId == 0));
                    }
                    else
                    {
                        _local_2.add(this._forumData.groupId, this._lastReadMessageId, false);
                    }
                    this._communicationManager.connection.send(_local_2);
                }
            }
            this._lastReadMessageId = 0;
            this._lastReadMessageIndexByThread = new ASDictionary<ASAny,ASAny>();
        }

        public function _Str_23963()
        {
            var k:UpdateForumReadMarkerMessageComposer = null;
            var _local_2:ForumData = null;
            if (((this._communicationManager != null) && (this._forumsListData != null)))
            {
                k = new UpdateForumReadMarkerMessageComposer();
                final _iter_ = this._forumsListData.forums; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2._Str_18237 > 0)
                    {
                        k.add(_local_2.groupId, _local_2._Str_8598, true);
                    }
                }
                if (k.size > 0)
                {
                    this._communicationManager.connection.send(k);
                    this._Str_7256(0);
                }
            }
        }

        public function _Str_16072(k:Int):Int
        {
            var _local_3:GuildForumThread = null;
            var _local_2:ASAny = this._lastReadMessageIndexByThread[k];
            if (_local_2 != null)
            {
                return ASCompat.toInt(_local_2);
            }
            if (this._threadsListData != null)
            {
                _local_3 = this._threadsListData._Str_6700[k];
                if (_local_3 != null)
                {
                    return (_local_3.totalMessages - _local_3.unreadMessagesCount) - 1;
                }
            }
            return -1;
        }

        public function _Str_20284(k:Int, _arg_2:Int, _arg_3:Int)
        {
            if (k > this._lastReadMessageId)
            {
                this._lastReadMessageId = k;
                if (this._forumsListData != null)
                {
                    this._forumsListData._Str_20834(this._forumData, k);
                    if (this._forumsListData._Str_5154 == FORUMS_LIST_CODE_MY_FORUMS)
                    {
                        this._Str_7256(this._forumsListData._Str_9052);
                    }
                }
            }
            this._lastReadMessageIndexByThread[_arg_2] = _arg_3;
        }

        public function _Str_20049():Int
        {
            return this._goToMessageIndex;
        }

        public function _Str_25071():Int
        {
            return this._goToThreadID;
        }

        public function _Str_23416()
        {
            this._goToThreadID = -1;
            this._goToMessageIndex = -1;
        }

        public function _Str_7256(k:Int)
        {
            if (this._unreadForumsCount == k)
            {
                return;
            }
            if (k > this._unreadForumsCount)
            {
                if (this._soundManager != null)
                {
                }
            }
            this._unreadForumsCount = k;
            events.dispatchEvent(new UnseenForumsCountUpdatedEvent(UnseenForumsCountUpdatedEvent.UNSEEN_FORUMS_COUNT, k));
            if (this._mainView != null)
            {
                this._mainView._Str_7256(k);
            }
        }

        function onUnreadForumsCountUpdateTimerEvent(k:TimerEvent)
        {
            if (this._mainView != null)
            {
                this._communicationManager.connection.send(new GetForumsListMessageComposer(FORUMS_LIST_CODE_MY_FORUMS, 0, ThreadsListData.PAGE_SIZE));
            }
            else
            {
                this._communicationManager.connection.send(new GetUnreadForumsCountMessageComposer());
            }
        }

        function _Str_23952(k:UnreadForumsCountMessageEvent)
        {
            this._Str_7256(k.getParser()._Str_9052);
        }
    }

