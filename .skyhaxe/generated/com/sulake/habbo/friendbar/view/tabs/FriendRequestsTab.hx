package com.sulake.habbo.friendbar.view.tabs
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBubbleWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.friendbar.data.FriendRequest;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class FriendRequestsTab extends Tab 
    {
        static inline final FRIEND_REQUESTS_TAB_XML= "friend_requests_tab_xml";
        static inline final ICON= "icon";
        static inline final LABEL= "label";
        static inline final HEADER= "header";
        static inline final CANVAS= "canvas";
        static inline final BUBBLE= "bubble";
        static inline final REQUEST_ENTITY_LIST= "request_entity_list";
        static inline final NAME= "name";
        static inline final BADGE_COUNTER= "badge_counter";
        static inline final REGION_PROFILE= "region_profile";
        static inline final REGION_PROFILE_NAME= "region_profile_name";
        static inline final BUTTON_ACCEPT_ALL= "button_accept_all";
        static inline final CLICK_AREA_DISCARD_ALL= "click_area_discard_all";
        static inline final BUTTON_CLOSE= "button_close";
        static inline final BUTTON_ACCEPT= "button_accept";
        static inline final CLICK_AREA_DISCARD= "click_area_discard";
        static inline final TEXT_DISCARD= "text_discard";
        static var _Str_4254:FriendRequestsTab;
        static inline final DEFAULT_COLOR:UInt = 0xFFFAC919;
        static inline final _Str_2841:UInt = 0xFFFFD966;
        static inline final _Str_16055:UInt = 0xFFAB8710;
        static inline final _Str_16914:UInt = 0xFFBD9C2A;
        static inline final _Str_5223:UInt = 16770666;
        static inline final _Str_5225:UInt = 0xFFFFFF;

        var _Str_3000:Array<ASAny>;
        var _Str_16213:Bool = false;
        var _Str_12138:IWindowContainer;

        public function new()
        {
            super();
            _window = this._Str_24108();
        }

        public static function _Str_2363(k:Array<ASAny>):FriendRequestsTab
        {
            var _local_2= ((_Str_4254 != null) ? _Str_4254 : Type.createInstance(FriendRequestsTab, []));
            _local_2._Str_2638 = false;
            _local_2._Str_3000 = k;
            _local_2._window.findChildByName(BADGE_COUNTER).caption = Std.string(k.length);
            return _local_2;
        }


        override public function dispose()
        {
            if (_window != null)
            {
                this._Str_25079(_window);
                _window = null;
            }
            if (this._Str_12138 != null)
            {
                this._Str_12138.dispose();
                this._Str_12138 = null;
            }
            super.dispose();
        }

        override public function recycle()
        {
            var k:IBubbleWindow = null;
            var _local_2:IItemListWindow = null;
            if (!disposed)
            {
                if (!_Str_2638)
                {
                    if (window != null)
                    {
                        k = Std.downcast(window.findChildByName(BUBBLE) , IBubbleWindow);
                        if (k != null)
                        {
                            _local_2 = Std.downcast(k.content.getChildByName(REQUEST_ENTITY_LIST) , IItemListWindow);
                            if (_local_2 != null)
                            {
                                while (_local_2.numListItems > 0)
                                {
                                    _local_2.removeListItemAt(0).dispose();
                                }
                            }
                        }
                    }
                    this._Str_16213 = false;
                    this._Str_3000 = null;
                    _Str_2638 = true;
                    _Str_4254 = this;
                }
            }
        }

        override public function select(k:Bool)
        {
            var _local_2:IBubbleWindow = null;
            var _local_3:IItemListWindow = null;
            var _local_4:IWindowContainer = null;
            var _local_5:FriendRequest = null;
            var _local_6:IBitmapWrapperWindow = null;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9:BitmapData = null;
            if (!selected)
            {
                if (window != null)
                {
                    _local_2 = Std.downcast(window.findChildByName(BUBBLE) , IBubbleWindow);
                    if (_local_2 != null)
                    {
                        _local_2.visible = true;
                        if (!this._Str_16213)
                        {
                            _local_3 = Std.downcast(_local_2.content.getChildByName(REQUEST_ENTITY_LIST) , IItemListWindow);
                            if (_local_3 != null)
                            {
                                _local_7 = 0;
                                _local_8 = 0;
                                while (_local_8 < this._Str_3000.length)
                                {
                                    _local_4 = Std.downcast(this._Str_12138.clone() , IWindowContainer);
                                    _local_4.color = (((_local_8 % 2) == 0) ? _Str_16055 : _Str_16914);
                                    _local_5 = this._Str_3000[_local_8];
                                    _local_4.id = _local_5.id;
                                    _local_4.findChildByName(NAME).caption = _local_5.name;
                                    _local_6 = Std.downcast(_local_4.findChildByName(CANVAS) , IBitmapWrapperWindow);
                                    _local_9 = Tab._Str_3553.getAvatarFaceBitmap(_local_5.figure);
                                    if (_local_9 != null)
                                    {
                                        _local_6.disposesBitmap = false;
                                        _local_6.bitmap = _local_9;
                                        _local_6.width = _local_9.width;
                                        _local_6.height = _local_9.height;
                                        _local_6.disposesBitmap = true;
                                    }
                                    _local_3.addListItem(_local_4);
                                    _local_7 = (_local_7 + (_local_4.height + _local_3.spacing));
                                    _local_8++;
                                }
                                _local_3.height = _local_7;
                            }
                        }
                        this._Str_16213 = true;
                    }
                }
                super.select(k);
            }
        }

        override public function deselect(k:Bool)
        {
            var _local_2:IWindow = null;
            if (selected)
            {
                if (window != null)
                {
                    _local_2 = window.findChildByName(BUBBLE);
                    if (_local_2 != null)
                    {
                        _local_2.visible = false;
                    }
                }
                super.deselect(k);
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

        function _Str_24108():IWindowContainer
        {
            var _local_7:BitmapDataAsset = null;
            var k= Std.downcast(Tab._Str_3684.buildFromXML(((Tab.ASSETS.getAssetByName(FRIEND_REQUESTS_TAB_XML).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            var _local_2= cast(k.findChildByName(CANVAS), IBitmapWrapperWindow);
            var _local_3= cast(k.findChildByName(HEADER), IRegionWindow);
            var _local_4= cast(k.findChildByName(REGION_PROFILE), IRegionWindow);
            var _local_5= cast(k.findChildByName(REGION_PROFILE_NAME), IRegionWindow);
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
            _local_4.toolTipCaption = Tab._Str_3840.getLocalization("infostand.profile.link.tooltip", "");
            _local_4.toolTipDelay = 100;
            _local_5.toolTipCaption = Tab._Str_3840.getLocalization("infostand.profile.link.tooltip", "");
            _local_5.toolTipDelay = 100;
            _local_2.disposesBitmap = true;
            _local_6.visible = false;
            _local_6.y = (-(_local_6.height - (_local_6.height - _local_6.margins.bottom)) - 1);
            _local_6.procedure = this._Str_5860;
            _local_7 = Std.downcast(Tab.ASSETS.getAssetByName("add_friends_icon_png") , BitmapDataAsset);
            var _local_8= Std.downcast(k.findChildByName(ICON) , IBitmapWrapperWindow);
            _local_8.disposesBitmap = false;
            _local_8.bitmap = ASCompat.dynamicAs(_local_7.content , BitmapData);
            var _local_9= Std.downcast(_local_6.content.getChildByName(REQUEST_ENTITY_LIST) , IItemListWindow);
            this._Str_12138 = Std.downcast(_local_9.removeListItemAt(0) , IWindowContainer);
            return k;
        }

        function _Str_25079(k:IWindowContainer)
        {
            var _local_2:IRegionWindow = null;
            var _local_3:IBitmapWrapperWindow = null;
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
                k.width = Tab.WIDTH;
                k.height = Tab.HEIGHT;
                k.color = DEFAULT_COLOR;
                _local_3 = cast(k.findChildByName(CANVAS), IBitmapWrapperWindow);
                if (_local_3 != null)
                {
                    _local_3.bitmap = null;
                }
                cast(k.findChildByTag(LABEL), ITextWindow).underline = false;
            }
        }

        function _Str_5860(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case BUTTON_CLOSE:
                        if (selected)
                        {
                            Tab._Str_3553.deSelect(true);
                        }
                        
                    case BUTTON_ACCEPT_ALL:
                        Tab._Str_2925.acceptAllFriendRequests();
                        
                    case CLICK_AREA_DISCARD_ALL:
                        Tab._Str_2925.declineAllFriendRequests();
                        
                    case BUTTON_ACCEPT:
                        Tab._Str_2925.acceptFriendRequest(_arg_2.parent.id);
                        
                    case CLICK_AREA_DISCARD:
                        Tab._Str_2925.declineFriendRequest(_arg_2.parent.id);
                        
                    case REGION_PROFILE:
                        Tab.TRACKING.trackGoogle("extendedProfile", "friendBar_multipleFriendRequestsAvatar");
                        Tab._Str_2925.showProfile(_arg_2.parent.id);
                        
                    case REGION_PROFILE_NAME:
                        Tab.TRACKING.trackGoogle("extendedProfile", "friendBar_multipleFriendRequestsName");
                        Tab._Str_2925.showProfile(_arg_2.parent.id);
                        
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    if (_arg_2.name == CLICK_AREA_DISCARD)
                    {
                        cast(cast(_arg_2, IWindowContainer).getChildByName(TEXT_DISCARD), ITextWindow).textColor = _Str_5223;
                    }
                    if (_arg_2.name == REGION_PROFILE_NAME)
                    {
                        cast(cast(_arg_2, IWindowContainer).getChildByName(NAME), ITextWindow).underline = true;
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        if (_arg_2.name == CLICK_AREA_DISCARD)
                        {
                            cast(cast(_arg_2, IWindowContainer).getChildByName(TEXT_DISCARD), ITextWindow).textColor = _Str_5225;
                        }
                        if (_arg_2.name == REGION_PROFILE_NAME)
                        {
                            cast(cast(_arg_2, IWindowContainer).getChildByName(NAME), ITextWindow).underline = false;
                        }
                    }
                }
            }
        }

        public function avatarImageReady(k:FriendRequest, _arg_2:BitmapData)
        {
            var _local_4:IItemListWindow = null;
            var _local_5:IWindowContainer = null;
            var _local_6 = 0;
            var _local_7:IBitmapWrapperWindow = null;
            if (disposed)
            {
                return;
            }
            var _local_3= Std.downcast(window.findChildByName(BUBBLE) , IBubbleWindow);
            if (_local_3 != null)
            {
                _local_4 = Std.downcast(_local_3.content.getChildByName(REQUEST_ENTITY_LIST) , IItemListWindow);
                if (_local_4 != null)
                {
                    _local_6 = 0;
                    while (_local_6 < _local_4.numListItems)
                    {
                        _local_5 = Std.downcast(_local_4.getListItemAt(_local_6) , IWindowContainer);
                        if (_local_5.id == k.id)
                        {
                            _local_7 = Std.downcast(_local_5.findChildByName(CANVAS) , IBitmapWrapperWindow);
                            _local_7.disposesBitmap = true;
                            _local_7.bitmap = _arg_2;
                            _local_7.width = _arg_2.width;
                            _local_7.height = _arg_2.height;
                            return;
                        }
                        _local_6++;
                    }
                }
            }
        }
    }












