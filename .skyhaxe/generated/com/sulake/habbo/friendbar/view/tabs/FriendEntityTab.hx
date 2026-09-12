package com.sulake.habbo.friendbar.view.tabs
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendbar.data.IFriendEntity;
    import com.sulake.habbo.friendbar.view.tabs.tokens.Token;
    import com.sulake.habbo.friendbar.data.FriendNotification;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.motion.Motions;
    import com.sulake.core.window.motion.Combo;
    import com.sulake.core.window.motion.EaseOut;
    import com.sulake.core.window.motion.ResizeTo;
    import com.sulake.core.window.motion.MoveTo;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IBubbleWindow;
    import com.sulake.habbo.friendbar.view.tabs.tokens.RoomEventToken;
    import com.sulake.habbo.friendbar.view.tabs.tokens.AchievementToken;
    import com.sulake.habbo.friendbar.view.tabs.tokens.QuestToken;
    import com.sulake.habbo.friendbar.view.tabs.tokens.MessengerToken;
    import com.sulake.habbo.friendbar.view.tabs.tokens.GameToken;
    import com.sulake.habbo.friendbar.view.tabs.tokens.GameInviteToken;
    import com.sulake.habbo.friendbar.data.IFriendNotification;
    import com.sulake.core.window.events.WindowEvent;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

     class FriendEntityTab extends Tab 
    {
        static inline final ENTITY_XML= "entity_xml";
        static inline final FACEBOOK_PIECE_XML= "facebook_piece_xml";
        static inline final CONTROLS_PIECE_XML= "controls_piece_xml";
        static inline final PIECES= "pieces";
        static inline final ICONS= "icons";
        static inline final HEADER= "header";
        static inline final REGION_PROFILE= "region_profile";
        static inline final FACEBOOK= "facebook";
        static inline final CONTROLS= "controls";
        static inline final CANVAS= "canvas";
        static inline final NAME= "name";
        static inline final MESSAGE= "btn_message";
        static inline final ICON_MESSAGE= "icon_message";
        static inline final BTN_VISIT= "btn_visit";
        static inline final ICON= "icon";
        static inline final LABEL= "label";
        static inline final NOTIFICATION= "notification";
        static inline final BUTTON_PROFILE= "button_profile";
        static inline final BTN_GAME= "btn_game";
        static inline final ICON_GAME= "icon_game";
        static inline final ICON_GAME_INVITE= "icon_game_invite";
        static inline final BUBBLE= "bubble";
        static inline final BUBBLE_MESSAGE= "bubble_message";
        static inline final BUBBLE_BUTTON_ACCEPT= "bubble_button_accept";
        static inline final BUBBLE_BUTTON_CLOSE= "bubble_button_close";
        static inline final BUBBLE_CLICK_REGION_REJECT= "bubble_click_region_reject";
        static inline final DEFAULT_COLOR:UInt = 10338138;
        static inline final _Str_2841:UInt = 13891476;
        static inline final _Str_5837:String = null;
        static inline final ICON_TAG_NOTIFY= "icon_tag_notify";
        static inline final ICON_TAG_MESSAGE= "icon_tag_message";
        static inline final ICON_TAG_GAME= "icon_tag_game";
        static inline final ICON_TAG_GAME_INVITE= "icon_tag_game_invite";
        static final POOL:Vector<FriendEntityTab> = new Vector();
        static final _Str_4561:Vector<IWindowContainer> = new Vector();

        var _friend:IFriendEntity;
        var _Str_2765:Vector<Token>;
        var _Str_5783:Bool = false;
        var _Str_4947:Bool = false;
        var _Str_4018:String;


        public static function _Str_2363(k:IFriendEntity):FriendEntityTab
        {
            var _local_2:FriendEntityTab = null;
            var _local_3:FriendNotification = null;
            _local_2 = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(FriendEntityTab, []));
            _local_2._Str_2638 = false;
            _local_2.friend = k;
            if (k.notifications.length > 0)
            {
                final _iter_ = k.notifications; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = cast(_tmp_, FriendNotification);
                    _local_2._Str_15853(_local_3);
                }
            }
            return _local_2;
        }

        static function _Str_5803(k:IWindowContainer)
        {
            var _local_3:IWindowContainer = null;
            var _local_5:IWindow = null;
            var _local_2= cast(k.getChildByName(PIECES), IItemListWindow);
            _local_3 = Std.downcast(_local_2.getListItemByName(FACEBOOK) , IWindowContainer);
            if (_local_3 != null)
            {
                _local_3.dispose();
            }
            _local_3 = Std.downcast(_local_2.getListItemByName(CONTROLS) , IWindowContainer);
            if (_local_3 != null)
            {
                _local_3.dispose();
            }
            var _local_4:Array<ASAny> = [];
            _local_2.groupListItemsWithTag(NOTIFICATION, _local_4);
            if (_local_4.length > 0)
            {
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_5  = _tmp_;
                    _local_5.parent = null;
                }
            }
            k.height = Tab.HEIGHT;
            k.y = 0;
        }


        
        public var friend(get,set):IFriendEntity;
public function  set_friend(k:IFriendEntity):IFriendEntity        {
            this._friend = k;
            this.refresh();
return k;
        }
public function  get_friend():IFriendEntity
        {
            return this._friend;
        }

        override public function recycle()
        {
            if (!disposed)
            {
                if (!_Str_2638)
                {
                    if (_window != null)
                    {
                        this._Str_17565(_window);
                        _window = null;
                    }
                    if (this._Str_2765 != null)
                    {
                        while (this._Str_2765.length > 0)
                        {
                            this._Str_2765.pop().dispose();
                        }
                        this._Str_2765 = null;
                    }
                    this._friend = null;
                    this._Str_5783 = false;
                    this._Str_4947 = false;
                    this._Str_4018 = "";
                    _Str_2638 = true;
                    POOL.push(this);
                }
            }
        }

        override public function select(k:Bool)
        {
            var _local_2:IItemListWindow = null;
            var _local_3:IWindowContainer = null;
            var _local_4:IBitmapWrapperWindow = null;
            var _local_5 = false;
            var _local_6:ITextWindow = null;
            var _local_7:Token = null;
            var _local_8:IWindow = null;
            var _local_9:IWindow = null;
            var _local_10:IWindow = null;
            var _local_11:String = null;
            if (!selected)
            {
                _local_2 = cast(window.getChildByName(PIECES), IItemListWindow);
                _local_5 = false;
                if (((!(this.friend.realName == null)) && (!(this.friend.realName == ""))))
                {
                    _local_3 = Std.downcast(Tab._Str_3684.buildFromXML(((Tab.ASSETS.getAssetByName(FACEBOOK_PIECE_XML).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                    _local_3.name = FACEBOOK;
                    _local_6 = Std.downcast(_local_3.getChildByName(NAME) , ITextWindow);
                    _local_6.caption = this.friend.realName;
                    if (!_local_6.wordWrap)
                    {
                        Tab._Str_9890.crop(_local_6);
                    }
                    _local_4 = cast(_local_3.getChildByName(ICON), IBitmapWrapperWindow);
                    _local_4.bitmap = ASCompat.dynamicAs(Tab.ASSETS.getAssetByName(_local_4.bitmapAssetName).content , BitmapData);
                    _local_4.width = _local_4.bitmap.width;
                    _local_4.height = _local_4.bitmap.height;
                    _local_2.addListItem(_local_3);
                    _local_5 = true;
                }
                if (this._Str_2765 != null)
                {
                    final _iter_ = this._Str_2765; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_7  = _tmp_;
                        _local_2.addListItem(_local_7._Str_21233);
                        _local_5 = true;
                    }
                }
                if (this.friend.online)
                {
                    _local_3 = Std.downcast(Tab._Str_3684.buildFromXML(((Tab.ASSETS.getAssetByName(CONTROLS_PIECE_XML).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                    _local_3.name = CONTROLS;
                    _local_8 = _local_3.getChildByName(MESSAGE);
                    if (_local_8 != null)
                    {
                        _local_8.addEventListener(WindowMouseEvent.CLICK, this._Str_3369);
                    }
                    if (((!this._Str_5783) && (!this._Str_4947)))
                    {
                        _local_9 = _local_3.getChildByName(BTN_GAME);
                        if (_local_9 != null)
                        {
                            _local_9.visible = false;
                        }
                        _local_8 = _local_3.getChildByName(BTN_VISIT);
                        if (_local_8 != null)
                        {
                            if (this.friend.allowFollow)
                            {
                                _local_8.visible = true;
                                _local_8.addEventListener(WindowMouseEvent.CLICK, this._Str_3369);
                            }
                            else
                            {
                                _local_8.visible = false;
                            }
                        }
                    }
                    else
                    {
                        _local_10 = _local_3.getChildByName(BTN_VISIT);
                        if (_local_10 != null)
                        {
                            _local_10.visible = false;
                        }
                        _local_8 = _local_3.getChildByName(BTN_GAME);
                        if (_local_8 != null)
                        {
                            _local_11 = Tab._Str_3840.getLocalization((("gamecenter." + this._Str_4018) + ".name"));
                            Tab._Str_3840.registerParameter("friend.bar.game", "game", _local_11);
                            Tab._Str_3840.registerParameter("friend.bar.game.tip", "game", _local_11);
                            _local_8.visible = true;
                            _local_8.addEventListener(WindowMouseEvent.CLICK, this._Str_3369);
                        }
                    }
                    _local_8 = _local_3.getChildByName(BUTTON_PROFILE);
                    if (_local_8 != null)
                    {
                        _local_8.addEventListener(WindowMouseEvent.CLICK, this._Str_3369);
                    }
                    _local_2.addListItem(_local_3);
                    _local_5 = true;
                }
                if ((((k && Tab._Str_11139) && _local_5) && (Motions._Str_9810(window) == null)))
                {
                    Motions._Str_4598(new Combo([new EaseOut(new ResizeTo(window, Tab._Str_6722, window.width, _local_2.height), Tab._Str_6252), new EaseOut(new MoveTo(window, Tab._Str_6722, window.x, (Tab.HEIGHT - _local_2.height)), Tab._Str_6252)]));
                }
                else
                {
                    if (_local_5)
                    {
                        window.height = _local_2.height;
                    }
                    window.y = (Tab.HEIGHT - window.height);
                }
                super.select(k);
                if (k)
                {
                    if (Tab.TRACKING != null)
                    {
                        Tab.TRACKING.trackEventLog("FriendBar", "", "clicked", "", ((this.friend.logEventId > 0) ? this.friend.logEventId : 0));
                    }
                    this.friend.logEventId = -1;
                }
            }
        }

        override public function deselect(k:Bool)
        {
            var _local_3 = 0;
            var _local_4:Token = null;
            if (selected)
            {
                if (window != null)
                {
                    _Str_5803(window);
                    if (this._Str_2765 != null)
                    {
                        _local_3 = (this._Str_2765.length - 1);
                        while (_local_3 > -1)
                        {
                            _local_4 = this._Str_2765[_local_3];
                            if (_local_4.viewOnce)
                            {
                                this._Str_5518(_local_4.typeCode, k);
                            }
                            _local_3--;
                        }
                    }
                }
                super.deselect(k);
            }
            var _local_2= window.findChildByName(BUBBLE);
            if (_local_2 != null)
            {
                _local_2.visible = false;
            }
        }

        override function expose()
        {
            super.expose();
            window.color = (_Str_3341 ? _Str_2841 : DEFAULT_COLOR);
            cast(window.findChildByTag(LABEL), ITextWindow).underline = _Str_3341;
        }

        override function conceal()
        {
            super.conceal();
            window.color = (_Str_3341 ? _Str_2841 : DEFAULT_COLOR);
            cast(window.findChildByTag(LABEL), ITextWindow).underline = _Str_3341;
        }

        function refresh()
        {
            var k:IWindowContainer = null;
            var _local_2:IBitmapWrapperWindow = null;
            if (_window == null)
            {
                _window = this._Str_16688();
            }
            if (this._friend != null)
            {
                window.id = this._friend.id;
                k = Std.downcast(cast(window.getChildByName(PIECES), IItemListWindow).getListItemByName(HEADER) , IWindowContainer);
                k.findChildByName(NAME).caption = this._friend.name;
                Tab._Str_9890.crop(Std.downcast(k.getChildByName(NAME) , ITextWindow));
                _local_2 = cast(k.findChildByName(CANVAS), IBitmapWrapperWindow);
                if (this._friend.id > 0)
                {
                    _local_2.bitmap = Tab._Str_3553.getAvatarFaceBitmap(this._friend.figure);
                }
                else
                {
                    _local_2.bitmap = Tab._Str_3553.getGroupIconBitmap(this._friend.figure);
                }
                _local_2.width = _local_2.bitmap.width;
                _local_2.height = _local_2.bitmap.height;
            }
        }

        function _Str_16688():IWindowContainer
        {
            var k= ((_Str_4561.length > 0) ? _Str_4561.pop() : Std.downcast(Tab._Str_3684.buildFromXML(((Tab.ASSETS.getAssetByName(ENTITY_XML).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer));
            var _local_2= cast(k.findChildByName(CANVAS), IBitmapWrapperWindow);
            var _local_3= cast(k.findChildByName(HEADER), IRegionWindow);
            var _local_4= cast(k.findChildByName(REGION_PROFILE), IRegionWindow);
            var _local_5= k.findChildByName(ICONS);
            var _local_6= Std.downcast(k.findChildByName(BUBBLE) , IBubbleWindow);
            k.x = 0;
            k.y = 0;
            k.width = Tab.WIDTH;
            k.height = Tab.HEIGHT;
            k.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
            k.addEventListener(WindowMouseEvent.OVER, onMouseOver);
            k.addEventListener(WindowMouseEvent.OUT, onMouseOut);
            _local_3.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
            _local_3.addEventListener(WindowMouseEvent.OVER, onMouseOver);
            _local_3.addEventListener(WindowMouseEvent.OUT, onMouseOut);
            _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_5926);
            _local_4.toolTipCaption = Tab._Str_3840.getLocalization("infostand.profile.link.tooltip", "");
            _local_4.toolTipDelay = 100;
            _local_5.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
            _local_5.addEventListener(WindowMouseEvent.OVER, onMouseOver);
            _local_5.addEventListener(WindowMouseEvent.OUT, onMouseOut);
            _local_2.disposesBitmap = true;
            _local_6.procedure = this._Str_5860;
            _local_6.y = -(_local_6.height + 5);
            _local_6.visible = false;
            return k;
        }

        function _Str_17565(k:IWindowContainer)
        {
            var _local_2:IRegionWindow = null;
            var _local_3:IWindow = null;
            var _local_4:IRegionWindow = null;
            var _local_5:IBitmapWrapperWindow = null;
            if (((k != null) && (!k.disposed)))
            {
                k.procedure = null;
                k.removeEventListener(WindowMouseEvent.CLICK, onMouseClick);
                k.removeEventListener(WindowMouseEvent.OVER, onMouseOver);
                k.removeEventListener(WindowMouseEvent.OUT, onMouseOut);
                _local_2 = cast(k.findChildByName(HEADER), IRegionWindow);
                _local_2.removeEventListener(WindowMouseEvent.CLICK, onMouseClick);
                _local_2.removeEventListener(WindowMouseEvent.OVER, onMouseOver);
                _local_2.removeEventListener(WindowMouseEvent.OUT, onMouseOut);
                _local_3 = k.findChildByName(ICONS);
                _local_3.removeEventListener(WindowMouseEvent.CLICK, onMouseClick);
                _local_3.removeEventListener(WindowMouseEvent.OVER, onMouseClick);
                _local_3.removeEventListener(WindowMouseEvent.OUT, onMouseClick);
                _local_4 = cast(k.findChildByName(REGION_PROFILE), IRegionWindow);
                _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_5926);
                k.width = Tab.WIDTH;
                k.height = Tab.HEIGHT;
                k.color = DEFAULT_COLOR;
                _local_5 = cast(k.findChildByName(CANVAS), IBitmapWrapperWindow);
                _local_5.bitmap = null;
                cast(k.findChildByTag("label"), ITextWindow).underline = false;
                _Str_5803(k);
                if (_Str_4561.indexOf(k) == -1)
                {
                    _Str_4561.push(k);
                }
            }
        }

        function _Str_3369(k:WindowMouseEvent)
        {
            if (((!disposed) && (!_Str_6044)))
            {
                switch (k.window.name)
                {
                    case MESSAGE
                       | ICON_MESSAGE:
                        Tab._Str_3553.removeMessengerNotifications();
                        if (((Tab._Str_2925 != null) && (this._friend != null)))
                        {
                            Tab._Str_2925.startConversation(this._friend.id);
                            this.deselect(true);
                            if (k.window.name == ICON_MESSAGE)
                            {
                                Tab._Str_3553.setMessengerIconNotify(false);
                            }
                        }
                        return;
                    case BTN_VISIT:
                        if (((Tab._Str_2925 != null) && (this._friend != null)))
                        {
                            Tab._Str_2925.followToRoom(this._friend.id);
                            this.deselect(true);
                        }
                        return;
                    case BUTTON_PROFILE:
                        if (((Tab._Str_2925 != null) && (this._friend != null)))
                        {
                            Tab.TRACKING.trackGoogle("extendedProfile", "friendToolbar_friendButton");
                            Tab._Str_2925.showProfile(this._friend.id);
                            this.deselect(true);
                        }
                        return;
                    case BTN_GAME
                       | ICON_GAME:
                        if (Tab.GAMES != null)
                        {
                            this.deselect(true);
                            if (this._Str_4947)
                            {
                                this._Str_10193();
                            }
                            else
                            {
                                Tab.GAMES.showGameCenterByGameName("showGameCenter.friendEntityTab", this._Str_4018);
                            }
                        }
                        return;
                    case ICON_GAME_INVITE:
                        this.deselect(true);
                        this._Str_10193();
                        return;
                }
            }
        }

        function _Str_10193()
        {
            var k:IWindow = null;
            if (window != null)
            {
                k = window.findChildByName(BUBBLE);
                window.findChildByName(BUBBLE_MESSAGE).caption = Tab._Str_3840.getLocalization((("gamecenter." + this._Str_4018) + ".name"));
                k.visible = true;
            }
        }

        function _Str_5926(k:WindowMouseEvent)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                Tab.TRACKING.trackGoogle("extendedProfile", "friendBar_friendAvatar");
                Tab._Str_2925.showProfile(this._friend.id);
                this.deselect(true);
            }
        }

        public function _Str_15853(k:IFriendNotification)
        {
            var _local_3:Token = null;
            var _local_5:Vector<Token> = null;
            var _local_6:IItemListWindow = null;
            var _local_7:IWindow = null;
            this._Str_5518(k.typeCode, false);
            if (this._Str_2765 == null)
            {
                this._Str_2765 = new Vector<Token>();
            }
            var _local_2= selected;
            if (_local_2)
            {
                _local_5 = this._Str_2765;
                this._Str_2765 = null;
                this.deselect(false);
                this._Str_2765 = _local_5;
            }
            var _local_4= _Str_5837;
            switch (k.typeCode)
            {
                case FriendNotification.TYPE_ROOM_EVENT:
                    _local_3 = new RoomEventToken(this.friend, k);
                    _local_3._Str_3614.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
                    _local_4 = ICON_TAG_NOTIFY;
                    
                case FriendNotification.TYPE_ACHIEVEMENT:
                    _local_3 = new AchievementToken(this.friend, k, Tab._Str_3840);
                    _local_3._Str_3614.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
                    _local_4 = ICON_TAG_NOTIFY;
                    
                case FriendNotification.TYPE_QUEST:
                    _local_3 = new QuestToken(this.friend, k);
                    _local_3._Str_3614.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
                    _local_4 = ICON_TAG_NOTIFY;
                    
                case FriendNotification.TYPE_MESSENGER:
                    _local_3 = new MessengerToken(this.friend, k);
                    _local_3._Str_3614.name = ICON_MESSAGE;
                    _local_3._Str_3614.addEventListener(WindowMouseEvent.CLICK, this._Str_3369);
                    _local_4 = ICON_TAG_MESSAGE;
                    
                case FriendNotification.TYPE_PLAYING_GAME:
                    _local_3 = new GameToken(this.friend, k);
                    _local_3._Str_3614.name = ICON_GAME;
                    _local_3._Str_3614.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
                    _local_4 = ICON_TAG_GAME;
                    this._Str_5783 = true;
                    this._Str_4018 = _local_3.notification.message;
                    
                case FriendNotification.TYPE_FINISHED_GAME:
                    this._Str_5518(FriendNotification.TYPE_PLAYING_GAME, true);
                    this._Str_5783 = false;
                    return;
                case FriendNotification.TYPE_GAME_INVITE:
                    _local_3 = new GameInviteToken(this.friend, k);
                    _local_3._Str_3614.name = ICON_GAME_INVITE;
                    _local_3._Str_3614.addEventListener(WindowMouseEvent.CLICK, this._Str_3369);
                    _local_4 = ICON_TAG_GAME_INVITE;
                    this._Str_4947 = true;
                    this._Str_4018 = _local_3.notification.message;
                    
                default:
                    throw new ASError((("Unknown friend notification type: " + Std.string(k.typeCode)) + "!"));
            }
            if (_local_3 != null)
            {
                this._Str_2765.push(_local_3);
                if (_local_4 != _Str_5837)
                {
                    _local_6 = cast(window.findChildByName(ICONS), IItemListWindow);
                    if (_local_6.getListItemByTag(_local_4) == null)
                    {
                        _local_7 = _local_3._Str_3614;
                        if (_local_7.tags.indexOf(_local_4) == -1)
                        {
                            _local_7.tags.push(_local_4);
                        }
                        _local_6.addListItemAt(_local_7, 0);
                    }
                }
            }
            if (_local_2)
            {
                this.select(false);
            }
        }

        public function _Str_5518(k:Int, _arg_2:Bool)
        {
            var _local_4:Token = null;
            if (this._Str_2765 == null)
            {
                return;
            }
            var _local_3= (this._Str_2765.length - 1);
            while (_local_3 > -1)
            {
                _local_4 = this._Str_2765[_local_3];
                if (_local_4.typeCode == k)
                {
                    this._Str_2765.splice(_local_3, 1);
                    if (_arg_2)
                    {
                        this._friend.notifications.splice(this._friend.notifications.indexOf(_local_4.notification), 1);
                    }
                    _local_4.dispose();
                    return;
                }
                _local_3--;
            }
        }

        function _Str_5860(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case BUBBLE_BUTTON_ACCEPT:
                        if (Tab.GAMES != null)
                        {
                            _local_3 = Tab.GAMES.getGameId(this._Str_4018);
                            Tab.GAMES.showGameCenter("showGameCenter.friendEntityTab", _local_3);
                            Tab.GAMES.acceptGameInvite(_local_3, this._friend.id);
                        }
                        this._Str_4947 = false;
                        this._Str_5518(FriendNotification.TYPE_GAME_INVITE, true);
                        this.deselect(true);
                        return;
                    case BUBBLE_BUTTON_CLOSE
                       | BUBBLE_CLICK_REGION_REJECT:
                        this._Str_4947 = false;
                        this._Str_5518(FriendNotification.TYPE_GAME_INVITE, true);
                        this.deselect(true);
                        return;
                }
            }
        }

        public function toString():String
        {
            return (getQualifiedClassName(this) + " ") + this._friend.name;
        }

	public function new() { super(); }
    }













