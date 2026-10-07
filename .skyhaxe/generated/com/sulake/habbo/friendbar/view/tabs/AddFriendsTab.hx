package com.sulake.habbo.friendbar.view.tabs
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.motion.Motions;
    import com.sulake.core.window.motion.Combo;
    import com.sulake.core.window.motion.EaseOut;
    import com.sulake.core.window.motion.ResizeTo;
    import com.sulake.core.window.motion.MoveBy;
    import com.sulake.core.window.components.ITextWindow;

     class AddFriendsTab extends Tab 
    {
        static inline final ICON= "icon";
        static inline final TEXT= "text";
        static inline final HEADER= "header";
        static inline final LABEL= "label";
        static inline final BUTTON= "button";
        static inline final ADD_FRIENDS_TAB_XML= "add_friends_tab_xml";
        static inline final FIND_FRIENDS_ICON_PNG= "find_friends_icon_png";
        static var _Str_6265:Int = -1;
        static inline final DEFAULT_COLOR:UInt = 8374494;
        static inline final _Str_2841:UInt = 9560569;
        static final POOL:Array<ASAny> = [];
        static final _Str_4440:Array<ASAny> = [];


        public static function _Str_2363():AddFriendsTab
        {
            var k:AddFriendsTab = ((POOL.length > 0) ? POOL.pop() : Type.createInstance(AddFriendsTab, []));
            k._Str_2638 = false;
            k._window = k._Str_18310();
            return k;
        }


        public function _Str_18310():IWindowContainer
        {
            var k:IWindowContainer = ((_Str_4440.length > 0) ? _Str_4440.pop() : Std.downcast(Tab._Str_3684.buildFromXML(((Tab.ASSETS.getAssetByName(ADD_FRIENDS_TAB_XML).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer));
            var _local_2= cast(k.findChildByName(HEADER), IRegionWindow);
            k.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
            k.addEventListener(WindowMouseEvent.OVER, onMouseOver);
            k.addEventListener(WindowMouseEvent.OUT, onMouseOut);
            _local_2.addEventListener(WindowMouseEvent.CLICK, onMouseClick);
            _local_2.addEventListener(WindowMouseEvent.OVER, onMouseOver);
            _local_2.addEventListener(WindowMouseEvent.OUT, onMouseOut);
            if (_Str_6265 < 0)
            {
                _Str_6265 = k.height;
            }
            k.height = Tab.HEIGHT;
            var _local_3= Std.downcast(k.findChildByName(ICON) , IBitmapWrapperWindow);
            _local_3.disposesBitmap = false;
            if (Tab.ASSETS.getAssetByName(FIND_FRIENDS_ICON_PNG) != null)
            {
                _local_3.bitmap = ASCompat.dynamicAs(Tab.ASSETS.getAssetByName(FIND_FRIENDS_ICON_PNG).content , BitmapData);
            }
            var _local_4= k.findChildByName(BUTTON);
            _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_3369);
            var _local_5= k.findChildByName(TEXT);
            _local_5.visible = false;
            return k;
        }

        function _Str_18874(k:IWindowContainer)
        {
            var _local_2:IRegionWindow = null;
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
                k.findChildByName(BUTTON).removeEventListener(WindowMouseEvent.CLICK, this._Str_3369);
                k.findChildByName(TEXT).visible = false;
                k.width = Tab.WIDTH;
                k.height = Tab.HEIGHT;
                if (_Str_4440.indexOf(k) == -1)
                {
                    _Str_4440.push(k);
                }
            }
        }

        override public function select(k:Bool)
        {
            if (!selected)
            {
                if (((k && Tab._Str_11139) && (Motions._Str_9810(window) == null)))
                {
                    Motions._Str_4598(new Combo([new EaseOut(new ResizeTo(window, Tab._Str_6722, window.width, _Str_6265), Tab._Str_6252), new EaseOut(new MoveBy(window, Tab._Str_6722, window.x, -(_Str_6265 - Tab.HEIGHT)), Tab._Str_6252)]));
                }
                else
                {
                    window.height = _Str_6265;
                    window.y = (window.y - (window.height - Tab.HEIGHT));
                }
                window.findChildByName(TEXT).visible = true;
                super.select(k);
            }
        }

        override public function deselect(k:Bool)
        {
            if (selected)
            {
                window.y = 0;
                window.height = Tab.HEIGHT;
                window.findChildByName(TEXT).visible = false;
                super.deselect(k);
            }
        }

        override public function recycle()
        {
            if (!disposed)
            {
                if (!_Str_2638)
                {
                    if (_window != null)
                    {
                        this._Str_18874(_window);
                        _window = null;
                    }
                    _Str_2638 = true;
                    POOL.push(this);
                }
            }
        }

        override function expose()
        {
            super.expose();
            cast(window.findChildByTag(LABEL), ITextWindow).underline = _Str_3341;
            window.color = (_Str_3341 ? _Str_2841 : DEFAULT_COLOR);
        }

        override function conceal()
        {
            super.conceal();
            cast(window.findChildByTag(LABEL), ITextWindow).underline = _Str_3341;
            window.color = (_Str_3341 ? _Str_2841 : DEFAULT_COLOR);
        }

        function _Str_3369(k:WindowMouseEvent)
        {
            if (((!disposed) && (!_Str_6044)))
            {
                Tab._Str_2925.findNewFriends();
                this.deselect(true);
            }
        }

	public function new() { super(); }
    }





