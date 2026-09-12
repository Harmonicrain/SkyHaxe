package com.sulake.habbo.friendlist
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.messenger.IHabboMessenger;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.friendlist.domain.FriendListTabs;
    import com.sulake.habbo.friendlist.domain.FriendCategories;
    import com.sulake.habbo.friendlist.domain._Str_9210;
    import com.sulake.habbo.friendlist.domain.AvatarSearchResults;
    import com.sulake.habbo.notifications.IHabboNotifications;
    import flash.utils.Timer;
    import com.sulake.habbo.friendlist.domain._Str_10966;
    import com.sulake.habbo.friendlist.domain._Str_10395;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.iid.IIDHabboMessenger;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboNotifications;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.MessengerInitEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListFragmentMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.MessengerInitMessageComposer;
    import flash.events.TimerEvent;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.friendlist.domain.Friend;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.RequestFriendMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.quest.FriendRequestQuestCompleteMessageComposer;
    import flash.geom.Point;
    import flash.display.BitmapData;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendParser;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendCategoryData;
    import com.sulake.habbo.friendlist.domain.FriendCategory;
    import com.sulake.habbo.friendlist.domain._Str_11887;
    import com.sulake.habbo.friendlist.domain._Str_11703;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FollowFriendFailedEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendListUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendRequestsEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.NewFriendRequestEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.AcceptFriendResultEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.MessengerErrorEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.HabboSearchResultEvent;
    import com.sulake.habbo.communication.messages.incoming.friendlist.RoomInviteErrorEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserRightsMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.GetFriendRequestsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.FriendListUpdateMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.friendlist.FriendRequestData;
    import com.sulake.habbo.friendlist.domain.FriendRequest;
    import com.sulake.habbo.communication.messages.incoming.friendlist.AcceptFriendFailureData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.SetRelationshipStatusMessageComposer;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.habbo.communication.messages.incoming.friendlist.*;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.*;
    import com.sulake.habbo.friendlist.domain.*;
    import com.sulake.habbo.communication.messages.parser.friendlist.*;

     class HabboFriendList extends Component implements IHabboFriendsList implements  IAvatarImageListener implements  ILinkEventTracker 
    {
        public static inline final FACE= "face";

        var _windowManager:IHabboWindowManager;
        var _communicationManager:IHabboCommunicationManager;
        var _messenger:IHabboMessenger;
        var _localizationManager:IHabboLocalizationManager;
        var _avatarManager:IAvatarRenderManager;
        var _sessionDataManager:ISessionDataManager;
        var _tracking:IHabboTracking;
        var _Str_19590:_Str_8767;
        var _tabs:FriendListTabs;
        var _view:FriendListView;
        var _Str_16825:_Str_9313;
        var _avatarId:Int = 0;
        @:allow(com.sulake.habbo.friendlist) var _categories:FriendCategories;
        var _friendRequests:_Str_9210;
        var _avatarSearchResults:AvatarSearchResults;
        var _notifications:IHabboNotifications;
        var _Str_6311:Timer;
        var _Str_21357:Int = 0;
        var _Str_5982:Array<ASAny>;
        var _Str_3489:Timer;
        var _Str_21697:Bool = false;
        var _Str_18300:Int = 0;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._Str_18300 = -FriendsView._Str_13372;
            super(k, _arg_2, _arg_3);
            this._categories = new FriendCategories(new _Str_10966(this));
            this._avatarSearchResults = new AvatarSearchResults(new _Str_10395(this));
            this._Str_19590 = new _Str_8767();
            this._Str_5982 = [];
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _tracking = k;
            }), new ComponentDependency(new IIDHabboMessenger(), function (k:IHabboMessenger)
            {
                _messenger = k;
            }, false), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboNotifications(), function (k:IHabboNotifications)
            {
                _notifications = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            })]));
        }

        override function initComponent()
        {
            this._communicationManager.addHabboConnectionMessageEvent(new UserObjectEvent(this.onUserObject));
            this._communicationManager.addHabboConnectionMessageEvent(new MessengerInitEvent(this.onMessengerInit));
            this._communicationManager.addHabboConnectionMessageEvent(new FriendListFragmentMessageEvent(this.onFriendsListFragment));
            context.addLinkEventTracker(this);
            this.send(new MessengerInitMessageComposer());
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            context.removeLinkEventTracker(this);
            if (this._Str_6311 != null)
            {
                this._Str_6311.stop();
                this._Str_6311.removeEventListener(TimerEvent.TIMER, (this._Str_20682 : ASAny));
                this._Str_6311 = null;
            }
            if (this._Str_3489 != null)
            {
                if (this._Str_3489.running)
                {
                    this._Str_3489.stop();
                }
                this._Str_3489.removeEventListener(TimerEvent.TIMER, (this._Str_20052 : ASAny));
                this._Str_3489 = null;
            }
            super.dispose();
        }

        public function send(k:IMessageComposer)
        {
            this._communicationManager.connection.send(k);
        }

        public function trackGoogle(k:String, _arg_2:String, _arg_3:Int=-1)
        {
            if (this._tracking != null)
            {
                this._tracking.trackGoogle(k, _arg_2, _arg_3);
            }
        }

        public function openHabboWebPage(linkAlias:String, params:ASDictionary<ASAny,ASAny>, x:Int, y:Int)
        {
            var url= getProperty(linkAlias, params);
            var webWindowName= "habboMain";
            try
            {
                HabboWebTools.navigateToURL(url, webWindowName);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("GOT ERROR: " + e)]);
            }
 }            if (this._Str_16825 == null)
            {
                this._Str_16825 = new _Str_9313(this);
            }
            this._Str_16825.show(x, y);
        }

        public function getText(k:String):String
        {
            return this._localizationManager.getLocalization(k);
        }

        public function registerParameter(k:String, _arg_2:String, _arg_3:String)
        {
            this._localizationManager.registerParameter(k, _arg_2, _arg_3);
        }

        public function _Str_18624()
        {
            this.registerParameter("friendlist.listfull.text", "mylimit", ("" + Std.string(this.friendRequests.limit)));
            this.registerParameter("friendlist.listfull.text", "clublimit", ("" + Std.string(this.friendRequests._Str_17940)));
            this.simpleAlert("${friendlist.listfull.title}", "${friendlist.listfull.text}");
        }

        public function _Str_23469(k:String)
        {
            this.registerParameter("friendlist.friendrequestsent.text", "user_name", k);
            this.simpleAlert("${friendlist.friendrequestsent.title}", "${friendlist.friendrequestsent.text}");
        }

        public function getFriend(k:Int):IFriend
        {
            if (this._view == null)
            {
                Logger.log(["Cannot process getFriend. Friendlist not initialized."]);
                return null;
            }
            var _local_2= this._categories._Str_13534(k);
            return _local_2;
        }

        public function canBeAskedForAFriend(k:Int):Bool
        {
            if (this._view == null)
            {
                Logger.log(["Cannot process canBeAskedForAFriend. Friendlist not initialized."]);
                return false;
            }
            return ((this.getFriend(k) == null) && (!this.searchResults.isRequestFriend(k))) && (this.categories.getFriendCount(false) < this.friendRequests.limit);
        }

        public function askForAFriend(k:Int, _arg_2:String):Bool
        {
            if (this._view == null)
            {
                Logger.log(["Cannot ask for friend. Friendlist not initialized."]);
                return false;
            }
            if (this.searchResults.isRequestFriend(k))
            {
                return true;
            }
            if (!this.canBeAskedForAFriend(k))
            {
                return false;
            }
            this.send(new RequestFriendMessageComposer(_arg_2));
            this.searchResults.setFriendRequestSent(k);
            this.send(new FriendRequestQuestCompleteMessageComposer());
            return true;
        }

        public function openFriendList()
        {
            this._Str_17876(_Str_2777._Str_4113);
        }

        public function openFriendRequests()
        {
            this._Str_17876(_Str_2777._Str_3798);
        }

        public function openFriendSearch()
        {
            this._Str_17876(_Str_2777._Str_5722);
            cast(this._tabs._Str_4403(_Str_2777._Str_5722)._Str_4621, SearchView).focus();
        }

        public function close()
        {
            if (this._view != null)
            {
                this._view.close();
            }
        }

        public function alignBottomLeftTo(k:Point)
        {
            if (this._view != null)
            {
                this._view.alignBottomLeftTo(k);
            }
        }

        public function isOpen():Bool
        {
            if (this._view != null)
            {
                return this._view.isOpen();
            }
            return false;
        }

        public function currentTabId():Int
        {
            if (((this._view == null) || (!this._view.isOpen())))
            {
                return _Str_2777._Str_18955;
            }
            return this._Str_21357;
        }

        function _Str_17876(k:Int)
        {
            if (this._view == null)
            {
                Logger.log(["Cannot open friendlist. Friendlist not initialized."]);
                return;
            }
            this._view.openFriendList();
            var _local_2= this.tabs._Str_4403(k);
            if (_local_2 != this.tabs._Str_14015())
            {
                this.tabs._Str_16257(_local_2);
                this.view.refresh("openFriendList");
            }
            this._view.mainWindow.activate();
            this._Str_21357 = k;
        }

        public function getFriendCount(k:Bool, _arg_2:Bool):Int
        {
            if (this._view == null)
            {
                Logger.log(["Cannot get friend count. Friendlist not initialized."]);
                return 0;
            }
            return this._categories.getFriendCount(k, _arg_2);
        }

        public function getButton(k:String, _arg_2:String, _arg_3:ASFunction, _arg_4:Int=0, _arg_5:Int=0, _arg_6:Int=0):IBitmapWrapperWindow
        {
            var _local_7= this.getButtonImage(_arg_2);
            var _local_8= Std.downcast(this._windowManager.createWindow(k, "", WindowType.WINDOW_TYPE_BITMAP_WRAPPER, HabboWindowStyle.NULL, (ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )| ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)), new Rectangle(_arg_4, _arg_5, _local_7.width, _local_7.height), _arg_3, _arg_6) , IBitmapWrapperWindow);
            _local_8.bitmap = _local_7;
            return _local_8;
        }

        public function getXmlWindow(k:String):IWindow
        {
            var _local_2= assets.getAssetByName((k + "_xml"));
            var _local_3= cast(_local_2, XmlAsset);
            return this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_3.content));
        }

        public function _Str_21131():Bool
        {
            return getBoolean("friend_list.persistent_message_status.enabled");
        }

        public function _Str_17617(k:String):BitmapData
        {
            if (this._sessionDataManager != null)
            {
                return this._sessionDataManager.getGroupBadgeSmallImage(k);
            }
            return null;
        }

        public function getAvatarFaceBitmap(k:String):BitmapData
        {
            var _local_2= getBoolean("zoom.enabled");
            var _local_3= this._avatarManager.createAvatarImage(k, (_local_2 ? AvatarScaleType.LARGE : AvatarScaleType.SMALL), null, this);
            if (_local_3 == null)
            {
                return null;
            }
var _local_4= _local_3.getCroppedImage(AvatarSetType.HEAD, (_local_2 ? 0.5 : 1));
            _local_3.dispose();
            return _local_4;
        }

        public function _Str_17007():Bool
        {
            var k= getProperty("client.minimail.embed.enabled");
            return k == "true";
        }

        function onUserObject(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserObjectEvent).getParser();
            this._avatarId = _local_2.id;
        }

        function onFriendsListFragment(k:IMessageEvent)
        {
            var _local_3:FriendParser = null;
            var _local_2= Std.downcast(k , FriendListFragmentMessageEvent).getParser();
            final _iter_ = _local_2.friendFragment; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._Str_5982.push(_local_3);
            }
            if ((_local_2.fragmentNo + 1) >= _local_2.totalFragments)
            {
                this._Str_3489 = new Timer(5000, Std.int(Math.fceil((this._Str_5982.length / 300))));
                this._Str_3489.addEventListener(TimerEvent.TIMER, (this._Str_20052 : ASAny));
                this._Str_3489.start();
            }
        }

        function _Str_20052(k:TimerEvent)
        {
            var _local_4:FriendParser = null;
            var _local_2 = 0;
            if (this._Str_5982.length > 300)
            {
                _local_2 = (this._Str_5982.length - 300);
            }
            var _local_3= (this._Str_5982.length - 1);
            while (_local_3 >= _local_2)
            {
                _local_4 = this._Str_5982[_local_3];
                this._categories._Str_11247(new Friend(_local_4));
                this._Str_5982.splice(_local_3, 1);
                _local_3--;
            }
            if (this._Str_5982.length == 0)
            {
                this._Str_21697 = true;
            }
        }

        function onMessengerInit(k:IMessageEvent)
        {
            var _local_3:FriendCategoryData = null;
            var _local_4:FriendCategory = null;
            this._view = new FriendListView(this);
            var _local_2= Std.downcast(k , MessengerInitEvent).getParser();
            this._friendRequests = new _Str_9210(new _Str_11887(this), _local_2._Str_22808, _local_2._Str_23653);
            final _iter_ = _local_2.categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._categories._Str_15664(new FriendCategory(_local_3.id, _local_3.name));
            }
            this._categories._Str_15664(new FriendCategory(FriendCategory._Str_15031, this.getText("friendlist.friends")));
            this._categories._Str_15664(new FriendCategory(FriendCategory._Str_7666, this.getText("friendlist.friends.offlinecaption")));
            this._tabs = new FriendListTabs(new _Str_11703(this));
            if (this._Str_6311 == null)
            {
                this._Str_6311 = new Timer(120000);
                this._Str_6311.addEventListener(TimerEvent.TIMER, (this._Str_20682 : ASAny));
                this._Str_6311.start();
            }
            this._Str_22340();
            this._Str_22421();
            if (this._categories.getFriendCount(true, false) == 0)
            {
                _local_4 = this._categories._Str_5067(FriendCategory._Str_7666);
                if (_local_4 != null)
                {
                    _local_4._Str_22255(true);
                }
            }
            Logger.log(["FRIENDLIST INITIALIZED SUCCESSFULLY"]);
        }

        public function _Str_9727(k:String)
        {
            events.dispatchEvent(new Event(k));
        }

        function _Str_25996(k:Array<ASAny>):Array<ASAny>
        {
            var _local_4:FriendParser = null;
            var _local_5:Array<ASAny> = null;
            var _local_6:String = null;
            var _local_2= new Array<ASAny>();
            var _local_3= new ASDictionary<ASAny,ASAny>();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                _local_2.push(_local_4.name.toLowerCase());
                _local_3[_local_4.name.toLowerCase()] = _local_4;
            }
            _local_2.sort(Reflect.compare);
            _local_5 = new Array<ASAny>();
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_6  = _tmp_;
                _local_5.push(_local_3[_local_6]);
            }
            return _local_5;
        }

        function _Str_22421()
        {
            this._communicationManager.addHabboConnectionMessageEvent(new FollowFriendFailedEvent(this._Str_24032));
            this._communicationManager.addHabboConnectionMessageEvent(new FriendListUpdateEvent(this.onFriendListUpdate));
            this._communicationManager.addHabboConnectionMessageEvent(new FriendRequestsEvent(this._Str_24954));
            this._communicationManager.addHabboConnectionMessageEvent(new NewFriendRequestEvent(this._Str_16886));
            this._communicationManager.addHabboConnectionMessageEvent(new AcceptFriendResultEvent(this._Str_22373));
            this._communicationManager.addHabboConnectionMessageEvent(new MessengerErrorEvent(this._Str_23472));
            this._communicationManager.addHabboConnectionMessageEvent(new HabboSearchResultEvent(this._Str_23021));
            this._communicationManager.addHabboConnectionMessageEvent(new RoomInviteErrorEvent(this._Str_22762));
            this._communicationManager.addHabboConnectionMessageEvent(new UserRightsMessageEvent(this.onUserRights));
        }

        function _Str_22340()
        {
            Logger.log(["Sending friend requests request"]);
            this.send(new GetFriendRequestsMessageComposer());
        }

        function _Str_20682(k:Event)
        {
            Logger.log(["Sending update request"]);
            this.send(new FriendListUpdateMessageComposer());
        }

        function _Str_24954(k:IMessageEvent)
        {
            var _local_3:FriendRequestData = null;
            var _local_2= Std.downcast(k , FriendRequestsEvent).getParser();
            this._friendRequests._Str_20199(false);
            final _iter_ = _local_2._Str_17539; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._friendRequests._Str_8472(new FriendRequest(_local_3));
            }
            if (_local_2._Str_17539.length > 0)
            {
                this._tabs._Str_4403(_Str_2777._Str_3798)._Str_9276(true);
            }
            this._view.refresh("friendRequests");
        }

        function _Str_16886(k:IMessageEvent)
        {
            Logger.log(["Received new friend request"]);
            var _local_2= Std.downcast(k , NewFriendRequestEvent).getParser();
            var _local_3= new FriendRequest(_local_2.req);
            this._friendRequests._Str_24807(_local_3);
            var _local_4= this._tabs._Str_4403(_Str_2777._Str_3798);
            _local_4._Str_9276(true);
            this._view.refresh("newFriendRequest");
        }

        function _Str_22373(k:IMessageEvent)
        {
            var _local_3:AcceptFriendFailureData = null;
            var _local_2= Std.downcast(k , AcceptFriendResultEvent).getParser();
            final _iter_ = _local_2._Str_22533; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this.friendRequests._Str_25626(_local_3.senderId);
                this._Str_20985(_local_3.errorCode);
            }
        }

        function _Str_23021(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , HabboSearchResultEvent).getParser();
            this._avatarSearchResults._Str_22668(_local_2.friends, _local_2.others);
            this._view.refresh("search");
        }

        function _Str_23472(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , MessengerErrorEvent).getParser();
            this._Str_20985(_local_2.errorCode, _local_2._Str_23408);
        }

        function _Str_20985(k:Int, _arg_2:Int=0)
        {
            var _local_3= "";
            switch (k)
            {
                case 1:
                    _local_3 = "${friendlist.error.friendlistownlimit}";
                    
                case 2:
                    _local_3 = "${friendlist.error.friendlistlimitofrequester}";
                    
                case 3:
                    _local_3 = "${friendlist.error.friend_requests_disabled}";
                    
                case 4:
                    _local_3 = "${friendlist.error.requestnotfound}";
                    
                default:
                    _local_3 = ((("Received messenger error: msg: " + Std.string(_arg_2)) + ", errorCode: ") + Std.string(k));
            }
            this.simpleAlert("${friendlist.alert.title}", _local_3);
        }

        function _Str_22762(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomInviteErrorEvent).getParser();
            var _local_3= ((("Received room invite error: errorCode: " + Std.string(_local_2.errorCode)) + ", recipients: ") + Util.arrayToString(_local_2._Str_25393));
            this.simpleAlert("${friendlist.alert.title}", _local_3);
        }

        function onFriendListUpdate(k:IMessageEvent)
        {
            this._categories.onFriendListUpdate(k);
            this._view.refresh("friendListUpdate");
        }

        function _Str_24032(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FollowFriendFailedEvent).getParser();
            var _local_3= this._Str_25719(_local_2.errorCode);
            Logger.log([((("Received follow friend failed: " + Std.string(_local_2.errorCode)) + ", ") + _local_3)]);
            this.simpleAlert("${friendlist.alert.title}", _local_3);
        }

        public function simpleAlert(k:String, _arg_2:String)
        {
            this.windowManager.simpleAlert(k, null, _arg_2);
        }

        function _Str_25719(k:Int):String
        {
            if (k == 0)
            {
                return "${friendlist.followerror.notfriend}";
            }
            if (k == 1)
            {
                return "${friendlist.followerror.offline}";
            }
            if (k == 2)
            {
                return "${friendlist.followerror.hotelview}";
            }
            if (k == 3)
            {
                return "${friendlist.followerror.prevented}";
            }
            return "Unknown follow friend error " + Std.string(k);
        }

        public function _Str_6498(k:IWindowContainer, _arg_2:String, _arg_3:Bool, _arg_4:String)
        {
            var _local_5= k.getChildByName(_arg_2);
            if (!_arg_3)
            {
                _local_5.visible = false;
            }
            else
            {
                _local_5.visible = true;
                _local_5.caption = _arg_4;
            }
        }

        public function refreshButton(k:IWindowContainer, _arg_2:String, _arg_3:Bool, _arg_4:ASFunction, _arg_5:Int)
        {
            var _local_6= k.findChildByName(_arg_2) ;
            if (!_arg_3)
            {
                _local_6.visible = false;
            }
            else
            {
                this._Str_11416(_local_6, _arg_2, _arg_4, _arg_5);
                _local_6.visible = true;
            }
        }

        public function _Str_25274(k:IWindowContainer, _arg_2:String, _arg_3:Int, _arg_4:ASFunction, _arg_5:Int)
        {
            var _local_6= cast(k.findChildByName(_arg_2), IRegionWindow);
            var _local_7= cast(_local_6.findChildByTag("bitmap"), IStaticBitmapWrapperWindow);
            var _local_8= "relationship_status_none";
            switch (_arg_3)
            {
                case RelationshipStatusEnum._Str_9205:
                    _local_8 = "relationship_status_heart";
                    
                case RelationshipStatusEnum._Str_8388:
                    _local_8 = "relationship_status_smile";
                    
                case RelationshipStatusEnum._Str_8824:
                    _local_8 = "relationship_status_bobba";
                    
            }
            _local_7.assetUri = _local_8;
            _local_7.visible = true;
            _local_6.id = _arg_5;
            _local_6.procedure = _arg_4;
            _local_6.visible = ((_arg_5 > 0) && getBoolean("relationship.status.enabled"));
        }

        public function _Str_17821(k:IWindowContainer, _arg_2:String, _arg_3:Bool, _arg_4:ASFunction, _arg_5:Int)
        {
            var _local_6= k.findChildByName(_arg_2);
            if (!_arg_3)
            {
                _local_6.visible = false;
            }
            else
            {
                _local_6.id = _arg_5;
                _local_6.procedure = _arg_4;
                _local_6.visible = true;
            }
        }

        function _Str_11416(k:IWindow, _arg_2:String, _arg_3:ASFunction, _arg_4:Int)
        {
            var _local_5:IBitmapWrapperWindow = null;
            k.id = _arg_4;
            if (Std.is(k , IBitmapWrapperWindow))
            {
                _local_5 = Std.downcast(k , IBitmapWrapperWindow);
            }
            else
            {
                _local_5 = Std.downcast(cast(k, IWindowContainer).findChildByTag("bitmap") , IBitmapWrapperWindow);
            }
            if (_local_5.bitmap != null)
            {
                return;
            }
            _local_5.bitmap = this.getButtonImage(_arg_2);
            _local_5.width = _local_5.bitmap.width;
            _local_5.height = _local_5.bitmap.height;
            k.procedure = _arg_3;
        }

        public function getButtonImage(k:String):BitmapData
        {
            var _local_5:BitmapData = null;
            var _local_2= assets.getAssetByName((k + "_png"));
            var _local_3= Std.downcast(_local_2 , BitmapDataAsset);
            Logger.log([("GETTING ASSET: " + k)]);
            var _local_4= ASCompat.dynamicAs(_local_3.content , BitmapData);
            Logger.log([((("GOT ASSET: " + _local_2) + ", ") + _local_4)]);
            _local_5 = new BitmapData(_local_4.width, _local_4.height, true, 0);
            _local_5.draw(_local_4);
            return _local_5;
        }

        public var _Str_23875(get,never):ASAny;
public function  get__Str_23875():ASAny
        {
            return this._Str_18300;
        }

        public function resetLastRoomInvitationTime()
        {
            this._Str_18300 = flash.Lib.getTimer();
        }

        public var hasfriendsListInitialized(get,never):Bool;
public function  get_hasfriendsListInitialized():Bool
        {
            return this._Str_21697;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var categories(get,never):FriendCategories;
public function  get_categories():FriendCategories
        {
            return this._categories;
        }

        public var friendRequests(get,never):_Str_9210;
public function  get_friendRequests():_Str_9210
        {
            return this._friendRequests;
        }

        public var searchResults(get,never):AvatarSearchResults;
public function  get_searchResults():AvatarSearchResults
        {
            return this._avatarSearchResults;
        }

        public var view(get,never):FriendListView;
public function  get_view():FriendListView
        {
            return this._view;
        }

        public var tabs(get,never):FriendListTabs;
public function  get_tabs():FriendListTabs
        {
            return this._tabs;
        }

        public var _Str_4930(get,never):_Str_8767;
public function  get__Str_4930():_Str_8767
        {
            return this._Str_19590;
        }

        public var messenger(get,never):IHabboMessenger;
public function  get_messenger():IHabboMessenger
        {
            return this._messenger;
        }

        public var avatarId(get,never):Int;
public function  get_avatarId():Int
        {
            return this._avatarId;
        }

        public var notifications(get,never):IHabboNotifications;
public function  get_notifications():IHabboNotifications
        {
            return this._notifications;
        }

        public var tracking(get,never):IHabboTracking;
public function  get_tracking():IHabboTracking
        {
            return this._tracking;
        }

        public var mainWindow(get,never):IWindowContainer;
public function  get_mainWindow():IWindowContainer
        {
            if (this._view == null)
            {
                return null;
            }
            return this._view.mainWindow;
        }

        public function getFriendNames():Array<ASAny>
        {
            if (this._categories == null)
            {
                return [];
            }
            return this._categories.getFriendNames();
        }

        public function acceptFriendRequest(k:Int)
        {
            if (this._tabs == null)
            {
                return;
            }
            var _local_2= this._tabs._Str_4403(_Str_2777._Str_3798);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= ASCompat.reinterpretAs(_local_2._Str_4621 , _Str_4097);
            if (_local_3 == null)
            {
                return;
            }
            _local_3._Str_11273(k);
        }

        public function acceptAllFriendRequests()
        {
            var k= this._tabs._Str_4403(_Str_2777._Str_3798);
            if (k == null)
            {
                return;
            }
            var _local_2= ASCompat.reinterpretAs(k._Str_4621 , _Str_4097);
            if (_local_2 == null)
            {
                return;
            }
            _local_2._Str_17684();
        }

        public function declineFriendRequest(k:Int)
        {
            var _local_2= this._tabs._Str_4403(_Str_2777._Str_3798);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= ASCompat.reinterpretAs(_local_2._Str_4621 , _Str_4097);
            if (_local_3 == null)
            {
                return;
            }
            _local_3._Str_12175(k);
        }

        public function declineAllFriendRequests()
        {
            var k= this._tabs._Str_4403(_Str_2777._Str_3798);
            if (k == null)
            {
                return;
            }
            var _local_2= ASCompat.reinterpretAs(k._Str_4621 , _Str_4097);
            if (_local_2 == null)
            {
                return;
            }
            _local_2._Str_17225();
        }

        public function setRelationshipStatus(k:Int, _arg_2:Int)
        {
            this.send(new SetRelationshipStatusMessageComposer(k, _arg_2));
        }

        public function getRelationshipStatus(k:Int):Int
        {
            var _local_2= this._categories._Str_13534(k);
            if (_local_2 != null)
            {
                return _local_2.relationshipStatus;
            }
            return RelationshipStatusEnum.NONE;
        }

        function onUserRights(k:IMessageEvent)
        {
            if (((!(this._sessionDataManager != null)) || (!(this._friendRequests != null))))
            {
                return;
            }
            var _local_2 = 0;
            if (this._sessionDataManager.clubLevel >= HabboClubLevelEnum.VIP)
            {
                _local_2 = this._friendRequests._Str_17940;
            }
            else
            {
                if (this._sessionDataManager.clubLevel >= HabboClubLevelEnum.CLUB)
                {
                    _local_2 = this._friendRequests._Str_17940;
                }
            }
            if (_local_2 > this._friendRequests.limit)
            {
                this._friendRequests.limit = _local_2;
            }
        }

        public function avatarImageReady(k:String)
        {
            var _local_3:Friend = null;
            var _local_4:IWindowContainer = null;
            var _local_5:IBitmapWrapperWindow = null;
            var _local_6:BitmapData = null;
            if ((disposed || (this._categories == null)))
            {
                return;
            }
            var _local_2= this._categories._Str_22560();
            if (_local_2 == null)
            {
                return;
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                if ((((!(_local_3 == null)) && (!_local_3.disposed)) && (_local_3.figure == k)))
                {
                    if (_local_3._Str_19416())
                    {
                        _local_3.face = this._Str_17617(_local_3.figure);
                    }
                    else
                    {
                        _local_3.face = this.getAvatarFaceBitmap(_local_3.figure);
                    }
                    if (_local_3.face != null)
                    {
                        _local_4 = _local_3.view;
                        if (_local_4 != null)
                        {
                            _local_5 = Std.downcast(_local_4.getChildByName(FACE) , IBitmapWrapperWindow);
                            if (((!(_local_5 == null)) && (!_local_5.disposed)))
                            {
                                _local_6 = _local_5.bitmap;
                                if (_local_6 != null)
                                {
                                    _local_6.fillRect(_local_6.rect, 0);
                                    _local_6.copyPixels(_local_3.face, _local_3.face.rect, new Point(0, 0), null, null, true);
                                }
                                _local_5.invalidate();
                            }
                        }
                    }
                }
            }
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "friendlist/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            _local_2 = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "open":
                    this.openFriendList();
                    return;
                case "openchat":
                    if (((_local_2.length < 3) || (this._messenger == null)))
                    {
                        return;
                    }
                    _local_3 = _local_2[2].split(":");
                    if (_local_3.length < 2)
                    {
                        return;
                    }
                    if (ASCompat.toInt(_local_3[0]) == this._avatarId)
                    {
                        _local_4 = ASCompat.toInt(_local_3[1]);
                    }
                    else
                    {
                        _local_4 = ASCompat.toInt(_local_3[0]);
                    }
                    if (((_local_4 != 0) && (_local_4 > 0)))
                    {
                        this.openFriendList();
                        this._messenger.startConversation(_local_4);
                    }
                    return;
                default:
                    Logger.log([("FriendList unknown link-type received: " + _local_2[1])]);
            }
        }
    }

