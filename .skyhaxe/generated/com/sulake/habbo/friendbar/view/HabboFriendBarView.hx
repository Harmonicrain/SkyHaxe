package com.sulake.habbo.friendbar.view
;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.friendbar.data.IHabboFriendBarData;
    import com.sulake.habbo.game.IHabboGameManager;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendbar.view.tabs.ITab;
    import com.sulake.habbo.friendbar.view.utils.TextCropper;
    import com.sulake.habbo.friendbar.view.utils.FriendListIcon;
    import com.sulake.habbo.friendbar.view.utils.MessengerIcon;
    import com.sulake.habbo.friendbar.view.tabs.NewOpenMessengerTab;
    import flash.utils.Timer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboFriendList;
    import com.sulake.iid.IIDHabboFriendBarData;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.iid.IIDHabboGameManager;
    import flash.events.TimerEvent;
    import com.sulake.habbo.friendbar.events.FriendBarUpdateEvent;
    import com.sulake.habbo.friendbar.events.FindFriendsNotificationEvent;
    import com.sulake.habbo.friendbar.events.FriendRequestUpdateEvent;
    import com.sulake.habbo.friendbar.events.NewMessageEvent;
    import com.sulake.habbo.friendbar.events.NotificationEvent;
    import com.sulake.habbo.friendbar.events.ActiveConversationsCountEvent;
    import com.sulake.habbo.session.events.SessionDataPreferencesEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.room.utils.RoomEnterEffect;
    import com.sulake.habbo.friendbar.data.IFriendRequest;
    import com.sulake.habbo.friendbar.data.IFriendEntity;
    import com.sulake.habbo.friendbar.view.tabs.Tab;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.friendbar.view.tabs.NewFriendRequestTab;
    import com.sulake.habbo.friendbar.view.tabs.FriendRequestsTab;
    import com.sulake.habbo.friendbar.view.tabs.NewFriendEntityTab;
    import com.sulake.habbo.friendbar.view.tabs.AddFriendsTab;
    import com.sulake.habbo.friendbar.view.tabs.FriendEntityTab;
    import com.sulake.habbo.friendbar.view.tabs.tokens.Token;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.friendbar.data.FriendRequest;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.friendbar.view.tabs.FriendRequestTab;
    import flash.events.Event;
    import com.sulake.habbo.window._enum.HabboAlertDialogFlag;
    import com.sulake.habbo.session.UIFlags;
    import com.sulake.habbo.friendbar.events.FriendBarResizeEvent;
    import com.sulake.habbo.friendbar.data.FriendNotification;

     class HabboFriendBarView extends AbstractView implements IHabboFriendBarView implements  IAvatarImageListener implements  ILinkEventTracker 
    {
        static inline final TAB_WIDTH= 127;
        static inline final WINDOW_LAYER_INDEX= 1;
        static inline final USE_TOGGLE_WINDOW= false;
        static inline final MIN_TABS_WHEN_ENOUGH_SPACE= 3;
        static inline final NEW_BAR_XML= "new_bar_xml";
        static inline final TOGGLE_XML= "toggle_xml";
        static inline final BORDER= "border";
        static inline final LIST= "list";
        static inline final HEADER= "header";
        static inline final CANVAS= "canvas";
        static inline final PIECES= "pieces";
        static inline final FRIENDTOOLS= "friendtools";
        static inline final COLLAPSE_LEFT= "collapse_left";
        static inline final COLLAPSE_RIGHT= "collapse_right";
        static inline final BUTTON_LEFT= "button_left";
        static inline final BUTTON_RIGHT= "button_right";
        static inline final BUTTON_LEFT_PAGE= "button_left_page";
        static inline final BUTTON_RIGHT_PAGE= "button_right_page";
        static inline final BUTTON_LEFT_END= "button_left_end";
        static inline final BUTTON_RIGHT_END= "button_right_end";
        static inline final BUTTON_CLOSE= "button_close";
        static inline final BUTTON_OPEN= "button_open";
        static inline final LINK_FRIENDLIST= "link_friendlist";
        static inline final ICON_FIND_FRIENDS= "icon_find_friends";
        static inline final ICON_ALL_FRIENDS= "icon_all_friends";
        static inline final COLLAPSED_MARGIN= 150;
        static inline final NEW_BAR_BOTTOM_OFFSET= 1;
        static inline final NEW_BAR_RIGHT_MARGIN= 16;

        var _friendBarData:IHabboFriendBarData;
        var _gameManager:IHabboGameManager;
        var _friendsList:IHabboFriendsList;
        var _toolbar:IHabboToolbar;
        var _friendBarWindow:IWindowContainer;
        var _friendRequestCounter:IWindowContainer;
        var _Str_3984:IWindowContainer;
        var _Str_2868:Vector<ITab>;
        var _Str_11900:ITab;
        var _Str_7119:Int = -1;
        var _Str_2748:Int = 0;
        var _Str_15295:TextCropper;
        var _Str_8151:FriendListIcon;
        var _Str_9738:MessengerIcon;
        var _Str_4075:IWindowContainer;
        var _Str_22151:NewOpenMessengerTab;
        var _Str_14931:Bool = true;
        var _removeDimmerTimer:Timer;
        var _Str_3312:Bool = false;
        var _Str_11102:IRegionWindow;
        var _Str_10857:IRegionWindow;
        var _Str_21385:Bool = false;
        var _Str_5894:IStaticBitmapWrapperWindow;
        var _timer:Timer;
        var _Str_21460:Bool = false;
		var playSnowstormEnabled:Bool = false;
		var snowstormFriendsThreshold:Int = 0;

        public function new(k:IContext, _arg_2:UInt, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
            this._Str_15295 = new TextCropper();
            this._Str_2868 = new Vector<ITab>();
            this._Str_2868 = new Vector<ITab>();
        }

        public function setMessengerIconNotify(k:Bool)
        {
            if (this._Str_9738 != null)
            {
                this._Str_9738.notify(k);
            }
            if (this._Str_4075 != null)
            {
                this._Str_12109(k);
            }
        }

        public var friendBarWidth(get,never):Int;
public function  get_friendBarWidth():Int
        {
            return (this._friendBarWindow == null) ? 0 : (this._Str_3312 ? COLLAPSED_MARGIN : this._friendBarWindow.width);
        }

        public function setFriendListIconNotify(k:Bool)
        {
            if (this._Str_8151 != null)
            {
                this._Str_8151.notify(k);
            }
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboFriendList(), function (k:IHabboFriendsList)
            {
                _friendsList = k;
            }), new ComponentDependency(new IIDHabboFriendBarData(), function (k:IHabboFriendBarData)
            {
                _friendBarData = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }), new ComponentDependency(new IIDHabboGameManager(), function (k:IHabboGameManager)
            {
                _gameManager = k;
            })]));
        }

        override public function dispose()
        {
            if (!disposed)
            {
                if (this._timer != null)
                {
                    this._timer.removeEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
                    this._timer.stop();
                    this._timer = null;
                }
                if (this._removeDimmerTimer != null)
                {
                    this._removeDimmerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRemoveDimmer : ASAny));
                    this._removeDimmerTimer = null;
                }
                if (this._Str_9738 != null)
                {
                    this._Str_9738.dispose();
                    this._Str_9738 = null;
                }
                if (this._Str_8151 != null)
                {
                    this._Str_8151.dispose();
                    this._Str_8151 = null;
                }
                if (this._Str_3984 != null)
                {
                    this._Str_3984.dispose();
                    this._Str_3984 = null;
                }
                if (this._friendBarWindow != null)
                {
                    this._friendBarWindow.dispose();
                    this._friendBarWindow = null;
                }
                if (this._friendRequestCounter != null)
                {
                    this._friendRequestCounter.dispose();
                    this._friendRequestCounter = null;
                }
                while (this._Str_2868.length > 0)
                {
                    this._Str_2868.pop().dispose();
                }
                while (this._Str_2868.length > 0)
                {
                    this._Str_2868.pop().dispose();
                }
                if ((((!(this._friendBarData == null)) && (!this._friendBarData.disposed)) && (!(this._friendBarData.events == null))))
                {
                    this._friendBarData.events.removeEventListener(FriendBarUpdateEvent.FBE_UPDATED, this._Str_21453);
                    this._friendBarData.events.removeEventListener(FindFriendsNotificationEvent.FIND_FRIENDS_RESULT, this._Str_19962);
                    this._friendBarData.events.removeEventListener(FriendRequestUpdateEvent.FBE_REQUESTS, this._Str_21633);
                    this._friendBarData.events.removeEventListener(NewMessageEvent.FBE_MESSAGE, this._Str_20447);
                    this._friendBarData.events.removeEventListener(NotificationEvent.FBE_NOTIFICATION_EVENT, this.onFriendNotification);
                    this._friendBarData.events.removeEventListener(ActiveConversationsCountEvent.AMC_EVENT, this._Str_21657);
                }
                if (_sessionDataManager != null)
                {
                    _sessionDataManager.events.removeEventListener(SessionDataPreferencesEvent.APUE_UPDATED, this._Str_10326);
                }
                if (((!(_windowManager == null)) && (!_windowManager.disposed)))
                {
                    _windowManager.getWindowContext(WINDOW_LAYER_INDEX).getDesktopWindow().removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
                }
                this._Str_15295.dispose();
                this._Str_15295 = null;
                super.dispose();
            }
        }

        override function initComponent()
        {
            context.addLinkEventTracker(this);
            this._friendBarData.events.addEventListener(FriendBarUpdateEvent.FBE_UPDATED, this._Str_21453);
            this._friendBarData.events.addEventListener(FindFriendsNotificationEvent.FIND_FRIENDS_RESULT, this._Str_19962);
            this._friendBarData.events.addEventListener(FriendRequestUpdateEvent.FBE_REQUESTS, this._Str_21633);
            this._friendBarData.events.addEventListener(NewMessageEvent.FBE_MESSAGE, this._Str_20447);
            this._friendBarData.events.addEventListener(NotificationEvent.FBE_NOTIFICATION_EVENT, this.onFriendNotification);
            this._friendBarData.events.addEventListener(ActiveConversationsCountEvent.AMC_EVENT, this._Str_21657);
            _sessionDataManager.events.addEventListener(SessionDataPreferencesEvent.APUE_UPDATED, this._Str_10326);
        }

        
        public var visible(get,set):Bool;
public function  set_visible(k:Bool):Bool        {
            if (this._friendBarWindow != null)
            {
                this._friendBarWindow.visible = k;
                this._friendBarWindow.activate();
            }
            if (this._Str_3984 != null)
            {
                this._Str_3984.visible = (!k);
                if (this._friendBarWindow != null)
                {
                    this._Str_3984.x = this._friendBarWindow.x;
                    this._Str_3984.y = this._friendBarWindow.y;
                    this._Str_3984.activate();
                }
            }
return k;
        }

        function addDimmerToFriendBar()
        {
            var k= _windowManager.createWindow("bar_dimmer", "", WindowType.WINDOW_TYPE_BORDER, HabboWindowStyle.BLACK, ((ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_STRETCH )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_STRETCH)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(0, 0, this._friendBarWindow.width, this._friendBarWindow.height), null, 0);
            k.color = 0;
            k.blend = 0.3;
            this._friendBarWindow.addChild(k);
            this._friendBarWindow.invalidate();
            if (this._removeDimmerTimer == null)
            {
                this._removeDimmerTimer = new Timer(RoomEnterEffect.totalRunningTime, 1);
                this._removeDimmerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onRemoveDimmer : ASAny));
                this._removeDimmerTimer.start();
            }
        }

        function onRemoveDimmer(k:TimerEvent)
        {
            this._removeDimmerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRemoveDimmer : ASAny));
            this._removeDimmerTimer = null;
            var _local_2= this._friendBarWindow.findChildByName("bar_dimmer");
            if (_local_2 != null)
            {
                this._friendBarWindow.removeChild(_local_2);
                _windowManager.destroy(_local_2);
            }
        }
public function  get_visible():Bool
        {
            return (this._friendBarWindow != null) && this._friendBarWindow.visible;
        }

        public function populate()
        {
            var _local_4 = 0;
            var _local_11:IFriendRequest = null;
            var _local_12:IFriendEntity = null;
            var _local_13:Tab = null;
            var _local_14 = 0;
            var _local_15:Tab = null;
            if (!(!(this._friendBarWindow == null)))
            {
                return;
            }
            var k= this._Str_7119;
            this.deSelect(false);
            var _local_2= Std.downcast(this._friendBarWindow.findChildByName(LIST) , IItemListWindow);
            if (!(!(_local_2 == null)))
            {
                return;
            }
			
            this.playSnowstormEnabled = true;// configurationManager.getBoolean("friendbar.playSnowStorm.enabled");
            this.snowstormFriendsThreshold = ASCompat.toInt(configurationManager.getProperty("friendbar.playSnowStorm.friendsThreshold"));
            _local_2.autoArrangeItems = false;
            var _local_3= _local_2.numListItems;
            _local_4 = _local_3;
            while (_local_4 > 0)
            {
                _local_2.removeListItemAt((_local_4 - 1));
                _local_4--;
            }
            while (this._Str_2868.length > 0)
            {
                this._Str_2868.pop().recycle();
            }
            this._Str_21482(this._friendBarData.numFriendRequests);
            var _local_5= this._friendBarData.numFriends;
            var _local_6 = 0;
            var _local_7= this._Str_7488;
            var _local_8= ((_local_5 + (this._Str_14931 ? 1 : 0)) + ((_local_6 > 0) ? 1 : 0));
            var _local_9= Std.int(Math.min(_local_7, _local_8));
            if ((this._Str_2748 + _local_9) > _local_8)
            {
                this._Str_2748 = Std.int(Math.max(0, (this._Str_2748 - ((this._Str_2748 + _local_9) - _local_8))));
            }
            var _local_10= this._Str_2748;
            if (_local_6 > 0)
            {
                if (this._Str_2748 == 0)
                {
                    if (this._Str_2868.length < _local_7)
                    {
                        if (_local_6 == 1)
                        {
                            _local_11 = this._friendBarData.getFriendRequestAt(0);
                            _local_13 = NewFriendRequestTab._Str_2363(_local_11);
                            this._Str_2868.push(_local_13);
                            _local_2.addListItem(_local_13.window);
                        }
                        else
                        {
                            if (_local_6 > 1)
                            {
                                _local_13 = FriendRequestsTab._Str_2363(this._friendBarData.getFriendRequestList());
                                this._Str_2868.push(_local_13);
                                _local_2.addListItem(_local_13.window);
                            }
                        }
                    }
                }
                else
                {
                    _local_10--;
                }
            }
            _local_4 = _local_10;
            while (_local_4 < (_local_5 + _local_10))
            {
                if (_local_4 >= _local_5)
                {
                    break;
                }
                if (this._Str_2868.length >= _local_7)
                {
                    break;
                }
                _local_12 = this._friendBarData.getFriendAt(_local_4);
                _local_13 = NewFriendEntityTab._Str_2363(_local_12);
                this._Str_2868.push(_local_13);
                _local_2.addListItem(_local_13.window);
                _local_4++;
            }
            if (this._Str_14931)
            {
                _local_14 = this._Str_22580(_local_7, _local_8, _local_5, _local_6);
                _local_8 = ((_local_5 + _local_14) + ((_local_6 > 0) ? 1 : 0));
                while (_local_14-- > 0)
                {
                    _local_15 = AddFriendsTab._Str_2363();
                    _local_2.addListItem(_local_15.window);
                    this._Str_2868.push(_local_15);
                }
            }
            _local_2.autoArrangeItems = true;
            if (k > -1)
            {
                this._Str_24826(k);
            }
            this._Str_20124();
            this._Str_22571(((this._Str_2868.length < _local_8) && (_local_8 > 0)), (!(this._Str_2748 == 0)), ((this._Str_2748 + this._Str_2868.length) < _local_8));
            if (!this._Str_21385)
            {
                this._Str_21385 = true;
                this._Str_6258(false);
                this._Str_6258(true);
            }
        }

        function _Str_22580(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int):Int
        {
            if (this._Str_2868.length >= k)
            {
                return 0;
            }
            if (this._Str_2868.length >= k)
            {
                return 0;
            }
            var _local_5= 1;
			var offset= (this._SafeStr_16451(k, (_arg_2 + _local_5), _arg_3) ? 1 : 0);
            if ((this._Str_2868.length + _local_5) < MIN_TABS_WHEN_ENOUGH_SPACE - offset)
            {
                _local_5 = Std.int(Math.min((k - this._Str_2868.length), (MIN_TABS_WHEN_ENOUGH_SPACE - this._Str_2868.length) - offset));
            }
            return _local_5;
        }
		
		function _SafeStr_16451(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            if (((this.playSnowstormEnabled && (_arg_2 < k)) && (_arg_3 <= this.snowstormFriendsThreshold)))
            {
                return true;
            }
            return false;
        }

        function _Str_21564(k:Int):FriendEntityTab
        {
            var _local_2:FriendEntityTab = null;
            var _local_3= this._Str_2868.length;
            var _local_4 = 0;
            while (_local_4 < _local_3)
            {
                _local_2 = Std.downcast(this._Str_2868[_local_4] , FriendEntityTab);
                if (_local_2 != null)
                {
                    if (_local_2.friend.id == k)
                    {
                        return _local_2;
                    }
                }
                _local_4++;
            }
            return null;
        }

        function isUserInterfaceReady():Bool
        {
            return (this._friendBarWindow != null) && (!this._friendBarWindow.disposed);
        }

        function buildUserInterface()
        {
            Tab._Str_2925 = this._friendBarData;
            Tab.GAMES = this._gameManager;
            Tab.FRIENDS = this._friendsList;
            Tab._Str_3553 = this;
            Tab.ASSETS = assets;
            Tab._Str_3684 = _windowManager;
            Tab._Str_3840 = _localizationManager;
            Tab._Str_9890 = this._Str_15295;
            Tab.TRACKING = _tracking;
            Token._Str_3684 = _windowManager;
            Token.ASSETS = assets;
            Token.GAMES = this._gameManager;
            var k= assets.getAssetByName(NEW_BAR_XML);
            this._friendBarWindow = Std.downcast(_windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) ), WINDOW_LAYER_INDEX) , IWindowContainer);
            this._friendBarWindow.y = (this._friendBarWindow.parent.height - (this._friendBarWindow.height + NEW_BAR_BOTTOM_OFFSET));
            this._friendBarWindow.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_MOVE, true);
            this._friendBarWindow.procedure = this._Str_22794;
            if (USE_TOGGLE_WINDOW)
            {
                k = assets.getAssetByName(TOGGLE_XML);
                this._Str_3984 = Std.downcast(_windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) ), WINDOW_LAYER_INDEX) , IWindowContainer);
                this._Str_3984.x = this._friendBarWindow.x;
                this._Str_3984.y = this._friendBarWindow.y;
                this._Str_3984.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_MOVE, true);
                this._Str_3984.visible = false;
                this._Str_3984.procedure = this._Str_24861;
            }
            if (RoomEnterEffect.isRunning())
            {
                this.addDimmerToFriendBar();
            }
            var _local_2= Std.downcast(this._friendBarWindow.findChildByName(FRIENDTOOLS) , IWindowContainer);
            this._Str_5894 = Std.downcast(_local_2.getChildByName("line") , IStaticBitmapWrapperWindow);
            this._Str_4075 = cast(_local_2.findChildByName("icon_messenger"), IWindowContainer);
            if (this._Str_4075 != null)
            {
                this._Str_4075.addEventListener(WindowMouseEvent.CLICK, this._Str_24031);
                this._Str_4075.visible = false;
            }
            var _local_3= cast(_local_2.findChildByName(ICON_ALL_FRIENDS), IWindowContainer);
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_24062);
            }
            var _local_4= cast(_local_2.findChildByName(ICON_FIND_FRIENDS), IWindowContainer);
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_22502);
            }
            this._Str_10857 = Std.downcast(this._friendBarWindow.findChildByName(COLLAPSE_LEFT) , IRegionWindow);
            if (this._Str_10857 != null)
            {
                this._Str_10857.addEventListener(WindowMouseEvent.CLICK, this._Str_20689);
            }
            this._Str_11102 = Std.downcast(this._friendBarWindow.findChildByName(COLLAPSE_RIGHT) , IRegionWindow);
            if (this._Str_11102 != null)
            {
                this._Str_11102.addEventListener(WindowMouseEvent.CLICK, this._Str_20689);
            }
            _windowManager.getWindowContext(WINDOW_LAYER_INDEX).getDesktopWindow().addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
            this.populate();
            if (this._Str_21460)
            {
                this._Str_12109(true);
            }
        }

        public function getAvatarFaceBitmap(k:String):BitmapData
        {
            var _local_2:BitmapData = null;
            var _local_3:IAvatarImage = null;
            if (_avatarManager != null)
            {
                _local_3 = _avatarManager.createAvatarImage(k, AvatarScaleType.LARGE, null, this);
                if (_local_3 != null)
                {
_local_2 = _local_3.getCroppedImage(AvatarSetType.HEAD);
                    _local_3.dispose();
                }
            }
            return _local_2;
        }

        public function getGroupIconBitmap(k:String):BitmapData
        {
            return _sessionDataManager.getGroupBadgeImage(k);
        }

        public function avatarImageReady(k:String)
        {
            var _local_2:IFriendEntity = null;
            var _local_7:FriendRequest = null;
            var _local_8:BitmapData = null;
            var _local_9:IWindowContainer = null;
            var _local_10:IItemListWindow = null;
            var _local_11:IWindowContainer = null;
            var _local_12:IBitmapWrapperWindow = null;
            var _local_13:Tab = null;
            var _local_3= Std.downcast(this._friendBarWindow.findChildByName(LIST) , IItemListWindow);
            var _local_4= this._friendBarData.numFriends;
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_2 = this._friendBarData.getFriendAt(_local_5);
                if (_local_2.figure == k)
                {
                    _local_8 = null;
                    if (_local_2.id > 0)
                    {
                        _local_8 = this.getAvatarFaceBitmap(_local_2.figure);
                    }
                    else
                    {
                        _local_8 = this.getGroupIconBitmap(_local_2.figure);
                    }
                    if (_local_8 != null)
                    {
                        _local_9 = Std.downcast(_local_3.getListItemByID(_local_2.id) , IWindowContainer);
                        if (_local_9 != null)
                        {
                            _local_10 = Std.downcast(_local_9.getChildByName(PIECES) , IItemListWindow);
                            if (_local_10 != null)
                            {
                                _local_11 = cast(_local_10.getListItemByName(HEADER), IWindowContainer);
                                if (_local_11 != null)
                                {
                                    _local_12 = Std.downcast(_local_11.findChildByName(CANVAS) , IBitmapWrapperWindow);
                                    _local_12.bitmap = _local_8;
                                    _local_12.width = _local_8.width;
                                    _local_12.height = _local_8.height;
                                }
                            }
                        }
                    }
                    return;
                }
                _local_5++;
            }
            var _local_6= this._friendBarData.getFriendRequestList();
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_7  = _tmp_;
                if (_local_7.figure == k)
                {
                    final _iter_ = this._Str_2868; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_13  = cast(_tmp_, Tab);
                        if (Std.is(_local_13 , FriendRequestTab))
                        {
                            cast(_local_13, FriendRequestTab).avatarImageReady(_local_7, this.getAvatarFaceBitmap(k));
                            return;
                        }
                        if (Std.is(_local_13 , NewFriendRequestTab))
                        {
                            cast(_local_13, NewFriendRequestTab).avatarImageReady(_local_7, this.getAvatarFaceBitmap(k));
                            return;
                        }
                        if (Std.is(_local_13 , FriendRequestsTab))
                        {
                            cast(_local_13, FriendRequestsTab).avatarImageReady(_local_7, this.getAvatarFaceBitmap(k));
                            return;
                        }
                    }
                }
            }
        }

        function isFriendSelected(k:IFriendEntity):Bool
        {
            return this._Str_7119 == k.id;
        }

        public function selectTab(k:ITab, _arg_2:Bool)
        {
            if (!k.selected)
            {
                if (this._Str_11900 != null)
                {
                    this.deSelect(true);
                }
                k.select(_arg_2);
                this._Str_11900 = k;
                if (Std.is(k , FriendEntityTab))
                {
                    this._Str_7119 = cast(k, FriendEntityTab).friend.id;
                }
                if (Std.is(k , NewFriendEntityTab))
                {
                    this._Str_7119 = cast(k, NewFriendEntityTab).friend.id;
                }
            }
        }

        public function _Str_24826(k:Int)
        {
            if (this._Str_7119 == k)
            {
                return;
            }
            var _local_2= this._Str_21564(k);
            if (_local_2 != null)
            {
                this.selectTab(_local_2, false);
                this._Str_7119 = k;
            }
        }

        public function deSelect(k:Bool)
        {
            if (this._Str_11900 != null)
            {
                this._Str_11900.deselect(k);
                this._Str_11900 = null;
                this._Str_7119 = -1;
            }
        }

        public function getIconLocation(k:String):IWindowContainer
        {
            var _local_2:IWindowContainer = null;
            _local_2 = cast(this._friendBarWindow.findChildByName(k), IWindowContainer);
            return _local_2;
        }

        function _Str_21453(k:Event)
        {
            if (!this.isUserInterfaceReady())
            {
                this.buildUserInterface();
            }
            else
            {
                this._Str_6258(true);
            }
        }

        function _Str_19962(event:FindFriendsNotificationEvent)
        {
            var title= (event.success ? "${friendbar.find.success.title}" : "${friendbar.find.error.title}");
            var text= (event.success ? "${friendbar.find.success.text}" : "${friendbar.find.error.text}");
            _windowManager.notify(title, text, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:WindowEvent)
            {
                k.dispose();
            }, HabboAlertDialogFlag.BUTTON_OK);
        }

        function _Str_21633(k:FriendRequestUpdateEvent)
        {
            if (this._Str_8151 != null)
            {
                this._Str_8151.notify((this._friendBarData.numFriendRequests > 0));
            }
            if (this._friendBarWindow != null)
            {
                this._Str_21482(this._friendBarData.numFriendRequests);
                this._Str_6258(true);
            }
            else
            {
                this.buildUserInterface();
            }
        }

        function onTimerEvent(k:TimerEvent)
        {
            this._Str_4075.visible = true;
            var _local_2= this._Str_4075.getChildByName("icon_1") ;
            var _local_3= this._Str_4075.getChildByName("icon_2") ;
            if (((_local_2 != null) && (_local_3 != null)))
            {
                if (_local_2.visible)
                {
                    _local_2.visible = false;
                    _local_3.visible = true;
                }
                else
                {
                    if (_local_3.visible)
                    {
                        _local_3.visible = false;
                        _local_2.visible = true;
                    }
                }
            }
        }

        function _Str_12109(k:Bool)
        {
            var _local_2= this._Str_4075.getChildByName("icon") ;
            var _local_3= this._Str_4075.getChildByName("icon_1") ;
            if (k)
            {
                if (this._timer == null)
                {
                    _local_2.visible = false;
                    _local_3.visible = true;
                    this._timer = new Timer(500, 0);
                    this._timer.addEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
                    this._timer.start();
                }
            }
            else
            {
                if (this._timer != null)
                {
                    this._timer.removeEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
                    this._timer.stop();
                    this._timer = null;
                }
                _local_2.visible = true;
                _local_3.visible = false;
                this._Str_4075.getChildByName("icon_2") .visible = false;
            }
        }

        function _Str_20447(k:NewMessageEvent)
        {
            if (k.notify)
            {
                this._Str_21460 = true;
            }
            if (this._Str_4075 != null)
            {
                if (k.notify)
                {
                    this._Str_12109(true);
                }
                else
                {
                    this._Str_4075.visible = true;
                    this._Str_12109(false);
                }
            }
            if (this._Str_22151 != null)
            {
                if (k.notify)
                {
                    this._Str_22151.window.visible = true;
                }
            }
        }

        function onFriendNotification(k:NotificationEvent)
        {
            var _local_2= this._Str_21564(k._Str_9566);
            if (_local_2 == null)
            {
                return;
            }
            _local_2._Str_15853(k.notification);
        }

        function _Str_21657(k:ActiveConversationsCountEvent)
        {
            if (this._Str_4075 != null)
            {
                this._Str_4075.visible = (!(k._Str_18689 == 0));
            }
        }

        function _Str_10326(k:SessionDataPreferencesEvent)
        {
            if (!((k.uiFlags & UIFlags.FRIEND_BAR_OPEN) != 0))
            {
                if (!this._Str_3312)
                {
                    this._Str_20336();
                }
            }
        }

        function _Str_22794(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            if (k.type == WindowMouseEvent.DOWN)
            {
                _local_3 = this._Str_2748;
                _local_4 = ((this._friendBarData.numFriends + (this._Str_14931 ? 1 : 0)) + ((this._friendBarData.numFriendRequests > 0) ? 1 : 0));
                switch (_arg_2.name)
                {
                    case BUTTON_LEFT:
                        _local_3 = Std.int(Math.max(0, (this._Str_2748 - 1)));
                        
                    case BUTTON_LEFT_PAGE:
                        _local_3 = Std.int(Math.max(0, (this._Str_2748 - this._Str_7488)));
                        
                    case BUTTON_LEFT_END:
                        _local_3 = 0;
                        
                    case BUTTON_RIGHT:
                        _local_3 = Std.int(Math.max(0, Math.min((_local_4 - this._Str_7488), (this._Str_2748 + 1))));
                        
                    case BUTTON_RIGHT_PAGE:
                        _local_3 = Std.int(Math.max(0, Math.min((_local_4 - this._Str_7488), (this._Str_2748 + this._Str_7488))));
                        
                    case BUTTON_RIGHT_END:
                        _local_3 = Std.int(Math.max(0, (_local_4 - this._Str_7488)));
                        
                    case BUTTON_CLOSE:
                        this.visible = false;
                        
                    case BORDER:
                        this.deSelect(true);
                        
                    case LINK_FRIENDLIST:
                        this._friendBarData.toggleFriendList();
                        
                }
                if (_local_3 != this._Str_2748)
                {
                    this.deSelect(true);
                    this._Str_2748 = _local_3;
                    this._Str_6258(true);
                }
            }
            if (k.type == WindowEvent.WINDOW_EVENT_DEACTIVATED)
            {
                this.deSelect(true);
            }
        }

        function _Str_20124()
        {
            if (this._Str_10857 != null)
            {
                this._Str_10857.visible = this._Str_3312;
            }
            if (this._Str_11102 != null)
            {
                this._Str_11102.visible = (!this._Str_3312);
            }
        }

        function _Str_20689(k:WindowMouseEvent)
        {
            this._Str_20336();
        }

        function _Str_20336()
        {
            this._Str_3312 = (!this._Str_3312);
            _sessionDataManager.setFriendBarState((!this._Str_3312));
            this.deSelect(true);
            this._Str_6258(true);
            this._Str_20124();
            if (!this._Str_3312)
            {
                this._Str_6258(true);
            }
            var k= new FriendBarResizeEvent();
            events.dispatchEvent(k);
        }

        function _Str_24031(k:WindowMouseEvent)
        {
            this._friendBarData.toggleMessenger();
            this._Str_12109(false);
        }

        function _Str_24062(k:WindowMouseEvent)
        {
            this._friendBarData.toggleFriendList();
        }

        function _Str_22502(k:WindowMouseEvent)
        {
            this._friendBarData.openUserTextSearch();
        }

        public function removeMessengerNotifications()
        {
            var k:ITab = null;
            final _iter_ = this._Str_2868; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (Std.is(k , FriendEntityTab))
                {
                    cast(k, FriendEntityTab)._Str_5518(FriendNotification.TYPE_MESSENGER, true);
                }
            }
        }

        public function _Str_21482(k:Int)
        {
            var _local_2:IRegionWindow = null;
            if (this._friendRequestCounter == null)
            {
                this._friendRequestCounter = _windowManager.createUnseenItemCounter();
            }
            if (this._friendRequestCounter != null)
            {
                _local_2 = Std.downcast(this._friendBarWindow.findChildByName("icon_all_friends") , IRegionWindow);
                if (_local_2 != null)
                {
                    _local_2.addChild(this._friendRequestCounter);
                    this._friendRequestCounter.x = ((_local_2.width - this._friendRequestCounter.width) - 5);
                    this._friendRequestCounter.y = 0;
                    if (k > 0)
                    {
                        this._friendRequestCounter.visible = true;
                        this._friendRequestCounter.findChildByName("count").caption = Std.string(k);
                    }
                    else
                    {
                        this._friendRequestCounter.visible = false;
                    }
                }
            }
        }

        function _Str_24861(k:WindowEvent, _arg_2:IWindow)
        {
            if (this._Str_3984.visible)
            {
                if (k.type == WindowMouseEvent.DOWN)
                {
                    switch (_arg_2.name)
                    {
                        case BUTTON_OPEN:
                            this.visible = true;
                            return;
                    }
                }
            }
        }

        function _Str_22571(k:Bool, _arg_2:Bool, _arg_3:Bool)
        {
            var _local_4= Std.downcast(this._friendBarWindow.findChildByName(BUTTON_LEFT_PAGE) , IRegionWindow);
            var _local_5= Std.downcast(this._friendBarWindow.findChildByName(BUTTON_RIGHT_PAGE) , IRegionWindow);
            if (_local_4 != null)
            {
                _local_4.visible = k;
                if (_arg_2)
                {
                    _local_4.enable();
                    _local_4.blend = 1;
                }
                else
                {
                    _local_4.disable();
                    _local_4.blend = 0.2;
                }
            }
            if (_local_5 != null)
            {
                _local_5.visible = k;
                if (_arg_3)
                {
                    _local_5.enable();
                    _local_5.blend = 1;
                }
                else
                {
                    _local_5.disable();
                    _local_5.blend = 0.2;
                }
            }
            this._Str_22020();
        }

        function _Str_6258(k:Bool=false)
        {
            var _local_2:Rectangle = null;
            var _local_3 = 0;
            if (!disposed)
            {
                if (this._friendBarWindow != null)
                {
                    _local_2 = this._toolbar.getRect();
                    this._friendBarWindow.width = Std.int(this._friendBarWindow.parent.width - _local_2.right);
                    this._Str_5894.visible = (!this._Str_3312);
                    if (!k)
                    {
                        _local_3 = this._Str_7488;
                        if (_local_3 < this._Str_2868.length)
                        {
                            k = true;
                        }
                        else
                        {
                            if (_local_3 > this._Str_2868.length)
                            {
                                if (this._Str_2868.length < MIN_TABS_WHEN_ENOUGH_SPACE)
                                {
                                    k = true;
                                }
                                else
                                {
                                    if (this._Str_2868.length < (this._friendBarData.numFriends + (this._Str_14931 ? 1 : 0)))
                                    {
                                        k = true;
                                    }
                                    else
                                    {
                                        if (this._Str_24539 < this._friendBarData.numFriends)
                                        {
                                            k = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (k)
                    {
                        this.populate();
                        this._Str_22020();
                    }
                    if (this._Str_3312)
                    {
                        this._friendBarWindow.x = (this._friendBarWindow.desktop.width - COLLAPSED_MARGIN);
                    }
                    else
                    {
                        this._friendBarWindow.x = (this._friendBarWindow.desktop.width - this._friendBarWindow.width);
                        this._Str_5894.x = 1;
                    }
                }
            }
        }

        function _Str_22020()
        {
            var _local_2:IWindow = null;
            var k = 0;
            final _iter_ = this._friendBarWindow.iterator; if (checkNullIteratee(_iter_)) for (_tmp_ in com.sulake.core.utils.ASProxy.values(_iter_))
            {
_local_2  = _tmp_;
                if (!_local_2.visible)
                {
                }
                else
                {
                    _local_2.x = k;
                    k = (k + _local_2.width);
                }
            }
            this._friendBarWindow.width = k;
        }

        var _Str_24539(get,never):Int;
function  get__Str_24539():Int
        {
            var k = 0;
            var _local_2= this._Str_2868.length;
            while (_local_2-- > 0)
            {
                if (Std.is(this._Str_2868[_local_2] , FriendEntityTab))
                {
                    k++;
                }
            }
            var _local_3= this._Str_2868.length;
            while (_local_3-- > 0)
            {
                if (Std.is(this._Str_2868[_local_3] , FriendEntityTab))
                {
                    k++;
                }
            }
            return k;
        }

        var _Str_7488(get,never):Int;
function  get__Str_7488():Int
        {
            var k= Std.downcast(this._friendBarWindow.findChildByName(LIST) , IItemListWindow);
            var _local_2= Std.downcast(this._friendBarWindow.findChildByName(FRIENDTOOLS) , IWindowContainer);
            var _local_3= Std.int(((this._friendBarWindow.width - _local_2.width) - NEW_BAR_RIGHT_MARGIN) / (TAB_WIDTH + k.spacing));
            return _local_3;
        }

        function onDesktopResized(k:WindowEvent)
        {
            this._Str_6258(true);
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "friendbar/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "findfriends":
                    this._friendBarData.findNewFriends();
                    return;
                case "user":
                    if (_local_2.length > 2)
                    {
                        this._friendBarData.showProfileByName(_local_2[2]);
                    }
                    return;
                default:
                    Logger.log([("HabboFriendBarView unknown link-type received: " + _local_2[1])]);
            }
        }
    }

