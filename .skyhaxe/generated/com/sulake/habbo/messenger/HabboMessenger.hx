package com.sulake.habbo.messenger
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboSoundManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboFriendList;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.habbo.communication.messages.incoming.friendlist.MessengerInitEvent;
    import com.sulake.habbo.communication.messages.incoming.preferences.AccountPreferencesEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.MiniMailNewMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.MiniMailUnreadCountEvent;
    import com.sulake.habbo.messenger.events.MiniMailMessageEvent;
    import com.sulake.habbo.communication.messages.parser.friendlist.MiniMailUnreadCountMessageParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.NewConsoleMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.InstantMessageErrorEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.RoomInviteEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.HabbiconInstantMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.habbicons.HabbiconMessengerHistoryMessageEvent;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconMessengerContent;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconMessengerHistoryEntry;
    import com.sulake.habbo.messenger.events.ActiveConversationEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendlist.IFriend;

     class HabboMessenger extends Component implements IHabboMessenger 
    {
        var _windowManager:IHabboWindowManager;
        var _communicationManager:IHabboCommunicationManager;
        var _localizationManager:IHabboLocalizationManager;
        var _friendsList:IHabboFriendsList;
        var _soundManager:IHabboSoundManager;
        var _tracking:IHabboTracking;
        var _miniMailUnseenCount:Int = 0;
        var _sessionDataManager:ISessionDataManager;
        var _help:IHabboHelp;
        var _mainView:MainView;
        var _messageEvents:Vector<IMessageEvent>;
        var _roomInvitesIgnored:Bool = false;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboSoundManager(), function (k:IHabboSoundManager)
            {
                _soundManager = k;
            }), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboFriendList(), function (k:IHabboFriendsList)
            {
                _friendsList = k;
            }), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _tracking = k;
            }), new ComponentDependency(new IIDHabboHelp(), function (k:IHabboHelp)
            {
                _help = k;
            })]));
        }

        override function initComponent()
        {
            this._messageEvents = new Vector<IMessageEvent>(0);
            this.addMessageEvent(new MessengerInitEvent(this.onMessengerInit));
            this.addMessageEvent(new AccountPreferencesEvent(this.onAccountPreferences));
            if (getBoolean("client.minimail.embed.enabled"))
            {
                this.addMessageEvent(new MiniMailNewMessageEvent(this.onMiniMailMessage));
                this.addMessageEvent(new MiniMailUnreadCountEvent(this.onMiniMailUnreadCount));
            }
        }

        function addMessageEvent(k:IMessageEvent)
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
            super.dispose();
        }

        function onMiniMailMessage(k:IMessageEvent)
        {
            this._miniMailUnseenCount++;
            this.playMessageReceivedSound();
            events.dispatchEvent(new MiniMailMessageEvent(MiniMailMessageEvent.MMME_NEW, this._miniMailUnseenCount));
        }

        function onMiniMailUnreadCount(k:IMessageEvent)
        {
            this._miniMailUnseenCount = Std.downcast(k.parser , MiniMailUnreadCountMessageParser)._Str_22745;
            events.dispatchEvent(new MiniMailMessageEvent(MiniMailMessageEvent.MMME_UNREAD, this._miniMailUnseenCount));
        }

        function onAccountPreferences(k:AccountPreferencesEvent)
        {
            this._roomInvitesIgnored = k.getParser().roomInvitesIgnored;
        }

        public function getRoomInvitesIgnored():Bool
        {
            return this._roomInvitesIgnored;
        }

        public function setRoomInvitesIgnored(k:Bool)
        {
            this._roomInvitesIgnored = k;
        }

        function onMessengerInit(k:IMessageEvent)
        {
            this._mainView = new MainView(this);
            this.addMessageEvent(new NewConsoleMessageEvent(this.onNewConsoleMessage));
            this.addMessageEvent(new HabbiconInstantMessageEvent(this.onHabbiconInstantMessage));
            this.addMessageEvent(new HabbiconMessengerHistoryMessageEvent(this.onHabbiconMessengerHistory));
            this.addMessageEvent(new InstantMessageErrorEvent(this.onInstantMessageError));
            this.addMessageEvent(new RoomInviteEvent(this.onRoomInvite));
        }

        public function startConversation(k:Int)
        {
            if (this._mainView != null)
            {
                this._mainView.startConversation(k);
                this._mainView.show();
            }
        }

        public function getUnseenMiniMailMessageCount():Int
        {
            return this._miniMailUnseenCount;
        }

        public function setFollowingAllowed(k:Int, _arg_2:Bool)
        {
            if (this._mainView != null)
            {
                this._mainView.setFollowingAllowed(k, _arg_2);
            }
        }

        public function setOnlineStatus(k:Int, _arg_2:Bool)
        {
            if (this._mainView != null)
            {
                this._mainView.setOnlineStatus(k, _arg_2);
            }
        }

        public function send(k:IMessageComposer)
        {
            this._communicationManager.connection.send(k);
        }

        public function playSendSound()
        {
            if (this._soundManager != null)
            {
                this._soundManager.playSound(HabboSoundTypesEnum.MESSAGE_SENT);
            }
        }

        public function isOpen():Bool
        {
            return (!(this._mainView == null)) && this._mainView.isOpen;
        }

        public function toggleMessenger()
        {
            if (this._mainView != null)
            {
                this._mainView.toggle();
            }
        }

        public function getText(k:String):String
        {
            return this._localizationManager.getLocalization(k, k);
        }

        function onNewConsoleMessage(k:NewConsoleMessageEvent)
        {
            var _local_2= k.getParser();
            Logger.log([((("Received console msg: " + _local_2.messageText) + ", ") + Std.string(_local_2.senderId))]);
            if (this._mainView != null)
            {
                this._mainView.addConsoleMessage(_local_2.senderId, _local_2.messageText, _local_2._Str_17201, _local_2.extraData);
                if (!this._mainView.isOpen)
                {
                    this.playMessageReceivedSound();
                }
            }
        }

        function onHabbiconInstantMessage(k:HabbiconInstantMessageEvent)
        {
            var parser= k.getParser();
            var content= parser.content;
            Logger.log([("Received Habbicon console msg: " + ((content != null) ? Std.string(content.habbiconId) : Std.string(0)) + ", " + Std.string(parser.senderId))]);
            if (this._mainView != null && content != null)
            {
                this._mainView.addHabbiconConsoleMessage(parser.chatId, content.messageType, content.messageText, content.habbiconId, parser.secondsSinceSent, parser.messageId, parser.confirmationId, parser.senderId, parser.senderName, parser.senderFigure);
                if (!this._mainView.isOpen)
                {
                    this.playMessageReceivedSound();
                }
            }
        }

        function onHabbiconMessengerHistory(k:HabbiconMessengerHistoryMessageEvent)
        {
            var parser= k.getParser();
            var entry:HabbiconMessengerHistoryEntry = null;
            var content:HabbiconMessengerContent = null;
            if (this._mainView == null || parser == null)
            {
                return;
            }
            final _iter_ = parser.entries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry  = _tmp_;
                content = entry.content;
                if (content != null)
                {
                    this._mainView.addHabbiconConsoleMessage(parser.chatId, content.messageType, content.messageText, content.habbiconId, entry.secondsSinceSent, entry.messageId, 0, entry.senderId, entry.senderName, entry.senderFigure);
                }
            }
        }

        function onRoomInvite(k:RoomInviteEvent)
        {
            var _local_2= k.getParser();
            if (this._mainView != null)
            {
                this._mainView.addRoomInvite(_local_2.senderId, _local_2.messageText);
                if (!this._mainView.isOpen)
                {
                    this.playMessageReceivedSound();
                }
            }
        }

        function playMessageReceivedSound()
        {
            if (this._soundManager != null)
            {
                this._soundManager.playSound(HabboSoundTypesEnum.MESSAGE_RECEIVED);
            }
        }

        function onInstantMessageError(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , InstantMessageErrorEvent).getParser();
            if (this._mainView != null)
            {
                this._mainView.onInstantMessageError(_local_2.userId, _local_2.errorCode, _local_2.message);
            }
        }

        public function conversationCountUpdated(k:Int)
        {
            events.dispatchEvent(new ActiveConversationEvent(ActiveConversationEvent.ACCE_CHANGED, k));
        }

        public function getXmlWindow(k:String):IWindow
        {
            var _local_2= assets.getAssetByName((k + "_xml"));
            var _local_3= cast(_local_2, XmlAsset);
            return this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_3.content));
        }

        public function trackGoogle(k:String, _arg_2:String, _arg_3:Int=-1)
        {
            if (this._tracking != null)
            {
                this._tracking.trackGoogle(k, _arg_2, _arg_3);
            }
        }

        @:allow(com.sulake.habbo.messenger) function getFriend(k:Int):IFriend
        {
            return this._friendsList.getFriend(k);
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localizationManager;
        }

        @:allow(com.sulake.habbo.messenger) function reportUser(k:Int)
        {
            this._help.reportUserFromIM(k);
        }

        public function closeConversation(k:Int)
        {
            this._mainView.hideConversation(k);
        }

        public var hasfriendsListInitialized(get,never):Bool;
public function  get_hasfriendsListInitialized():Bool
        {
            return this._friendsList.hasfriendsListInitialized;
        }
    }

