package com.sulake.habbo.friendbar.view.tabs
;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.friendbar.data.FriendEntity;
    import com.sulake.habbo.friendbar.data.IFriendRequest;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IBubbleWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.friendbar.data.FriendRequest;

     class NewFriendRequestTab extends NewFriendEntityTab 
    {
        static inline final FRIEND_REQUEST_TAB_XML= "friend_request_tab_xml";
        static inline final BUBBLE= "bubble";
        static inline final MESSAGE= "message";
        static inline final BUTTON_ACCEPT= "button_accept";
        static inline final BUTTON_CLOSE= "button_close";
        static inline final CLICK_REGION_REJECT= "click_region_reject";
        static inline final LINK_REJECT= "link_reject";
        static inline final DEFAULT_COLOR:UInt = 16435481;
        static inline final _Str_2841:UInt = 16767334;
        static inline final _Str_5223:UInt = 16770666;
        static inline final _Str_5225:UInt = 0xFFFFFF;
        static var _Str_4254:NewFriendRequestTab;

        var _Str_23728:String;

        public function new()
        {
            super();
            _window = this._Str_17362();
            if (_window != null)
            {
                _window.findChildByName(BUBBLE).visible = false;
            }
        }

        public static function _Str_2363(k:IFriendRequest):NewFriendRequestTab
        {
            var _local_3:IBitmapWrapperWindow = null;
            var _local_2= ((_Str_4254 != null) ? _Str_4254 : Type.createInstance(NewFriendRequestTab, []));
            _local_2._Str_2638 = false;
            if (_local_2.friend != null)
            {
                if (_local_2.friend.figure != k.figure)
                {
                    _local_3 = cast(_local_2.window.findChildByName(NewFriendEntityTab.CANVAS), IBitmapWrapperWindow);
                    _local_3.bitmap = Tab._Str_3553.getAvatarFaceBitmap(k.figure);
                }
            }
            _local_2.friend = new FriendEntity(k.id, k.name, null, null, -1, false, false, k.figure, 0, null);
            return _local_2;
        }


        override public function dispose()
        {
            if (_window != null)
            {
                this._Str_18446(window);
                _window = null;
            }
            super.dispose();
        }

        override public function recycle()
        {
            if (!disposed)
            {
                if (!_Str_2638)
                {
                    _friend = null;
                    _Str_2638 = true;
                    _Str_4254 = this;
                }
            }
        }

        override public function select(k:Bool)
        {
            var _local_2:IWindow = null;
            if (!selected)
            {
                if (window != null)
                {
                    _local_2 = window.findChildByName(BUBBLE);
                    if (_local_2 != null)
                    {
                        _local_2.visible = true;
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
        }

        override function conceal()
        {
            super.conceal();
            window.color = (_Str_3341 ? _Str_2841 : DEFAULT_COLOR);
        }

        function _Str_17362():IWindowContainer
        {
            var _local_7:BitmapDataAsset = null;
            var k= Std.downcast(Tab._Str_3684.buildFromXML(((Tab.ASSETS.getAssetByName(FRIEND_REQUEST_TAB_XML).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            var _local_2= cast(k.findChildByName(NewFriendEntityTab.CANVAS), IBitmapWrapperWindow);
            var _local_3= cast(k.findChildByName(NewFriendEntityTab.HEADER), IRegionWindow);
            var _local_4= cast(k.findChildByName(NewFriendEntityTab.REGION_PROFILE), IRegionWindow);
            var _local_5= k.findChildByName(NewFriendEntityTab.ICONS);
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
            _local_4.addEventListener(WindowMouseEvent.CLICK, _Str_5926);
            _local_4.toolTipCaption = Tab._Str_3840.getLocalization("infostand.profile.link.tooltip", "");
            _local_4.toolTipDelay = 100;
            _local_5.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
            _local_5.addEventListener(WindowMouseEvent.OVER, onMouseOver);
            _local_5.addEventListener(WindowMouseEvent.OUT, onMouseOut);
            _local_2.disposesBitmap = true;
            _local_6.procedure = this._Str_5860__com_sulake_habbo_friendbar_view_tabs_NewFriendRequestTab;
            _local_6.y = (-(_local_6.height - (_local_6.height - _local_6.margins.bottom)) - 1);
            var _local_8= Std.downcast(Tab._Str_3684.create("ICON", WindowType.WINDOW_TYPE_REGION, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, new Rectangle(0, 0, 25, 25)) , IRegionWindow);
            _local_8.mouseThreshold = 0;
            var _local_9= Std.downcast(Tab._Str_3684.create("BITMAP", WindowType.WINDOW_TYPE_BITMAP_WRAPPER, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, new Rectangle(0, 0, 25, 25)) , IBitmapWrapperWindow);
            _local_9.disposesBitmap = false;
            _local_7 = Std.downcast(Tab.ASSETS.getAssetByName("plus_friend_icon_png") , BitmapDataAsset);
            if (_local_7 != null)
            {
                _local_9.bitmap = ASCompat.dynamicAs(_local_7.content , BitmapData);
            }
            _local_8.addChild(_local_9);
            cast(k.findChildByName(NewFriendEntityTab.ICONS), IItemListWindow).addListItemAt(_local_8, 0);
            return k;
        }

        function _Str_18446(k:IWindowContainer)
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
                _local_2 = cast(k.findChildByName(NewFriendEntityTab.HEADER), IRegionWindow);
                _local_2.removeEventListener(WindowMouseEvent.CLICK, onMouseClick);
                _local_2.removeEventListener(WindowMouseEvent.OVER, onMouseOver);
                _local_2.removeEventListener(WindowMouseEvent.OUT, onMouseOut);
                _local_3 = k.findChildByName(NewFriendEntityTab.ICONS);
                _local_3.removeEventListener(WindowMouseEvent.CLICK, onMouseClick);
                _local_3.removeEventListener(WindowMouseEvent.OVER, onMouseClick);
                _local_3.removeEventListener(WindowMouseEvent.OUT, onMouseClick);
                _local_4 = cast(k.findChildByName(NewFriendEntityTab.REGION_PROFILE), IRegionWindow);
                _local_4.removeEventListener(WindowMouseEvent.CLICK, _Str_5926);
                k.width = Tab.WIDTH;
                k.height = Tab.HEIGHT;
                k.color = DEFAULT_COLOR;
                _local_5 = cast(k.findChildByName(NewFriendEntityTab.CANVAS), IBitmapWrapperWindow);
                _local_5.bitmap = null;
                cast(k.findChildByTag("label"), ITextWindow).underline = false;
            }
        }

        function _Str_5860__com_sulake_habbo_friendbar_view_tabs_NewFriendRequestTab/*redefined private*/(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case BUTTON_ACCEPT:
                        Tab._Str_2925.acceptFriendRequest(_friend.id);
                        
                    case BUTTON_CLOSE:
                        if (selected)
                        {
                            Tab._Str_3553.deSelect(true);
                        }
                        
                    case NewFriendEntityTab.BUTTON_PROFILE:
                        Tab.TRACKING.trackGoogle("extendedProfile", "friendBar_friendRequestButton");
                        Tab._Str_2925.showProfile(_friend.id);
                        
                    case CLICK_REGION_REJECT:
                        Tab._Str_2925.declineFriendRequest(_friend.id);
                        
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    if (_arg_2.name == CLICK_REGION_REJECT)
                    {
                        cast(cast(_arg_2, IWindowContainer).getChildByName(LINK_REJECT), ITextWindow).textColor = _Str_5223;
                    }
                    if (_arg_2.name == NewFriendEntityTab.BUTTON_PROFILE)
                    {
                        cast(cast(_arg_2, IWindowContainer).findChildByName("icon"), IIconWindow).style = 22;
                    }
                    if (_arg_2.name == NewFriendEntityTab.REGION_PROFILE)
                    {
                        cast(cast(_arg_2, IWindowContainer).getChildByName("name"), ITextWindow).underline = true;
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        if (_arg_2.name == CLICK_REGION_REJECT)
                        {
                            cast(cast(_arg_2, IWindowContainer).getChildByName(LINK_REJECT), ITextWindow).textColor = _Str_5225;
                        }
                        if (_arg_2.name == NewFriendEntityTab.BUTTON_PROFILE)
                        {
                            cast(cast(_arg_2, IWindowContainer).findChildByName("icon"), IIconWindow).style = 21;
                        }
                        if (_arg_2.name == NewFriendEntityTab.REGION_PROFILE)
                        {
                            cast(cast(_arg_2, IWindowContainer).getChildByName("name"), ITextWindow).underline = false;
                        }
                    }
                }
            }
        }

        public function avatarImageReady(k:FriendRequest, _arg_2:BitmapData)
        {
            var _local_3:IBitmapWrapperWindow = null;
            var _local_4:BitmapData = null;
            if (!disposed)
            {
                if (friend != null)
                {
                    if (friend.figure == k.figure)
                    {
                        _local_3 = Std.downcast(window.findChildByName(NewFriendEntityTab.CANVAS) , IBitmapWrapperWindow);
                        if (_local_3 != null)
                        {
                            _local_4 = Tab._Str_3553.getAvatarFaceBitmap(k.figure);
                            if (_local_4 != null)
                            {
                                _local_3.bitmap = _local_4;
                                _local_3.width = _local_4.width;
                                _local_3.height = _local_4.height;
                            }
                        }
                    }
                }
            }
        }
    }

